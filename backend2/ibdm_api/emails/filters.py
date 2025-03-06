from  django_filters import rest_framework as filters
from .models import AlertEmail
class CustomAlertFilter(filters.FilterSet):
    tag = filters.CharFilter(lookup_expr='icontains', field_name="monitored_value")
    class Meta:
        model = AlertEmail
        fields = ["tag", "enabled"]