import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

import 'package:cattle_weight/Screens/Widgets/PictureCameraSide.dart';
import 'package:cattle_weight/convetHex.dart';

// class ที่ใช้ในการแปลงค่าสีจากภายนอกมาใช้ใน flutter
ConvertHex hex = new ConvertHex();
final formKey = GlobalKey<FormState>();

class AddProfile extends StatelessWidget {

  ///controller ใช้ดึงข้อมูลที่กรอกเข้ามา (Input)
  final titleController = TextEditingController(); //รับค่าชื่อรายการ
  final amountController = TextEditingController(); //รับตัวเลขจำนวนเงิน

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Create Profile",
          style: TextStyle(fontSize: 24, fontFamily: 'boogaloo'),
        ),
        backgroundColor: Color(hex.hexColor("#007BA4")),
      ),
      body: ListView(
        children: [
          // Center(
          //   child: Image.asset("assets/images/IconApp.jpg",
          //       height: 240, width: 360, fit: BoxFit.cover),
          // ),
          // MyCustomForm(camera: camera)
        ],
      ),
      backgroundColor: Color(hex.hexColor("ffffff")),
    );
  }
}

class MyCustomForm extends StatefulWidget {
  final CameraDescription camera;
  const MyCustomForm({Key? key,required this.camera});
  @override
  MyCustomFormState createState() {
    return MyCustomFormState();
  }
}

class MyCustomFormState extends State<MyCustomForm> {
  String dropdownGender = 'กรุณาเลือกเพศ';
  String dropdownSpecise = 'กรุณาเลือกสายพันธุ์โค';

  final formKey = GlobalKey<FormState>();

  ///controller ใช้ดึงข้อมูลที่กรอกเข้ามา (Input)
  final cattleNameController = TextEditingController(); //รับชื่อโค
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(
          height: 20,
        ),
        Padding(
            padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
            child: Text(
              "ชื่อโค :",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            )),
        // ระบุชื่อโค
        Padding(
          padding: EdgeInsets.all(10),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(10),
                  child: TextFormField(
                    autofocus: false,
                    controller: cattleNameController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'กรุณาระบุชื่อโค',
                      labelText: 'ชื่อโค',
                    ),
                    // The validator receives the text that the user has entered.
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'กรุณาระบุชื่อโค';
                      }
                      return null;
                    },
                  ),
                ),
                // เลือกเพศ
                Padding(
                    padding: EdgeInsets.all(10),
                    child: Text(
                      "เพศโค :",
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    )),
                Card(
                  elevation: 5,
                  margin: EdgeInsets.all(8.0),
                  child: Padding(
                    padding: EdgeInsets.all(10),
                    child: Row(children: [
                      Expanded(
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: dropdownGender,
                            icon: const Icon(Icons.arrow_downward),
                            iconSize: 24,
                            elevation: 80,
                            style: const TextStyle(color: Colors.black),
                            underline: Container(
                              height: 2,
                              width: 100,
                              color: Colors.black,
                            ),
                            onChanged: (String? newValue) {
                              setState(() {
                                dropdownGender = newValue!;
                                print(dropdownGender);
                              });
                            },
                            items: <String>[
                              'กรุณาเลือกเพศ',
                              'เพศผู้',
                              'เพศเมีย'
                            ].map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                    ]),
                  ),
                ),

                // เลือกสายพันธุ์โค
                Padding(
                    padding: EdgeInsets.all(10),
                    child: Text(
                      "สายพันธุ์โค :",
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    )),
                Card(
                  elevation: 5,
                  margin: EdgeInsets.all(8.0),
                  child: Padding(
                    padding: EdgeInsets.all(10),
                    child: Row(children: [
                      Expanded(
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: dropdownSpecise,
                            icon: const Icon(Icons.arrow_downward),
                            iconSize: 24,
                            elevation: 80,
                            style: const TextStyle(color: Colors.black),
                            underline: Container(
                              height: 2,
                              width: 100,
                              color: Colors.black,
                            ),
                            onChanged: (String? newValue) {
                              setState(() {
                                dropdownSpecise = newValue!;
                                print(dropdownSpecise);
                              });
                            },
                            items: <String>['กรุณาเลือกสายพันธุ์โค', 'Brahman']
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                    ]),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                // ปุ้มบันทึก
                Center(
                  child: Container(
                      height: 60,
                      width: 360,
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                        child: new RaisedButton(
                          // กดแลเวให้ไปหน้า FisrtPage/SelectInput
                          onPressed: () {
                            if (formKey.currentState!.validate()) {
                              // แสดงข้อความเมื่อกดบันทึก
                              // ScaffoldMessenger.of(context).showSnackBar(
                              //     SnackBar(content: Text('Processing Data')));
                              print(
                                  "ชื่อโค : ${cattleNameController.text} \tเพศ : $dropdownGender \tสายพันธุ์ : $dropdownSpecise");
                              // Navigator.of(context).push(MaterialPageRoute(
                              //     builder: (context) => TakePictureSide(
                              //       blueConnection: false,
                              //           camera: widget.camera,
                              //           localFront: "assets/images/SideLeftNavigation.png",
                              //           localBack: "assets/images/SideRightNavigation.png",
                              //         )));
                            }
                          },
                          child: Text("บันทึก",
                              style: TextStyle(
                                  fontSize: 24,
                                  color: Color(hex.hexColor("ffffff")),
                                  fontWeight: FontWeight.bold)),
                          color: Color(hex.hexColor("#47B5BE")),
                          // รูปทรงปุ่ม
                          shape: RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(20.0),
                            // กรอบปุ่ม
                            side: BorderSide(color: Colors.white),
                          ),
                        ),
                      )),
                ),
                SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
