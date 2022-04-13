import 'package:camera/camera.dart';
import 'package:cattle_weight/DataBase/catPro_handler.dart';
import 'package:cattle_weight/Screens/Pages/catTime_screen.dart';
import 'package:cattle_weight/model/catPro.dart';
import 'package:flutter/material.dart';

import 'package:cattle_weight/DataBase/CattleDB.dart';
import 'package:cattle_weight/DataBase/ProfileDB.dart';
import 'package:cattle_weight/Screens/Pages/SelectPicture.dart';
import 'package:cattle_weight/Screens/Widgets/CattleBox.dart';
import 'package:cattle_weight/Screens/Widgets/ProfileBox.dart';
import 'package:cattle_weight/convetHex.dart';

import 'ChartPage.dart';

ConvertHex hex = new ConvertHex();

// class ProfilePage extends StatefulWidget {
//   final CameraDescription camera;
//   const ProfilePage({required this.camera});
//   @override
//   _ProfilePageState createState() => _ProfilePageState();
// }

// class _ProfilePageState extends State<ProfilePage> {
//   List<CattleDB> cattle = [
//     CattleDB("01", "cattle01", "male", "Brahman", "assets/images/cattle01.jpg",
//         10, 20, 30),
//     CattleDB("01", "cattle01", "male", "Brahman", "assets/images/cattle01.jpg",
//         20, 30, 40),
//     CattleDB("01", "cattle01", "male", "Brahman", "assets/images/cattle01.jpg",
//         30, 40, 50),
//     CattleDB("01", "cattle01", "male", "Brahman", "assets/images/cattle01.jpg",
//         20, 30, 40),
//     CattleDB("01", "cattle01", "male", "Brahman", "assets/images/cattle01.jpg",
//         20, 30, 40),
//   ];

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(
//           "Cattle Weight",
//           style: TextStyle(
//             fontFamily: "boogaloo",
//             fontSize: 24,
//           ),
//         ),
//         backgroundColor: Color(hex.hexColor("#007BA4")),
//       ),
//       body: ListView.separated(
//           // สร้าง card widget ตามจำนวนโคที่อยู่ใน dataBase
//           itemBuilder: (BuildContext context, int index) {
//             CattleDB listCattle = cattle[index];
//             return CattleBox(
//               cattleNumber: listCattle.cattleNumber,
//               cattleName: listCattle.cattleName,
//               gender: listCattle.gender,
//               specise: listCattle.specise,
//               img: listCattle.img,
//               heartGirth: listCattle.heartGirth,
//               bodyLenght: listCattle.bodyLenght,
//               weight: listCattle.weight,
//               camera: widget.camera,
//             );
//           },
//           separatorBuilder: (BuildContext context, int index) =>
//               const Divider(),
//           itemCount: cattle.length),
//     );
//   }
// }

class CattleProfilPage extends StatefulWidget {
  const CattleProfilPage({
    Key? key,
    required this.catProID,
  }) : super(key: key);

  final int catProID;

  @override
  _CattleProfilPageState createState() => _CattleProfilPageState();
}

class _CattleProfilPageState extends State<CattleProfilPage> {
  CatProHelper? catProHelper;

  late Future<CatProModel> catProData;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    catProHelper = new CatProHelper();

    loadData();
    // NotesModel(title: "User00",age: 22,description: "Default user",email: "User@exemple.com");
  }

  loadData() async {
    catProData = catProHelper!.getCatProWithID(widget.catProID);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: catProData,
        builder: (context, AsyncSnapshot<CatProModel> catPro) {
          if (catPro.hasData) {
            return DefaultTabController(
              ///จำนวนเมนู
              length: 2,
              child: Scaffold(
                backgroundColor: Color(hex.hexColor('#FFC909')),

                ///กำหนดให้แต่ละ tapBar แสดงอะไร
                body: TabBarView(
                  children: [
                    // หน้าแอปที่ต้องการให้ทำงานเมื่อกดเมนู
                    CatTimeScreen(
                      catProID: widget.catProID,
                    ),
                    ChartCattle(
                        title: catPro.data!.name, catProID: catPro.data!.id!),
                  ],
                ),
                bottomNavigationBar: TabBar(
                  tabs: [
                    // ตั้งค่าเมนูภายใน  TapBar View
                    Tab(
                        icon: Icon(
                      Icons.list,
                      size: 48,
                    )),
                    Tab(
                      icon: Icon(
                        Icons.bar_chart_rounded,
                        size: 48,
                      ),
                    ),
                  ],
                ),
              ),
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        });
  }
}
