import 'package:cattle_weight/Screens/Pages/exportData.dart';
import 'package:csv/csv.dart';

import '../model/catTime.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import 'package:path/path.dart';
import 'dart:io' as io;

class CatTimeHelper {
//  ************************** Create table **************************
  static Database? _db;
  Future<Database?> get db async {
    if (_db != null) {
      return _db!;
    }
    _db = await initDatabase();
    return _db!;
  }

  initDatabase() async {
    io.Directory documentDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentDirectory.path, 'catTime.db');
    var db = await openDatabase(path, version: 1, onCreate: _onCreate);
    return db;
  }

  _onCreate(Database db, int version) async {
    await db.execute(
      "CREATE TABLE cattime(id INTEGER PRIMARY KEY, idPro INTEGER,weight REAL,bodyLenght REAL,heartGirth REAL,hearLenghtSide REAL,hearLenghtRear REAL,hearLenghtTop REAL,pixelReference REAL,distanceReference REAL,imageSide TEXT, imageRear TEXT, imageTop TEXT,date TEXT,note TEXT)",
    );
  }

//  ************************** Create table **************************

//  ************************** Insert **************************

  Future<CatTimeModel> insert(CatTimeModel catTimeModel) async {
    var dbClient = await db;
    await dbClient!.insert('cattime', catTimeModel.toMap());
    return catTimeModel;
  }

//  ************************** Insert **************************

//  ************************** Query **************************

  Future<List<CatTimeModel>> getAllCatTimeList() async {
    var dbClient = await db;

    final List<Map<String, Object?>> queryResult =
        await dbClient!.query('cattime', orderBy: "date DESC");
    return queryResult.map((e) => CatTimeModel.fromMap(e)).toList();
  }

  Future<List<CatTimeModel>> getCatTimeListWithCatProID(int idPro) async {
    var dbClient = await db;

    final List<Map<String, Object?>> queryResult = await dbClient!.query(
        'cattime',
        columns: CatTimeFields.values,
        where: 'idPro = ?',
        whereArgs: [idPro],
        orderBy: "date DESC");
    return queryResult.map((e) => CatTimeModel.fromMap(e)).toList();
  }

  Future<CatTimeModel> getCatTimeWithCatTimeID(int idTime) async {
    var dbClient = await db;

    final queryResult = await dbClient!.query(
      'cattime',
      columns: CatTimeFields.values,
      where: 'id = ?',
      whereArgs: [idTime],
    );

    if (queryResult.isNotEmpty) {
      return CatTimeModel.fromJson(queryResult.first);
    } else {
      throw Exception('ID $idTime not found');
    }
  }

  Future<CatTimeModel> getCatTimeWithCatPro(int idPro) async {
    var dbClient = await db;

    final queryResult = await dbClient!.query('cattime',
        columns: CatTimeFields.values,
        where: 'idPro = ?',
        whereArgs: [idPro],
        orderBy: "date DESC");

    if (queryResult.isNotEmpty) {
      return CatTimeModel.fromJson(queryResult.first);
    } else {
      throw Exception('ID $idPro not found');
    }
  }

  exportSQLtoCSV() async {
    var dbClient = await db;

    final queryResult = await dbClient!
        .query('cattime', columns: CatTimeFields.values, orderBy: "date DESC");

    var csv = mapListToCsv(queryResult);

    // List<List<CatTimeModel>> catTime = [<String>CatTimeFields.values,...queryResult.map((e) => CatTimeModel.fromMap(e)).toList()];

    // String csv = const ListToCsvConverter().convert(catTime);

    final String dir = "/storage/emulated/0/Documents";
    final String path = '$dir/cattle_time.csv';

    // create file
    final io.File file = io.File(path);
    // Save csv string using default configuration
    // , as field separator
    // " as text delimiter and
    // \r\n as eol.
    await file.writeAsString(csv);
  }

  // generateCsv() async {
  //   var dbClient = await db;

  //   final queryResult = await dbClient!.query('cattime',
  //       orderBy: "date DESC");

  //   List<List<String>> data = [
  //     [
  //       CatTimeFields.id,
  //       CatTimeFields.idPro,
  //       CatTimeFields.weight,
  //       CatTimeFields.bodyLenght,
  //       CatTimeFields.heartGirth,
  //       CatTimeFields.hearLenghtSide,
  //       CatTimeFields.hearLenghtRear,
  //       CatTimeFields.hearLenghtTop,
  //       CatTimeFields.pixelReference,
  //       CatTimeFields.distanceReference,
  //       CatTimeFields.imageSide,
  //       CatTimeFields.imageRear,
  //       CatTimeFields.imageTop,
  //       CatTimeFields.date,
  //       CatTimeFields.note,
  //     ],
  //     ...queryResult.map((e) => CatTimeModel.fromMap(e)).toList()
  //   ];
  //   String csvData = ListToCsvConverter().convert(data);
  //   final String directory = (await getApplicationSupportDirectory()).path;
  //   final path = "$directory/csv-${DateTime.now()}.csv";
  //   print(path);
  //   final io.File file = io.File(path);
  //   await file.writeAsString(csvData);
  //   // Navigator.of(context).push(
  //   //   MaterialPageRoute(
  //   //     builder: (_) {
  //   //       return LoadCsvDataScreen(path: path);
  //   //     },
  //   //   ),
  //   // );
  // }

//  ************************** Query **************************

//  ************************** Update **************************

  Future<int> updateCatTime(CatTimeModel catTimeModel) async {
    var dbClient = await db;
    return await dbClient!.update(
      'cattime',
      catTimeModel.toMap(),
      where: 'id = ?',
      whereArgs: [catTimeModel.id],
    );
  }

//  ************************** Update **************************

//  ************************** Delete **************************

  Future deleteTableContent() async {
    var dbClient = await db;
    return await dbClient!.delete(
      'cattime',
    );
  }

  Future<int> deleteCatTime(int id) async {
    var dbClient = await db;
    return await dbClient!.delete(
      'cattime',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> deleteCatTimeWithIdPro(int idPro) async {
    var dbClient = await db;
    return await dbClient!.delete(
      'cattime',
      where: 'idPro = ?',
      whereArgs: [idPro],
    );
  }

//  ************************** Delete **************************
  Future close() async {
    var dbClient = await db;
    dbClient!.close();
  }

  /// Convert a map list to csv
  String mapListToCsv(List<Map<String, dynamic>> mapList,
      {ListToCsvConverter? converter}) {
    if (mapList == null) {
      return "null";
    }
    converter ??= const ListToCsvConverter();
    var data = <List>[];
    var keys = <String>[];
    var keyIndexMap = <String, int>{};

    // Add the key and fix previous records
    int _addKey(String key) {
      var index = keys.length;
      keyIndexMap[key] = index;
      keys.add(key);
      for (var dataRow in data) {
        dataRow.add(null);
      }
      return index;
    }

    for (var map in mapList) {
      // This list might grow if a new key is found
      var dataRow = List.filled(keyIndexMap.length, null, growable: false);
      // Fix missing key
      map.forEach((key, value) {
        var keyIndex = keyIndexMap[key];
        if (keyIndex == null) {
          // New key is found
          // Add it and fix previous data
          keyIndex = _addKey(key);
          // grow our list
          dataRow = List.from(dataRow, growable: true)..add(value);
        } else {
          dataRow[keyIndex] = value;
        }
      });
      data.add(dataRow);
    }
    return converter.convert(<List>[]
      ..add(keys)
      ..addAll(data));
  }
}
