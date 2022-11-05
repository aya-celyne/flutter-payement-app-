import 'package:d_chart/d_chart.dart';
import 'package:flutter/material.dart';

class stat extends StatefulWidget {
  final List<Map<String, int>> L;
  const stat({Key? key, required this.L}) : super(key: key);

  @override
  State<stat> createState() => _statState(L);
}

class _statState extends State<stat> {
  List<Map<String, int>> L;
  _statState(this.L);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: Container(
          alignment: Alignment.center,
          // color: Colors.black,
          child: Column(
            children: [
              SizedBox(
                height: 200,
              ),
              Padding(
                padding: EdgeInsets.all(16),
                child: AspectRatio(
                  aspectRatio: 16 / 9,
                  child: DChartBar(
                    yAxisTitle: 'Montant(DA)',
                    xAxisTitle: 'Mois',
                    data: [
                      {
                        'id': 'Bar',
                        'data': [
                          {'domain': 0, 'measure': 4.1},
                          {'domain': 2, 'measure': 4},
                          {'domain': 3, 'measure': 6},
                          {'domain': 4, 'measure': 1},
                        ],
                      },
                    ],
                    domainLabelPaddingToAxisLine: 16,
                    axisLineTick: 2,
                    axisLinePointTick: 2,
                    axisLinePointWidth: 10,
                    axisLineColor: Color.fromARGB(255, 1, 2, 12),
                    measureLabelPaddingToAxisLine: 16,
                    barColor: (barData, index, id) =>
                        Color.fromARGB(255, 41, 7, 235),
                    showBarValue: true,
                  ),
                ),
              ),
            ],
          )),
    ));
  }
}
