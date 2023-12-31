import 'package:chat_db/dao/note_dao.dart';
import 'package:chat_db/model/NoteModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:sqflite/sqflite.dart';

/// 数据管理类，实现不同的业务接口
class HiStorage implements INote {
  /// 多实例
  static final Map<String, HiStorage> _storageMap = {};

  /// 数据库名字
  final String _dbName;

  ///数据库实例
  late Database _db;

  ///私有构造
  HiStorage._({required String dbName}) : _dbName = dbName {
    _storageMap[_dbName] = this;
  }

  static Future<HiStorage> instance({required String dbName}) async {
    if (!dbName.endsWith(".db")) {
      dbName = "$dbName.db";
    }
    var storage = _storageMap[dbName];
    storage ??= await HiStorage._(dbName: dbName)._init();
    return storage;
  }

  Future<HiStorage> _init() async {
    _db = await openDatabase(_dbName);
    debugPrint('db ver: ${await _db.getVersion()}');
    return this;
  }

  void destroy() {
    _db.close();
    _storageMap.remove(_dbName);
  }

  @override
  Future<List<NoteModel>> getAllNote() {
    return NoteDao(_db).getAllNote();
  }

  @override
  void saveNote(NoteModel model) {
    NoteDao(_db).saveNote(model);
  }

  @override
  void deleteNote(int id) {
    NoteDao(_db).deleteNote(id);
  }

  @override
  Future<int> getNoteCount() {
    return NoteDao(_db).getNoteCount();
  }

  @override
  void update(NoteModel model) {
    NoteDao(_db).update(model);
  }
}
