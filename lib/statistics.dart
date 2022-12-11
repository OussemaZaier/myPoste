import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class Statistics extends StatefulWidget {
  Statistics({Key? key, required this.index}) : super(key: key);
  int index;
  final List<Color> gradienColors = [
    const Color(0xFF23B6E6),
    const Color(0xFF02D39A),
  ];
  @override
  State<Statistics> createState() => _StatisticsState();
}

class _StatisticsState extends State<Statistics> {
  double x = 0;
  double y = 0;
  @override
  void initState() {
    // TODO: implement initState

    final _transactionsStream = FirebaseFirestore.instance
        .collection('Users')
        .doc(FirebaseAuth.instance.currentUser!.uid.toString())
        .collection('Cards')
        .doc(widget.index.toString())
        .collection('History')
        .get()
        .then((value) {
      if (value.docs.isNotEmpty) {
        x = double.parse(value.docs[0]['history'].length.toString());
        y = value.docs[0]['history'][0].toDouble();

        for (var i = 0; i < value.docs[0]['history'].length; i++) {
          // Checking for largest value in the list
          if (value.docs[0]['history'][i].toDouble() > y) {
            y = value.docs[0]['history'][i].toDouble();
          }
        }
        for (var i in value.docs) {
          print(i);
        }
      }
      setState(() {});
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(0, 20, 20, 0),
          child: LineChart(
            LineChartData(
              minX: 0,
              minY: 0,
              maxX: 9,
              maxY: 1000,
              // gridData: FlGridData(
              //   show: true,
              //   getDrawingHorizontalLine: (value) {
              //     return FlLine(
              //       color: const Color(0xFF37434D),
              //       strokeWidth: 1,
              //     );
              //   },
              //   drawVerticalLine: true,
              //   getDrawingVerticalLine: (value) {
              //     return FlLine(
              //       color: const Color(0xFF37434D),
              //       strokeWidth: 1,
              //     );
              //   },
              // ),
              borderData: FlBorderData(
                show: true,
                border: Border(
                  bottom: BorderSide(),
                  left: BorderSide(),
                ),
              ),
              titlesData: FlTitlesData(
                topTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: false,
                  ),
                ),
                rightTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: false,
                  ),
                ),
              ),
              //gridData: FlGridData(show: false),
              lineBarsData: [
                LineChartBarData(
                  isCurved: true,
                  barWidth: 4,
                  belowBarData: BarAreaData(
                    show: true,
                  ),
                  spots: [
                    const FlSpot(0, 500),
                    const FlSpot(1, 600),
                    const FlSpot(2, 1000),
                    const FlSpot(3, 700),
                    const FlSpot(5, 200),
                    const FlSpot(6, 1000),
                    const FlSpot(7, 300),
                    const FlSpot(8, 10),
                  ],
                ),
              ],
            ),

            swapAnimationDuration:
                const Duration(milliseconds: 150), // Optional
            swapAnimationCurve: Curves.linear, // Optional
          ),
        ),
      ),
    );
  }
}
