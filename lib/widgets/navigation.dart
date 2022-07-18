import 'package:car_computer/providers/navigation_provider.dart';
import 'package:car_computer/providers/ui_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NavigationWidget extends StatefulWidget {
  final List<NavigationItem> navigationItems;
  const NavigationWidget({Key? key, required this.navigationItems})
      : super(key: key);

  @override
  State<NavigationWidget> createState() => _NavigationWidget();
}

class _NavigationWidget extends State<NavigationWidget> {
  @override
  void initState() {
    super.initState();
    _currView = widget.navigationItems[0].icon;
  }

  late IconData _currView;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.1,
      constraints: const BoxConstraints(minHeight: 40.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: widget.navigationItems.map((e) {
          return SizedBox(
            width: 40,
            height: 40,
            child: IconButton(
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                iconSize: 30,
                color: e.icon == _currView
                    ? Provider.of<UiProvider>(context).accentColor
                    : Colors.white,
                icon: Icon(e.icon),
                onPressed: () {
                  Provider.of<NavigationProvider>(context, listen: false)
                      .setView(e.view);
                  _currView = e.icon;
                }),
          );
        }).toList(),
      ),
      color: Colors.black,
    );
  }
}

class NavigationItem {
  final IconData icon;
  final dynamic view;

  NavigationItem({required this.icon, required this.view});
}
