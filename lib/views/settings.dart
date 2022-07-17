import 'package:car_computer/providers/ui_provider.dart';
import 'package:car_computer/widgets/navigation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:provider/provider.dart';

import '../widgets/container_gradient_border.dart';

class SettingsView extends StatefulWidget {
  const SettingsView({Key? key}) : super(key: key);

  @override
  State<SettingsView> createState() => _SettingsView();
}

class _SettingsView extends State<SettingsView> {
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
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: ContainerGradientBorder(
                  description: "Ustawienia interfejsu",
                  innerWidget: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Column(
                      children: [
                        SettingsItem(
                            description: "Kolor interfejsu",
                            innerWidget: SizedBox(
                              width: 40,
                              height: 40,
                              child: GestureDetector(
                                onTap: () {
                                  showDialog(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                            actions: [
                                              TextButton(
                                                child: Text(
                                                  "Zamknij",
                                                  style: TextStyle(
                                                      color:
                                                          uiProvider.accentColor),
                                                ),
                                                onPressed: () =>
                                                    {Navigator.of(context).pop()},
                                              )
                                            ],
                                            backgroundColor: const Color.fromRGBO(
                                                65, 65, 65, 1),
                                            content: BlockPicker(
                                              pickerColor: uiProvider.accentColor,
                                              onColorChanged: (color) {
                                                uiProvider.setColor(color);
                                                Navigator.of(context).pop();
                                              },
                                            ),
                                          ));
                                },
                                child: Container(
                                    decoration: BoxDecoration(
                                        color: uiProvider.accentColor,
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(
                                            color: Colors.white, width: 2))),
                              ),
                            )),
                        SettingsItem(
                            description: "Jednostka miary",
                            innerWidget: SettingsItemChooser(
                                description: "Jednostka miary",
                                options: const ["Kilometry", "Mile"])),
                        SettingsItem(
                            description: "Jednostka temperatury",
                            innerWidget: SettingsItemChooser(
                                description: "Jednostka temperatury",
                                options: const [
                                  "Celsjusz",
                                  "Kelwin",
                                  "Farenheit"
                                ])),
                      ],
                    ),
                  ),
                )),
                Expanded(
                    child: ContainerGradientBorder(
                  description: "Ustawienia samochodu",
                  innerWidget: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Column(
                      children: [
                        SettingsItem(
                            description: "Marka i model pojazdu",
                            innerWidget: SettingsItemInput(
                              description: "Marka i model pojazdu",
                            )),
                        SettingsItem(
                            description: "Rok produkcji",
                            innerWidget: SettingsItemInput(
                              description: "Rok produkcji",
                            )),
                        SettingsItem(
                            description: "Moc silnika",
                            innerWidget: SettingsItemInput(
                              description: "Moc silnika",
                              suffix: "KM",
                            )),
                            SettingsItem(
                            description: "Rodzaj paliwa",
                            innerWidget: SettingsItemChooser(
                                description: "Rodzaj paliwa",
                                options: const ["Benzyna", "Diesel", "Hybrydowy", "Elektryczny"])),
                        SettingsItem(
                            description: "Pojemność skokowa silnika",
                            innerWidget: SettingsItemInput(
                              description: "Pojemność skokowa silnika",
                              suffix: "cm³",
                            )),
                        SettingsItem(
                            description: "Maksymalne obroty",
                            innerWidget: SettingsItemInput(
                              description: "Maksymalne obroty",
                              suffix: "r/min",
                            )),
                        SettingsItem(
                            description: "Data ważności przeglądu",
                            innerWidget: SettingsItemInput(
                              description: "Data ważności przeglądu",
                            )),
                      ],
                    ),
                  ),
                )),
              ],
            ),
          )),
    );
  }
}

class SettingsItem extends StatelessWidget {
  final String description;
  final Widget innerWidget;
  SettingsItem({required this.description, required this.innerWidget});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10, bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width*0.12),
            child: Text(
              description,
              style: const TextStyle(color: Colors.white, fontSize: 15, ),
            ),
          ),
          innerWidget
        ],
      ),
    );
  }
}

class SettingsItemChooser extends StatelessWidget {
  final List<String> options;
  late String _settingKey;
  SettingsItemChooser({required description, required this.options}) {
    _settingKey = description.toString().toLowerCase().replaceAll(' ', '_');
  }

  void chooseDialog(context) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
                actions: [
                  TextButton(
                    style: ButtonStyle(
                        overlayColor:
                            MaterialStateProperty.all(Colors.transparent)
                        // foregroundColor: Colors.transparent
                        ),
                    child: Text(
                      "Zamknij",
                      style: TextStyle(
                          color: Provider.of<UiProvider>(context).accentColor,
                          fontSize: 20),
                    ),
                    onPressed: () => {Navigator.of(context).pop()},
                  )
                ],
                backgroundColor: const Color.fromRGBO(65, 65, 65, 1),
                content: Column(
                  children: options
                      .map((e) => TextButton(
                          style: ButtonStyle(
                              overlayColor: MaterialStateProperty.all(
                                  Colors.transparent)),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              e,
                              style: TextStyle(
                                  color: Provider.of<UiProvider>(context)
                                      .accentColor),
                            ),
                          ),
                          onPressed: () {
                            Provider.of<UiProvider>(context, listen: false)
                                .setSetting(_settingKey, e);
                            Navigator.of(context).pop();
                          }))
                      .toList(),
                )));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: GestureDetector(
        onTap: () {
          chooseDialog(context);
        },
        child: Container(
            height: 40,
            width: 150,
            // constraints: BoxC,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
              child: Center(
                  child: Text(
                Provider.of<UiProvider>(context)
                    .getSetting(_settingKey)
                    .toString(),
                style: const TextStyle(color: Colors.white, fontSize: 14),
              )),
            ),
            decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.white, width: 2))),
      ),
      constraints: const BoxConstraints(maxHeight: 50),
      decoration: BoxDecoration(
          color: Colors.transparent, borderRadius: BorderRadius.circular(10)),
    );
  }
}

class SettingsItemInput extends StatelessWidget {
  late String _settingKey;
  late String? _suffix;
  final myController = TextEditingController();
  SettingsItemInput({required description, suffix}) {
    _settingKey = description.toString().toLowerCase().replaceAll(' ', '_');
    _suffix = suffix;
  }

  @override
  Widget build(BuildContext context) {
    myController.text = Provider.of<UiProvider>(context).getSetting(_settingKey);
    return Container(
        // height: 40,
        constraints: const BoxConstraints(maxHeight: 40),
        width: 150,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Center(
            child: TextFormField(
              controller: myController,
              // initialValue: ,
              style: const TextStyle(color: Colors.white, height: 1.0, fontSize: 14),
              cursorColor: Provider.of<UiProvider>(context).accentColor,
              toolbarOptions: null,
              // strutStyle: ,
              textAlign: TextAlign.center,
              decoration: InputDecoration(
                suffix: Text(_suffix ?? "", style: const TextStyle(color: Colors.white, fontSize: 12),),
                  focusedBorder: InputBorder.none,
                  isCollapsed: true,
                  enabledBorder: InputBorder.none,
                  errorBorder: InputBorder.none,
                  disabledBorder: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 15.0),
                  border: InputBorder.none,
                  fillColor: Colors.white),
              onFieldSubmitted: (value) {
                Provider.of<UiProvider>(context, listen: false)
                    .setSetting(_settingKey, value);
              },
            ),
          ),
        ),
        decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.white, width: 2)));
  }
}
