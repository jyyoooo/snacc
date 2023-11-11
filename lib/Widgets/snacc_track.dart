import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:snacc/Admin/manage_orders/item_tiles.dart';
import 'package:snacc/Admin/manage_orders/order_details.dart';
import 'package:snacc/DataModels/combo_model.dart';
import 'package:snacc/DataModels/order_model.dart';
import 'package:snacc/DataModels/product_model.dart';

class TrackSnacc extends StatefulWidget {
  final Order order;
  final bool isHistory;
  const TrackSnacc({super.key, required this.order, required this.isHistory});

  @override
  State<TrackSnacc> createState() => TrackSnaccState();
}

class TrackSnaccState extends State<TrackSnacc> {
  late double _sliderValue;
  Order? thisOrder;
  @override
  void initState() {
    super.initState();
    thisOrder = Hive.box<Order>('orders').getAt(widget.order.orderID!);
    _sliderValue = getStatusValue(thisOrder!.status);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Order ID: ${thisOrder!.orderID}',
          style:
              GoogleFonts.nunitoSans(fontSize: 23, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            !widget.isHistory
                ? SizedBox(
                    child: OrderTrackingProgress(sliderValue: _sliderValue),
                  )
                : const SizedBox.shrink(),
            Gap(!widget.isHistory ? 20 : 0),
            Text(
              '  Ordered Items',
              style: GoogleFonts.nunitoSans(
                  fontSize: 20, fontWeight: FontWeight.bold),
              textAlign: TextAlign.left,
            ),
            Expanded(
              child: ListView.builder(
                physics: const BouncingScrollPhysics(),
                itemCount: widget.order.orderItems?.length ?? 0,
                itemBuilder: (context, index) {
                  final orderItem = widget.order.orderItems![index];
                  if (orderItem is ComboModel) {
                    return ComboTile(
                      combo: orderItem,
                      isHistory: widget.isHistory,
                    );
                  } else if (orderItem is Product) {
                    return ProductTIle(
                      product: orderItem,
                      isHistory: widget.isHistory,
                    );
                  }
                  return const Center(
                      child: Text(
                          'Oops no items, thats some error on the ordering part'));
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class OrderTrackingProgress extends StatelessWidget {
  const OrderTrackingProgress({
    super.key,
    required double sliderValue,
  }) : _sliderValue = sliderValue;

  final double _sliderValue;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Gap(20),
        Text(
          'We have received your order.',
          style: GoogleFonts.nunitoSans(),
        ),
        Padding(
          padding: const EdgeInsets.all(20),
          child: LinearProgressIndicator(
            minHeight: 5,
            borderRadius: BorderRadius.circular(10),
            color: Colors.green,
            backgroundColor: Colors.grey[300],
            value: _sliderValue,
            // onChanged: null,
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text(
              'Order\nPlaced',
              textAlign: TextAlign.justify,
              style: GoogleFonts.nunitoSans(),
            ),
            Text(
              'Processing',
              style: GoogleFonts.nunitoSans(),
            ),
            Text('Delivering\nsoon',
                textAlign: TextAlign.center, style: GoogleFonts.nunitoSans()),
            Text('Delivered', style: GoogleFonts.nunitoSans()),
          ],
        )
      ],
    );
  }
}

double getStatusValue(OrderStatus? status) {
  switch (status) {
    case OrderStatus.orderPlaced:
      return 0.1;
    case OrderStatus.processingOrder:
      return 0.3;
    case OrderStatus.outforDelivery:
      return 0.7;
    case OrderStatus.delivered:
      return 1.0;
    default:
      OrderStatus.cancelled;
      return 1;
  }
}
