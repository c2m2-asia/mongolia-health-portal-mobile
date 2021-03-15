// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../main.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class FeatureTypeAdapter extends TypeAdapter<FeatureType> {
  @override
  final int typeId = 3;

  @override
  FeatureType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return FeatureType.HEALTH_SERVICES;
      case 1:
        return FeatureType.PHARMACY;
      default:
        return null;
    }
  }

  @override
  void write(BinaryWriter writer, FeatureType obj) {
    switch (obj) {
      case FeatureType.HEALTH_SERVICES:
        writer.writeByte(0);
        break;
      case FeatureType.PHARMACY:
        writer.writeByte(1);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FeatureTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
