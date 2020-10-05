import 'package:deukki/data/model/user_vo.dart';
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
            "CREATE TABLE $TABLE_VERSION(idx INTEGER PRIMARY KEY AUTOINCREMENT, version_name TEXT, version TEXT)"
          );
          db.execute(
            "CREATE TABLE $TABLE_USER(idx INTEGER PRIMARY KEY AUTOINCREMENT, email TEXT, name TEXT, birth_date TEXT, gender TEXT, enable INTEGER, premium INTEGER)"
          );
          db.execute(
            "CREATE TABLE $TABLE_CATEGORY_BIG(id TEXT, title TEXT, content_order INTEGER)"
          );
          db.execute(
            "CREATE TABLE $TABLE_CATEGORY_MEDIUM(id TEXT, title TEXT, description TEXT, content_order INTEGER, premium INTEGER, enable INTEGER, large_id TEXT)"
          );
          db.execute(
            "CREATE TABLE $TABLE_CATEGORY_SMALL(id TEXT, title TEXT, description TEXT, content_order INTEGER, premium INTEGER, enable INTEGER, medium_id TEXT)"
          );
          db.execute(
            "CREATE TABLE $TABLE_SENTENCE(id TEXT, content TEXT, content_order INTEGER, cutline_score INTEGER, enable INTEGER, small_id TEXT)"
          );
        }
    );
  }

  /* Version */

  /* User */
  Future<void> insertUser(UserVO userVO) async {
    final db = await database;
    await db.insert(TABLE_USER, _userToJson(userVO), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  getUser() async {
    final db = await database;
    var res = await db.query(TABLE_USER, where: 'idx = 0');
    return res.isNotEmpty ? _userFromJson(res.first) : new UserVO(0, '', '', '', '', false, false);
  }

  updateUser(UserVO userVO) async {
    final db = await database;
    await db.update(TABLE_USER, _userToJson(userVO), where: 'idx = 0', whereArgs: [userVO.idx]);
  }

  Map<String, dynamic> _userToJson(UserVO userVO) {
    var userMap = <String, dynamic> {
      'idx': userVO.idx,
      'email': userVO.email,
      'name': userVO.name,
      'birth_date': userVO.birthDate,
      'gender': userVO.gender,
      'enable': userVO.enable ? 1 : 0,
      'premium': userVO.premium ? 1 : 0
    };
    return userMap;
  }

  UserVO _userFromJson(Map<String, dynamic> map) {
    return UserVO(
      map['idx'] as int,
      map['email'] as String,
      map['name'] as String,
      map['birth_date'] as String,
      map['gender'] as String,
      map['enable'] == 1 ? true : false,
      map['premium'] == 1 ? true : false
    );
  }


  /* Vocabulary */

  /* Sentence */
}