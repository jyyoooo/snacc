import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:snacc/Admin/manage_orders/order_details.dart';
import 'package:snacc/Functions/order_funtions.dart';
import '../../DataModels/order_model.dart';

class OrdersPage extends StatefulWidget {
  const OrdersPage();

  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const SizedBox.shrink(),
        title: Text(
          'Orders',
          style:
              GoogleFonts.nunitoSans(fontSize: 23, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: .4,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          physics: const BouncingScrollPhysics(),
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
    final screenHeight = MediaQuery.of(context).size.height;
    return FutureBuilder(
        future: fetchOrders(),
        builder: (context, snapshot) {
          if (snapshot.data != null) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else if (snapshot.hasError) {
              log('order snapshot has error');
              return const Text('Error loading Orders');
            } else if (snapshot.hasData) {
              List<Order> reversedOrders = snapshot.data!.reversed.toList();

              return snapshot.data!.isNotEmpty
                  ? ListView.builder(
                      physics: const BouncingScrollPhysics(),
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
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15)),
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(8, 12, 16, 8),
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
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  'Order ID: ${order.orderID}',
                                                  style: GoogleFonts.nunitoSans(
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                Text(
                                                  '₹${order.orderPrice}',
                                                  style: GoogleFonts.nunitoSans(
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 18,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const Gap(10),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                    '${getFormattedOrderedTime(order.orderDateTime)}',
                                                    style:
                                                        GoogleFonts.nunitoSans(
                                                            fontSize:
                                                                screenHeight >
                                                                        700
                                                                    ? 15
                                                                    : 13)),
                                                Text(
                                                    '${DateFormat.yMMMEd().format(order.orderDateTime!)} ',
                                                    style:
                                                        GoogleFonts.nunitoSans(
                                                            fontSize:
                                                                screenHeight >
                                                                        700
                                                                    ? 15
                                                                    : 13)),
                                                Row(
                                                  children: [
                                                    Icon(
                                                      Icons.circle,
                                                      color:
                                                          getOrderStatusColor(
                                                              order.status!),
                                                      size: screenHeight > 700
                                                          ? 15
                                                          : 13,
                                                    ),
                                                    const Gap(3),
                                                    // FIX HERE, theres overflow issue

                                                    Text(
                                                        getOrderStatus(
                                                            order.status!),
                                                        style: GoogleFonts
                                                            .nunitoSans(
                                                                fontSize:
                                                                    screenHeight >
                                                                            700
                                                                        ? 15
                                                                        : 13,
                                                                color:
                                                                    Colors.blue,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold)),
                                                  ],
                                                ),
                                              ],
                                            ),
                                            const Gap(8),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  '${getPaymentMethod(order.patymentMethod!)}',
                                                  style: GoogleFonts.nunitoSans(
                                                      color: Colors.blue,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                Text(
                                                  order.screenAndSeatNumber!,
                                                  style: GoogleFonts.nunitoSans(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 20),
                                                )
                                              ],
                                            )
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
                    )
                  : Center(
                      heightFactor: 15,
                      child: Text(
                        'No Orders',
                        style: GoogleFonts.nunitoSans(
                            color: Colors.grey, fontSize: 15),
                      ));
            }
          }
          return SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: SizedBox(
              height: 640,
              child: Center(
                  heightFactor: 15,
                  child: Text(
                    'No Orders',
                    style: GoogleFonts.nunitoSans(
                        color: Colors.grey, fontSize: 17),
                  )),
            ),
          );
        });
  }
}
