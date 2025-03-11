from  django_filters import rest_framework as filters
from .models import AlertEmail, sentEmail
class CustomAlertFilter(filters.FilterSet):
    tag = filters.CharFilter(lookup_expr='icontains', field_name="monitored_value")
    class Meta:
        model = AlertEmail
        fields = ["tag", "enabled"]
""" 
class SentEmailFilters(filters.FilterSet):
    email = filters.ChoiceFilter(
        choices=[("alert","alert"), ("schedule", "schedule")]
    )
    # TODO: fix
    def filter_email_type(self, value, queryset):
        if value == "alert":
            return queryset.filter(alert__neq = None)
        if value == "schedule":
            return queryset.filter(schedule__neq = None)

    class Meta:
        model = sentEmail
        fields = ["email_type"] """