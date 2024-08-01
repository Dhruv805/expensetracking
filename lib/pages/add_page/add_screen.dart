
import 'dart:convert';
import 'dart:io';
import 'package:expenses_traking/pages/home_page/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart' as xls;


class AddScreen extends StatefulWidget {

  AddScreen({super.key});

  @override
  State<AddScreen> createState() => _AddScreenState();
}

class _AddScreenState extends State<AddScreen> {
  TextEditingController addExpenseController = TextEditingController();
  TextEditingController discriptionController = TextEditingController();
  double sum = 0.0;
  List<ExpenseData> expenses = [];
  int incomeCount = 0;
  int expenseCount = 0;
  double totalIncome = 0.0;
  double totalExpense = 0.0;
  double totalOverall = 0.0;
  double incomePercentage = 0.0;
  double expensePercentage = 0.0;

  bool isIncome = false;


  final List<ChartDataPie> chartData = [
    ChartDataPie('income',10, Colors.black),
    ChartDataPie('income',10, Colors.black),
  ];

  @override
  void initState() {
    super.initState();
    loadExpenses();
    loadTotalAmount();
  }

  void loadTotalAmount() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      incomePercentage = prefs.getDouble('incomePercentage') ?? 0.0;
      expensePercentage = prefs.getDouble('expensePercentage') ?? 0.0;
      totalIncome = prefs.getDouble('totalIncome') ?? 0.0;
      totalExpense = prefs.getDouble('totalExpense') ?? 0.0;
      sum = prefs.getDouble('totalAmount') ?? 0.0;
      print('Sum-->$sum');
    });
  }

  void saveTotalAmount() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setDouble('incomePercentage',incomePercentage);
    prefs.setDouble('expensePercentage',expensePercentage);
    prefs.setDouble('totalIncome',totalIncome);
    prefs.setDouble('totalExpense',totalExpense);
    prefs.setDouble('totalAmount', sum);
  }

  void loadExpenses() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? encodedList = prefs.getStringList('expenses');
    if (encodedList != null) {
      expenses = encodedList.map((String encodedExpense) {
        Map<String, dynamic> decodedExpense = json.decode(encodedExpense);
        return ExpenseData.fromMap(decodedExpense);
      }).toList();
    }
  }

  void saveExpenses() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> encodedList = expenses.map((expense) => json.encode(expense.toMap())).toList();
    prefs.setStringList('expenses', encodedList);
  }

  void updateTotalAmount(bool isIncome) {
    double expenseValue = double.tryParse(addExpenseController.text) ?? 0.0;
    print('expenseValue-->$expenseValue');
    setState(() {
        if (isIncome) {
          totalIncome += expenseValue;
          print('totlalincome-->$totalIncome');
          sum += expenseValue;
          incomeCount++;
          print('incomeCount-->$incomeCount');
        } else {
          totalExpense += expenseValue;
          print('totalExpense-->$totalExpense');
          sum -= expenseValue;
          expenseCount++;
        }
        totalOverall = totalIncome + totalExpense;
        incomePercentage = totalIncome/totalOverall*100;
        expensePercentage = totalExpense/totalOverall*100;
        print('persentage of income-->${incomePercentage}');
        print('persentage of expense-->${expensePercentage}');

        chartData[0] = ChartDataPie('Expense',expensePercentage, Colors.red);
        chartData[1] = ChartDataPie('Income', incomePercentage, Colors.green);

        expenses.add(
        ExpenseData(
          discriptionController.text,
          expenseValue,
          !isIncome,
          DateTime.now(),
        ),
      );
      discriptionController.clear();
      addExpenseController.clear();
      saveTotalAmount();
      saveExpenses();
      // widget.onTotalAmountUpdated?.call(sum);
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Add Your Expense', style: TextStyle(color: Colors.white)),
          backgroundColor: Colors.lightBlue,
          centerTitle: true,
        ),
        // floatingActionButton: FloatingActionButton(onPressed: () {
        //   Navigator.pop(context,sum);
        // },),
        // floatingActionButton: FloatingActionButton(onPressed: () {
        //   Navigator.push(context, MaterialPageRoute(builder: (context) {
        //     return HomeScreen();
        //   },));
        // },),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: ListView(
              children: [
                Container(
                  height: 250,
                  width: double.infinity,
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
                        ),
                      ],
                  ),
                ),
                SizedBox(height: 10,),
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: Colors.grey, borderRadius: BorderRadius.circular(30)),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Total Amount :-',
                              style: TextStyle(fontSize: 20, color: Colors.black, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              '$sum',
                              style: const TextStyle(fontSize: 20, color: Colors.black, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                TextFormField(
                 onChanged: (value) {
                   setState(() {});
                 },
                  controller: discriptionController,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                      labelText: 'Enter Your Discription'),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  onChanged: (value) {
                    setState(() {});
                  },
                  controller: addExpenseController,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)), labelText: 'Enter Amount'),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    (addExpenseController.text.isNotEmpty && discriptionController.text.isNotEmpty)?
                    InkWell(
                      onTap: () => updateTotalAmount(false),
                      child: Container(
                          decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(10)),
                          child: const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                            child: Text('Expense ( -- )', style: TextStyle(color: Colors.white)),
                          )),
                    ):Container(
                    decoration: BoxDecoration(color: Colors.red.shade100, borderRadius: BorderRadius.circular(10)),
                    child: const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                      child: Text('Expense ( -- )', style: TextStyle(color: Colors.white)),
                    )),
                    (addExpenseController.text.isNotEmpty && discriptionController.text.isNotEmpty)?
                    InkWell(
                      onTap: () => updateTotalAmount(true),
                      child: Container(
                          decoration: BoxDecoration(color: Colors.green, borderRadius: BorderRadius.circular(10)),
                          child: const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                            child: Text('Income ( ++ ) ', style: TextStyle(color: Colors.white)),
                          )),
                    ):Container(
                        decoration: BoxDecoration(color: Colors.green.shade100, borderRadius: BorderRadius.circular(10)),
                        child: const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                          child: Text('Income ( ++ ) ', style: TextStyle(color: Colors.white)),
                        )),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    // Container(
                    //     decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(10)),
                    //     child:  Padding(
                    //       padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                    //       child: Text('$expenseCount', style: TextStyle(color: Colors.white)),
                    //     )),
                    Container(
                        decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(10)),
                        child:  Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                          child: Text('$totalExpense', style: TextStyle(color: Colors.white)),
                        )),
                    // Container(
                    //     decoration: BoxDecoration(color: Colors.green, borderRadius: BorderRadius.circular(10)),
                    //     child:  Padding(
                    //       padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                    //       child: Text('$incomeCount', style: TextStyle(color: Colors.white)),
                    //     )),
                    Container(
                        decoration: BoxDecoration(color: Colors.green, borderRadius: BorderRadius.circular(10)),
                        child:  Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                          child: Text('$totalIncome', style: TextStyle(color: Colors.white)),
                        ))
                  ],
                ),
                const SizedBox(height: 10),
                ListView.separated(
                  physics: PageScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: expenses.length,
                  itemBuilder: (context, index) {
                    ExpenseData expense = expenses.reversed.toList()[index];
                    print('expenses-->${expense.amount}');
                    return InkWell(
                      onTap: () async {
                        generateExcelFile(expense);
                      },
                      child: Container(
                          decoration: BoxDecoration(color: Colors.black12, borderRadius: BorderRadius.circular(10)),
                          child: Padding(
                            padding:  EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                 const Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Discription :- '),
                                    Text('Amount :- '),
                                    Text('Date :- '),
                                  ],
                                ),
                                Container(
                                  alignment: Alignment.center,
                                  height: 20,
                                  width: 20,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(30),
                                    color: (expense.isExpense ?? true) ? Colors.red : Colors.green,
                                  ),
                                  child: Icon(
                                    (expense.isExpense ?? true) ? Icons.remove : Icons.add,
                                    color: Colors.white,
                                    size: 15,
                                  ),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text('${expense.description}'),
                                    Text('${expense.amount.toString()}'),
                                    // Text(DateTimeUtils.getExpensesDate(expense.date ?? DateTime.now())),
                                  ],
                                ),
                              ],
                            ),
                          )),
                    );
                  },
                  separatorBuilder: (context, index) {
                    return const SizedBox(height: 5);
                  },
                ),
              ],
            ),
          ),
        ));
  }

  Future<String?> generateExcelFile(ExpenseData expense) async {

    final xls.Workbook workbook = xls.Workbook();
    final xls.Worksheet sheet = workbook.worksheets[0];

    sheet.getRangeByIndex(1, 1).setText('Description');
    sheet.getRangeByIndex(1, 2).setText('Amount');
    sheet.getRangeByIndex(1, 3).setText('Is Expense');
    sheet.getRangeByIndex(1, 4).setText('Date');

    for (int i = 0; i < expenses.length; i++) {
      sheet.getRangeByIndex(i + 2, 1).setText(expenses[i].description ?? '');
      sheet.getRangeByIndex(i + 2, 2).setNumber(expenses[i].amount ?? 0.0);
      sheet.getRangeByIndex(i + 2, 3).setText(expenses[i].isExpense.toString());
      sheet.getRangeByIndex(i + 2, 4).setText(expenses[i].date?.toIso8601String() ?? '');
    }

    final List<int> bytes = workbook.saveAsStream();
    final File file = File('expense_data_syncfusion.xlsx');
    file.writeAsBytesSync(bytes);
    print('Excel file saved at: ${file.path}');

    // Dispose resources
    workbook.dispose();

  }
}


class ExpenseData {
  String? description;
  double? amount;
  bool? isExpense;
  DateTime? date;

  ExpenseData(this.description, this.amount, this.isExpense, this.date);

  Map<String, dynamic> toMap() {
    return {
      'description': description,
      'amount': amount,
      'isExpense': isExpense,
      'date': date!.toIso8601String(),
    };
  }

  factory ExpenseData.fromMap(Map<String, dynamic> map) {
    return ExpenseData(
      map['description'],
      map['amount'],
      map['isExpense'],
      DateTime.parse(map['date']),
    );
  }
}