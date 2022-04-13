import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import 'package:cattle_weight/DataBase/catPro_handler.dart';
import 'package:cattle_weight/DataBase/catTime_handler.dart';
import 'package:cattle_weight/convetHex.dart';
import 'package:cattle_weight/model/catPro.dart';
import 'package:cattle_weight/model/catTime.dart';

// class ที่ใช้ในการแปลงค่าสีจากภายนอกมาใช้ใน flutter
ConvertHex hex = new ConvertHex();

// model for show data in chart
class ChartData {
  ChartData(this.x, this.y);
  final String x;
  final double? y;
}

class ChartCattle extends StatefulWidget {
  const ChartCattle({
    Key? key,
    required this.title,
    required this.catProID,
  }) : super(key: key);
  final String title;
  final int catProID;

  @override
  State<ChartCattle> createState() => _ChartCattleState();
}

class _ChartCattleState extends State<ChartCattle> {
  late TooltipBehavior _tooltipBehavior;
  CatTimeHelper? dbHelper;
  CatProHelper? catProHelper;
  final List<ChartData> chartData = [];

  late Future<List<CatTimeModel>> catTime;
  late Future<CatProModel> catProData;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    dbHelper = new CatTimeHelper();
    catProHelper = new CatProHelper();

    loadData();
    // NotesModel(title: "User00",age: 22,description: "Default user",email: "User@exemple.com");
  }

  loadData() async {
    catTime = dbHelper!.getCatTimeListWithCatProID(widget.catProID);
    catProData = catProHelper!.getCatProWithID(widget.catProID);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: catTime,
        builder: (context, AsyncSnapshot<List<CatTimeModel>> snapshot) {
          if (snapshot.hasData) {
            for (int i = snapshot.data!.length - 1; i >= 0; i--) {
              DateTime catTimeDate = DateTime.parse(snapshot.data![i].date);
              String convertedDateTime =
                  "${catTimeDate.day.toString().padLeft(2, '0')}/${catTimeDate.month.toString().padLeft(2, '0')}/${catTimeDate.year.toString()} ";
              chartData
                  .add(ChartData(convertedDateTime, snapshot.data![i].weight));
            }
            return Scaffold(
                appBar: AppBar(
                  title: Text(widget.title),
                  backgroundColor: Color(hex.hexColor("#007BA4")),
                  actions: [MenuBar(catProID: widget.catProID)],
                ),
                body: RotatedBox(
                  quarterTurns: 1,
                  child: ExampleChart(
                    title: widget.title,
                    chartData: chartData,
                  ),
                ));
          } else {
            return Center(child: CircularProgressIndicator());
          }
        });

    // ChartData(widget.title),
  }
}

class ExampleChart extends StatefulWidget {
  final String title;
  final List<ChartData> chartData;
  const ExampleChart({
    Key? key,
    required this.title,
    required this.chartData,
  }) : super(key: key);

  @override
  State<ExampleChart> createState() => _ExampleChartState();
}

class _ExampleChartState extends State<ExampleChart> {
  late TooltipBehavior _tooltipBehavior;

  @override
  void initState() {
    _tooltipBehavior = TooltipBehavior(enable: true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // appBar: AppBar(
        //   title: Text('afadff'),
        // ),
        body: Center(
            child: Container(
                child: SfCartesianChart(
                    primaryYAxis: NumericAxis(
                        title: AxisTitle(text: 'น้ำหนัก (Kg)'),
                        rangePadding: ChartRangePadding.additional,
                        // Assigned a name for the y-axis for customization purposes
                        name: 'primaryYAxis'),
                    title: ChartTitle(
                        text: 'อัตราการเจริญเติบโตของ${widget.title}'),
                    // legend: Legend(isVisible: true),
                    // widget ที่ใช้แสดงค่าประจำจุดบนกราฟ
                    // Enables the tooltip for all the series in chart
                    tooltipBehavior: _tooltipBehavior,
                    // Initialize category axis
                    primaryXAxis: CategoryAxis(),
                    series: <ChartSeries>[
          // Initialize line series
          LineSeries<ChartData, String>(
              name: 'อัตราการเจริญเติบโต',
              // Enables the tooltip for individual series
              enableTooltip: true,
              dataSource: widget.chartData,
              xValueMapper: (ChartData data, _) => data.x,
              yValueMapper: (ChartData data, _) => data.y,
              dataLabelSettings: DataLabelSettings(isVisible: true))
        ]))));
  }
}

class MenuBar extends StatefulWidget {
  final int catProID;
  const MenuBar({Key? key, required this.catProID}) : super(key: key);

  @override
  State<MenuBar> createState() => _MenuBarState();
}

class _MenuBarState extends State<MenuBar> {
  CatTimeHelper? dbHelper;
  CatProHelper? catProHelper;
  final List<ChartData> chartData = [];

  late Future<List<CatTimeModel>> catTime;
  late Future<CatProModel> catProData;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    dbHelper = new CatTimeHelper();
    catProHelper = new CatProHelper();

    loadData();
    // NotesModel(title: "User00",age: 22,description: "Default user",email: "User@exemple.com");
  }

  loadData() async {
    catTime = dbHelper!.getCatTimeListWithCatProID(widget.catProID);
    catProData = catProHelper!.getCatProWithID(widget.catProID);
  }

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<int>(
        icon: Icon(Icons.menu),
        // เมื่อเลือกเมนูแล้วจะส่งไปทำงานที่หังก์ชัน onSelected
        onSelected: (item) {
          dbHelper!.exportSQLtoCSV();
          onSelected(context, item);
        },
        itemBuilder: (context) => [
              PopupMenuItem<int>(
                  value: 0,
                  child: ListTile(
                    leading: Icon(Icons.assignment_outlined),
                    title: Text("Export"),
                  )),
              //   PopupMenuItem<int>(
              //       value: 1,
              //       child: ListTile(
              //         leading: Icon(Icons.edit),
              //         title: Text("Edit"),
              //       ))
            ]);
  }
}

void onSelected(BuildContext context, int item) {
  switch (item) {
    case 0:
      showDialog<String>(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text(
                "บันทึกไฟล์ ",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              content: Text(
                'บันทึกไฟล์เสร็จสิน',
                style: TextStyle(fontSize: 16),
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.pop(context, 'ตกลง'),
                  child: const Text('ตกลง'),
                ),
              ],
            );
          });
      // Navigator.of(context)
      //     .push(MaterialPageRoute(builder: (context) => ExportFile()));
      break;
    // case 1:
    //   Navigator.of(context)
    //       .push(MaterialPageRoute(builder: (context) => EditOption()));
    //   break;
  }
}
