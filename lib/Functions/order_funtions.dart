import 'dart:developer';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:snacc/DataModels/order_model.dart';
import '../UserPages/Your Bag/payment.dart';

Future<bool> createOrder(int? userId, List<dynamic>? orderItems, double orderPrice,
    PaymentOption method) async {
  final ordersBox = Hive.box<Order>('orders');
  bool isDuplicate = false;

  final newOrder = Order(
    userID: userId,
    orderPrice: orderPrice,
    orderItems: orderItems,
    patymentMethod: method,
  );

  // Iterate through existing orders and check for duplicates
  for (var i = 0; i < ordersBox.length; i++) {
    final existingOrder = ordersBox.getAt(i);
    if (existingOrder != null) {
      if (existingOrder.userID == newOrder.userID &&
          existingOrder.orderPrice == newOrder.orderPrice &&
          existingOrder.patymentMethod == newOrder.patymentMethod) {
        isDuplicate = true;
        break;
      }
    }
  }

  if (isDuplicate) {
    Fluttertoast.showToast(msg: 'You have already placed this order');
    return false;
  } else {
    final orderIdFromHive = await ordersBox.add(newOrder);
    newOrder.orderID = orderIdFromHive;
    await ordersBox.put(newOrder.orderID, newOrder);
    log('ORDER DETAILS\n orderid: ${newOrder.orderID}\n userid: ${newOrder.userID}\n order price: ${newOrder.orderPrice}\n order time: ${newOrder.orderDateTime}\n order method: ${newOrder.patymentMethod}');

    return true;
  }
}

Future<List<Order>> fetchOrders() async {
  final allOrders = Hive.box<Order>('orders');
  return allOrders.values.toList();
}
