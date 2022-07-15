import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class CarInfoProvider extends ChangeNotifier {

  final channel = WebSocketChannel.connect(
    Uri.parse('ws://localhost:7890'),
  );

  CarInfoProvider() {
    print("ASD");
  }

}