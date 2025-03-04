from rest_framework import serializers

from emails.models import AlertEmail, EmailSchedule, sentEmail
from users.models import Role, User

class EmailScheduleSerializer(serializers.ModelSerializer):
    scheduled_users = serializers.SlugRelatedField(slug_field="email", queryset=User.objects.all(), many=True)
    class Meta:
        model = EmailSchedule
        fields = ["id","rapport", "temps_envoi", "interval", "interval_manual", "next_run_time", "scheduled_users", "scheduled_roles", "created_at", "updated_at"]

class SentEmailSerializer(serializers.ModelSerializer):
    receptionist = serializers.SlugRelatedField(slug_field="email", queryset=User.objects.all())
    class Meta:
        model = sentEmail
        fields = [
            "id",
            "temps_envoi",
            "receptionist",
            "schedule",
            "alert",
        ]

class AlertEmailSerializer(serializers.ModelSerializer):
    send_to_users = serializers.SlugRelatedField(slug_field="email", queryset=User.objects.all() ,many=True)
    class Meta:
        model = AlertEmail
        fields = "__all__"


class PossibleMonitorValuesAlertEmailsSerializer(serializers.Serializer):
    all_values = serializers.ListField(child=serializers.CharField())
    monitored_values = serializers.ListField(child=serializers.CharField())
    possible_values = serializers.ListField(child=serializers.CharField())