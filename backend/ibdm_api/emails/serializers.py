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
        fields = "__all__"
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