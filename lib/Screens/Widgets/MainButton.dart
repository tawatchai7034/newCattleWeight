// @dart=2.9
import 'package:flutter/material.dart';
import 'package:cattle_weight/convetHex.dart';

// convert external colors
ConvertHex hex = new ConvertHex();

class MainButton extends StatefulWidget {
  final VoidCallback onSelected;
  final String title;
  final double pixelDistance;
   MainButton({this.onSelected, this.title,this.pixelDistance});

  @override
  _MainButtonState createState() => _MainButtonState();
}

class _MainButtonState extends State<MainButton> {
  @override
  Widget build(BuildContext context) {
    return Container(
        height: 54,
        width: 328,
        child: Padding(
          padding: EdgeInsets.all(4),
          child: new RaisedButton(
            // กดแล้วให้ไปหน้า FisrtPage/SelectInput พร้อบระบุชนิดของสื่เป็น vdo หรือ  image
            onPressed: () => widget.onSelected(),
            child: Text("${widget.title}",
                style: TextStyle(
                    fontSize: 24,
                    color: Color(hex.hexColor("ffffff")),
                    fontWeight: FontWeight.bold)),
            color: Color(hex.Blue()),
            // รูปทรงปุ่ม
            shape: RoundedRectangleBorder(
              borderRadius: new BorderRadius.circular(12.0),
              // กรอบปุ่ม
              side: BorderSide(color: Colors.white),
            ),
          ),
        ));
  }
}
