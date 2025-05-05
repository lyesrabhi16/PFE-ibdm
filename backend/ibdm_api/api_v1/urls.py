from django.urls import include, path

urlpatterns = [
    path('auth/', include("app_auth.urls"), name='app_auth'),
    path('documentation/', include('documentation.urls'), name='documentation'),
    path('docs/', include('documentation.urls'), name='documentation'),
    path('user-management/', include('users.urls'), name='users'),
    path("siroperie/", include("siroperie.urls"), name="siroperie"),
    path("emails/", include("emails.urls"), name="emails"),
    path("filtration/", include("filtration.urls"), name="filtration"),
    path("utilite/", include("utilite.urls"), name="utilite"),
    path("reports/", include("reports.urls"), name="reports"),

]
