from django.db import models

# Create your models here.

class EmailSchedule(models.Model):
    rapport = models.CharField(max_length=255, choices=[('inventaire-sucre', 'inventaire-sucre')])
    temps_envoi = models.TimeField()
    interval = models.CharField(max_length=255, choices=[('jour', 'jour'), ('semaine', 'semaine'), ('mois', 'mois'), ("manual", "manual")])
    interval_manual = models.IntegerField(blank=True, null=True)
    next_run_time = models.DateTimeField(null=True, blank=True)
    scheduled_users = models.ManyToManyField("users.User", related_name="scheduled_emails_to_users", blank=True)
    scheduled_roles = models.ManyToManyField("users.Role", related_name="scheduled_emails_to_roles", blank=True)

    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)
    
    def __str__(self):
        return f"{self.pk} {self.rapport} - {self.temps_envoi} - {self.interval}"

class sentEmail(models.Model):
    temps_envoi = models.DateTimeField(auto_now_add=True)
    receptionist = models.ForeignKey("users.User", on_delete=models.CASCADE, related_name="sent_emails")
    schedule = models.ForeignKey(EmailSchedule, on_delete=models.CASCADE, related_name="sent_emails")


    def __str__(self):
        return f"{self.pk}  {self.receptionist} - {self.temps_envoi} - {self.schedule.rapport}"