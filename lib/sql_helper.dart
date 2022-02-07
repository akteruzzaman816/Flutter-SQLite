import 'package:sqflite/sqflite.dart' as sql;

class SQLHelper{

  static Future<sql.Database> db() async{
    return sql.openDatabase(
      'test.db',
      version: 1,
      onCreate:(sql.Database database,int version) async {
        await database.execute("""CREATE TABLE items(
        id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        title TEXT,
        description TEXT,
        createdAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
      )
      """);
      });
  }


  static Future<List<Map<String, dynamic>>> getItems() async {
    final db = await SQLHelper.db();
    return db.query('items', orderBy: "id");
  }

  static Future<int> saveNotes(String title,String description) async {
    final db = await SQLHelper.db();
    final values ={'title':title,'description':description};
    int status = await db.insert(
        "items",
        values,
    conflictAlgorithm: sql.ConflictAlgorithm.replace);
    print("$title  $description "+status.toString());

    return status;
  }


}