import 'package:chat_db/model/NoteModel.dart';
import 'package:sqflite/sqflite.dart';

/// 数据表接口
abstract class ITable {
  late String tableName;
}

abstract class INote {
  /// 保存笔记
  void saveNote(NoteModel model);

  /// 删除笔记
  void deleteNote(int id);

  /// 更新笔记
  void update(NoteModel model);

  /// 获取笔记数量
  Future<int> getNoteCount();

  /// 获取所有笔记
  Future<List<NoteModel>> getAllNote();
}

class NoteDao implements INote, ITable {
  final Database db;

  @override
  String tableName = 't_note';

  NoteDao(this.db) {
    db.execute('create table if not exists $tableName (id integer primary key autoincrement, content text)');
  }

  @override
  Future<List<NoteModel>> getAllNote() async {
    var results = await db.rawQuery('select * from $tableName');
    var list = results.map((item) => NoteModel.fromJson(item)).toList();
    return list;
  }

  @override
  void saveNote(NoteModel model) {
    db.insert(tableName, model.toJson());
  }

  @override
  void deleteNote(int id) {
    db.delete(tableName, where: 'id=$id');
  }

  @override
  Future<int> getNoteCount() async {
    var result = await db.query(tableName, columns: ['COUNT(*) as cnt']);
    return result.first['cnt'] as int;
  }

  @override
  void update(NoteModel model) {
    db.update(tableName, model.toJson(), where: 'id=?', whereArgs: [model.id]);
  }
}
