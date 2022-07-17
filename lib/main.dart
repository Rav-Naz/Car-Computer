import 'package:car_computer/providers/car_info_provider.dart';
import 'package:car_computer/providers/navigation_provider.dart';
import 'package:car_computer/providers/ui_provider.dart';
import 'package:car_computer/views/car.dart';
import 'package:car_computer/views/home.dart';
import 'package:car_computer/views/map.dart';
import 'package:car_computer/views/music.dart';
import 'package:car_computer/views/settings.dart';
import 'package:car_computer/widgets/navigation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
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
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => CarInfoProvider()),
        ChangeNotifierProvider(create: (context) => UiProvider()),
        ChangeNotifierProvider(create: (context) => NavigationProvider()),
      ],
      child: MaterialApp(
        title: 'Car Computer',
        theme: ThemeData(fontFamily: 'Inter'),
        debugShowCheckedModeBanner: false,
        home: MyHomePage(),
      ),
    );
  }
}

class MyHomePage extends StatelessWidget {
  MyHomePage({Key? key}) : super(key: key);

  final List<NavigationItem> navigationItems = [
    NavigationItem(icon: Icons.home, view: const HomeView()),
    NavigationItem(icon: Icons.navigation, view: const MapView()),
    NavigationItem(icon: Icons.music_note, view: const MusicView()),
    NavigationItem(icon: Icons.settings, view: const SettingsView()),
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color.fromRGBO(65, 65, 65, 1),
          body: Column(
        children: [
          Expanded(
            child: Row(
              children: [
                const CarView(),
                Expanded(
                  child: Column(
                    children: [
                      TopInfoBar(),
                      Provider.of<NavigationProvider>(context).currentView
                    ],
                  ),
                ),
              ],
            ),
          ),
          NavigationWidget(navigationItems: navigationItems)
        ],
      )),
    );
  }
}

class TopInfoBar extends StatelessWidget{

  TopInfoBar();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,children: [
        Text("19°C", style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w600, fontSize: 12),),
        Text(Provider.of<CarInfoProvider>(context).getCurrentTimeString, style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 15),),
        Row(
          children: const [
            Icon(Icons.signal_cellular_alt, size: 15, color: Colors.grey,),
            SizedBox(width: 10,),
            Icon(Icons.bluetooth_connected, size: 15, color: Colors.grey,)
          ],
        )
      ]),
    );
  }
}