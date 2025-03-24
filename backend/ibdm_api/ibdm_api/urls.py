"""
URL configuration for ibdm_api project.

The `urlpatterns` list routes URLs to views. For more information please see:
    https://docs.djangoproject.com/en/5.0/topics/http/urls/
Examples:
Function views
    1. Add an import:  from my_app import views
    2. Add a URL to urlpatterns:  path('', views.home, name='home')
Class-based views
    1. Add an import:  from other_app.views import Home
    2. Add a URL to urlpatterns:  path('', Home.as_view(), name='home')
Including another URLconf
    1. Import the include() function: from django.urls import include, path
    2. Add a URL to urlpatterns:  path('blog/', include('blog.urls'))
"""
from django.conf import settings
from django.conf.urls.static import static
from django.contrib import admin
from django.shortcuts import redirect
from django.urls import include, path, re_path
from ibdm_api.ibdm_api.urls import redirect_home
from .views import index, getCA


def redirect_home(request):
    path = request.META['PATH_INFO'].split(
        "app/"
    )[1]
    return redirect(f'/{path}')

def redirectTo404Page(request, exception):
    return redirect('/404')

handler404 = redirectTo404Page
urlpatterns = [
    path('admin', admin.site.urls),
    path("ca", getCA),
    path('api/v1/', include('api_v1.urls')),
    path('drf/auth/', include('rest_framework.urls', namespace='rest_framework')),

    path("app/", index),
    re_path(r"app/login.*$", redirect_home),
    re_path(r"^app/siroperie.*$", redirect_home),
    re_path(r"^app/filtration.*$", redirect_home),
    re_path(r"^app/settings.*$", redirect_home),
    re_path(r"^app/utilite.*$", redirect_home),

    *static(settings.STATIC_URL, document_root=settings.STATIC_ROOT),
    *static(settings.MEDIA_URL, document_root=settings.MEDIA_ROOT),


    re_path(r'^.*$', index),
]  
