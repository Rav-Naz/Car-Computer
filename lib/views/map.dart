import 'package:car_computer/providers/ui_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';

class MapView extends StatefulWidget {
  const MapView({Key? key}) : super(key: key);

  @override
  State<MapView> createState() => _MapView();
}

class _MapView extends State<MapView> {
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
              child: FlutterMap(
                options: MapOptions(center: LatLng(50.007867, 21.998181)),
                layers: [
                  TileLayerOptions(
                      urlTemplate:
                          "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                      subdomains: ['a', 'b', 'c']),
                  MarkerLayerOptions(markers: [
                    Marker(
                        width: 20,
                        height: 48,
                        builder: (context) => CarMarker(angle: 0),
                        point: LatLng(50.007867, 21.998181))
                  ])
                ],
              ),
            ),
          )),
    ));
  }
}

class CarMarker extends StatelessWidget {
  final double angle;
  CarMarker({required this.angle});

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: angle,
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
