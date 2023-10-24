// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'combo_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ComboModelAdapter extends TypeAdapter<ComboModel> {
  @override
  final int typeId = 3;

  @override
  ComboModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ComboModel(
      comboImgUrl: fields[2] as String?,
      comboItems: (fields[3] as List?)?.cast<Product?>(),
      comboName: fields[0] as String?,
      comboPrice: fields[1] as double?,
    );
  }

  @override
  void write(BinaryWriter writer, ComboModel obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.comboName)
      ..writeByte(1)
      ..write(obj.comboPrice)
      ..writeByte(2)
      ..write(obj.comboImgUrl)
      ..writeByte(3)
      ..write(obj.comboItems);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ComboModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
