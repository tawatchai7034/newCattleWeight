import 'package:cattle_weight/DataBase/catImage_handler.dart';
import 'package:cattle_weight/DataBase/catPro_handler.dart';
import 'package:cattle_weight/DataBase/catTime_handler.dart';
import 'package:cattle_weight/Screens/Pages/addPhotoCattles.dart';
import 'package:cattle_weight/model/catPro.dart';
import 'package:cattle_weight/model/catTime.dart';
import 'package:cattle_weight/Screens/Pages/catImage_screen.dart';
import 'package:cattle_weight/model/utility.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:intl/intl.dart';

class CatTimeScreen extends StatefulWidget {
  final int catProID;
  const CatTimeScreen({Key? key, required this.catProID}) : super(key: key);

  @override
  _CatTimeScreenState createState() => _CatTimeScreenState();
}

class _CatTimeScreenState extends State<CatTimeScreen> {
  CatTimeHelper? dbHelper;
  CatProHelper? catProHelper;
  CatImageHelper? dbImage;
  late Future<List<CatTimeModel>> catTime;
  late Future<CatProModel> catProData;
  final formatDay = DateFormat('dd/MM/yyyy hh:mm a');

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    dbHelper = new CatTimeHelper();
    catProHelper = new CatProHelper();
    dbImage = new CatImageHelper();
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
        future: catProData,
        builder: (context, AsyncSnapshot<CatProModel> catPro) {
          if (catPro.hasData) {
            return Scaffold(
              appBar: AppBar(
                  title: Text("${catPro.data!.name}"),
                  centerTitle: true,
                  actions: [
                    IconButton(
                        onPressed: () {
                          setState(() {
                            loadData();
                          });
                        },
                        icon: Icon(Icons.refresh)),
                    IconButton(
                        onPressed: () {
                          Phoenix.rebirth(context);
                        },
                        icon: Icon(Icons.home_filled)),
                  ]),
              body: Column(
                children: [
                  Expanded(
                    child: FutureBuilder(
                        future: catTime,
                        builder: (context,
                            AsyncSnapshot<List<CatTimeModel>> snapshot) {
                          if (snapshot.hasData) {
                            return ListView.builder(
                                reverse: false,
                                shrinkWrap: true,
                                itemCount: snapshot.data?.length,
                                itemBuilder: (context, index) {
                                  DateTime catTimeDate = DateTime.parse(
                                      snapshot.data![index].date);
                                  String convertedDateTime =
                                      "${catTimeDate.day.toString().padLeft(2, '0')}/${catTimeDate.month.toString().padLeft(2, '0')}/${catTimeDate.year.toString()} เวลา: ${catTimeDate.hour.toString().padLeft(2, '0')}.${catTimeDate.minute.toString().padLeft(2, '0')}";
                                  return InkWell(
                                    onTap: () {
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  CatImageScreen(
                                                      idPro: widget.catProID,
                                                      idTime: snapshot
                                                          .data![index].id!)));
                                    },
                                    child: Dismissible(
                                      direction: DismissDirection.endToStart,
                                      background: Container(
                                          color: Colors.red,
                                          alignment: Alignment.centerRight,
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10.0),
                                          child: Icon(Icons.delete_forever)),
                                      onDismissed:
                                          (DismissDirection direction) {
                                        setState(() {
                                          // delete row in cattime table with snapshot.data![index].id!
                                          dbHelper!.deleteCatTime(
                                              snapshot.data![index].id!);

                                          // delete cattle Image in images table
                                          dbImage!.deleteWithIDTime(
                                              snapshot.data![index].id!);

                                          catTime = dbHelper!
                                              .getCatTimeListWithCatProID(
                                                  widget.catProID);
                                          snapshot.data!
                                              .remove(snapshot.data![index]);
                                        });
                                      },
                                      key: ValueKey<int>(
                                          snapshot.data![index].id!),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: PhysicalModel(
                                          color: Colors.white,
                                          elevation: 8,
                                          shadowColor: Colors.grey,
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: ListTile(
                                              title: ((snapshot.data![index]
                                                              .imageSide ==
                                                          null) ||
                                                      (snapshot.data![index]
                                                              .imageSide ==
                                                          ''))
                                                  ? RotatedBox(
                                                      quarterTurns: 0,
                                                      child: Image.asset(
                                                        "assets/images/SideLeftNavigation2.png",
                                                        height: 240,
                                                        width: 320,
                                                      ),
                                                    )
                                                  : RotatedBox(
                                                      quarterTurns: -1,
                                                      child: Utility
                                                          .imageFromBase64String(
                                                              snapshot
                                                                  .data![index]
                                                                  .imageSide),
                                                    ),
                                              subtitle: ListTile(
                                                contentPadding:
                                                    EdgeInsets.all(0),
                                                title: Text(
                                                    "น้ำหนัก: ${snapshot.data![index].weight.toStringAsFixed(4)} Kg",
                                                    style: TextStyle(
                                                        fontSize: 24)),
                                                subtitle: Text(
                                                    "ข้อความ: ${snapshot.data![index].note.toString()}\nวันที่: ${convertedDateTime}",
                                                    style: TextStyle(
                                                        fontSize: 18)),
                                                trailing: IconButton(
                                                    onPressed: () {
                                                      Navigator.of(context).push(
                                                          MaterialPageRoute(
                                                              builder: (context) =>
                                                                  AddPhotoCattles(
                                                                    idPro: widget
                                                                        .catProID,
                                                                    idTime: snapshot
                                                                        .data![
                                                                            index]
                                                                        .id!,
                                                                  )));
                                                    },
                                                    icon: Icon(Icons.edit)),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                });
                          } else {
                            return Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [CircularProgressIndicator()]);
                          }
                        }),
                  ),
                ],
              ),
              floatingActionButton: FloatingActionButton(
                  onPressed: () {
                    dbHelper!
                        .insert(CatTimeModel(
                            idPro: widget.catProID,
                            weight: 0,
                            bodyLenght: 0,
                            heartGirth: 0,
                            hearLenghtSide: 0,
                            hearLenghtRear: 0,
                            hearLenghtTop: 0,
                            pixelReference: 0,
                            distanceReference: 0,
                            imageSide: '',
                            imageRear: '',
                            imageTop: '',
                            date: DateTime.now().toIso8601String(),
                            note: "New create"))
                        .then((value) {
                      print("Add data completed");
                      setState(() {
                        catTime = dbHelper!
                            .getCatTimeListWithCatProID(widget.catProID);
                      });
                      catTime =
                          dbHelper!.getCatTimeListWithCatProID(widget.catProID);
                    }).onError((error, stackTrace) {
                      print("Error: " + error.toString());
                    });
                  },
                  child: const Icon(Icons.add)),
            );
          } else {
            return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [CircularProgressIndicator()]);
          }
        });
  }
}
