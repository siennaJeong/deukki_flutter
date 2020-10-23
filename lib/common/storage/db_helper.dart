import 'package:deukki/data/model/audio_file_path_vo.dart';
import 'package:deukki/data/model/category_vo.dart';
import 'package:deukki/data/model/faq_vo.dart';
import 'package:deukki/data/model/user_vo.dart';
import 'package:deukki/data/model/version_vo.dart';
import 'package:deukki/data/repository/version/version_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

const String DB_NAME = 'Deukki.db';
const int DB_VERSION = 1;

const String TABLE_VERSION = 'version';
const String TABLE_USER = 'user';
const String TABLE_CATEGORY_LARGE = 'category_large';
const String TABLE_CATEGORY_MEDIUM = 'category_medium';
const String TABLE_CATEGORY_SMALL = 'category_small';
const String TABLE_AUDIO_PATH = 'audio_path';
const String TABLE_FAQ = 'faq';

class DBHelper with ChangeNotifier{
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
            "CREATE TABLE $TABLE_VERSION(idx INTEGER PRIMARY KEY AUTOINCREMENT, version_name TEXT, version INTEGER)"
          );
          db.execute(
            "CREATE TABLE $TABLE_USER(idx INTEGER PRIMARY KEY AUTOINCREMENT, email TEXT, name TEXT, birth_date TEXT, gender TEXT, voice TEXT, enable INTEGER, premium INTEGER)"
          );
          db.execute(
            "CREATE TABLE $TABLE_CATEGORY_LARGE(id TEXT, title TEXT, sequence INTEGER)"
          );
          db.execute(
            "CREATE TABLE $TABLE_CATEGORY_MEDIUM(id TEXT, title TEXT, sequence INTEGER, premium INTEGER, archive_star INTEGER, total_star INTEGER, large_id TEXT)"
          );
          db.execute(
            "CREATE TABLE $TABLE_FAQ(idx INTEGER PRIMARY KEY AUTOINCREMENT, question TEXT, answer TEXT, sequence INTEGER)"
          );
          db.execute(
            "CREATE TABLE $TABLE_AUDIO_PATH(sentence_id TEXT, stage_idx INTEGER, path TEXT)"
          );
        }
    );
  }

  /* ============================ Version ============================ */
  Future<void> insertVersion(int appVersion, int categoryLarge, int categoryMedium, int categorySmall, int faqVersion) async {
    final db = await database;
    Batch batch = db.batch();
    _versionToList(appVersion, categoryLarge, categoryMedium, categorySmall, faqVersion).forEach((val) {
      VersionVOwithDB vOwithDB = VersionVOwithDB.fromJson(val);
      batch.insert(TABLE_VERSION, vOwithDB.toJson());
    });
    batch.commit();
  }

  Future<List<Map>> getVersion() async {
    final db = await database;
    var res = await db.query(TABLE_VERSION);
    return res.isNotEmpty ? res : null;
  }

  updateVersion(VersionVOwithDB vOwithDB) async {
    final db = await database;
    await db.update(TABLE_VERSION, vOwithDB.toJson(), where: 'version_name = ?', whereArgs: [vOwithDB.versionName]);
  }

  List<Map<String, dynamic>> _versionToList(int appVersion, int categoryLarge, int categoryMedium, int categorySmall, int faqVersion) {
    List<Map<String, dynamic>> versions = [];
    versions.add(new VersionVOwithDB(0, VersionRepository.APP_VERSION, appVersion).toJson());
    versions.add(new VersionVOwithDB(1, VersionRepository.CATEGORY_LARGE_VERSION, categoryLarge).toJson());
    versions.add(new VersionVOwithDB(2, VersionRepository.CATEGORY_MEDIUM_VERSION, categoryMedium).toJson());
    versions.add(new VersionVOwithDB(3, VersionRepository.CATEGORY_SMALL_VERSION, categorySmall).toJson());
    versions.add(new VersionVOwithDB(4, VersionRepository.FAQ_VERSION, faqVersion).toJson());
    return versions;
  }

  /* ============================ User ============================ */
  Future<void> insertUser(UserVO userVO) async {
    final db = await database;
    await db.insert(TABLE_USER, _userToJson(userVO), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  getUser() async {
    final db = await database;
    var res = await db.query(TABLE_USER, where: 'idx = 0');
    return res.isNotEmpty ? _userFromJson(res.first) : new UserVO(0, '', '', '', '', '', false, false);
  }

  updateUser(UserVO userVO) async {
    final db = await database;
    await db.update(TABLE_USER, _userToJson(userVO), where: 'idx = 0');
  }

  Map<String, dynamic> _userToJson(UserVO userVO) {
    var userMap = <String, dynamic> {
      'idx': userVO.idx,
      'email': userVO.email,
      'name': userVO.name,
      'birth_date': userVO.birthDate,
      'gender': userVO.gender,
      'voice': userVO.defaultVoice,
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
      map['voice'] as String,
      map['enable'] == 1 ? true : false,
      map['premium'] == 1 ? true : false
    );
  }


  /* ============================ Category ============================ */
  Future<void> insertCategoryLarge(List<dynamic> categoryLarges) async {
    final db = await database;
    Batch batch = db.batch();
    batch.delete(TABLE_CATEGORY_LARGE);
    categoryLarges.forEach((val) {
      CategoryLargeVO categoryLargeVO = CategoryLargeVO.fromJson(val);
      batch.insert(TABLE_CATEGORY_LARGE, categoryLargeVO.toJson());
    });
    batch.commit();
  }

  Future<void> insertCategoryMedium(String largeId, List<dynamic> categoryMediums) async {
    final db = await database;
    Batch batch = db.batch();
    categoryMediums.forEach((val) {
      CategoryMediumVO categoryMediumVO = CategoryMediumVO.fromJson(val);
      batch.insert(TABLE_CATEGORY_MEDIUM, _categoryMediumToJson(categoryMediumVO, largeId));
    });
    batch.commit();
  }

  Future<void> updateCategoryMedium(List<dynamic> mediumStars) async {
    final db = await database;
    Batch batch = db.batch();
    mediumStars.forEach((val) {
      MediumStarsVO mediumStarsVO = MediumStarsVO.fromJson(val);
      batch.update(TABLE_CATEGORY_MEDIUM,
          {'archive_star': mediumStarsVO.archiveStars == null ? 0 : mediumStarsVO.archiveStars , 'total_star': mediumStarsVO.totalStars},
          where: 'id = ?',
          whereArgs: ['${mediumStarsVO.id}']
      );
    });
    batch.commit();
  }

  Future<List<Map<String, dynamic>>> getCategories(String tableName) async {
    final db = await database;
    var res = await db.query(tableName);
    return res.isNotEmpty ? res : null;
  }

  Future<List<Map<String, dynamic>>> getCategoryMedium(String largeId) async {
    final db = await database;
    var res = await db.query(TABLE_CATEGORY_MEDIUM, where: 'large_id = ?', whereArgs: [largeId]);
    return res.isNotEmpty ? res : null;
  }

  Map<String, dynamic> _categoryMediumToJson(CategoryMediumVO mediumVO, String largeId) {
    var map = <String, dynamic> {
      'id': mediumVO.id,
      'title': mediumVO.title,
      'sequence': mediumVO.sequence,
      'archive_star': mediumVO.archiveStars == null ? 0 : mediumVO.archiveStars,
      'total_star': mediumVO.totalStars == null ? 0 : mediumVO.totalStars,
      'premium': mediumVO.premium ? 1 : 0,
      'large_id': largeId
    };
    return map;
  }

  CategoryMediumVO mediumFromJson(Map<String, dynamic> map) {
    return CategoryMediumVO(
      map['id'] as String,
      map['title'] as String,
      map['sequence'] as int,
      map['archive_star'] as int,
      map['total_star'] as int,
      map['premium'] == 1 ? true : false
    );
  }

  /* ============================ Audio File Path ============================ */
  Future<void> insertAudioFile(String sentenceId, int stageIdx, String path) async {
    final db = await database;
    Batch batch = db.batch();
    AudioFilePathVO audioFileVO = AudioFilePathVO(sentenceId, stageIdx, path);
    batch.insert(TABLE_AUDIO_PATH, audioFileVO.toJson());
    batch.commit();
  }

  Future<List<Map<String, dynamic>>> getFilePath(int stageIdx) async {
    final db = await database;
    var res = await db.query(TABLE_AUDIO_PATH, where: 'stage_idx = ?', whereArgs: [stageIdx]);
    return res.isNotEmpty ? res : null;
  }


  /* ============================ FAQ ============================ */
  Future<void> insertFaq(List<dynamic> faqs) async {
    final db = await database;
    Batch batch = db.batch();
    batch.delete(TABLE_FAQ);
    faqs.forEach((val) {
      FaqVO faqVO = FaqVO.fromJson(val);
      batch.insert(TABLE_FAQ, faqVO.toJson());
    });
    batch.commit();
  }

  getFaqs() async {
    final db = await database;
    var res = await db.query(TABLE_FAQ);
    return res.isNotEmpty ? res : null;
  }


  Future<int> delete(String tableName) async {
    final db = await database;
    return await db.delete(tableName);
  }

  Future<int> deleteAllResource() async {
    final db = await database;
    await db.delete(TABLE_CATEGORY_LARGE);
    await db.delete(TABLE_CATEGORY_MEDIUM);
    return await db.delete(TABLE_FAQ);
  }

  void dispose() {

  }
}