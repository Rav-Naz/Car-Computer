import 'package:animated_flip_counter/animated_flip_counter.dart';
import 'package:car_computer/providers/car_info_provider.dart';
import 'package:car_computer/providers/ui_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class CarView extends StatefulWidget {
  const CarView({Key? key}) : super(key: key);

  @override
  State<CarView> createState() => _CarView();
}

class _CarView extends State<CarView> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UiProvider>(
      builder: ((context, uiProvider, child) {
        return Consumer<CarInfoProvider>(
            builder: (context, carInfoProvider, child) {
          return Container(
            color: const Color.fromRGBO(65, 65, 65, 1),
            child: Padding(
              padding: const EdgeInsets.only(right: 20),
              child: Transform.scale(
                scaleY: 1.001,
                child: Container(
                    // height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width * 0.25,
                    constraints: const BoxConstraints(minWidth: 300.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SliderContainerWidget(
                          carInfoProvider: carInfoProvider,
                          color: uiProvider.accentColor,
                          icon: Icons.speed,
                          top: true,
                          value1:
                              carInfoProvider.getCarInfoValue('engine_rpm') ??
                                  0,
                          suffix1: " r/min",
                          maxValue1: double.parse(
                              uiProvider.getSetting("maksymalne_obroty")),
                        ),
                        Expanded(
                            child: Column(
                          children: [
                            Expanded(
                              child: Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(20, 15, 20, 10),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      flex: 1,
                                      child: IndicatorLightWidget(iconList: [
                                        IndicatorLightIcon(
                                            svgAssetPath:
                                                'assets/svg/check_engine.svg',
                                            colorOn: const Color.fromARGB(
                                                255, 250, 200, 36)),
                                        IndicatorLightIcon(
                                            svgAssetPath: 'assets/svg/abs.svg',
                                            colorOn: const Color.fromARGB(
                                                255, 250, 200, 36)),
                                        IndicatorLightIcon(
                                            svgAssetPath:
                                                'assets/svg/door_open.svg',
                                            colorOn: const Color.fromARGB(
                                                255, 223, 4, 4)),
                                        IndicatorLightIcon(
                                            svgAssetPath:
                                                'assets/svg/road_lights.svg',
                                            colorOn: const Color.fromARGB(255, 15, 78, 214)),
                                        IndicatorLightIcon(
                                            isOn: true,
                                            svgAssetPath:
                                                'assets/svg/traffic_light.svg',
                                            colorOn: const Color.fromARGB(
                                                255, 69, 192, 12))
                                      ]),
                                    ),
                                    Expanded(
                                      flex: 4,
                                      child: Column(
                                        children: [
                                          Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              AnimatedFlipCounter(
                                                  value: carInfoProvider
                                                          .getCarInfoValue(
                                                              "vehicle_speed") ??
                                                      0,
                                                  textStyle: const TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 40,
                                                      fontWeight:
                                                          FontWeight.bold)),
                                              const Text("KM/H",
                                                  style: TextStyle(
                                                      color: Colors.grey,
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w600))
                                            ],
                                          ),
                                          Expanded(
                                              child: Padding(
                                            padding: const EdgeInsets.all(15.0),
                                            child: Container(
                                              decoration: const BoxDecoration(),
                                              clipBehavior: Clip.hardEdge,
                                              child: Transform.scale(
                                                scale: 1.015,
                                                child: ColorFiltered(
                                                  colorFilter: ColorFilter.mode(
                                                      uiProvider.accentColor,
                                                      BlendMode.hue),
                                                  child: Stack(
                                                    children: [
                                                      Container(
                                                          color: const Color
                                                                  .fromRGBO(
                                                              65, 65, 65, 1)),
                                                      const Center(
                                                          child: Image(
                                                              image: AssetImage(
                                                        "assets/png/car.png",
                                                      ))),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ))
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: IndicatorLightWidget(iconList: [
                                        IndicatorLightIcon(
                                            svgAssetPath:
                                                'assets/svg/handbrake.svg',
                                            colorOn: const Color.fromARGB(
                                                255, 223, 4, 4)),
                                        IndicatorLightIcon(
                                            svgAssetPath:
                                                'assets/svg/triangle.svg',
                                            colorOn: const Color.fromARGB(
                                                255, 250, 200, 36)),
                                        IndicatorLightIcon(
                                            isOn: true,
                                            svgAssetPath:
                                                'assets/svg/coolant.svg',
                                            colorOn: const Color.fromARGB(255, 15, 78, 214)),
                                        IndicatorLightIcon(
                                            svgAssetPath:
                                                'assets/svg/accumulator.svg',
                                            colorOn: const Color.fromARGB(
                                                255, 223, 4, 4)),
                                        IndicatorLightIcon(
                                            svgAssetPath:
                                                'assets/svg/seat_bealt.svg',
                                            colorOn: const Color.fromARGB(
                                                255, 223, 4, 4))
                                      ]),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.fromLTRB(20, 10, 20, 15),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  BottomCarInfoWidget(
                                      description: "Śr. prędkość",
                                      value:
                                          carInfoProvider.getAverageSpeedString,
                                      unit: "KM/H"),
                                  Container(
                                    color: Colors.grey.withOpacity(0.5),
                                    width: 0.5,
                                    height: 50,
                                  ),
                                  BottomCarInfoWidget(
                                      description: "Pok. dystans",
                                      value: carInfoProvider
                                          .getDistanceTraveledInKm,
                                      unit: "KM"),
                                  Container(
                                    color: Colors.grey.withOpacity(0.5),
                                    width: 0.5,
                                    height: 50,
                                  ),
                                  BottomCarInfoWidget(
                                      description: "Czas jazdy",
                                      value: carInfoProvider
                                          .getTimeFromStartString,
                                      unit: "GODZIN")
                                ],
                              ),
                            )
                          ],
                        )),
                        SliderContainerWidget(
                          carInfoProvider: carInfoProvider,
                          color: uiProvider.accentColor,
                          icon: Icons.local_gas_station,
                          top: false,
                          value1: 45,
                          suffix1: "%",
                          maxValue1: 100,
                        ),
                      ],
                    ),
                    decoration: const BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                              color: Color.fromARGB(255, 44, 44, 44),
                              // offset: Offset(2, 0),
                              blurRadius: 10,
                              spreadRadius: 10)
                        ],
                        gradient: LinearGradient(
                            begin: Alignment.topRight,
                            end: Alignment.bottomLeft,
                            colors: [
                              Color.fromRGBO(65, 65, 65, 1),
                              Color.fromRGBO(48, 48, 48, 1)
                            ],
                            stops: [
                              0.8,
                              1
                            ]))),
              ),
            ),
          );
        });
      }),
    );
  }
}

class IndicatorLightWidget extends StatelessWidget {
  final List<IndicatorLightIcon> iconList;
  const IndicatorLightWidget({
    Key? key,
    required this.iconList,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: iconList
          .map((e) => SizedBox(
              width: 30,
              height: 30,
              child: SvgPicture.asset(e.svgAssetPath,
                  color: e.isOn != null && e.isOn!
                      ? e.colorOn
                      : const Color.fromARGB(255, 28, 28, 28))))
          .toList(),
    );
  }
}

class IndicatorLightIcon {
  final String svgAssetPath;
  final Color colorOn;
  final bool? isOn;

  IndicatorLightIcon(
      {required this.svgAssetPath, required this.colorOn, this.isOn});
}

class BottomCarInfoWidget extends StatelessWidget {
  final String description;
  final String value;
  final String unit;

  const BottomCarInfoWidget({
    Key? key,
    required this.description,
    required this.value,
    required this.unit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 75,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            description,
            style: const TextStyle(color: Colors.grey, fontSize: 10),
            textAlign: TextAlign.center,
          ),
          Padding(
              padding: const EdgeInsets.all(5),
              child: Text(
                value,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              )),
          Text(
            unit,
            style: const TextStyle(
                color: Colors.grey, fontSize: 12, fontWeight: FontWeight.w600),
            textAlign: TextAlign.center,
          )
        ],
      ),
    );
  }
}

class SliderContainerWidget extends StatelessWidget {
  final CarInfoProvider carInfoProvider;
  final bool top;
  final Color color;
  final IconData icon;
  final double value1;
  final double maxValue1;
  final String? suffix1;
  final String? suffix2;
  final double? value2;

  const SliderContainerWidget(
      {Key? key,
      required this.top,
      required this.color,
      required this.icon,
      required this.value1,
      required this.maxValue1,
      required this.carInfoProvider,
      this.suffix1,
      this.suffix2,
      this.value2})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RotatedBox(
      quarterTurns: top ? 0 : 2,
      child: Container(
        clipBehavior: Clip.hardEdge,
        width: MediaQuery.of(context).size.width,
        decoration: ShapeDecoration(
          color: Colors.black,
          shape: const SliderContainerWidgetBorderTop(),
          shadows: [
            BoxShadow(
                color: color,
                blurRadius: 10.0,
                spreadRadius: 1,
                offset: const Offset(0, 3)),
          ],
        ),
        child: RotatedBox(
          quarterTurns: top ? 0 : -2,
          child: Padding(
            padding: EdgeInsets.fromLTRB(50, top ? 0 : 10, 50, top ? 10 : 0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: listOfWidgetsInColumn(context, !top),
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> listOfWidgetsInColumn(context, bool isReversed) {
    var list = [
      Padding(
        padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(icon, color: Colors.white, size: 15),
            Visibility(
                visible: value2 != null,
                child: Text(
                  value2.toString() + (suffix2 ?? ""),
                  style: const TextStyle(
                      color: Colors.white, fontWeight: FontWeight.w600),
                )),
            Text(value1.toStringAsFixed(0) + (suffix1 ?? ""),
                style: const TextStyle(
                    color: Colors.white, fontWeight: FontWeight.w600)),
          ],
        ),
      ),
      Container(
        decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(20)),
            gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [
                  Provider.of<UiProvider>(context).accentColor,
                  Colors.grey
                ],
                stops: [
                  percentageValue,
                  percentageValue + 0.01
                ])),
        height: 4,
      )
    ];
    return isReversed ? list.reversed.toList() : list;
  }

  double get percentageValue {
    return ((value1 / maxValue1) * 100).toInt() / 100;
  }
}

class SliderContainerWidgetBorderTop extends ShapeBorder {
  final bool usePadding;

  const SliderContainerWidgetBorderTop({this.usePadding = true});

  @override
  EdgeInsetsGeometry get dimensions =>
      EdgeInsets.only(bottom: usePadding ? 0 : 0);

  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) => Path();

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) {
    var rect_rel = Rect.fromPoints(rect.topLeft, rect.bottomRight);
    var path = Path()
      ..moveTo(
          rect_rel.width * 0.5000000, rect_rel.topLeft.dy + rect_rel.height)
      ..lineTo(
          rect_rel.width * 0.1725254, rect_rel.topLeft.dy + rect_rel.height)
      ..cubicTo(
          rect_rel.width * 0.1384822,
          rect_rel.topLeft.dy + rect_rel.height,
          rect_rel.width * 0.1064052,
          rect_rel.topLeft.dy + rect_rel.height * 0.8980986,
          rect_rel.width * 0.08585870,
          rect_rel.topLeft.dy + rect_rel.height * 0.7246792)
      ..lineTo(0, rect_rel.topLeft.dy)
      ..lineTo(rect_rel.width, rect_rel.topLeft.dy)
      ..lineTo(rect_rel.width * 0.9032565,
          rect_rel.topLeft.dy + rect_rel.height * 0.7479306)
      ..cubicTo(
          rect_rel.width * 0.8826087,
          rect_rel.topLeft.dy + rect_rel.height * 0.9075694,
          rect_rel.width * 0.8518848,
          rect_rel.topLeft.dy + rect_rel.height,
          rect_rel.width * 0.8194696,
          rect_rel.topLeft.dy + rect_rel.height)
      ..lineTo(
          rect_rel.width * 0.5000000, rect_rel.topLeft.dy + rect_rel.height)
      ..close();
    return path;
  }

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection? textDirection}) {}

  @override
  ShapeBorder scale(double t) => this;
}
