import 'package:car_computer/providers/ui_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import 'dart:math';

import '../providers/car_info_provider.dart';

class MapView extends StatefulWidget {
  const MapView({Key? key}) : super(key: key);

  @override
  State<MapView> createState() => _MapView();
}

class _MapView extends State<MapView> {
  LatLng? _lastLatLong;
  double? _rotationAngle;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: Padding(
      padding: const EdgeInsets.only(right: 15, bottom: 15),
      child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: LinearGradient(
                colors: [
                  Provider.of<UiProvider>(context).accentColor,
                  const Color.fromARGB(255, 37, 37, 37)
                ],
                stops: const [0.3, 0.7],
                end: Alignment.topCenter,
                begin: Alignment.bottomRight,
              ),
              boxShadow: const [
                BoxShadow(
                    color: Color.fromARGB(255, 48, 48, 48),
                    offset: Offset(5, 5),
                    blurRadius: 10)
              ]),
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(18),
              child: Consumer<CarInfoProvider>(
                builder: (context, carInfoProvider, child) {
                  var latlong = LatLng(
                      double.parse(carInfoProvider.getCarInfoValue("latitude")),
                      double.parse(
                          carInfoProvider.getCarInfoValue("longitude")));
                  if (_lastLatLong != null && _lastLatLong != latlong) {
                    var speed = Provider.of<CarInfoProvider>(context)
                        .getCarInfoValue("vehicle_speed");
                    if (speed != null && speed >= 1) {
                      var w = latlong.latitude - _lastLatLong!.latitude;
                      var h = latlong.longitude - _lastLatLong!.longitude;
                      var atans = atan((h / w)) / pi * 180;
                      if (w < 0 || h < 0) {
                        atans += 180;
                      }
                      if (w > 0 && h < 0) {
                        atans -= 180;
                      }
                      if (atans < 0) {
                        atans += 360;
                      }
                      _rotationAngle = atans % 360;
                    }
                  }
                  _lastLatLong = latlong;
                  return FlutterMap(
                    options: MapOptions(center: latlong, maxZoom: 18),
                    layers: [
                      TileLayerOptions(
                          urlTemplate:
                              "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                          subdomains: ['a', 'b', 'c']),
                      MarkerLayerOptions(markers: [
                        Marker(
                            width: 20,
                            height: 48,
                            builder: (context) =>
                                CarMarker(angle: _rotationAngle),
                            point: latlong)
                      ])
                    ],
                  );
                },
              ),
            ),
          )),
    ));
  }
}

class CarMarker extends StatelessWidget {
  final double? angle;
  CarMarker({required this.angle});

  @override
  Widget build(BuildContext context) {
    return AnimatedRotation(
      turns: angle != null ? (angle! / 360) : 0,
      duration: const Duration(milliseconds: 500),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(500),
        child: ColorFiltered(
          colorFilter: ColorFilter.mode(
              Provider.of<UiProvider>(context).accentColor, BlendMode.hue),
          child: Container(
            decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage(
                      "assets/png/car.png",
                    ),
                    fit: BoxFit.cover)),
          ),
        ),
      ),
    );
  }
}
