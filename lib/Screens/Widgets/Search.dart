// class ของ เมนูค้นหาในหน้า home page
import 'package:flutter/material.dart';
import 'package:cattle_weight/DataBase/ProfileDB.dart';

class DataSearch extends SearchDelegate<String> {
  // สร้าง card widget ตามจำนวนโคที่อยู่ใน dataBase
  List<String> recentCities = ["cattle01", "cattle02", "cattle03", "cattle04"];
  List<String> cities = [
    "cattle01",
    "cattle02",
    "banana",
    "yellow",
    "mango",
    "fish",
    "quist",
    "exit",
    "day",
    "ant",
    "univercity",
    "zero"
  ];
  List<ProfileDB> profile = [];

  @override
  List<Widget> buildActions(BuildContext context) {
    // ปุ่มรีเซ็ตข้อความ
    return [
      IconButton(
          onPressed: () {
            query = "";
          },
          icon: Icon(Icons.close))
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    // ปุ่มกลับไปยังหน้า home page
    return IconButton(
        onPressed: () {
          Navigator.pop(context);
        },
        icon: Icon(Icons.arrow_back));
  }

  late String selectResult;

  @override
  Widget buildResults(BuildContext context) {
    // เมื่อเลือกชื่อที่ต้องการเจอแล้วจะให้ทำอะไรต่อหรือกระโดดไปหน้าไหน
    // throw UnimplementedError();
    return Container(
      child: Center(
        child: Text(selectResult),
      ),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // แสดงรายการที่ค้นหน้าและรับรายการที่ค้นหา

    List<String> suggestionList = query.isEmpty
        ? recentCities
        : cities.where((p) => p.startsWith(query)).toList();

    // ? suggestionList = cities
    // : suggestionList
    //     .addAll(recentCities.where((element) => element.contains(query)));

    return ListView.builder(
      itemBuilder: (BuildContext context, int index) {
        // ProfileDB listProfile = profile[index];
        return ListTile(
          leading: Icon(Icons.search),
          title: RichText(
            text: TextSpan(
              // ตัวอักษรที่กำลังพิมพ์
                text: suggestionList[index].substring(0, query.length),
                style:
                    TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                children: [
                  TextSpan(
                    // รายการหรือที่มีอยู่ใน dataBase
                      text: suggestionList[index].substring(query.length),
                      style: TextStyle(
                        color: Colors.grey,
                      )),
                ]),
          ),
          onTap: () {
            // เมื่อเลือกรายการแล้วจะทำงานตามฟังก์ชันนี้
            selectResult = suggestionList[index];
            showResults(context);
          },

          // leading: Icon(Icons.search),
          // title: Text(suggestionList[index]),
          // onTap: () {
          //   selectResult = suggestionList[index];
          //   showResults(context);
          // },
        );
      },
      itemCount: suggestionList.length,
    );
  }
}
