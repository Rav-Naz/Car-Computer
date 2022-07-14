import 'package:car_computer/views/car.dart';
import 'package:car_computer/widgets/navigation.dart';
import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/status.dart' as status;
import 'dart:convert';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Car Computer',
      debugShowCheckedModeBanner: false,
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({Key? key}) : super(key: key);

  // @override
  // State<MyHomePage> createState() => _MyHomePageState();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          body: Column(
        children: [
          Expanded(
            child: Row(
              children: [
                const CarView(),
                Expanded(child: Container(color: Colors.blue)),
              ],
            ),
          ),
          const NavigationWidget()
        ],
      )),
    );
  }
}

// Center(
//               child: StreamBuilder(
//             stream: channel.stream,
//             builder: (context, snapshot) {
//               return Text(
//                 snapshot.hasData
//                     ? '${jsonDecode(snapshot.data.toString().replaceAll("'", "\""))['engine_rpm']}'
//                     : '',
//                 style: TextStyle(fontSize: 100.0),
//               );
//             },
//           ))

// class _MyHomePageState extends State<MyHomePage> {
//   final channel = WebSocketChannel.connect(
//     Uri.parse('ws://localhost:7890'),
//   );

//   @override
//   void initState() {
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: Scaffold(
//           body: Center(
//               child: StreamBuilder(
//             stream: channel.stream,
//             builder: (context, snapshot) {
//               return Text(
//                 snapshot.hasData
//                     ? '${jsonDecode(snapshot.data.toString().replaceAll("'", "\""))['engine_rpm']}'
//                     : '',
//                 style: TextStyle(fontSize: 100.0),
//               );
//             },
//           ))),
//     );
//   }
// }
