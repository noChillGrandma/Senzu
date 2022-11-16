import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';


final carbIndicator = CircularPercentIndicator(
  radius: 60.0,
  lineWidth: 5.0,
  percent: 0.4,
  center: Text("100%"),
  progressColor: Colors.green,
);