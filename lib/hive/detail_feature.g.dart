// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../mapfeature/detail_feature.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class FeaturePairAdapter extends TypeAdapter<FeaturePair> {
  @override
  final int typeId = 4;

  @override
  FeaturePair read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return FeaturePair(
      fields[0] as String,
      fields[1] as dynamic,
    );
  }

  @override
  void write(BinaryWriter writer, FeaturePair obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.key)
      ..writeByte(1)
      ..write(obj.value);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FeaturePairAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class TitleDetailAdapter extends TypeAdapter<TitleDetail> {
  @override
  final int typeId = 1;

  @override
  TitleDetail read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TitleDetail(
      fields[0] as String,
      fields[1] as String,
      fields[2] as String,
      fields[4] as int,
      fields[3] as FeatureType,
    );
  }

  @override
  void write(BinaryWriter writer, TitleDetail obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.title)
      ..writeByte(1)
      ..write(obj.subTitle)
      ..writeByte(2)
      ..write(obj.rating)
      ..writeByte(3)
      ..write(obj.featureType)
      ..writeByte(4)
      ..write(obj.raters);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TitleDetailAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class InfoDetailAdapter extends TypeAdapter<InfoDetail> {
  @override
  final int typeId = 2;

  @override
  InfoDetail read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return InfoDetail(
      (fields[0] as List)?.cast<String>(),
      (fields[1] as List)?.cast<double>(),
      fields[3] as String,
      fields[5] as String,
      fields[2] as String,
      fields[4] as String,
    );
  }

  @override
  void write(BinaryWriter writer, InfoDetail obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.phone)
      ..writeByte(1)
      ..write(obj.coordinates)
      ..writeByte(2)
      ..write(obj.name)
      ..writeByte(3)
      ..write(obj.serviceId)
      ..writeByte(4)
      ..write(obj.osmID)
      ..writeByte(5)
      ..write(obj.type);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is InfoDetailAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
