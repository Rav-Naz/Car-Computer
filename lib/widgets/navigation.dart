import 'package:flutter/material.dart';

class NavigationWidget extends StatefulWidget {
  const NavigationWidget({Key? key}) : super(key: key);

  @override
  State<NavigationWidget> createState() => _NavigationWidget();
}

class _NavigationWidget extends State<NavigationWidget> {
  // final channel = WebSocketChannel.connect(
  //   Uri.parse('ws://localhost:7890'),
  // );
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height*0.1,
      constraints: const BoxConstraints(minHeight: 50.0),
      child: Row(
        
      ),
      color: Colors.black,
    );
  }
}
