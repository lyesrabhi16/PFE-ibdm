from django.db import models


ALL_MONITORED_VALUES = (
    #sucre
    ("sucre.t_s21", "sucre.t_s21"), ("sucre.t_s22", "sucre.t_s21"), ("sucre.t_s23", "sucre.t_s23"), ("sucre.t_s24", "sucre.t_s24"), ("sucre.t_s25", "sucre.t_s25"),
    ("sucre.t02", "sucre.t02"), ("sucre.t03", "sucre.t03"), ("sucre.t04", "sucre.t04"), ("sucre.t05", "sucre.t05"), ("sucre.t06", "sucre.t06"),
    
    #niveau
    ("niveau.niv_f1", "niveau.niv_f2"), ("niveau.niv_uf1", "niveau.niv_uf1"), ("niveau.niv_uf2", "niveau.niv_uf2"), ("niveau.niv_os1", "niveau.niv_os1"),
    ("niveau.niv_os2", "niveau.niv_os2"), ("niveau.niv_os3", "niveau.niv_os3"), ("niveau.niv_os4", "niveau.niv_os4"), ("niveau.niv_os5", "niveau.niv_os5"),
    ("niveau.niv_os6", "niveau.niv_os6"), ("niveau.niv_os7", "niveau.niv_os7"),
    
    #debit
    ("debit.d_F1", "debit.d_F1"), ("debit.d_uf1", "debit.d_uf1"), ("debit.d_uf2", "debit.d_uf2"), ("debit.d_uf3", "debit.d_uf3"), ("debit.d_uf4", "debit.d_uf4"),("debit.d_uf5", "debit.d_uf5"),("debit.d_uf6", "debit.d_uf6"), ("debit.d_os1", "debit.d_os1"),
    ("debit.d_os2", "debit.d_os2"), ("debit.d_os3", "debit.d_os3"), ("debit.d_os4", "debit.d_os4"), ("debit.d_os5", "debit.d_os5"),
    ("debit.d_os6", "debit.d_os6"), ("debit.d_os7", "debit.d_os7"), ("debit.d_os8", "debit.d_os8"), ("debit.d_os9", "debit.d_os9"),
    
    #pres cond
    ("Pres_Cond.p_uf", "Pres_Cond.p_uf"), ("Pres_Cond.p_uf4", "Pres_Cond.p_uf4"), ("Pres_Cond.p_uf6", "Pres_Cond.p_uf6"), ("Pres_Cond.p_os1", "Pres_Cond.p_os1"),
    ("Pres_Cond.p_os2", "Pres_Cond.p_os2"), ("Pres_Cond.p_os3", "Pres_Cond.p_os3"), ("Pres_Cond.p_os4", "Pres_Cond.p_os4"), ("Pres_Cond.p_os5", "Pres_Cond.p_os5"),
    ("Pres_Cond.p_os6", "Pres_Cond.p_os6"), ("Pres_Cond.p_os7", "Pres_Cond.p_os7"),("Pres_Cond.p_os71", "Pres_Cond.p_os71"), ("Pres_Cond.p_os8", "Pres_Cond.p_os8"), ("Pres_Cond.p_os9", "Pres_Cond.p_os9"),
    ("Pres_Cond.p_ose1", "Pres_Cond.p_ose1"), ("Pres_Cond.p_ose2", "Pres_Cond.p_ose2"), ("Pres_Cond.p_conc", "Pres_Cond.p_conc"),
    ("Pres_Cond.c_uf", "Pres_Cond.c_uf"),("Pres_Cond.c_os1", "Pres_Cond.c_os1"),("Pres_Cond.c_os2", "Pres_Cond.c_os2"),("Pres_Cond.c_os3", "Pres_Cond.c_os3"),
    ("Pres_Cond.c_os4", "Pres_Cond.c_os4"),("Pres_Cond.c_os5", "Pres_Cond.c_os5"),("Pres_Cond.c_os6", "Pres_Cond.c_os6"),("Pres_Cond.c_os7", "Pres_Cond.c_os7"),("Pres_Cond.c_os8", "Pres_Cond.c_os8"),("Pres_Cond.c_os9", "Pres_Cond.c_os9"),
    ("Pres_Cond.c_ose", "Pres_Cond.c_ose"),
    
    #volume
    ("volume.vol_for", "volume.vol_for"),("volume.vol_uf1", "volume.vol_uf1"),("volume.vol_uf2", "volume.vol_uf2"),
    ("volume.vol_uf3", "volume.vol_uf3"),("volume.vol_uf4", "volume.vol_uf4"),("volume.vol_uf5", "volume.vol_uf5"),
    ("volume.vol_uf6", "volume.vol_uf6"),("volume.vol_os1", "volume.vol_os1"),("volume.vol_os2", "volume.vol_os2"),
    ("volume.vol_os3", "volume.vol_os3"),("volume.vol_os4", "volume.vol_os4"),("volume.vol_os5", "volume.vol_os5"),
    ("volume.vol_os6", "volume.vol_os6"),("volume.vol_os7", "volume.vol_os7"),("volume.vol_os8", "volume.vol_os8"),
    ("volume.vol_os9", "volume.vol_os9"),
)

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
    receptionist = models.ForeignKey("users.User", on_delete=models.CASCADE, related_name="sent_email_to")
    schedule = models.ForeignKey(EmailSchedule, on_delete=models.CASCADE, related_name="sent_email_schedule", blank=True, null=True)
    alert = models.ForeignKey("emails.AlertEmail", on_delete=models.CASCADE, related_name="sent_email_alert", blank=True, null=True)



    def __str__(self):
        if (self.schedule is not None):
            return f"SCHEDULED: {self.pk}  {self.receptionist} - {self.temps_envoi} - {self.schedule.rapport}"
        elif self.alert is not None:
            return f"ALERT: {self.pk}  {self.receptionist} - {self.temps_envoi} - {self.alert.monitored_value}"
        else:
            return f"unknown email type with id: {self.pk}"

class AlertEmail(models.Model):
    monitored_value = models.CharField(max_length=255,choices=ALL_MONITORED_VALUES, unique=True)
    danger_point = models.IntegerField(default=10)
    warning_point = models.IntegerField(default=25)
    
    danger_reminder_interval = models.IntegerField(default=1)
    warning_reminder_interval = models.IntegerField(default=7)

    custom_alert_message = models.TextField(blank=True, null=True)
    send_to_users = models.ManyToManyField("users.User", related_name="users", blank=True)
    send_to_roles = models.ManyToManyField("users.Role", related_name="roles", blank=True)
    enabled = models.BooleanField(default=True, blank=True)

    def __str__(self) -> str:
        return f"ALERT: {self.monitored_value} - danger: {self.danger_point} - warning: {self.warning_point}"


