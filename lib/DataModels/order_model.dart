import 'package:hive_flutter/hive_flutter.dart';
import 'package:snacc/UserPages/Your%20Bag/payment.dart';
part 'order_model.g.dart';

@HiveType(typeId: 5)
class Order {
  @HiveField(0)
  int? orderID;

  @HiveField(1)
  int? userID;

  @HiveField(2)
  List<dynamic>? orderItems;

  @HiveField(3)
  OrderStatus? status;

  @HiveField(4)
  DateTime? orderDateTime;

  @HiveField(5)
  double? orderPrice;

  @HiveField(6)
  PaymentOption? patymentMethod;

  @HiveField(7)
  String? screenAndSeatNumber;

  Order(
      {this.orderID,
      required this.userID,
      required this.orderPrice,
      required this.orderItems,
      this.status,
      required this.patymentMethod,
      DateTime? orderDateTime,
      required this.screenAndSeatNumber})
      : orderDateTime = orderDateTime ?? DateTime.now();
}

enum OrderStatus {
  orderPlaced,
  processingOrder,
  outforDelivery,
  delivered,
  cancelled
}

class OrderStatusAdapter extends TypeAdapter<OrderStatus> {
  @override
  final int typeId = 6;

  @override
  OrderStatus read(BinaryReader reader) {
    return OrderStatus.values[reader.readByte()];
  }

  @override
  void write(BinaryWriter writer, OrderStatus orderStatus) {
    writer.writeByte(orderStatus.index);
  }
}
