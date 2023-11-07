import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:snacc/Admin/manage_orders/oorder_details.dart';
import 'package:snacc/Functions/order_funtions.dart';

import '../../DataModels/order_model.dart';

class OrdersPage extends StatelessWidget {
  const OrdersPage({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Orders'),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          TextButton.icon(
            onPressed: () {
              Hive.box<Order>('orders').clear();
            },
            icon: const Icon(Icons.warning_amber_rounded),
            label: const Text('Ditch All Orders',style: TextStyle(color: Colors.red),),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            FutureBuilder(
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
                      // physics: const NeverScrollableScrollPhysics(),
                      itemCount: reversedOrders.length,
                      itemBuilder: (context, index) {
                        final order = reversedOrders[index];
                        return InkWell(
                          onTap: () {
                            log('${order.orderID}');
                            // Navigator.of(context).push(MaterialPageRoute(
                            //     builder: (context) =>
                            //         OrderDetails(order: order)));
                          },
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  // Container(
                                  //   height: 70,
                                  //   width: 70,
                                  //   decoration: BoxDecoration(
                                  //     borderRadius: BorderRadius.circular(10),
                                  //     border: Border.all(
                                  //       color: Colors.grey,
                                  //       width: 2.0,
                                  //     ),
                                  //   ),
                                  //   child: ClipRRect(
                                  //     borderRadius: BorderRadius.circular(10),
                                  //     child: Image.asset(
                                  //       'assets/images/Snacc.png',
                                  //       fit: BoxFit.contain,
                                  //     ),
                                  //   ),
                                  // ),
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
                                              '${order.orderID}',
                                              style:
                                                  const TextStyle(fontSize: 18),
                                            ),
                                            Text(
                                              '${order.orderPrice}',
                                              style: const TextStyle(
                                                color: Colors.blue,
                                                fontWeight: FontWeight.w400,
                                                fontSize: 15,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              '${order.orderDateTime}',
                                              style: const TextStyle(
                                                fontSize: 14,
                                                color: Colors.grey,
                                              ),
                                            ),
                                            Row(
                                              children: [
                                                const Icon(
                                                  Icons.circle,
                                                  color: Colors.green,
                                                  size: 12,
                                                ),
                                                const SizedBox.square(
                                                  dimension: 5,
                                                ),
                                                Text(
                                                  'order status: ${order.status}',
                                                  style: const TextStyle(
                                                    fontSize: 14,
                                                    color: Colors.grey,
                                                    fontWeight: FontWeight.w400,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                            ],
                          ),
                        );
                      },
                    );
                  } else {
                    return const Text('No Orders');
                  }
                }),
          ],
        ),
      ),
    );
  }
}
