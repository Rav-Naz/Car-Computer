import 'package:car_computer/providers/car_info_provider.dart';
import 'package:car_computer/providers/ui_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class CarView extends StatefulWidget {
  const CarView({Key? key}) : super(key: key);

  @override
  State<CarView> createState() => _CarView();
}

class _CarView extends State<CarView> {
  // final channel = WebSocketChannel.connect(
  //   Uri.parse('ws://localhost:7890'),
  // );
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var uiProvider = Provider.of<UiProvider>(context);
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
                    color: uiProvider.accentColor,
                    icon: Icons.speed,
                    top: true,
                    value1: "N",
                    value2: "806",
                  ),
                  Expanded(
                      child: Column(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(20, 15, 20, 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                flex: 1,
                                child: IndicatorLightWidget(iconList: [
                                  IndicatorLightIcon(
                                      svgAssetPath: 'assets/svg/check_engine.svg',
                                      colorOn: const Color.fromARGB(255, 250, 200, 36)),
                                  IndicatorLightIcon(
                                      svgAssetPath: 'assets/svg/abs.svg',
                                      colorOn: const Color.fromARGB(255, 250, 200, 36)),
                                  IndicatorLightIcon(
                                      svgAssetPath: 'assets/svg/door_open.svg',
                                      colorOn: const Color.fromARGB(255, 223, 4, 4)),
                                  IndicatorLightIcon(
                                      svgAssetPath: 'assets/svg/road_lights.svg',
                                      colorOn: const Color.fromARGB(255, 15, 62, 214)),
                                  IndicatorLightIcon(
                                      svgAssetPath: 'assets/svg/traffic_light.svg',
                                      colorOn: const Color.fromARGB(255, 69, 192, 12))
                                ]),
                              ),
                              Expanded(
                                flex: 4,
                                child: Column(
                                  children: [
                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      children: const [
                                        Text("0",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 40,
                                                fontWeight: FontWeight.bold)),
                                        Text("KM/H",
                                            style: TextStyle(
                                                color: Colors.grey,
                                                fontSize: 14,
                                                fontWeight: FontWeight.w600))
                                      ],
                                    ),
                                    Expanded(child: Container(
                                      decoration: const BoxDecoration(),
                                      clipBehavior: Clip.hardEdge,
                                      child: Transform.scale(
                                        scale: 1.01,
                                        child: ColorFiltered(
                                          colorFilter: ColorFilter.mode(uiProvider.accentColor, BlendMode.hue),
                                          child: Stack(
                                            children: [
                                              Container(color: const Color.fromRGBO(65, 65, 65, 1)),
                                              const Center(child: Image(image: AssetImage("assets/png/car.png",))),
                                            ],
                                          ),
                                        ),
                                      ),
                                    )
                                    )
                                  ],
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: IndicatorLightWidget(iconList: [
                                  IndicatorLightIcon(
                                      svgAssetPath: 'assets/svg/handbrake.svg',
                                      colorOn: const Color.fromARGB(255, 223, 4, 4)),
                                  IndicatorLightIcon(
                                      svgAssetPath: 'assets/svg/triangle.svg',
                                      colorOn: const Color.fromARGB(255, 250, 200, 36)),
                                  IndicatorLightIcon(
                                      svgAssetPath: 'assets/svg/coolant.svg',
                                      colorOn:const Color.fromARGB(255, 15, 62, 214)),
                                  IndicatorLightIcon(
                                      svgAssetPath: 'assets/svg/accumulator.svg',
                                      colorOn: const Color.fromARGB(255, 223, 4, 4)),
                                  IndicatorLightIcon(
                                      svgAssetPath: 'assets/svg/seat_bealt.svg',
                                      colorOn: const Color.fromARGB(255, 223, 4, 4))
                                ]),
                              )
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 10, 20, 15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const BottomCarInfoWidget(
                                description: "Śr. prędkość",
                                value: "32",
                                unit: "KM/H"),
                            Container(
                              color: Colors.grey.withOpacity(0.5),
                              width: 0.5,
                              height: 50,
                            ),
                            const BottomCarInfoWidget(
                                description: "Pok. dystans",
                                value: "4.0",
                                unit: "KM"),
                            Container(
                              color: Colors.grey.withOpacity(0.5),
                              width: 0.5,
                              height: 50,
                            ),
                            BottomCarInfoWidget(
                                description: "Czas jazdy",
                                value: Provider.of<CarInfoProvider>(context).getTimeFromStartString,
                                unit: "GODZIN")
                          ],
                        ),
                      )
                    ],
                  )),
                  SliderContainerWidget(
                    color: uiProvider.accentColor,
                    icon: Icons.local_gas_station,
                    top: false,
                    value1: "45%",
                  ),
                ],
              ),
              decoration: const BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Color.fromARGB(255, 44, 44, 44),
                    // offset: Offset(2, 0),
                    blurRadius: 10,
                    spreadRadius: 10
                  )
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
                  color: const Color.fromARGB(255, 28, 28, 28))))
          .toList(),
    );
  }
}

class IndicatorLightIcon {
  final String svgAssetPath;
  final Color colorOn;

  IndicatorLightIcon({
    required this.svgAssetPath,
    required this.colorOn,
  });
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
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(description,
            style: const TextStyle(color: Colors.grey, fontSize: 10)),
        Padding(
            padding: const EdgeInsets.all(5),
            child: Text(value,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold))),
        Text(unit,
            style: const TextStyle(
                color: Colors.grey, fontSize: 12, fontWeight: FontWeight.w600))
      ],
    );
  }
}

class SliderContainerWidget extends StatelessWidget {
  final bool top;
  final Color color;
  final IconData icon;
  final String value1;
  final String? value2;

  const SliderContainerWidget(
      {Key? key,
      required this.top,
      required this.color,
      required this.icon,
      required this.value1,
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
              children: listOfWidgetsInColumn(context,!top),
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> listOfWidgetsInColumn(context,bool isReversed) {
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
                  value2 ?? "",
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                )),
            Text(value1, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
          ],
        ),
      ),
      Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(20)),
            gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [Provider.of<UiProvider>(context).accentColor, Colors.grey],
                stops: [0.6, 0.6])),
        height: 4,
      )
    ];
    return isReversed ? list.reversed.toList() : list;
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
