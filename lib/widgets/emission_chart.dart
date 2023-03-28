import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:charts_flutter/flutter.dart' as charts;

import '../models/emissions.dart';

class EmissionsChart extends StatefulWidget {
  const EmissionsChart({Key? key}) : super(key: key);

  @override
  _EmissionsChartState createState() => _EmissionsChartState();
}

class _EmissionsChartState extends State<EmissionsChart> {
  Future<List<Emissions>>? _emissions;

  @override
  void initState() {
    super.initState();
    _emissions = _fetchEmissionsData();
  }

  Future<List<Emissions>> _fetchEmissionsData() async {
    final response = await http.get(Uri.parse(
        'https://firebasestorage.googleapis.com/v0/b/ecoflow-adbd3.appspot.com/o/climate_data%2Fco2-gr-mlo_json.json?alt=media&token=1a04e239-569e-4c02-9cc6-49adbbcd037c'));
    if (response.statusCode == 200) {
      final jsonBody = json.decode(response.body);
      final List<Emissions> emissions =
          List<Emissions>.from(jsonBody.map((e) => Emissions.fromJson(e)));
      return emissions;
    } else {
      throw Exception('Failed to fetch emissions data');
    }
  }

  List<charts.Series<Emissions, DateTime>> _createChartData(
      List<Emissions> emissions) {
    return [
      charts.Series<Emissions, DateTime>(
        id: 'Emissions',
        data: emissions,
        domainFn: (Emissions emissions, _) => DateTime.parse(emissions.year),
        measureFn: (Emissions emissions, _) => emissions.annualIncrease,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 350,
      child: Card(
        child: FutureBuilder<List<Emissions>>(
          future: _emissions,
          builder:
              (BuildContext context, AsyncSnapshot<List<Emissions>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text('Error: ${snapshot.error}'),
              );
            } else {
              final emissions = snapshot.data!;
              final chartData = _createChartData(emissions);
              return Container(
                height: 300,
                child: charts.TimeSeriesChart(
                  animationDuration: const Duration(seconds: 1),
                  chartData,
                  animate: true,
                  behaviors: [
                    charts.ChartTitle(
                      'Year',
                      titleStyleSpec: charts.TextStyleSpec(
                        fontSize: 18,
                        color: charts.MaterialPalette.black,
                      ),
                      behaviorPosition: charts.BehaviorPosition.bottom,
                      titleOutsideJustification:
                          charts.OutsideJustification.middle,
                    ),
                    charts.ChartTitle(
                      'CO2 Emissions in PPM',
                      titleStyleSpec: charts.TextStyleSpec(
                        fontSize: 18,
                        color: charts.MaterialPalette.black,
                      ),
                      behaviorPosition: charts.BehaviorPosition.start,
                      titleOutsideJustification:
                          charts.OutsideJustification.middle,
                    ),
                    charts.LinePointHighlighter(
                      showHorizontalFollowLine:
                          charts.LinePointHighlighterFollowLineType.nearest,
                      showVerticalFollowLine:
                          charts.LinePointHighlighterFollowLineType.nearest,
                    ),
                    charts.SeriesLegend(
                      position: charts.BehaviorPosition.bottom,
                      outsideJustification:
                          charts.OutsideJustification.middleDrawArea,
                      horizontalFirst: false,
                      desiredMaxRows: 2,
                      cellPadding: EdgeInsets.only(right: 4.0, bottom: 4.0),
                      entryTextStyle: charts.TextStyleSpec(
                        color: charts.MaterialPalette.black,
                        fontFamily: 'Georgia',
                        fontSize: 11,
                      ),
                    ),
                  ],
                  primaryMeasureAxis: charts.NumericAxisSpec(
                    // add title

                    tickProviderSpec: charts.BasicNumericTickProviderSpec(
                      desiredTickCount: 5,
                    ),
                  ),
                  domainAxis: charts.DateTimeAxisSpec(
                    renderSpec: charts.SmallTickRendererSpec(
                      labelStyle: charts.TextStyleSpec(
                        fontSize: 12,
                        color: charts.MaterialPalette.black,
                      ),
                    ),
                    tickProviderSpec: charts.DayTickProviderSpec(
                      increments: [365 * 6],
                    ),
                  ),
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
