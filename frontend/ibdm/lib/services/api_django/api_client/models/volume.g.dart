// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'volume.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Volume _$VolumeFromJson(Map<String, dynamic> json) => Volume(
      date: DateTime.parse(json['date'] as String),
      volFor: (json['vol_for'] as num?)?.toDouble(),
      volUf1: (json['vol_uf1'] as num?)?.toDouble(),
      volUf2: (json['vol_uf2'] as num?)?.toDouble(),
      volUf3: (json['vol_uf3'] as num?)?.toDouble(),
      volUf4: (json['vol_uf4'] as num?)?.toDouble(),
      volUf5: (json['vol_uf5'] as num?)?.toDouble(),
      volUf6: (json['vol_uf6'] as num?)?.toDouble(),
      volOs1: (json['vol_os1'] as num?)?.toDouble(),
      volOs2: (json['vol_os2'] as num?)?.toDouble(),
      volOs3: (json['vol_os3'] as num?)?.toDouble(),
      volOs4: (json['vol_os4'] as num?)?.toDouble(),
      volOs5: (json['vol_os5'] as num?)?.toDouble(),
      volOs6: (json['vol_os6'] as num?)?.toDouble(),
      volOs7: (json['vol_os7'] as num?)?.toDouble(),
      volOs8: (json['vol_os8'] as num?)?.toDouble(),
      volOs9: (json['vol_os9'] as num?)?.toDouble(),
      volConLav: (json['vol_con_lav'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$VolumeToJson(Volume instance) => <String, dynamic>{
      'date': instance.date.toIso8601String(),
      'vol_for': instance.volFor,
      'vol_uf1': instance.volUf1,
      'vol_uf2': instance.volUf2,
      'vol_uf3': instance.volUf3,
      'vol_uf4': instance.volUf4,
      'vol_uf5': instance.volUf5,
      'vol_uf6': instance.volUf6,
      'vol_os1': instance.volOs1,
      'vol_os2': instance.volOs2,
      'vol_os3': instance.volOs3,
      'vol_os4': instance.volOs4,
      'vol_os5': instance.volOs5,
      'vol_os6': instance.volOs6,
      'vol_os7': instance.volOs7,
      'vol_os8': instance.volOs8,
      'vol_os9': instance.volOs9,
      'vol_con_lav': instance.volConLav,
    };
