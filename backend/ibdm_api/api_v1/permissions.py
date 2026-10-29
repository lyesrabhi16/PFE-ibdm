from rest_framework import permissions


def is_system_admin(user) -> bool:
    """True for superusers and for users whose own flag or assigned role is an admin one."""
    if not (user and user.is_authenticated):
        return False
    role = getattr(user, "role", None)
    return bool(
        user.is_superuser
        or getattr(user, "is_admin", False)
        or (role is not None and getattr(role, "is_admin", False))
    )


class IsSystemAdmin(permissions.BasePermission):
    """Only administrators (see is_system_admin)."""

    def has_permission(self, request, view):
        return is_system_admin(request.user)


class IsAdminOrReadOnly(permissions.BasePermission):
    """Any authenticated user can read; only administrators can create, change or delete."""

    def has_permission(self, request, view):
        if not (request.user and request.user.is_authenticated):
            return False
        if request.method in permissions.SAFE_METHODS:
            return True
        return is_system_admin(request.user)


def admin_or_permission(codename: str):
    """Administrators, or users who were granted the given permission (e.g. via their role in the app)."""

    class AdminOrHasPermission(permissions.BasePermission):
        def has_permission(self, request, view):
            user = request.user
            if is_system_admin(user):
                return True
            if not (user and user.is_authenticated):
                return False
            try:
                return bool(user.has_perm(codename))
            except AttributeError:  # a user without a role
                return False

    AdminOrHasPermission.__name__ = f"AdminOr_{codename}"
    return AdminOrHasPermission
