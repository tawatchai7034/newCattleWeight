import 'package:camera/camera.dart';
import 'package:cattle_weight/Screens/Pages/CameraSolutions/PictureHG.dart';
import 'package:cattle_weight/Screens/Widgets/LineAndPosition.dart';
import 'package:cattle_weight/Screens/Widgets/MainButton.dart';
import 'package:cattle_weight/Screens/Widgets/preview.dart';
import 'package:cattle_weight/convetHex.dart';
import 'package:flutter/material.dart';

ConvertHex hex = new ConvertHex();

class PictureRef extends StatefulWidget {
  final CameraDescription camera;
  final String imgPath;
  final String fileName;
  const PictureRef(
      {Key? key,
      required this.camera,
      required this.imgPath,
      required this.fileName})
      : super(key: key);

  @override
  _PictureRefState createState() => _PictureRefState();
}

class _PictureRefState extends State<PictureRef> {
  TextEditingController _textFieldController = TextEditingController();

  Future<void> _displayTextInputDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(
              'ระบุความยาวของจุดอ้างอิง',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            content: TextField(
              onChanged: (value) {
                setState(() {
                  valueText = value;
                });
              },
              controller: _textFieldController,
              decoration:
                  InputDecoration(hintText: "กรุณาระบุความยาวของจุดอ้างอิง"),
            ),
            actions: <Widget>[
              FlatButton(
                color: Colors.red,
                textColor: Colors.white,
                child: Text('ยกเลิก'),
                onPressed: () {
                  setState(() {
                    Navigator.pop(context);
                  });
                },
              ),
              FlatButton(
                color: Colors.green,
                textColor: Colors.white,
                child: Text('บันทึก'),
                onPressed: () {
                  setState(() {
                    codeDialog = valueText;
                    print('Input = ' + codeDialog);
                    // Navigator.of(context).push(MaterialPageRoute(
                    //     builder: (context) => PictureHG(
                    //         blueConnection: false,
                    //         camera: widget.camera,
                    //         imgPath: widget.imgPath,
                    //         fileName: widget.fileName)));
                  });
                },
              ),
            ],
          );
        });
  }

  late String codeDialog;
  late String valueText;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text("Refferent page [1/2]",
              style: TextStyle(
                  fontSize: 24,
                  color: Color(hex.hexColor("ffffff")),
                  fontWeight: FontWeight.bold)),
          backgroundColor: Color(hex.hexColor("#007BA4"))),
      body: Stack(children: [
        LineAndPosition(
          imgPath: widget.imgPath,
          fileName: widget.fileName,
        ),
        Padding(
          padding: EdgeInsets.all(20),
          child: Column(mainAxisAlignment: MainAxisAlignment.end, children: [
            MainButton(
                onSelected: () {
                  _displayTextInputDialog(context);
                },
                title: "บันทึก")
          ]),
        ),
      ]),
    );
  }
}
