// @dart=2.9
import 'dart:async';
import 'dart:io';
import 'package:camera/camera.dart';
import 'package:cattle_weight/Screens/Pages/FirstPage.dart';
import 'package:cattle_weight/Screens/Pages/catPro_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'convetHex.dart';
import 'package:cattle_weight/Screens/Pages/FirstPage.dart';
import 'package:cattle_weight/Screens/Pages/exportData.dart';

ConvertHex hex = new ConvertHex();

List<CameraDescription> cameras = [];

void main() async {
//  // Ensure that plugin services are initialized so that `availableCameras()`
//   // can be called before `runApp()`
//   WidgetsFlutterBinding.ensureInitialized();

//   // Obtain a list of the available cameras on the device.
//   final cameras = await availableCameras();
  try {
    WidgetsFlutterBinding.ensureInitialized();
    cameras = await availableCameras();
  } on CameraException catch (e) {
    print('Error in fetching the cameras: $e');
  }

  // Get a specific camera from the list of available cameras.
  final firstCamera = cameras.first;

  runApp(Phoenix(child: new MyApp(firstCamera)));
}

class MyApp extends StatelessWidget {
  final CameraDescription camera;

  const MyApp(this.camera);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          // กำหนด font เริ่มต้น
          fontFamily: 'TH-Niramit-AS',

          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: 
        // ExportSQLtoCSV(title:"Export sql table to csv")
        CatProScreen()
        
        );
  }
}
