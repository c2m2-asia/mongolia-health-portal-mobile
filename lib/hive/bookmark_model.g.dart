// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../models/bookmark_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class BookmarkItemAdapter extends TypeAdapter<BookmarkItem> {
  @override
  final int typeId = 0;

  @override
  BookmarkItem read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return BookmarkItem(
      titleDetail: fields[0] as TitleDetail,
      infoDetail: fields[1] as InfoDetail,
      serviceId: fields[2] as String,
      list: (fields[3] as List)?.cast<FeaturePair>(),
    );
  }

  @override
  void write(BinaryWriter writer, BookmarkItem obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.titleDetail)
      ..writeByte(1)
      ..write(obj.infoDetail)
      ..writeByte(2)
      ..write(obj.serviceId)
      ..writeByte(3)
      ..write(obj.list);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BookmarkItemAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
