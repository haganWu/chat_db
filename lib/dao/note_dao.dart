import 'package:sqflite/sqflite.dart';

/// 数据表接口
abstract class ITable {
  late String tableName;
}

abstract class INote {
  void saveNode(String content);

  Future<List<String>> getAllNote();
}

class NoteDao implements INote, ITable {
  final Database db;

  @override
  String tableName = 't_note';

  NoteDao(this.db) {
    db.execute('create table if not exists $tableName (id integer primary key autoincrement, content text)');
  }

  @override
  Future<List<String>> getAllNote() async {
    var results = await db.rawQuery('select * from $tableName');
    var list = results.map((item) => item['content'] as String).toList();
    return list;
  }

  @override
  void saveNode(String content) {
    db.insert(tableName, {'content': content});
  }
}
