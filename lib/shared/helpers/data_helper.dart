import 'package:path/path.dart' as path;
import 'package:sqflite/sqlite_api.dart';
import 'package:sqflite/sqflite.dart' as sql;

import '../components/constants.dart';

class DBHelper {
  // open database
  static Future<Database> getDataBase() async {
    final dbPath = await sql.getDatabasesPath();
    return sql.openDatabase(path.join(dbPath, 'tasks.db'), version: 1,
        onCreate: (db, version) {
      return db
          .execute(
              'CREATE TABLE IF NOT EXISTS $kTableName(id INTEGER PRIMARY KEY, $kTitleColumn TEXT, $kDateColumn TEXT, $kTimeColumn TEXT, $kStatusColumn TEXT)')
          .then((value) => print('DataBase & Tasks table created'));
    });
  }

  // insert task
  Future<void> insertTasks(Map<String, Object> data) async {
    final db = await DBHelper.getDataBase();
    db.insert(
      kTableName,
      data,
      conflictAlgorithm: ConflictAlgorithm.replace, // for replacing if exist
    );
  }

  // get all tasks
  Future<List<Map<String, dynamic>>> getTasks() async {
    final db = await DBHelper.getDataBase();
    return await db.query(kTableName);
  }

  // update task
  Future<void> updateTasks(Map<String, Object> task) async {
    final db = await DBHelper.getDataBase();
    db.update(kTableName, task, where: 'id = ?', whereArgs: [task['id']]);
  }

  // delete task
  Future<void> deleteTasks(int id) async {
    final db = await DBHelper.getDataBase();
    db.delete(kTableName, where: 'id = ?', whereArgs: [id]);
  }

  // close database
  Future<void> close() async {
    final db = await DBHelper.getDataBase();
    return await db.close();
  }
}
