

from filtration.models import Niveau, Debit, PresCond, Volume
from rest_framework import serializers

class NiveauSerializer(serializers.ModelSerializer):
    class Meta:
        model = Niveau
        fields = [
            'date',
            'niv_f1',
            'niv_f2',
            'niv_uf1',
            'niv_uf2',
            'niv_os1',
            'niv_os2',
            'niv_os3',
            'niv_os4',
            'niv_os5',
            'niv_os6',
            'niv_os7',
        ]

class DebitSerializer(serializers.ModelSerializer):
    class Meta:
        model = Debit
        fields = [
            'date',
            'd_f1',
            'd_f2',
            'd_uf1',
            'd_uf2',
            'd_uf3',
            'd_uf4',
            'd_uf5',
            'd_uf6',
            'd_os1',
            'd_os2',
            'd_os3',
            'd_os4',
            'd_os5',
            'd_os6',
            'd_os7',
            'd_os8',
            'd_os9',
        ]

class PresCondSerializer(serializers.ModelSerializer):
    class Meta:
        model = PresCond
        fields = [
            'date',
            'p_uf',
            'p_uf4',
            'p_uf6',
            'p_os1',
            'p_os2',
            'p_os3',
            'p_os4',
            'p_os5',
            'p_os6',
            'p_os7',
            'p_os71',
            'p_os8',
        ]

class VolumeSerializer(serializers.ModelSerializer):
    class Meta:
        model = Volume
        fields = [
            'date',
            "vol_for",
            "vol_uf1",
            "vol_uf2",
            "vol_uf3",
            "vol_uf4",
            "vol_uf5",
            "vol_uf6",
            "vol_os1",
            "vol_os2",
            "vol_os3",
            "vol_os4",
            "vol_os5",
            "vol_os6",
            "vol_os7",
            "vol_os8",
            "vol_os9"
    ]