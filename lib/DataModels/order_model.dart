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

  Order(
      {this.orderID,
      required this.userID,
      required this.orderPrice,
      required this.orderItems,
      this.status,
      required this.patymentMethod,
      DateTime? orderDateTime})
      : orderDateTime = orderDateTime ?? DateTime.now();
}

enum OrderStatus {
  orderPlaced,
  processingOrder,
  outforDelivery,
  delivered,
  cancelled
}
