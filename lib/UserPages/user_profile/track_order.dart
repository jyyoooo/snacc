
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:snacc/Functions/order_funtions.dart';
import 'package:snacc/Widgets/snacc_track.dart';
import '../../DataModels/order_model.dart';

class TrackOrders extends StatelessWidget {
  final int userID;

  const TrackOrders({Key? key, required this.userID}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            'Track Your Order',
            style:
                GoogleFonts.nunitoSans(fontWeight: FontWeight.bold, fontSize: 23),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: FutureBuilder(
            future: fetchUserOrders(userID),
            builder: (context, AsyncSnapshot<List<Order>> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return const Center(child: Text('Error loading Orders'));
              } else if (snapshot.hasData) {
                List<Order> userOrders = snapshot.data!.reversed.toList();
                int ordersLength = userOrders.length;
      
                return Column(
                  children: [
                    Text(
                      '$ordersLength Active orders',
                      style: GoogleFonts.nunitoSans(),
                    ),
                    const Gap(10),
                    Expanded(
                      child: userOrders.isNotEmpty
                          ? ListView.builder(
                              physics: const BouncingScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: userOrders.length,
                              itemBuilder: (context, index) {
                                final order = userOrders[index];
      
                                if (order.status == OrderStatus.cancelled) {
                                  return const SizedBox.shrink();
                                } else {
                                  return OrderItem(order: order);
                                }
                              },
                            )
                          : Center(
                              child: Text(
                              'No Orders',
                              style: GoogleFonts.nunitoSans(
                                  color: Colors.grey, fontSize: 15),
                            )),
                    ),
                  ],
                );
              } else {
                return const Center(child: Text('No Orders'));
              }
            },
          ),
        ),
      ),
    );
  }
}

class OrderItem extends StatelessWidget {
  const OrderItem({
    super.key,
    required this.order,
  });

  final Order order;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => TrackSnacc(
                  order: order,
                  isHistory: false,
                )));
      },
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(8, 12, 16, 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Order ID: ${order.orderID}',
                                  style: GoogleFonts.nunitoSans(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                                const Gap(10),
                                Text(
                                    '${getFormattedOrderedTime(order.orderDateTime)}')
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  '₹${order.orderPrice}',
                                  style: GoogleFonts.nunitoSans(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 18,
                                  ),
                                ),
                                const Gap(10),
                                Row(
                                  children: [
                                    // Icon(
                                    //   Icons.circle,
                                    //   color:
                                    //       getOrderStatusColor(
                                    //           order
                                    //               .status!),
                                    // ),
                                    const Gap(10),
                                    Text(
                                      'See Status',
                                      style: GoogleFonts.nunitoSans(
                                          color: Colors.blue,
                                          fontWeight: FontWeight.normal),
                                    ),
                                    const Icon(
                                      Icons.keyboard_arrow_right_rounded,
                                      color: Colors.blue,
                                    ),
                                  ],
                                ),
                              ],
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const Gap(5),
            ],
          ),
        ),
      ),
    );
  }
}
