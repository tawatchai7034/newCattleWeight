// หน้าเลือกภาพที่จะนำไปใช้คำนวณน้ำหนัก
import 'package:camera/camera.dart';
import 'package:cattle_weight/Screens/Pages/BlueAndCameraSolution/BluetoothPage.dart';
import 'package:cattle_weight/Screens/Widgets/MainButton.dart';
import 'package:cattle_weight/Screens/Pages/GallorySolutions/AddProfile.dart';
import 'package:flutter/material.dart';
import 'package:cattle_weight/convetHex.dart';

ConvertHex hex = new ConvertHex();

class SelectInput extends StatelessWidget {
  final CameraDescription camera;
  const SelectInput(this.camera);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Center(
              child: Image.asset("assets/images/camera01.png",
                  height: 240, width: 240, fit: BoxFit.cover)),
          SizedBox(
            height: 5,
          ),
          // ปุ่มถ่ายภาพ
          MainButton(
              onSelected: () {

                // Navigator.of(context).push(MaterialPageRoute(
                //     builder: (context) => BlueMainPage(
                //           camera: camera,
                //         )
                //     // AddProfile(widget.camera)
                //     ));
              },
              title: "ถ่ายภาพ"),
          Center(
              child: Image.asset("assets/images/photo01.png",
                  height: 240, width: 240, fit: BoxFit.cover)),
          SizedBox(
            height: 5,
          ),
          MainButton(
              onSelected: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => AddProfile(camera)));
              },
              title: "นำเข้าภาพ"),
        ],
      ),
      backgroundColor: Color(hex.Blue()),
    );
  }
}
