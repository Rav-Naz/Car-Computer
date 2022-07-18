import 'package:flutter/material.dart';


class MusicView extends StatefulWidget {
  const MusicView({Key? key}) : super(key: key);

  @override
  State<MusicView> createState() => _MusicView();
}

class _MusicView extends State<MusicView> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(color: Colors.amber),
    );
  }}