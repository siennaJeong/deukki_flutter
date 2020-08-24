import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

const String DB_NAME = 'Deukki.db';
const int DB_VERSION = 1;

const String TABLE_VERSION = 'version';
const String TABLE_USER = 'user';
const String TABLE_CATEGORY_BIG = 'category_big';
const String TABLE_CATEGORY_MEDIUM = 'category_medium';
const String TABLE_CATEGORY_SMALL = 'category_small';
const String TABLE_SENTENCE = 'sentence';

class DBHelper {
  DBHelper._();
  static final DBHelper _dbHelper = DBHelper._();
  factory DBHelper() => _dbHelper;

  static Database _database;

  Future<Database> get database async {
    if(_database != null) return _database;
    _database = await initDB();
    return _database;
  }

  initDB() async {
    return await openDatabase(
        join(await getDatabasesPath(), DB_NAME),
        version: DB_VERSION,
        onCreate: (db, version) {
          db.execute (
            "CREATE TABLE $TABLE_VERSION(idx INTEGER PRIMARY KEY, version_name TEXT, version TEXT)"
          );
          db.execute(
            "CREATE TABLE $TABLE_USER(idx INTEGER PRIMARY KEY, email TEXT, name TEXT, birth_data TEXT, gender INTEGER)"
          );
          db.execute(
            "CREATE TABLE $TABLE_CATEGORY_BIG(id TEXT, title TEXT, order INTEGER)"
          );
          db.execute(
            "CREATE TABLE $TABLE_CATEGORY_MEDIUM(id TEXT, title TEXT, description TEXT, order INTEGER, premium INTEGER, enable INTEGER, large_id TEXT)"
          );
          db.execute(
            "CREATE TABLE $TABLE_CATEGORY_SMALL(id TEXT, title TEXT, description TEXT, order INTEGER, premium INTEGER, enable INTEGER, medium_id TEXT)"
          );
          db.execute(
            "CREATE TABLE $TABLE_SENTENCE(id TEXT, content TEXT, order INTEGER, cutline_score INTEGER, enable INTEGER, small_id TEXT)"
          );
        }
    );
  }

  /* Version */

  /* User */

  /* Vocabulary */

  /* Sentence */
}