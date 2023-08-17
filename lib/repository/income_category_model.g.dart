// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'income_category_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class IncomeCategoryModelAdapter extends TypeAdapter<IncomeCategoryModel> {
  @override
  final int typeId = 1;

  @override
  IncomeCategoryModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return IncomeCategoryModel(
      id: fields[0] as String,
      categoryName: fields[1] as String,
    );
  }

  @override
  void write(BinaryWriter writer, IncomeCategoryModel obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.categoryName);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is IncomeCategoryModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
