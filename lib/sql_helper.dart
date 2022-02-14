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

  static Future<int> insertData(String title,String des) async{
    final database = await SQLHelper.db();
    var values = {"title":title,"description":des};
    int status = await database.insert("items", values);
    return status;
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
    return status;
  }

  static Future<int> updateData(int id,String title,String des) async{
    final database = await SQLHelper.db();
    var values = {"title":title,"description":des};
    int status = await database.update("items",values,where: "id = ?",whereArgs: [id]);
    return status;
  }

  static Future<int> deleteData(int id) async{
    final database = await SQLHelper.db();
    int status = await database.delete("items",where: "id = ?",whereArgs: [id]);
    return status;
  }






}