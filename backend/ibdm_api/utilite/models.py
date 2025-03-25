# This is an auto-generated Django model module.
# You'll have to do the following manually to clean this up:
#   * Rearrange models' order
#   * Make sure each model has one field with primary_key=True
#   * Make sure each ForeignKey and OneToOneField has `on_delete` set to the desired behavior
#   * Remove `managed = False` lines if you wish to allow Django to create, modify, and delete the table
# Feel free to rename the models, but don't rename db_table values or field names.
from django.db import models


class Co2Ifruit(models.Model):
    date = models.DateTimeField(blank=True, primary_key=True)
    ut_co2_vc1 = models.FloatField(db_column='UT_Co2_VC1', blank=True, null=True)  # Field name made lowercase.
    ut_co2_vc2 = models.FloatField(db_column='UT_Co2_VC2', blank=True, null=True)  # Field name made lowercase.
    ut_co2_de = models.FloatField(db_column='UT_Co2_DE', blank=True, null=True)  # Field name made lowercase.
    ut_co2_ve = models.FloatField(db_column='UT_Co2_VE', blank=True, null=True)  # Field name made lowercase.
    ut_co2_pc1 = models.FloatField(db_column='UT_Co2_PC1', blank=True, null=True)  # Field name made lowercase.
    ut_co2_pc2 = models.FloatField(db_column='UT_Co2_PC2', blank=True, null=True)  # Field name made lowercase.
    ut_co2_pn = models.FloatField(db_column='UT_Co2_PN', blank=True, null=True)  # Field name made lowercase.
    ut_co2_d182 = models.FloatField(db_column='UT_Co2_D182', blank=True, null=True)  # Field name made lowercase.
    ut_co2_d1833 = models.FloatField(db_column='UT_Co2_D1833', blank=True, null=True)  # Field name made lowercase.
    ut_co2_dcan35 = models.FloatField(db_column='UT_Co2_DCan35', blank=True, null=True)  # Field name made lowercase.
    ut_co2_dkrv40 = models.FloatField(db_column='UT_Co2_DKRV40', blank=True, null=True)  # Field name made lowercase.
    ut_co2_dcan2 = models.FloatField(db_column='UT_Co2_DCan2', blank=True, null=True)  # Field name made lowercase.
    ut_co2_dcm16 = models.FloatField(db_column='UT_Co2_DCM16', blank=True, null=True)  # Field name made lowercase.
    ut_co2_v182 = models.FloatField(db_column='UT_Co2_V182', blank=True, null=True)  # Field name made lowercase.
    ut_co2_v1833 = models.FloatField(db_column='UT_Co2_V1833', blank=True, null=True)  # Field name made lowercase.
    ut_co2_vcan35 = models.FloatField(db_column='UT_Co2_VCan35', blank=True, null=True)  # Field name made lowercase.
    ut_co2_vkrv40 = models.FloatField(db_column='UT_Co2_VKRV40', blank=True, null=True)  # Field name made lowercase.
    ut_co2_vcan2 = models.FloatField(db_column='UT_Co2_VCan2', blank=True, null=True)  # Field name made lowercase.
    ut_co2_vcm16 = models.FloatField(db_column='UT_Co2_VCM16', blank=True, null=True)  # Field name made lowercase.
    ut_co2_p182 = models.FloatField(db_column='UT_Co2_P182', blank=True, null=True)  # Field name made lowercase.
    ut_co2_p1833 = models.FloatField(db_column='UT_Co2_P1833', blank=True, null=True)  # Field name made lowercase.
    ut_co2_pcan35 = models.FloatField(db_column='UT_Co2_PCan35', blank=True, null=True)  # Field name made lowercase.
    ut_co2_pkrv40 = models.FloatField(db_column='UT_Co2_PKRV40', blank=True, null=True)  # Field name made lowercase.
    ut_co2_pcan2 = models.FloatField(db_column='UT_Co2_PCan2', blank=True, null=True)  # Field name made lowercase.
    ut_co2_pcm16 = models.FloatField(db_column='UT_Co2_PCM16', blank=True, null=True)  # Field name made lowercase.
    ut_n2_vn2 = models.FloatField(db_column='UT_N2_VN2', blank=True, null=True)  # Field name made lowercase.
    ut_n2_pn2 = models.FloatField(db_column='UT_N2_PN2', blank=True, null=True)  # Field name made lowercase.
    ut_soude = models.FloatField(db_column='UT_Soude', blank=True, null=True)  # Field name made lowercase.

    class Meta:
        managed = False
        db_table = 'Co2_Ifruit'


class Utilite(models.Model):
    date = models.DateTimeField(blank=True, primary_key=True)
    ut_kr_p7 = models.FloatField(db_column='UT_KR_P7', blank=True, null=True)  # Field name made lowercase.
    ut_kr_pn2 = models.FloatField(db_column='UT_KR_PN2', blank=True, null=True)  # Field name made lowercase.
    ut_kr_p40 = models.FloatField(db_column='UT_KR_P40', blank=True, null=True)  # Field name made lowercase.
    ut_kr_pv = models.FloatField(db_column='UT_KR_PV', blank=True, null=True)  # Field name made lowercase.
    ut_kr_pg = models.FloatField(db_column='UT_KR_PG', blank=True, null=True)  # Field name made lowercase.
    ut_kr_tt = models.FloatField(db_column='UT_KR_TT', blank=True, null=True)  # Field name made lowercase.
    ut_kr_tc = models.FloatField(db_column='UT_KR_TC', blank=True, null=True)  # Field name made lowercase.
    ut_sid_p7 = models.FloatField(db_column='UT_SID_P7', blank=True, null=True)  # Field name made lowercase.
    ut_sid_pn2 = models.FloatField(db_column='UT_SID_PN2', blank=True, null=True)  # Field name made lowercase.
    ut_sid_p40 = models.FloatField(db_column='UT_SID_P40', blank=True, null=True)  # Field name made lowercase.
    ut_sid_pv = models.FloatField(db_column='UT_SID_PV', blank=True, null=True)  # Field name made lowercase.
    ut_sid_pg = models.FloatField(db_column='UT_SID_PG', blank=True, null=True)  # Field name made lowercase.
    ut_sid_tt = models.FloatField(db_column='UT_SID_TT', blank=True, null=True)  # Field name made lowercase.
    ut_sid_tc = models.FloatField(db_column='UT_SID_TC', blank=True, null=True)  # Field name made lowercase.

    class Meta:
        managed = False
        db_table = 'Utilite'
