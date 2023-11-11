// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserModelAdapter extends TypeAdapter<UserModel> {
  @override
  final int typeId = 2;

  @override
  UserModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserModel(
      userID: fields[0] as int?,
      username: fields[3] as String?,
      userMail: fields[1] as String?,
      userPass: fields[2] as String?,
      confirmPass: fields[4] as String?,
      favorites: (fields[5] as List?)?.cast<dynamic>(),
      userBag: (fields[6] as List?)?.cast<dynamic>(),
    )..userOrders = (fields[7] as List?)?.cast<Order>();
  }

  @override
  void write(BinaryWriter writer, UserModel obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.userID)
      ..writeByte(1)
      ..write(obj.userMail)
      ..writeByte(2)
      ..write(obj.userPass)
      ..writeByte(3)
      ..write(obj.username)
      ..writeByte(4)
      ..write(obj.confirmPass)
      ..writeByte(5)
      ..write(obj.favorites)
      ..writeByte(6)
      ..write(obj.userBag)
      ..writeByte(7)
      ..write(obj.userOrders);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
