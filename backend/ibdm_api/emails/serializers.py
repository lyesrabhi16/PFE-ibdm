from rest_framework import serializers

from emails.models import AlertEmail, EmailSchedule, SentAlertEmail, sentEmail
from users.models import Role, User

class EmailScheduleSerializer(serializers.ModelSerializer):
    scheduled_users = serializers.SlugRelatedField(slug_field="email", queryset=User.objects.all(), many=True, required=False)
    class Meta:
        model = EmailSchedule
        fields = ["id","rapport", "temps_envoi", "interval", "interval_manual", "next_run_time", "scheduled_users", "scheduled_roles", "created_at", "updated_at"]


class AlertEmailSerializer(serializers.ModelSerializer):
    send_to_users = serializers.SlugRelatedField(slug_field="email", queryset=User.objects.all(), required=False,many=True)
    class Meta:
        model = AlertEmail
        fields = [
            "id",
            "monitored_value",
            "monitor_type",
            "danger_point",
            "warning_point",
            "danger_reminder_interval",
            "warning_reminder_interval",
            "reminder_interval_unit",
            "custom_alert_message",
            "send_to_users",
            "send_to_roles",
            "enabled",
        ]
        extra_kwargs={
            "danger_point": {"allow_null": True},
            "warning_point": {"allow_null": True},
            "danger_reminder_interval": {"allow_null": True},
            "warning_reminder_interval": {"allow_null": True},
            "custom_alert_message": {"allow_null": True},
            "send_to_users": {"allow_null": True, "required":False,},
            "send_to_roles": {"allow_null": True, "required":False,},
            "enabled": {"allow_null": True},
            "monitor_type": {"allow_null": True, "default": "DESC"},
        }
class SentAlertEmailSerializer(serializers.ModelSerializer):
    alert = AlertEmailSerializer()
    class Meta:
        model = SentAlertEmail
        fields = "__all__"

class SentEmailSerializer(serializers.ModelSerializer):
    receptionist = serializers.SlugRelatedField(slug_field="email", queryset=User.objects.all())
    schedule = EmailScheduleSerializer(required=False, allow_null=True)
    alert = SentAlertEmailSerializer(required=False, allow_null=True)
    class Meta:
        model = sentEmail
        fields = [
            "id",
            "temps_envoi",
            "receptionist",
            "schedule",
            "alert",
        ]

class PossibleMonitorValuesAlertEmailsSerializer(serializers.Serializer):
    all_values = serializers.ListField(child=serializers.CharField())
    monitored_values = serializers.ListField(child=serializers.CharField())
    possible_values = serializers.ListField(child=serializers.CharField())