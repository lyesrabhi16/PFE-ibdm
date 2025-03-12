from  django_filters import rest_framework as filters
from .models import AlertEmail, sentEmail
from rest_framework.request import Request
class CustomAlertFilter(filters.FilterSet):
    tag = filters.CharFilter(lookup_expr='icontains', field_name="monitored_value")
    class Meta:
        model = AlertEmail
        fields = ["tag", "enabled"]

class SentEmailFilters(filters.FilterSet):
    def filter_queryset(self, queryset):
        if self.request:
            request : Request = self.request
            if "email_type" in request.query_params:
                email_type = request.query_params["email_type"]
                if email_type == "alert":
                    return queryset.filter(alert__isnull=False)
                if email_type == "schedule":
                    return queryset.filter(schedule__isnull=False)
        return super().filter_queryset(queryset)
    class Meta:
        model = sentEmail
        fields = []