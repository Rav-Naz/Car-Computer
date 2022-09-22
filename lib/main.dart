import 'package:car_computer/providers/car_info_provider.dart';
import 'package:car_computer/providers/navigation_provider.dart';
import 'package:car_computer/providers/ui_provider.dart';
import 'package:car_computer/views/car.dart';
import 'package:car_computer/views/car_info.dart';
import 'package:car_computer/views/home.dart';
import 'package:car_computer/views/map.dart';
import 'package:car_computer/views/settings.dart';
import 'package:car_computer/widgets/navigation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<CarInfoProvider>(create: (BuildContext context) => CarInfoProvider()),
        ChangeNotifierProvider<UiProvider>(create: (BuildContext context) => UiProvider()),
        ChangeNotifierProvider<NavigationProvider>(create: (BuildContext context) => NavigationProvider())
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
    NavigationItem(icon: Icons.map, view: const MapView()),
    NavigationItem(icon: Icons.directions_car, view: const CarInfoView()),
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
    var carInfoProvider = Provider.of<CarInfoProvider>(context);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,children: [
        SizedBox(width: MediaQuery.of(context).size.width*0.25,child: Text((carInfoProvider.getWeatherInfo != null ? (carInfoProvider.getWeatherInfo["main"]["temp"] as double).toStringAsFixed(1) + " °C    " +  carInfoProvider.getWeatherInfo["name"]: " --°C"), style: const TextStyle(color: Colors.grey, fontWeight: FontWeight.w600, fontSize: 12),)),
        Text(carInfoProvider.getCurrentTimeString, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 15),),
        SizedBox(
          width: MediaQuery.of(context).size.width*0.25,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              const Icon(Icons.signal_cellular_alt, size: 15, color: Colors.grey,),
              const SizedBox(width: 10,),
              Icon (carInfoProvider.isConnectedToCar ? Icons.bluetooth_connected : Icons.bluetooth_disabled, size: 15, color: Colors.grey,)
            ],
          ),
        )
      ]),
    );
  }
}