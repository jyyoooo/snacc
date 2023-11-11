import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:snacc/DataModels/order_model.dart';
import 'package:snacc/DataModels/user_model.dart';
import 'package:snacc/Functions/favorites_functions.dart';
import '../UserPages/Your Bag/payment.dart';
import 'package:intl/intl.dart';

Future<bool> createOrder(
  int? userId,
  List<dynamic>? orderItems,
  double orderPrice,
  PaymentOption method,
  String screenAndSeatNumber,
) async {
  final ordersBox = Hive.box<Order>('orders');
  bool isDuplicate = false;

  final newOrder = Order(
      screenAndSeatNumber: screenAndSeatNumber,
      userID: userId,
      orderPrice: orderPrice,
      orderItems: orderItems,
      patymentMethod: method,
      status: OrderStatus.orderPlaced);

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
    log('ORDER DETAILS\n orderid: ${newOrder.orderID}\n userid: ${newOrder.userID}\n order price: ${newOrder.orderPrice}\n order time: ${newOrder.orderDateTime}\n order method: ${newOrder.patymentMethod}\n scrren & seat:${newOrder.screenAndSeatNumber}');

    return true;
  }
}

Future<List<Order>> fetchOrders() async {
  final allOrders = Hive.box<Order>('orders');
  return allOrders.values.toList();
}

getFormattedOrderedTime(time) {
  var now = time;
  String formattedTime = DateFormat('kk:mm:a').format(now);
  log(formattedTime);
  return formattedTime;
}

getOrderStatus(OrderStatus status) {
  if (status == OrderStatus.orderPlaced) {
    return 'Order Pending';
  } else if (status == OrderStatus.processingOrder) {
    return 'Preparing';
  } else if (status == OrderStatus.outforDelivery) {
    return 'Delivering';
  } else if (status == OrderStatus.delivered) {
    return 'Complete';
  } else {
    return 'Cancelled';
  }
}

Color getOrderStatusColor(OrderStatus status) {
  if (status == OrderStatus.orderPlaced) {
    return Colors.orange;
  } else if (status == OrderStatus.processingOrder) {
    return Colors.yellow;
  } else if (status == OrderStatus.outforDelivery) {
    return Colors.lightGreen;
  } else if (status == OrderStatus.delivered) {
    return Colors.green;
  } else {
    return Colors.red;
  }
}

getPaymentMethod(PaymentOption method) {
  if (method == PaymentOption.cod) {
    return 'Cash On Delivery';
  } else if (method == PaymentOption.card) {
    return 'Card Payment';
  } else if (method == PaymentOption.payPal) {
    return 'Paypal';
  } else if (method == PaymentOption.upi) {
    return 'UPI';
  } else {
    return 'unknown';
  }
}

Future<List<Order>> fetchUserOrders(int userID) async {
  final allOrders = Hive.box<Order>('orders').values.toList();
  List<Order> userOrders = [];

  for (Order order in allOrders) {
    if (order.userID == userID) {
      userOrders.add(order);
    }
  }
  putOrdersToUserOrders(userOrders);

  log('$userID user orders: $userOrders');
  return userOrders;
}

putOrdersToUserOrders(userOrders) async {
  final user = await getUser();
  user.userOrders?.addAll(userOrders);
  final userbox = Hive.box<UserModel>('userinfo');
  userbox.put(user.userID, user);
}
