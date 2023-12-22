
import 'package:expenses_traking/pages/add_page/add_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    totalAmount = 0.0;
    loadTotalAmount();
  }
  double sum = 0.0;
  double totalAmount = 0.0;

  void loadTotalAmount() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      sum = prefs.getDouble('totalAmount') ?? 0.0;
      print('Sum-->$sum');
    });
  }
  final List<ChartDataPie> chartData = [
    ChartDataPie('David', 20, Colors.red),
    ChartDataPie('Steve',10, Colors.green),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        title: const Text('Expense Track'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              // Container(
              //   height: 250,
              //   decoration: BoxDecoration(
              //     color: Colors.white,
              //     borderRadius: BorderRadius.circular(15),
              //     border: Border.all(color: Colors.grey),
              //   ),
              //   child: Column(
              //     crossAxisAlignment: CrossAxisAlignment.start,
              //     mainAxisAlignment: MainAxisAlignment.spaceAround,
              //     children: [
              //       const Padding(
              //         padding: EdgeInsets.all(10),
              //         child: Text('Expenses Yearly Chart',
              //             style: TextStyle(fontSize: 16, color: Colors.black, fontWeight: FontWeight.w600)),
              //       ),
              //       Expanded(
              //         child: SfCartesianChart(
              //           plotAreaBorderWidth: 0,
              //           primaryXAxis: CategoryAxis(
              //             placeLabelsNearAxisLine: false,
              //             majorGridLines: const MajorGridLines(width: 0),
              //             minorGridLines: const MinorGridLines(width: 0),
              //             axisLine: const AxisLine(width: 0),
              //           ),
              //           primaryYAxis: NumericAxis(
              //             placeLabelsNearAxisLine: false,
              //             majorGridLines: const MajorGridLines(width: 0),
              //             minorGridLines: const MinorGridLines(width: 0),
              //             axisLine: const AxisLine(width: 0),
              //           ),
              //           series: <ChartSeries<ChartData, String>>[
              //             StackedColumnSeries<ChartData, String>(
              //               isTrackVisible: true,
              //               borderRadius:
              //                   const BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15)),
              //               dataSource: [
              //                 ChartData('Jan', 11),
              //                 ChartData('Feb', 15),
              //                 ChartData('Mar', 20),
              //                 ChartData('Apr', 10),
              //                 ChartData('May', 05),
              //                 ChartData('Jun', 20),
              //                 ChartData('Jul', 12),
              //                 ChartData('Aug', 18),
              //                 ChartData('Sep', 56),
              //                 ChartData('Oct', 11),
              //                 ChartData('Nov', 23),
              //                 ChartData('Dec', 65),
              //               ],
              //               width: 0.35,
              //               trackBorderColor: Colors.grey,
              //               trackColor: Colors.white,
              //               color: Colors.green,
              //               xValueMapper: (ChartData data, _) => data.category,
              //               yValueMapper: (ChartData data, _) => data.value1,
              //             ),
              //           ],
              //         ),
              //       ),
              //     ],
              //   ),
              // ),
              const SizedBox(height: 20),
              Container(
                height: 300,
                width: double.infinity,
                decoration: BoxDecoration(border: Border.all(color: Colors.black)),
                child: SfCircularChart(
                    title: ChartTitle(
                      text: 'Expenses Pie Chart',
                    ),
                    backgroundColor: Colors.black12,
                    series: <CircularSeries>[
                      PieSeries<ChartDataPie, String>(
                        dataSource: chartData,
                        pointColorMapper: (ChartDataPie data, _) => data.color,
                        xValueMapper: (ChartDataPie data, _) => data.x,
                        yValueMapper: (ChartDataPie data, _) => data.y,
                        explode: true,
                        dataLabelSettings: DataLabelSettings(isVisible: true)
                      ),
                    ]),
              )
            ],
          ),
        ),
      ),
      bottomNavigationBar: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Container(
              height: 50,
              width: double.infinity,
              decoration: BoxDecoration(
                  color: Colors.lightBlue.shade100,
                  borderRadius: const BorderRadius.only(topRight: Radius.circular(30), topLeft: Radius.circular(30))),
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 50),
                child: Row(
                  children: [
                    Icon(Icons.home),
                    Spacer(),
                    Icon(Icons.settings),
                  ],
                ),
              )),
          Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: InkWell(
              onTap: () async {
                totalAmount = await Navigator.push(context, MaterialPageRoute(
                  builder: (context) {
                    return AddScreen(
                      // onTotalAmountUpdated: (updatedAmount) {
                      //   setState(() {
                      //     totalAmount = updatedAmount;
                      //   });
                      // },
                    );
                  },
                ));
                print('aa->$totalAmount');
              },
              child: Container(
                margin: const EdgeInsets.all(3),
                padding: const EdgeInsets.all(3),
                decoration:
                    const BoxDecoration(gradient: LinearGradient(colors: Colors.accents), shape: BoxShape.circle),
                child: Container(
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(color: Colors.black.withOpacity(0.5), shape: BoxShape.circle),
                    child: const Icon(
                      Icons.add,
                      color: Colors.white,
                    )),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class ChartData {
  final String category;
  final double value1;

  ChartData(this.category, this.value1);
}

class ChartDataPie {
  final String? x;
  final double? y;
  final Color? color;

  ChartDataPie(this.x, this.y, this.color);
}
