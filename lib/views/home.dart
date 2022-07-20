import 'package:car_computer/providers/car_info_provider.dart';
import 'package:car_computer/providers/ui_provider.dart';
import 'package:car_computer/views/music.dart';
import 'package:car_computer/widgets/container_gradient_border.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  State<HomeView> createState() => _HomeView();
}

class _HomeView extends State<HomeView> {
  @override
  void initState() {
    super.initState();
  }

  Future<void> _launchUrl(Uri uri) async {
  if (!await launchUrl(uri)) {
    throw 'Could not launch $uri';
  }
}


  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: Padding(
      padding: const EdgeInsets.only(bottom: 10.0, right: 8),
      child: Column(
        children: [
          Expanded(
            child: Row(
              children: [
                Consumer<UiProvider>(
                  builder: (context, uiProvider, child) {
                    return Expanded(
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Padding(
                  padding: EdgeInsets.only(top:  5, left: 10),
                  child: Text( "Pogoda", style: TextStyle(color:Colors.grey, fontSize: 12, fontWeight: FontWeight.w600),),
                ),
                              ContainerGradientBorder(
                                  innerWidget: SizedBox(
                                    width: constraints.maxWidth,
                                    height: constraints.maxHeight - 65,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "Witaj ${uiProvider.getSetting("twoje_imię")}!",
                                                style: const TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 30,
                                                    fontWeight: FontWeight.bold,
                                                    letterSpacing: 1.5),
                                              ),
                                              const Text(
                                                "Dokąd jedziemy?",
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w100,
                                                    letterSpacing: 1.2),
                                              ),
                                            ],
                                          ),
                                          Expanded(child:
                                              Consumer<CarInfoProvider>(builder:
                                                  (context, carInfoProvider,
                                                      child) {
                                            return Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      carInfoProvider
                                                                  .getWeatherInfo !=
                                                              null
                                                          ? (carInfoProvider.getWeatherInfo[
                                                                              "main"]
                                                                          ["temp"]
                                                                      as double)
                                                                  .toStringAsFixed(
                                                                      1) +
                                                              " °C"
                                                          : "-- °C",
                                                      style: const TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 50,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    Visibility(
                                                      visible: carInfoProvider
                                                              .getWeatherInfo !=
                                                          null,
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets.all(
                                                                8.0),
                                                        child: Icon(
                                                          Icons.sunny,
                                                          color: uiProvider
                                                              .accentColor,
                                                          size: 50,
                                                        ),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                                Text(
                                                  carInfoProvider
                                                              .getWeatherInfo !=
                                                          null
                                                      ? (carInfoProvider.getWeatherInfo[
                                                                      "weather"][0]
                                                                  ["description"]
                                                              as String)
                                                          .toUpperCase()
                                                      : "",
                                                  style: const TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 16),
                                                ),
                                                const SizedBox(height: 30),
                                                Text(
                                                  carInfoProvider
                                                              .getWeatherInfo !=
                                                          null
                                                      ? carInfoProvider
                                                          .getWeatherInfo["name"]
                                                      : "",
                                                  style: const TextStyle(
                                                      color: Colors.grey,
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ],
                                            );
                                          }))
                                        ],
                                      ),
                                    ),
                                  )),
                            ],
                          );
                        },
                      ),
                    );
                  },
                ),
                Expanded(
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      return Consumer<UiProvider>(
                        builder: (context, uiProvider, child) {
                          return Padding(
                            padding: const EdgeInsets.only(right: 5),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Padding(
                  padding: EdgeInsets.only(top:  5, left: 10),
                  child: Text( "Newsy", style: TextStyle(color:Colors.grey, fontSize: 12, fontWeight: FontWeight.w600),),
                ),
                                CarouselSlider(
                                    options: CarouselOptions(
                                        autoPlay: true,
                                        autoPlayInterval: const Duration(seconds: 5),
                                        height: constraints.maxHeight-25,
                                        viewportFraction: 1),
                                    items: uiProvider.getTopNews.map((e) {
                                      return LayoutBuilder(
                                          builder: (context, constraintsX) {
                                        return GestureDetector(
                                          child: ContainerGradientBorder(
                                              padding: const EdgeInsets.all(0),
                                              innerWidget: Container(
                                                child: ClipRRect(
                                                  borderRadius: BorderRadius.circular(18),
                                                  child: Container(
                                                    padding: const EdgeInsets.all(15),
                                                    child: Column(
                                                      mainAxisAlignment: MainAxisAlignment.end,
                                                      crossAxisAlignment: CrossAxisAlignment.end,
                                                      children: [
                                                        Text(e["title"],style:  const TextStyle(color: Colors.white, fontSize: 16),textAlign: TextAlign.right)
                                                      ],
                                                    ),
                                                    decoration: const BoxDecoration(
                                                      gradient: LinearGradient(
                                                        colors: [Colors.transparent, Color.fromARGB(255, 28, 28, 28)],
                                                        end: Alignment.bottomCenter,
                                                        begin: Alignment.topCenter,
                                                        stops: [0.4,1]
                                                      )
                                                    ),
                                                  ),
                                                ),
                                                height: constraintsX.maxHeight - 25,
                                                width: constraintsX.maxWidth,
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(18),
                                                    image: DecorationImage(
                                                        image: NetworkImage(
                                                            e["urlToImage"]),
                                                        fit: BoxFit.cover)),
                                              )),
                                              onTap: () {_launchUrl(Uri.parse(e["url"]));},
                                        );
                                      });
                                    }).toList()),
                              ],
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          const MusicTrackPanel()
        ],
      ),
    ));
  }
}
