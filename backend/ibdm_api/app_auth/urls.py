from django.urls import path

from app_auth.views import get_current_user_info, login_view, logout_view, connected_user_has_perm


# Wire up our API using automatic URL routing.
# Additionally, we include login URLs for the browsable API.
urlpatterns = [
    path('login', login_view, name='login'),
    path("logout", logout_view, name="logout"),
    path('user/me', get_current_user_info, name='user_me'),
    path("user/permission/<str:codename>", connected_user_has_perm, name="user_has_permission"),
]
