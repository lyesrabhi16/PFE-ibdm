from rest_framework.permissions import BasePermission
from logs.logging import logger as logging
from channels.exceptions import DenyConnection
from asgiref.sync import sync_to_async
from rest_framework.permissions import SAFE_METHODS

def check_permission(user, permission_name):
    if isinstance(permission_name, list):
        # If permission_name is a list, check if the user has any of the permissions
        return any(user.has_perm(perm) for perm in permission_name)
    return user.has_perm(permission_name)


def WithPermission(permission_name, allow_if_safe_methods=False):
    """
    Factory function to create a permission class that checks for a specific permission.
    :param permission_name: The permission string to check (e.g., 'app.some_perm' or a role name).
    :return: A DRF permission class.
    """
    class PermissionClass(BasePermission):
        message = f"User does not have the required permission: {permission_name}"

        def has_permission(self, request, view):
            print(f"Checking permission {permission_name} for user: {request.user}")
            if allow_if_safe_methods and request.method in SAFE_METHODS:
                print("Allowing access for safe methods")
                return True
            return check_permission(request.user, permission_name)

        def has_object_permission(self, request, view, obj):
            # Apply same logic for object-level permission (customize as needed)
            return self.has_permission(request, view)

    return PermissionClass

def WithAnyPermissionOf(permission_list):
    """
    Factory function to create a permission class that checks if the use has any of provided permissions.
    :param permission_name: The permission string to check (e.g., 'app.some_perm' or a role name).
    :return: A DRF permission class.
    """
    class PermissionClass(BasePermission):

        def has_permission(self, request, view):
            print(f"Checking for any permission in {permission_list} for user: {request.user}")
            return check_permission(request.user, permission_list)

        def has_object_permission(self, request, view, obj):
            # Apply same logic for object-level permission (customize as needed)
            return self.has_permission(request, view)

    return PermissionClass


class OnlyAccessibleReports(BasePermission):
    """
    Custom permission class to restrict access to reports based on user permissions.
    """

    report_type_to_permission = {
            "sucre": "can_view_sucre_reports_page",
            "filtration": "can_view_filtration_reports_page",
            "utilite": "can_view_utilite_reports_page",
            "co2": "can_view_co2_reports_page",
            "co2_ifruit": "can_view_co2_reports_page",
            "inventaire-sucre": "can_view_sucre_reports_page",
        }

    def has_permission(self, request, view):
        report_type = request.query_params.get('report_type', None) or request.query_params.get('reports_type', None)
        if not report_type:
            print("No report type specified in request parameters.")
            return False
        report_type = report_type.lower()
        print(f"Checking if user {request.user} has permission for reports: {report_type}")
        # Check if the user has the 'can_view_reports' permission
        
        if report_type in self.report_type_to_permission:
            permission = self.report_type_to_permission[report_type]
            has_perm = check_permission(request.user, permission)
            print(f"User {request.user} has permission '{permission}': {has_perm}")
            return has_perm
        else:
            print(f"Unknown report type: {report_type}")
            return False
    def has_object_permission(self, request, view, obj):
        # Apply same logic for object-level permission (customize as needed)
        return self.has_permission(request, view)
    


async def broadcastConnectionCheck(scope, group_name, permission_type):
    logging.info(f"Broadcast connection check for group: {group_name}, user: {scope['user']} with permission: {permission_type}")
    print(f"Broadcast connection check for group: {group_name}, user: {scope['user']} with permission: {permission_type}")
    perms = permission_type if isinstance(permission_type, list) else [permission_type]
    has_perm = False
    for perm in perms:
        has_perm = await sync_to_async(check_permission)(scope['user'], perm)
        if has_perm:
            logging.info(f"User {scope['user']} has permission {perm} to connect to {group_name} broadcast")
            print(f"User {scope['user']} has permission {perm} to connect to {group_name} broadcast")
            break
    if not has_perm:
        logging.warning(f"User {scope['user']} attempted to connect to {group_name} broadcast without having the permission {permission_type}")
        print(f"User {scope['user']} attempted to connect to {group_name} without having permission {permission_type}")
        raise DenyConnection
    return has_perm
