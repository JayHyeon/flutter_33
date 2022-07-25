import 'package:flutter_33/models/searchDataModel.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DBHelper {
  var _db;

  Future<Database> get database async {
    if (_db != null) return _db;
    _db = openDatabase(join(await getDatabasesPath(), 'Wish.db'),
        onCreate: (db, version) => _createDb(db), version: 1);
    return _db;
  }

  static void _createDb(Database db) {
    db.execute(
      "CREATE TABLE wish(id INTEGER PRIMARY KEY, doc_url TEXT, thumbnail_url TEXT, collection TEXT, image_url TEXT, width INTEGER, height INTEGER, display_sitename TEXT, datetime INTEGER DEFAULT (cast(strftime('%s','now') as int)))",
    );
  }

  Future<void> insertWish(SearchData data) async {
    final db = await database;

    await db.insert("Wish", data.toJsonFromInsert(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<SearchData>> getAllWish(int page, int size) async {
    final db = await database;

    final List<Map<String, dynamic>> maps =
        await db.query('Wish', limit: size, offset: (page - 1) * size);

    return List.generate(maps.length, (i) {
      return SearchData(
          docUrl: maps[i]['doc_url'],
          imageUrl: maps[i]['image_url'],
          displaySitename: maps[i]['display_sitename'],
          thumbnailUrl: maps[i]['thumbnail_url'],
          collection: maps[i]['collection'],
          width: maps[i]['width'],
          height: maps[i]['height'],
          datetime: maps[i]['datetime'].toString());
    });
  }

  Future<dynamic> getWish(String docUrl) async {
    final db = await database;

    final List<Map<String, dynamic>> maps = (await db.query(
      'Wish',
      where: 'doc_url = ?',
      whereArgs: [docUrl],
    ));

    return maps.isNotEmpty ? maps : null;
  }

  Future<void> updateWish(SearchData data) async {
    final db = await database;

    await db.update(
      "Wish",
      data.toJson(),
      where: "doc_url = ?",
      whereArgs: [data.docUrl],
    );
  }

  Future<void> deleteWish(String docUrl) async {
    final db = await database;

    await db.delete(
      "Wish",
      where: "doc_url = ?",
      whereArgs: [docUrl],
    );
  }
}
