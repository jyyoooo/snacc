import 'package:flutter/material.dart';

class Accounts extends StatefulWidget {
  const Accounts({super.key});

  @override
  State<Accounts> createState() => _AccountsState();
}

class _AccountsState extends State<Accounts> {
  bool toggl = true;

  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      body: Stack(
        children: [
          ListView(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListTile(
                  leading: const Icon(Icons.share_rounded, size: 32),
                  title: const Text('Share Dukaan App'),
                  trailing: IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.arrow_forward_rounded)),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListTile(
                  leading: const Icon(
                    Icons.language,
                    size: 35,
                  ),
                  title: const Text('Change Language'),
                  trailing: IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.arrow_forward_rounded)),
                ),
              ),
              
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: ListTile(
                  leading: Icon(Icons.logout, size: 35),
                  title: Text('Share Dukaan App'),
                ),
              ),
            ],
          ),
          Positioned(
              top: 620,
              left: 173,
              child: Column(
                children: [
                  const Text(
                    'Version',
                    style: TextStyle(color: Colors.grey, fontSize: 13),
                  ),
                  Text('2.4.2',
                      style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 13,
                          fontWeight: FontWeight.w500))
                ],
              ))
        ],
      ),
    );
  }
}
