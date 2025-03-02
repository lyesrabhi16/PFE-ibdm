# This is an auto-generated Django model module.
# You'll have to do the following manually to clean this up:
#   * Rearrange models' order
#   * Make sure each model has one field with primary_key=True
#   * Make sure each ForeignKey and OneToOneField has `on_delete` set to the desired behavior
#   * Remove `managed = False` lines if you wish to allow Django to create, modify, and delete the table
# Feel free to rename the models, but don't rename db_table values or field names.
from django.db import models


class Debit(models.Model):
    date = models.DateTimeField(blank=True, primary_key=True)
    d_f1 = models.FloatField(db_column='D_F1', blank=True, null=True)  # Field name made lowercase.
    d_f2 = models.FloatField(db_column='D_F2', blank=True, null=True)  # Field name made lowercase.
    d_uf1 = models.FloatField(db_column='D_UF1', blank=True, null=True)  # Field name made lowercase.
    d_uf2 = models.FloatField(db_column='D_UF2', blank=True, null=True)  # Field name made lowercase.
    d_uf3 = models.FloatField(db_column='D_UF3', blank=True, null=True)  # Field name made lowercase.
    d_uf4 = models.FloatField(db_column='D_UF4', blank=True, null=True)  # Field name made lowercase.
    d_uf5 = models.FloatField(db_column='D_UF5', blank=True, null=True)  # Field name made lowercase.
    d_uf6 = models.FloatField(db_column='D_UF6', blank=True, null=True)  # Field name made lowercase.
    d_os1 = models.FloatField(db_column='D_OS1', blank=True, null=True)  # Field name made lowercase.
    d_os2 = models.FloatField(db_column='D_OS2', blank=True, null=True)  # Field name made lowercase.
    d_os3 = models.FloatField(db_column='D_OS3', blank=True, null=True)  # Field name made lowercase.
    d_os4 = models.FloatField(db_column='D_OS4', blank=True, null=True)  # Field name made lowercase.
    d_os5 = models.FloatField(db_column='D_OS5', blank=True, null=True)  # Field name made lowercase.
    d_os6 = models.FloatField(db_column='D_OS6', blank=True, null=True)  # Field name made lowercase.
    d_os7 = models.FloatField(db_column='D_OS7', blank=True, null=True)  # Field name made lowercase.
    d_os8 = models.FloatField(db_column='D_OS8', blank=True, null=True)  # Field name made lowercase.
    d_os9 = models.FloatField(db_column='D_OS9', blank=True, null=True)  # Field name made lowercase.

    class Meta:
        managed = False
        db_table = 'Debit'

class Niveau(models.Model):
    date = models.DateTimeField(blank=True, primary_key=True)
    niv_f1 = models.FloatField(db_column='Niv_F1', blank=True, null=True)  # Field name made lowercase.
    niv_f2 = models.FloatField(db_column='Niv_F2', blank=True, null=True)  # Field name made lowercase.
    niv_uf1 = models.FloatField(db_column='Niv_UF1', blank=True, null=True)  # Field name made lowercase.
    niv_uf2 = models.FloatField(db_column='Niv_UF2', blank=True, null=True)  # Field name made lowercase.
    niv_os1 = models.FloatField(db_column='Niv_OS1', blank=True, null=True)  # Field name made lowercase.
    niv_os2 = models.FloatField(db_column='Niv_OS2', blank=True, null=True)  # Field name made lowercase.
    niv_os3 = models.FloatField(db_column='Niv_OS3', blank=True, null=True)  # Field name made lowercase.
    niv_os4 = models.FloatField(db_column='Niv_OS4', blank=True, null=True)  # Field name made lowercase.
    niv_os5 = models.FloatField(db_column='Niv_OS5', blank=True, null=True)  # Field name made lowercase.
    niv_os6 = models.FloatField(db_column='Niv_OS6', blank=True, null=True)  # Field name made lowercase.
    niv_os7 = models.FloatField(db_column='Niv_OS7', blank=True, null=True)  # Field name made lowercase.

    class Meta:
        managed = False
        db_table = 'Niveau'


class PresCond(models.Model):
    date = models.DateTimeField(blank=True, primary_key=True)
    p_uf = models.FloatField(db_column='P_UF', blank=True, null=True)  # Field name made lowercase.
    p_uf4 = models.FloatField(db_column='P_UF4', blank=True, null=True)  # Field name made lowercase.
    p_uf6 = models.FloatField(db_column='P_UF6', blank=True, null=True)  # Field name made lowercase.
    p_os1 = models.FloatField(db_column='P_OS1', blank=True, null=True)  # Field name made lowercase.
    p_os2 = models.FloatField(db_column='P_OS2', blank=True, null=True)  # Field name made lowercase.
    p_os3 = models.FloatField(db_column='P_OS3', blank=True, null=True)  # Field name made lowercase.
    p_os4 = models.FloatField(db_column='P_OS4', blank=True, null=True)  # Field name made lowercase.
    p_os5 = models.FloatField(db_column='P_OS5', blank=True, null=True)  # Field name made lowercase.
    p_os6 = models.FloatField(db_column='P_OS6', blank=True, null=True)  # Field name made lowercase.
    p_os7 = models.FloatField(db_column='P_OS7', blank=True, null=True)  # Field name made lowercase.
    p_os71 = models.FloatField(db_column='P_OS71', blank=True, null=True)  # Field name made lowercase.
    p_os8 = models.FloatField(db_column='P_OS8', blank=True, null=True)  # Field name made lowercase.
    p_os9 = models.FloatField(db_column='P_OS9', blank=True, null=True)  # Field name made lowercase.
    p_ose1 = models.FloatField(db_column='P_OSE1', blank=True, null=True)  # Field name made lowercase.
    p_ose2 = models.FloatField(db_column='P_OSE2', blank=True, null=True)  # Field name made lowercase.
    p_conc = models.FloatField(db_column='P_Conc', blank=True, null=True)  # Field name made lowercase.
    c_uf = models.FloatField(db_column='C_UF', blank=True, null=True)  # Field name made lowercase.
    c_os1 = models.FloatField(db_column='C_OS1', blank=True, null=True)  # Field name made lowercase.
    c_os2 = models.FloatField(db_column='C_OS2', blank=True, null=True)  # Field name made lowercase.
    c_os3 = models.FloatField(db_column='C_OS3', blank=True, null=True)  # Field name made lowercase.
    c_os4 = models.FloatField(db_column='C_OS4', blank=True, null=True)  # Field name made lowercase.
    c_os5 = models.FloatField(db_column='C_OS5', blank=True, null=True)  # Field name made lowercase.
    c_os6 = models.FloatField(db_column='C_OS6', blank=True, null=True)  # Field name made lowercase.
    c_os7 = models.FloatField(db_column='C_OS7', blank=True, null=True)  # Field name made lowercase.
    c_os8 = models.FloatField(db_column='C_OS8', blank=True, null=True)  # Field name made lowercase.
    c_os9 = models.FloatField(db_column='C_OS9', blank=True, null=True)  # Field name made lowercase.
    c_ose = models.FloatField(db_column='C_OSE', blank=True, null=True)  # Field name made lowercase.

    class Meta:
        managed = False
        db_table = 'Pres_Cond'


class Volume(models.Model):
    date = models.DateTimeField(blank=True, primary_key=True)
    vol_for = models.FloatField(db_column='Vol_For', blank=True, null=True)  # Field name made lowercase.
    vol_uf1 = models.FloatField(db_column='Vol_UF1', blank=True, null=True)  # Field name made lowercase.
    vol_uf2 = models.FloatField(db_column='Vol_UF2', blank=True, null=True)  # Field name made lowercase.
    vol_uf3 = models.FloatField(db_column='Vol_UF3', blank=True, null=True)  # Field name made lowercase.
    vol_uf4 = models.FloatField(db_column='Vol_UF4', blank=True, null=True)  # Field name made lowercase.
    vol_uf5 = models.FloatField(db_column='Vol_UF5', blank=True, null=True)  # Field name made lowercase.
    vol_uf6 = models.FloatField(db_column='Vol_UF6', blank=True, null=True)  # Field name made lowercase.
    vol_os1 = models.FloatField(db_column='Vol_OS1', blank=True, null=True)  # Field name made lowercase.
    vol_os2 = models.FloatField(db_column='Vol_OS2', blank=True, null=True)  # Field name made lowercase.
    vol_os3 = models.FloatField(db_column='Vol_OS3', blank=True, null=True)  # Field name made lowercase.
    vol_os4 = models.FloatField(db_column='Vol_OS4', blank=True, null=True)  # Field name made lowercase.
    vol_os5 = models.FloatField(db_column='Vol_OS5', blank=True, null=True)  # Field name made lowercase.
    vol_os6 = models.FloatField(db_column='Vol_OS6', blank=True, null=True)  # Field name made lowercase.
    vol_os7 = models.FloatField(db_column='Vol_OS7', blank=True, null=True)  # Field name made lowercase.
    vol_os8 = models.FloatField(db_column='Vol_OS8', blank=True, null=True)  # Field name made lowercase.
    vol_os9 = models.FloatField(db_column='Vol_OS9', blank=True, null=True)  # Field name made lowercase.

    class Meta:
        managed = False
        db_table = 'Volume'
