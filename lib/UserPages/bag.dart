import 'package:flutter/material.dart';
import 'package:snacc/Widgets/button.dart';

class UserBag extends StatefulWidget {
  const UserBag({super.key});

  @override
  State<UserBag> createState() => _UserBagState();
}

class _UserBagState extends State<UserBag> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      extendBody: true,
      appBar: AppBar(
        leading: const Icon(Icons.shopping_bag_rounded),
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: const Text('Your Bag'),
      ),
      body: Stack(children: <Widget>[
        Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(35),
                color: Colors.grey[200],
              ),
              width: double.maxFinite,
              height: 210,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [Text('Total', style: TextStyle(fontSize: 16)), Text('₹0.00', style: TextStyle(fontSize: 16))],
                    ),const SizedBox(
                      height: 10,
                    ),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [Text('SGST 18%'), Text('₹0.00')],
                    ),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [Text('CGST 18%'), Text('₹0.00')],
                    ),const SizedBox(
                      height: 10,
                    ),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Grand Total',
                          style: TextStyle(fontSize: 20),
                        ),
                        Text('₹0.00', style: TextStyle(fontSize: 20))
                      ],
                    ),const SizedBox(
                      height: 10,
                    ),
                    ElevatedButton(
                        onPressed: () {}, child: const Text('CONTINUE PAYMENT'))
                  ],
                ),
              ),
            ))
      ]),
    ));
  }
}
