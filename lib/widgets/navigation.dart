import 'dart:async';

import 'package:car_computer/providers/music_provider.dart';
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
    Provider.of<MusicProvider>(context, listen: false).getVolumeStream.listen((event) {
      setState(() {
        _volume = event;
      });
    });
  }

  late IconData _currView;
  bool isSettingVolume = false;
  double _volume = 0.5;
  Timer? _timer;


  void runCountdown() {
    setState(() {      
    _timer = Timer(const Duration(seconds: 5), () {
      setState(() {
      isSettingVolume = false;
      });
    });
    });
  }

  void stopCountdown() {
    if(_timer != null && _timer!.isActive) {
      setState(() {
      _timer!.cancel();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.1,
      constraints: const BoxConstraints(minHeight: 40.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: !isSettingVolume ? (widget.navigationItems.map((e) {
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
        }).toList()..add(SizedBox(
            width: 40,
            height: 40,
            child: IconButton(
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                iconSize: 30,
                color: Icons.volume_up == _currView
                    ? Provider.of<UiProvider>(context).accentColor
                    : Colors.white,
                icon: const Icon(Icons.volume_up),
                onPressed: () {
                  setState(() {
                    isSettingVolume = true;
                  });
                  runCountdown();
                }),
          ))) : [
            IconButton(
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                iconSize: 30,
                color: Colors.white,
                icon: const Icon(Icons.close),
                onPressed: () {
                  setState(() {
                    isSettingVolume = false;
                  });
                  stopCountdown();
                }),
                Consumer<MusicProvider>(
                  builder: (context, musicProvider, child) {
                    return SizedBox(
                      width: MediaQuery.of(context).size.width*0.6,
                      child: Slider(
                            min: 0.0,
                            max: 1.0,
                            divisions: 20,
                            value: _volume,
                            onChangeStart: (_) {stopCountdown();},
                            onChanged: (value) {
                              musicProvider.setVolume(value);
                            },
                            onChangeEnd: (_) {runCountdown();},
                            activeColor:
                                Provider.of<UiProvider>(context).accentColor,
                            inactiveColor: Provider.of<UiProvider>(context)
                                .accentColor
                                .withOpacity(0.2),
                          ),
                    );
                  },
                ),
                SizedBox(
                  width: 80,
                  child: Row(
                    children: [
                      SizedBox(width: 40,child: Text("${(_volume*100).toInt()}%", style: TextStyle(color: Colors.white),)),
                      Padding(padding: const EdgeInsets.all(5),child: Icon(_volume  == 0 ? Icons.volume_off : _volume < 0.3 ? Icons.volume_mute : _volume < 0.7 ? Icons.volume_down: Icons.volume_up, color: Colors.white, size: 30,))
                    ],
                  ),
                )
          ]
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
