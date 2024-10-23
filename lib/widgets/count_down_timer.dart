// ignore_for_file: prefer_const_constructors

import 'dart:async';
import 'dart:developer';

import 'package:everestvpn/controllers/VpnController.dart';
import 'package:everestvpn/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class CountDownTimer extends StatefulWidget {
  final bool startTimer;

  const CountDownTimer({super.key, required this.startTimer});

  @override
  State<CountDownTimer> createState() => _CountDownTimerState();
}

class _CountDownTimerState extends State<CountDownTimer> {
  var controller = Get.put(VpnController());

  Timer? _timer;

  _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        controller.duration.value =
            Duration(seconds: controller.duration.value.inSeconds + 1);
      });
    });
  }

  _stopTimer() {
    setState(() {
      _timer?.cancel();
      _timer = null;
      controller.duration.value = Duration();
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_timer == null || !widget.startTimer)
      widget.startTimer ? _startTimer() : _stopTimer();

    String twoDigit(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigit(controller.duration.value.inMinutes.remainder(60));
    final seconds = twoDigit(controller.duration.value.inSeconds.remainder(60));
    final hours = twoDigit(controller.duration.value.inHours.remainder(60));

    return Text(
      '$hours: $minutes: $seconds',
      textAlign: TextAlign.center,
      style: TextStyle(
        color:
            Theme.of(context).scaffoldBackgroundColor == kContentColorDarkTheme
                ? Color.fromARGB(255, 98, 98, 98)
                : kSecondaryColor,
        fontSize: 30,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}

Widget buildTimeComponent(int value, String label) {
  return Padding(
    padding: const EdgeInsets.all(3.0),
    child: Container(
      padding: EdgeInsets.symmetric(horizontal: 6, vertical: 3),
      child: Column(
        children: <Widget>[
          Text(
            value.toString().padLeft(2, '0'),
            style: TextStyle(
              fontSize: 12,
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              fontSize: 6,
              color: Colors.black,
            ),
          ),
        ],
      ),
    ),
  );
}
