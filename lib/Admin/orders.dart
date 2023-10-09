import 'package:flutter/material.dart';

class Orders extends StatelessWidget {
  const Orders({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const Text('Catergories',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500)),
          ListView.builder(
            itemBuilder: (context, index) => Column(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      children: [
                        Row(
                          children: [
                            SizedBox(
                              height: 70,
                              width: 70,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.asset(
                                  'assets/images/digital-food-product-label-design-500x500.webp',
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            const Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Product name here',
                                        style: TextStyle(fontSize: 18),
                                      ),
                                      Text('₹387.4',
                                          style: TextStyle(
                                              color: Colors.blue,
                                              fontWeight: FontWeight.w400,
                                              fontSize: 15)),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text('Apr 8, 9:45 AM',
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.grey,
                                          )),
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.circle,
                                            color: Colors.green,
                                            size: 12,
                                          ),
                                          SizedBox.square(
                                            dimension: 5,
                                          ),
                                          Text('Successful',
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.grey,
                                                  fontWeight: FontWeight.w400)),
                                        ],
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    const Text('₹387.4 desposited to 13876123598',
                        style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                            fontWeight: FontWeight.w400)),
                    const SizedBox(
                      height: 10,
                    )
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
