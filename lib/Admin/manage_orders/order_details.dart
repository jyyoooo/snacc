import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:snacc/Admin/manage_orders/item_tiles.dart';
import 'package:snacc/DataModels/combo_model.dart';
import 'package:snacc/DataModels/order_model.dart';
import 'package:snacc/Widgets/snacc_button.dart';
import '../../DataModels/product_model.dart';

class OrderDetails extends StatefulWidget {
  final Order order;
  const OrderDetails({super.key, required this.order});

  @override
  State<OrderDetails> createState() => _OrderDetailsState();
}

class _OrderDetailsState extends State<OrderDetails> {
  OrderStatus? selectedOrderStatus;

  @override
  void initState() {
    super.initState();
    selectedOrderStatus = OrderStatus.orderPlaced;
  }

  Widget buildOrderStatusPicker(
    OrderStatus value,
    String title,
    String subtitle,
    Icon icon,
    BorderRadiusGeometry? borderRadius,
  ) {
    return Card(
      margin: const EdgeInsets.all(0),
      shape: RoundedRectangleBorder(
          borderRadius: borderRadius ??
              const BorderRadius.all(Radius.elliptical(15, 15))),
      child: InkResponse(
        onTap: () {
          setState(() {
            selectedOrderStatus = value;
          });
        },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Radio<OrderStatus>(
                    activeColor: Colors.blue,
                    value: value,
                    groupValue: selectedOrderStatus,
                    onChanged: (OrderStatus? selectedStatus) {
                      setState(() {
                        selectedOrderStatus = selectedStatus;
                      });
                    },
                  ),
                  icon,
                  const Gap(10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: GoogleFonts.nunitoSans(
                          fontWeight: FontWeight.normal,
                          fontSize: 16.5,
                        ),
                      ),
                      if (subtitle.isNotEmpty)
                        Text(
                          subtitle,
                          style: GoogleFonts.nunitoSans(
                            fontWeight: FontWeight.normal,
                            fontSize: 13,
                            color: Colors.grey,
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Order number: ${widget.order.orderID}'),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                physics: const BouncingScrollPhysics(),
                itemCount: widget.order.orderItems?.length ?? 0,
                itemBuilder: (context, index) {
                  final orderItem = widget.order.orderItems![index];
                  if (orderItem is ComboModel) {
                    return ComboTile(combo: orderItem);
                  } else if (orderItem is Product) {
                    return ProductTIle(product: orderItem);
                  }
                  return const Center(
                      child: Text(
                          'Oops no items, thats some error on the ordering part'));
                },
              ),
            ),
            Text(
              'Update Order Status',
              style: GoogleFonts.nunitoSans(
                  fontWeight: FontWeight.bold, fontSize: 18),
            ),
            SizedBox(
              height: 400,
              child: Column(
                children: [
                  buildOrderStatusPicker(
                      OrderStatus.orderPlaced,
                      'Order Placed',
                      'Placed order is pending updation',
                      const Icon(
                        Icons.circle,
                        color: Colors.orange,
                      ),
                      BorderRadius.zero),
                  buildOrderStatusPicker(
                      OrderStatus.processingOrder,
                      'Processing Order',
                      'Placed order is pending updation',
                      const Icon(
                        Icons.circle,
                        color: Colors.yellow,
                      ),
                      BorderRadius.zero),
                  buildOrderStatusPicker(
                      OrderStatus.outforDelivery,
                      'Out for Delivery',
                      'Placed order is pending updation',
                      const Icon(
                        Icons.circle,
                        color: Colors.lightGreen,
                      ),
                      BorderRadius.zero),
                  buildOrderStatusPicker(
                      OrderStatus.delivered,
                      'Delivered',
                      'Placed order is pending updation',
                      const Icon(
                        Icons.circle,
                        color: Colors.green,
                      ),
                      BorderRadius.zero),
                  buildOrderStatusPicker(
                      OrderStatus.cancelled,
                      'Cancelled',
                      'Placed order is pending updation',
                      const Icon(
                        Icons.circle,
                        color: Colors.red,
                      ),
                      BorderRadius.zero),
                  const Gap(20),
                  SnaccButton(
                      btncolor: Colors.amber,
                      inputText: 'UPDATE',
                      callBack: () async {
                        final allOrders = Hive.box<Order>('orders');
                        final currentOrder =
                            await allOrders.getAt(widget.order.orderID!);
                        currentOrder!.status = selectedOrderStatus;
                        allOrders.put(currentOrder.orderID, currentOrder);
                        log('order update: ${widget.order.status}');
                      })
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
