# This is an auto-generated Django model module.
# You'll have to do the following manually to clean this up:
#   * Rearrange models' order
#   * Make sure each model has one field with primary_key=True
#   * Make sure each ForeignKey and OneToOneField has `on_delete` set to the desired behavior
#   * Remove `managed = False` lines if you wish to allow Django to create, modify, and delete the table
# Feel free to rename the models, but don't rename db_table values or field names.
from django.db import models


class Sucre(models.Model):
    date = models.DateTimeField(blank=True, primary_key=True)
    t_s21 = models.FloatField(db_column='T_S21', blank=True, null=True) # Field name made lowercase.
    t_s22 = models.FloatField(db_column='T_S22', blank=True, null=True) # Field name made lowercase.
    t_s23 = models.FloatField(db_column='T_S23', blank=True, null=True) # Field name made lowercase.
    t_s24 = models.FloatField(db_column='T_S24', blank=True, null=True) # Field name made lowercase.
    t_s25 = models.FloatField(db_column='T_S25', blank=True, null=True) # Field name made lowercase.
    a_t02 = models.FloatField(db_column='A_T02', blank=True, null=True) # Field name made lowercase.
    a_t03 = models.FloatField(db_column='A_T03', blank=True, null=True) # Field name made lowercase.
    a_t04 = models.FloatField(db_column='A_T04', blank=True, null=True) # Field name made lowercase.
    a_t05 = models.FloatField(db_column='A_T05', blank=True, null=True) # Field name made lowercase.
    a_t06 = models.FloatField(db_column='A_T06', blank=True, null=True) # Field name made lowercase.

    class Meta:
        managed = False
        db_table = 'Sucre'
