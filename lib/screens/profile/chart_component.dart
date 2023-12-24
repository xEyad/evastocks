import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../models/chart_data_model/chart_data_model.dart';

/*
class SplineChart extends StatelessWidget {
  final ChartDataModel chartData;

  const SplineChart(this.chartData, {super.key});

  @override
  Widget build(BuildContext context) {
    List<FlSpot> dailySpots = chartData.data!.chart!.dailyPerformance!
        .map((dp) => FlSpot(
            DateTime.parse(dp.date!).millisecondsSinceEpoch.toDouble(),
            dp.value!.toDouble()))
        .toList();

    List<FlSpot> indexSpots = chartData.data!.chart!.indexPerformance!
        .map((ip) => FlSpot(
            DateTime.parse(ip.date!).millisecondsSinceEpoch.toDouble(),
            ip.value!.toDouble()))
        .toList();

    return LineChart(
      LineChartData(
        gridData: const FlGridData(show: false),
        titlesData: const FlTitlesData(show: false),
        // borderData: BorderData(
        //   show: true,
        //   border: Border.all(color: Colors.black, width: 1),
        // ),
        minX: dailySpots.first.x,
        maxX: dailySpots.last.x,
        minY: dailySpots
            .map((e) => e.y)
            .reduce((value, element) => value < element ? value : element),
        maxY: dailySpots
            .map((e) => e.y)
            .reduce((value, element) => value > element ? value : element),
        lineBarsData: [
          LineChartBarData(
            spots: dailySpots,
            isCurved: true,
            color: Colors.blue,
            dotData: const FlDotData(show: false),
            belowBarData: BarAreaData(show: false),
          ),
          LineChartBarData(
            spots: indexSpots,
            isCurved: true,
            color: Colors.red,
            dotData: const FlDotData(show: false),
            belowBarData: BarAreaData(show: false),
          ),
        ],
      ),
    );
  }
}
*/
class YourChartWidget extends StatelessWidget {
  final ChartDataModel chartDataModel;

  const YourChartWidget({required this.chartDataModel, super.key});

  @override
  Widget build(BuildContext context) {
    List<ChartData> mapToChartData(
        List<DailyPerformance> daily, List<IndexPerformance> index) {
      List<ChartData> result = [];
      for (int i = 0; i < daily.length; i++) {
        int x = i; // or other representation of date
        double y = double.parse(daily[i].value!.toString());
        double y1 = double.parse(index[i].value!.toString());
        result.add(ChartData(x, y, y1));
      }
      return result;
    }

    List<ChartData> chartData = mapToChartData(
        chartDataModel.data!.chart!.dailyPerformance!,
        chartDataModel.data!.chart!.indexPerformance!);

    return SfCartesianChart(
      isTransposed: false,
      enableAxisAnimation: true,
      enableSideBySideSeriesPlacement: false,

      palette: [
        Colors.transparent,
        Colors.transparent,
        Colors.transparent

      ],
      borderWidth: 0,
      primaryXAxis: CategoryAxis(
        borderWidth: 0,
        labelStyle:
            TextStyle(color: Colors.transparent), // Makes labels invisible
        majorTickLines:
            MajorTickLines(color: Colors.transparent,width: 0), // Hides tick lines
        minorTickLines:
            MinorTickLines(color: Colors.transparent,width: 0), // Hides minor tick lines
        majorGridLines:
            MajorGridLines(width: 0), // Hides major grid lines
       minorGridLines:
            MinorGridLines(color: Colors.transparent,width: 0), // Hides minor grid line
        axisLine: AxisLine(width: 0,color: Colors.transparent),
          axisBorderType: AxisBorderType.withoutTopAndBottom,
borderColor: Colors.transparent,
        isVisible: false,

      ),
      primaryYAxis:  NumericAxis(
        borderColor: Colors.transparent,
        labelStyle:
            TextStyle(color: Colors.transparent), // Makes labels invisible
        majorTickLines:
            MajorTickLines(color: Colors.transparent,width: 0), // Hides tick lines
        minorTickLines:
            MinorTickLines(color: Colors.transparent,width: 0), // Hides minor tick lines
        majorGridLines:
            MajorGridLines(width: 0), // Hides major grid lines
        minorGridLines:
            MinorGridLines(color: Colors.transparent,width: 0), // Hides minor grid lines
        axisLine: AxisLine(width: 0,color: Colors.transparent),
        axisBorderType: AxisBorderType.withoutTopAndBottom
      ),

      series: <ChartSeries>[
        SplineAreaSeries<ChartData, int>(
          color: HexColor('#31D5C8'),
          borderColor: Colors.transparent,

          dataSource: chartData,
          xValueMapper: (ChartData data, _) => data.x,
          yValueMapper: (ChartData data, _) => data.y,
        ),
        SplineAreaSeries<ChartData, int>(
          color: HexColor('#305CD5'),
          borderColor: Colors.transparent,
          dataSource: chartData,
          xValueMapper: (ChartData data, _) => data.x,
          yValueMapper: (ChartData data, _) => data.y1,
        ),
      ],
    );
  }
}

class ChartData {
  ChartData(this.x, this.y, this.y1);
  final int x;
  final double y;
  final double y1;
}
