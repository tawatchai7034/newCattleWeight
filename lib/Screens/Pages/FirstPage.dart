import 'dart:io';

import 'package:camera/camera.dart';
import 'package:cattle_weight/Screens/Pages/FirstAddProfile.dart';
import 'package:cattle_weight/Screens/Pages/SelectPicture.dart';
import 'package:cattle_weight/Screens/Pages/catPro_screen.dart';

import 'package:cattle_weight/Screens/Widgets/MainButton.dart';
import 'package:flutter/material.dart';
import 'package:cattle_weight/convetHex.dart';
import 'package:cattle_weight/model/MediaSource.dart';

ConvertHex hex = new ConvertHex();

class FisrtPage extends StatefulWidget {
  final CameraDescription camera;
  const FisrtPage(this.camera);

  @override
  _FisrtPageState createState() => _FisrtPageState();
}

class _FisrtPageState extends State<FisrtPage> {
  late File fileMedia;
  late MediaSource source;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: 30,
              ),
              // โลโก้แอป
              Center(
                child: Image.asset("assets/images/IconApp.jpg",
                    height: 240, width: 240, fit: BoxFit.cover),
              ),
              SizedBox(
                height: 16,
              ),
              Container(
                child: Text(
                  "Cattle Weight",
                  style: TextStyle(
                      fontSize: 36,
                      color: Color(hex.hexColor("ffffff")),
                      fontFamily: 'boogaloo',
                      fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(
                height: 32,
              ),
              // ปุ่มคำนวณน้ำหนักโค
              MainButton(
                  onSelected: () {
                    capture(MediaSource.image);
                  },
                  title: "คำนวณน้ำหนักโค"),
              SizedBox(
                height: 16,
              ),
              // ปุ่มหน้าประวัติ
              MainButton(
                  onSelected: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => CatProScreen()));
                  },
                  title: "หน้าประวัติ"),
            ]),
      ),
      backgroundColor: Color(hex.hexColor("#47B5BE")),
    );
  }

  Future capture(MediaSource source) async {
    setState(() {
      this.source = source;
      var _fileMedia = null;
      this.fileMedia = _fileMedia;
    });

    final result = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => SelectInput(widget.camera),
        settings: RouteSettings(
          arguments: source,
        ),
      ),
    );

    if (result == null) {
      return;
    } else {
      setState(() {
        fileMedia = result;
      });
    }
  }
}
