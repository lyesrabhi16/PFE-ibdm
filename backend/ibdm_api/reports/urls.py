from .views import ReportsViewSet, generateReport
from django.urls import include, path


urlpatterns = [
    path("list", ReportsViewSet.as_view({"get": "list"}), name="reports-list"),
    path("generate", generateReport, name="reports-generate"),
]
