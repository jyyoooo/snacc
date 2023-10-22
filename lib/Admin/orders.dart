import 'package:flutter/material.dart';

class Orders extends StatelessWidget {
  const Orders({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'Your Bag',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
              ),
            ),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 5,
              itemBuilder: (context, index) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          height: 70,
                          width: 70,
                          decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.circular(10), // Border radius
                            border: Border.all(
                              color: Colors.grey, // Border color
                              width: 2.0, // Border width
                            ),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.asset(
                              'assets/images/Snacc.png',
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
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
                                  Text(
                                    '₹387.4',
                                    style: TextStyle(
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
                                    'Apr 8, 9:45 AM',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey,
                                    ),
                                  ),
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
                                      Text(
                                        'Successful',
                                        style: TextStyle(
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
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
