import 'package:ecoflow_v3/widgets/airQualityCard.dart';
import 'package:ecoflow_v3/widgets/emission_chart.dart';
import 'package:flutter/material.dart';

class MetricsScreen extends StatelessWidget {
  const MetricsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MetricsScreen'),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.all(10),
          child: Column(
            children: [
              Card(
                child: Column(
                  children: [
                    const Text('Air Quality'),
                    AirQualityCard(),
                  ],
                ),
              ),
              Card(
                child: Column(
                  children: [
                    const Text('Emissions'),
                    EmissionsChart(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
