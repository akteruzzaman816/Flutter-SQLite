import 'package:sqflite/sqflite.dart' as test;

class SQLTest {

  static Future<test.Database> db() async{
    return test.openDatabase(
      "test.db",
      version: 1,
      onCreate: (test.Database db,int version) async{
        await db.execute("CREATE TABLE new(id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, title TEXT, description TEXT) ");
      });
  }

  static Future<List<Map<String,dynamic>>> getAllData() async{
    final database = await SQLTest.db();
    return database.query("new",orderBy: 'id');
  }

  static Future<int> insertData(String title,String des) async{
    final database = await SQLTest.db();
    var values = {"title":title,"description":des};
    int status = await database.insert("new", values);
    return status;
  }

  static Future<int> updateData(int id,String title,String des) async{
    final database = await SQLTest.db();
    var values = {"title":title,"description":des};
    int status = await database.update("new",values,where: "id = ?",whereArgs: [id]);
    return status;
  }

  static Future<int> deleteData(int id) async{
    final database = await SQLTest.db();
    int status = await database.delete("new",where: "id = ?",whereArgs: [id]);
    return status;
  }



}