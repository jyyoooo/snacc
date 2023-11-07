import 'dart:io';

import 'package:flutter/material.dart';
import 'package:snacc/DataModels/combo_model.dart';
import 'package:snacc/DataModels/order_model.dart';

import '../../DataModels/product_model.dart';

class OrderDetails extends StatelessWidget {
  final Order order;
  const OrderDetails({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Order number: ${order.orderID}'),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Container(
        child: ListView.builder(
          itemCount: order.orderItems?.length ?? 0,
          itemBuilder: (context, index) {
            final orderItem = order.orderItems![index];
            // You can access and display properties of the orderItem here
            // For example:

            return ListTile(
              leading: SizedBox(
                width: 50,
                height: 50,
                // child: Image.file(File()),
              ),
              title: Text('fuckinghell'),
              // Add more details or widgets to display order item details
            );
          },
        ),
      ),
    );
  }
}



// orderItem is ComboModel
//                     ? orderItem.comboImgUrl
//                     : orderItem is Product
//                         ? orderItem.prodimgUrl!
//                         : null