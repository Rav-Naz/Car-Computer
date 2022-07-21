import 'package:car_computer/providers/car_info_provider.dart';
import 'package:car_computer/providers/ui_provider.dart';
import 'package:car_computer/views/car.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/container_gradient_border.dart';

class CarInfoView extends StatefulWidget {
  const CarInfoView({Key? key}) : super(key: key);

  @override
  State<CarInfoView> createState() => _CarInfoView();
}

class _CarInfoView extends State<CarInfoView> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var uiProvider = Provider.of<UiProvider>(context);
    return Expanded(
      child: Container(
        padding: const EdgeInsets.only(right: 10),
          color: const Color.fromRGBO(65, 65, 65, 1),
          child: SingleChildScrollView(
            child: Consumer<UiProvider>(
              builder: (context, uiProvider, child) {
                return Consumer<CarInfoProvider>(
                  builder: (context, carInfoProvider, child) {
                    return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: ContainerGradientBorder(
                      description: "Informacje o samochodzie",
                      innerWidget: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(uiProvider.getSetting("marka_i_model_pojazdu"), style: const TextStyle(color: Colors.white, fontSize: 30, fontWeight: FontWeight.bold),),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8.0),
                              child: Text(uiProvider.getSetting("rok_produkcji"), style: const TextStyle(color: Colors.grey, fontSize: 18, fontWeight: FontWeight.normal)),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const BottomCarInfoWidget(description: "Przebieg", value: "286 152", unit: "KM"),
                                Container(
                                      color: Colors.grey.withOpacity(0.5),
                                      width: 0.5,
                                      height: 50,
                                    ),
                                BottomCarInfoWidget(description: "Rodzaj paliwa", value: uiProvider.getSetting("rodzaj_paliwa"), unit: ""),
                                Container(
                                      color: Colors.grey.withOpacity(0.5),
                                      width: 0.5,
                                      height: 50,
                                    ),
                                BottomCarInfoWidget(description: "Moc silnika", value: uiProvider.getSetting("moc_silnika"), unit: "KM"),
                                
                              ],
                            ),
                            const SizedBox(height: 20,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const BottomCarInfoWidget(description: "Akt. spalanie", value: "8.9", unit: "L/100KM"),
                                Container(
                                      color: Colors.grey.withOpacity(0.5),
                                      width: 0.5,
                                      height: 50,
                                    ),
                                const BottomCarInfoWidget(description: "Śr. spalanie", value: "14.0", unit: "L/100KM"),
                                Container(
                                      color: Colors.grey.withOpacity(0.5),
                                      width: 0.5,
                                      height: 50,
                                    ),
                                const BottomCarInfoWidget(description: "Poj. skokowa", value: "1998", unit: "cm³"),
                                
                              ],
                            ),
                                                        const SizedBox(height: 20,),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                BottomCarInfoWidget(description: "Akt. prędkość", value: carInfoProvider.getCarInfoValue("vehicle_speed").toString(), unit: "KM/H"),
                                Container(
                                      color: Colors.grey.withOpacity(0.5),
                                      width: 0.5,
                                      height: 50,
                                    ),
                                BottomCarInfoWidget(description: "Akt. obroty silnika", value: carInfoProvider.getCarInfoValue("engine_rpm").toString(), unit: "OBR/MIN"),
                                Container(
                                      color: Colors.grey.withOpacity(0.5),
                                      width: 0.5,
                                      height: 50,
                                    ),
                                const BottomCarInfoWidget(description: "Akt. ilość paliwa", value: "23", unit: "L"),
                                
                              ],
                            ),
                                                        const SizedBox(height: 20,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                  BottomCarInfoWidget(
                                      description: "Śr. prędkość",
                                      value: carInfoProvider.getAverageSpeedString,
                                      unit: "KM/H"),
                                  Container(
                                    color: Colors.grey.withOpacity(0.5),
                                    width: 0.5,
                                    height: 50,
                                  ),
                                  BottomCarInfoWidget(
                                      description: "Pok. dystans",
                                      value: carInfoProvider.getDistanceTraveledInKm,
                                      unit: "KM"),
                                  Container(
                                    color: Colors.grey.withOpacity(0.5),
                                    width: 0.5,
                                    height: 50,
                                  ),
                                  BottomCarInfoWidget(
                                      description: "Czas jazdy",
                                      value: carInfoProvider.getTimeFromStartString,
                                      unit: "GODZIN")
                                ],
                            ),
                                                        const SizedBox(height: 20,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                  BottomCarInfoWidget(
                                      description: "Nap. akumulatora",
                                      value: carInfoProvider.getCarInfoValue("voltage_detected_by_obd-ii_adapter").toString(),
                                      unit: "V"),
                                  Container(
                                    color: Colors.grey.withOpacity(0.5),
                                    width: 0.5,
                                    height: 50,
                                  ),
                                  const BottomCarInfoWidget(
                                      description: "Temp. płynu chłod.",
                                      value: "60",
                                      unit: "°C"),
                                  Container(
                                    color: Colors.grey.withOpacity(0.5),
                                    width: 0.5,
                                    height: 50,
                                  ),
                                  BottomCarInfoWidget(
                                      description: "Przegląd upływa za",
                                      value: getDurationToNextCheck,
                                      unit: "DNI")
                                ],
                            ),

                          ],
                        ),
                      ),
                    )),
                    Expanded(
                        child: ContainerGradientBorder(
                      description: "Wykryte błędy silnika",
                      innerWidget: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Column(
                          children: [
                            Text("Nie zgłoszono żadnych błędów", style: TextStyle(color: Colors.white, fontSize: 20),),
                            Row()
                          ],
                        ),
                      ),
                    )),
                  ],
                              );
                  },
                );
              },
            ),
          )),
    );
  }

  get getDurationToNextCheck {
    var uiProvider = Provider.of<UiProvider>(context);
    var data = uiProvider.getSetting("data_ważności_przeglądu");
    if (data != null) {
      var przeglad = DateTime.parse(data);
      return przeglad.difference(DateTime.now()).inDays.toStringAsFixed(0);
    } else {
      return "--";
    }
  }
}