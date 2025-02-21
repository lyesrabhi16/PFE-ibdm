from django.urls import include, path
from rest_framework import routers

from users.views import GroupViewSet, PermissionViewSet, RoleViewSet, SubordinateAndSuperiorViewSet, UserViewSet


router = routers.DefaultRouter(
)
router.register(r'groups', GroupViewSet)
router.register(r'roles', RoleViewSet)
router.register(r'permissions', PermissionViewSet)
router.register(r'users', UserViewSet)
router.register(r'subordinates_superiors', SubordinateAndSuperiorViewSet)


# Wire up our API using automatic URL routing.
# Additionally, we include login URLs for the browsable API.
urlpatterns = [
    path('', include(router.urls), name="User Management Api Root"),
]
