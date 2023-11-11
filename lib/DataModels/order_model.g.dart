// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class OrderAdapter extends TypeAdapter<Order> {
  @override
  final int typeId = 5;

  @override
  Order read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Order(
      orderID: fields[0] as int?,
      userID: fields[1] as int?,
      orderPrice: fields[5] as double?,
      orderItems: (fields[2] as List?)?.cast<dynamic>(),
      status: fields[3] as OrderStatus?,
      patymentMethod: fields[6] as PaymentOption?,
      orderDateTime: fields[4] as DateTime?,
      screenAndSeatNumber: fields[7] as String?
    );
  }

  @override
  void write(BinaryWriter writer, Order obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.orderID)
      ..writeByte(1)
      ..write(obj.userID)
      ..writeByte(2)
      ..write(obj.orderItems)
      ..writeByte(3)
      ..write(obj.status)
      ..writeByte(4)
      ..write(obj.orderDateTime)
      ..writeByte(5)
      ..write(obj.orderPrice)
      ..writeByte(6)
      ..write(obj.patymentMethod)
      ..writeByte(7)
      ..write(obj.screenAndSeatNumber);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OrderAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
