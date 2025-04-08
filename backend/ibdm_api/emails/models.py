from django.db import models


CUSTOM_MONITORED_VALUES = {
    "sucre.total.tetra": (
        "t_s21",
        "t_s22",
        "t_s23",
        "t_s24",
        "t_s25",
    ),
    "sucre.total.adue": (
        "a_t02",
        "a_t03",
        "a_t04",
        "a_t05",
        "a_t06",
    ),
    "sucre.total": (
        "t_s21",
        "t_s22",
        "t_s23",
        "t_s24",
        "t_s25",
        "a_t02",
        "a_t03",
        "a_t04",
        "a_t05",
        "a_t06",
    ),
}

ALL_MONITORED_VALUES = (
    # sucre
    ("sucre.t_s21", "sucre.t_s21"),
    ("sucre.t_s22", "sucre.t_s22"),
    ("sucre.t_s23", "sucre.t_s23"),
    ("sucre.t_s24", "sucre.t_s24"),
    ("sucre.t_s25", "sucre.t_s25"),
    ("sucre.a_t02", "sucre.a_t02"),
    ("sucre.a_t03", "sucre.a_t03"),
    ("sucre.a_t04", "sucre.a_t04"),
    ("sucre.a_t05", "sucre.a_t05"),
    ("sucre.a_t06", "sucre.a_t06"),

    # niveau
    ("niveau.niv_f1", "niveau.niv_f2"),
    ("niveau.niv_uf1", "niveau.niv_uf1"),
    ("niveau.niv_uf2", "niveau.niv_uf2"),
    ("niveau.niv_os1", "niveau.niv_os1"),
    ("niveau.niv_os2", "niveau.niv_os2"),
    ("niveau.niv_os3", "niveau.niv_os3"),
    ("niveau.niv_os4", "niveau.niv_os4"),
    ("niveau.niv_os5", "niveau.niv_os5"),
    ("niveau.niv_os6", "niveau.niv_os6"),
    ("niveau.niv_os7", "niveau.niv_os7"),

    # debit
    ("debit.d_F1", "debit.d_F1"),
    ("debit.d_uf1", "debit.d_uf1"),
    ("debit.d_uf2", "debit.d_uf2"),
    ("debit.d_uf3", "debit.d_uf3"),
    ("debit.d_uf4", "debit.d_uf4"),
    ("debit.d_uf5", "debit.d_uf5"),
    ("debit.d_uf6", "debit.d_uf6"),
    ("debit.d_os1", "debit.d_os1"),
    ("debit.d_os2", "debit.d_os2"),
    ("debit.d_os3", "debit.d_os3"),
    ("debit.d_os4", "debit.d_os4"),
    ("debit.d_os5", "debit.d_os5"),
    ("debit.d_os6", "debit.d_os6"),
    ("debit.d_os7", "debit.d_os7"),
    ("debit.d_os8", "debit.d_os8"),
    ("debit.d_os9", "debit.d_os9"),

    # pression
    ("Pres_Cond.p_uf", "Pres_Cond.p_uf"),
    ("Pres_Cond.p_uf4", "Pres_Cond.p_uf4"),
    ("Pres_Cond.p_uf6", "Pres_Cond.p_uf6"),
    ("Pres_Cond.p_os1", "Pres_Cond.p_os1"),
    ("Pres_Cond.p_os2", "Pres_Cond.p_os2"),
    ("Pres_Cond.p_os3", "Pres_Cond.p_os3"),
    ("Pres_Cond.p_os4", "Pres_Cond.p_os4"),
    ("Pres_Cond.p_os5", "Pres_Cond.p_os5"),
    ("Pres_Cond.p_os6", "Pres_Cond.p_os6"),
    ("Pres_Cond.p_os7", "Pres_Cond.p_os7"),
    ("Pres_Cond.p_os71", "Pres_Cond.p_os71"),
    ("Pres_Cond.p_os8", "Pres_Cond.p_os8"),
    ("Pres_Cond.p_os9", "Pres_Cond.p_os9"),
    ("Pres_Cond.p_ose1", "Pres_Cond.p_ose1"),
    ("Pres_Cond.p_ose2", "Pres_Cond.p_ose2"),
    ("Pres_Cond.p_conc", "Pres_Cond.p_conc"),
    ("Pres_Cond.c_uf", "Pres_Cond.c_uf"),
    ("Pres_Cond.c_os1", "Pres_Cond.c_os1"),
    ("Pres_Cond.c_os2", "Pres_Cond.c_os2"),
    ("Pres_Cond.c_os3", "Pres_Cond.c_os3"),
    ("Pres_Cond.c_os4", "Pres_Cond.c_os4"),
    ("Pres_Cond.c_os5", "Pres_Cond.c_os5"),
    ("Pres_Cond.c_os6", "Pres_Cond.c_os6"),
    ("Pres_Cond.c_os7", "Pres_Cond.c_os7"),
    ("Pres_Cond.c_os8", "Pres_Cond.c_os8"),
    ("Pres_Cond.c_os9", "Pres_Cond.c_os9"),
    ("Pres_Cond.c_ose", "Pres_Cond.c_ose"),

    # volume
    ("volume.vol_for", "volume.vol_for"),
    ("volume.vol_uf1", "volume.vol_uf1"),
    ("volume.vol_uf2", "volume.vol_uf2"),
    ("volume.vol_uf3", "volume.vol_uf3"),
    ("volume.vol_uf4", "volume.vol_uf4"),
    ("volume.vol_uf5", "volume.vol_uf5"),
    ("volume.vol_uf6", "volume.vol_uf6"),
    ("volume.vol_os1", "volume.vol_os1"),
    ("volume.vol_os2", "volume.vol_os2"),
    ("volume.vol_os3", "volume.vol_os3"),
    ("volume.vol_os4", "volume.vol_os4"),
    ("volume.vol_os5", "volume.vol_os5"),
    ("volume.vol_os6", "volume.vol_os6"),
    ("volume.vol_os7", "volume.vol_os7"),
    ("volume.vol_os8", "volume.vol_os8"),
    ("volume.vol_os9", "volume.vol_os9"),

    # utilite
    ("co2_ifruit.ut_co2_vc1", "co2_ifruit.ut_co2_vc1"),
    ("co2_ifruit.ut_co2_vc2", "co2_ifruit.ut_co2_vc2"),
    ("co2_ifruit.ut_co2_de", "co2_ifruit.ut_co2_de"),
    ("co2_ifruit.ut_co2_ve", "co2_ifruit.ut_co2_ve"),
    ("co2_ifruit.ut_co2_pc1", "co2_ifruit.ut_co2_pc1"),
    ("co2_ifruit.ut_co2_pc2", "co2_ifruit.ut_co2_pc2"),
    ("co2_ifruit.ut_co2_pn", "co2_ifruit.ut_co2_pn"),
    ("co2_ifruit.ut_co2_d182", "co2_ifruit.ut_co2_d182"),
    ("co2_ifruit.ut_co2_d1833", "co2_ifruit.ut_co2_d1833"),
    ("co2_ifruit.ut_co2_dcan35", "co2_ifruit.ut_co2_dcan35"),
    ("co2_ifruit.ut_co2_dkrv40", "co2_ifruit.ut_co2_dkrv40"),
    ("co2_ifruit.ut_co2_dcan2", "co2_ifruit.ut_co2_dcan2"),
    ("co2_ifruit.ut_co2_dcm16", "co2_ifruit.ut_co2_dcm16"),
    ("co2_ifruit.ut_co2_v182", "co2_ifruit.ut_co2_v182"),
    ("co2_ifruit.ut_co2_v1833", "co2_ifruit.ut_co2_v1833"),
    ("co2_ifruit.ut_co2_vcan35", "co2_ifruit.ut_co2_vcan35"),
    ("co2_ifruit.ut_co2_vkrv40", "co2_ifruit.ut_co2_vkrv40"),
    ("co2_ifruit.ut_co2_vcan2", "co2_ifruit.ut_co2_vcan2"),
    ("co2_ifruit.ut_co2_vcm16", "co2_ifruit.ut_co2_vcm16"),
    ("co2_ifruit.ut_co2_p182", "co2_ifruit.ut_co2_p182"),
    ("co2_ifruit.ut_co2_p1833", "co2_ifruit.ut_co2_p1833"),
    ("co2_ifruit.ut_co2_pcan35", "co2_ifruit.ut_co2_pcan35"),
    ("co2_ifruit.ut_co2_pkrv40", "co2_ifruit.ut_co2_pkrv40"),
    ("co2_ifruit.ut_co2_pcan2", "co2_ifruit.ut_co2_pcan2"),
    ("co2_ifruit.ut_co2_pcm16", "co2_ifruit.ut_co2_pcm16"),
    ("co2_ifruit.ut_n2_vn2", "co2_ifruit.ut_n2_vn2"),
    ("co2_ifruit.ut_n2_pn2", "co2_ifruit.ut_n2_pn2"),
    ("co2_ifruit.ut_soude", "co2_ifruit.ut_soude"),

    ("utilite.ut_kr_p7", "utilite.ut_kr_p7"),
    ("utilite.ut_kr_pn2", "utilite.ut_kr_pn2"),
    ("utilite.ut_kr_p40", "utilite.ut_kr_p40"),
    ("utilite.ut_kr_pv", "utilite.ut_kr_pv"),
    ("utilite.ut_kr_pg", "utilite.ut_kr_pg"),
    ("utilite.ut_kr_tt", "utilite.ut_kr_tt"),
    ("utilite.ut_kr_tc", "utilite.ut_kr_tc"),
    ("utilite.ut_sid_p7", "utilite.ut_sid_p7"),
    ("utilite.ut_sid_pn2", "utilite.ut_sid_pn2"),
    ("utilite.ut_sid_p40", "utilite.ut_sid_p40"),
    ("utilite.ut_sid_pv", "utilite.ut_sid_pv"),
    ("utilite.ut_sid_pg", "utilite.ut_sid_pg"),
    ("utilite.ut_sid_tt", "utilite.ut_sid_tt"),
    ("utilite.ut_sid_tc", "utilite.ut_sid_tc"),

    # custom values
    *{(k, k) for k in CUSTOM_MONITORED_VALUES},
)

# Create your models here.
RAPPORTS = (
    ("inventaire-sucre", "inventaire-sucre"),
    ("utilite", "utilite"),
    ("filtration", "filtration"),
    ("co2_ifruit", "co2_ifruit"),
)
class EmailSchedule(models.Model):
    rapport = models.CharField(max_length=255, choices=RAPPORTS)
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
    alert = models.ForeignKey("emails.SentAlertEmail", on_delete=models.CASCADE, related_name="sent_email_alert_meta", blank=True, null=True)



    def __str__(self):
        if (self.schedule is not None):
            return f"SCHEDULED: {self.pk}  {self.receptionist} - {self.temps_envoi} - {self.schedule.rapport}"
        elif self.alert is not None:
            return f"ALERT: {self.pk}  {self.receptionist} - {self.temps_envoi} - {self.alert.alert.monitored_value}"
        else:
            return f"unknown email type with id: {self.pk}"

class AlertEmail(models.Model):
    monitored_value = models.CharField(max_length=255,choices=ALL_MONITORED_VALUES, unique=True)
    monitor_type = models.CharField(max_length=255, choices=[('ASC', 'ASC'), ('DESC','DESC')], default='DESC')
    danger_point = models.FloatField(default=10)
    warning_point = models.FloatField(default=25)
    
    danger_reminder_interval = models.IntegerField(default=1)
    warning_reminder_interval = models.IntegerField(default=7)

    custom_alert_message = models.TextField(blank=True, null=True)
    send_to_users = models.ManyToManyField("users.User", related_name="users", blank=True, null=True)
    send_to_roles = models.ManyToManyField("users.Role", related_name="roles", blank=True, null=True)
    enabled = models.BooleanField(default=True, blank=True)

    def __str__(self) -> str:
        return f"ALERT: {self.monitored_value} - danger: {self.danger_point} - warning: {self.warning_point}"


class SentAlertEmail(models.Model):
    alert = models.ForeignKey(AlertEmail, on_delete=models.CASCADE, related_name="sent_alert_email_alert")
    at_value = models.FloatField()
    alert_type = models.CharField(choices=(("danger", "danger"), ("warning", "warning")), max_length=255)