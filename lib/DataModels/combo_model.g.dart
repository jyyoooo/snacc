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
      comboID: fields[0] as int?,
      comboImgUrl: fields[3] as String?,
      comboItems: (fields[4] as List?)?.cast<Product?>(),
      comboName: fields[1] as String?,
      comboPrice: fields[2] as double?,
      isFavorite: fields[5] as bool?,
    )..description = fields[6] as String?;
  }

  @override
  void write(BinaryWriter writer, ComboModel obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.comboID)
      ..writeByte(1)
      ..write(obj.comboName)
      ..writeByte(2)
      ..write(obj.comboPrice)
      ..writeByte(3)
      ..write(obj.comboImgUrl)
      ..writeByte(4)
      ..write(obj.comboItems)
      ..writeByte(5)
      ..write(obj.isFavorite)
      ..writeByte(6)
      ..write(obj.description);
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
