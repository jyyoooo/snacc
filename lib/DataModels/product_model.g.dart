// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ProductAdapter extends TypeAdapter<Product> {
  @override
  final int typeId = 1;

  @override
  Product read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Product(
      prodimgUrl: fields[1] as String?,
      prodname: fields[2] as String?,
      prodprice: fields[3] as double?,
      quantity: fields[4] as int?,
      isFavorite: fields[5] as bool?,
      categoryID: fields[6] as int?,
      productID: fields[0] as int?,
    );
  }

  @override
  void write(BinaryWriter writer, Product obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.productID)
      ..writeByte(1)
      ..write(obj.prodimgUrl)
      ..writeByte(2)
      ..write(obj.prodname)
      ..writeByte(3)
      ..write(obj.prodprice)
      ..writeByte(4)
      ..write(obj.quantity)
      ..writeByte(5)
      ..write(obj.isFavorite)
      ..writeByte(6)
      ..write(obj.categoryID);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProductAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
