import 'package:car_computer/providers/ui_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ContainerGradientBorder extends StatelessWidget {
  final Widget? innerWidget;
  final String? description;
  final Color? descriptionColor;
  final EdgeInsets? padding;

  ContainerGradientBorder(
      {this.innerWidget, this.description, this.descriptionColor, this.padding});

  @override
  Widget build(BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Visibility(
                visible: description != null,
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Text(description ?? "", style: TextStyle(color: descriptionColor ?? Colors.grey, fontSize: 12, fontWeight: FontWeight.w600),),
                ),
              ),
              Container(
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
                      offset: Offset(5,5),
                      blurRadius: 10
                    )
                    ]
                    ),
                child: Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: Container(
                    padding: padding ??  const EdgeInsets.all(8),
                    child: innerWidget,
                    constraints: const BoxConstraints(minHeight: 30, minWidth: 30),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        gradient: const LinearGradient(
                          colors: [
                            Color.fromARGB(255, 37, 37, 37),
                            Color.fromARGB(255, 28, 28, 28)
                          ],
                          stops: [0.3, 0.7],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        )),
                  ),
                ),
              ),
            ],
          ),
        );
      }
}
