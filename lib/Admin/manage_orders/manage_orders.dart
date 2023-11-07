import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:snacc/Admin/manage_orders/order_details.dart';
import 'package:snacc/Functions/order_funtions.dart';

import '../../DataModels/order_model.dart';

class OrdersPage extends StatelessWidget {
  const OrdersPage({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Orders',
          style:
              GoogleFonts.nunitoSans(fontSize: 23, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          TextButton.icon(
            onPressed: () {
              Hive.box<Order>('orders').clear();
            },
            icon: const Icon(Icons.warning_amber_rounded),
            label: const Text(
              'Ditch All Orders',
              style: TextStyle(color: Colors.red),
            ),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: const [
            ManageOrderList(),
          ],
        ),
      ),
    );
  }
}

class ManageOrderList extends StatelessWidget {
  const ManageOrderList({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: fetchOrders(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else if (snapshot.hasError) {
            log('order snapshot has error');
            return const Text('Error loading Orders');
          } else if (snapshot.hasData) {
            List<Order> reversedOrders =
                snapshot.data!.reversed.toList();
            return ListView.builder(
              shrinkWrap: true,
              itemCount: reversedOrders.length,
              itemBuilder: (context, index) {
                final order = reversedOrders[index];
                return InkWell(
                  onTap: () {
                    log('${order.orderID}');
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) =>
                            OrderDetails(order: order)));
                  },
                  child: Card(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(8,12,16,8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'Order ID: ${order.orderID}',
                                          style: GoogleFonts.nunitoSans(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          '₹${order.orderPrice}',
                                          style: GoogleFonts.nunitoSans(
                                            color: Colors.blue,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 18,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const Gap(10),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                            '${getFormattedOrderedTime(order.orderDateTime)}',
                                            style: GoogleFonts.nunitoSans(
                                                fontSize: 15)),
                                        Text(
                                            '${DateFormat.yMMMEd().format(order.orderDateTime!)} ',
                                            style: GoogleFonts.nunitoSans(
                                                fontSize: 15)),
                                      const  Row(
                                          children: [
                                             Icon(
                                              Icons.circle,
                                              color: Colors.green,
                                              size: 12,
                                            ),
                                             SizedBox.square(
                                              dimension: 5,
                                            ),

                                              // FIX HERE, theres overflow issue



                                            // Text(
                                            //   '${order.status}',
                                            //   style: const TextStyle(
                                            //     fontSize: 14,
                                            //     color: Colors.grey,
                                            //     fontWeight: FontWeight.w400,
                                            //   ),
                                            // ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    const Gap(8),
                                    Text('Payment Method: ${order.patymentMethod}',style: GoogleFonts.nunitoSans(color: Colors.blue),)
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          } else {
            return const Text('No Orders');
          }
        });
  }
}