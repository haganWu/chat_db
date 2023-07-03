import 'package:chat_db/database/hi_storage.dart';
import 'package:chat_db/model/NoteModel.dart';
import 'package:flutter/material.dart';

import 'dao/note_dao.dart';

class IMDBPage extends StatefulWidget {
  const IMDBPage({Key? key}) : super(key: key);

  @override
  State<IMDBPage> createState() => _IMDBPageState();
}

class _IMDBPageState extends State<IMDBPage> {
  late HiStorage storage;
  late INote noteDao;
  List<NoteModel> noteList = [];
  String _inputContent = '';
  final _controller = TextEditingController();
  int? _updateId;
  int _count = 0;
  String _updateContent = '';
  final _updateIdController = TextEditingController();
  final _updateContentController = TextEditingController();

  get topInput {
    return Container(
      margin: const EdgeInsets.only(left: 12, top: 12, right: 12),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              onChanged: (text) => _inputContent = text,
              controller: _controller,
              cursorColor: Colors.green,
              style: const TextStyle(fontSize: 12, color: Colors.white, fontWeight: FontWeight.w400),
              // 输入框样式
              decoration: InputDecoration(
                  // 圆角
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(6), borderSide: const BorderSide(width: 0, style: BorderStyle.none)),
                  filled: true,
                  // 输入框样式的大小约束
                  constraints: const BoxConstraints(maxHeight: 30),
                  fillColor: Colors.lightGreen,
                  contentPadding: const EdgeInsets.only(left: 10),
                  hintStyle: const TextStyle(fontSize: 12, color: Colors.white),
                  hintText: '请输入内容'),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(left: 12),
            width: 44,
            height: 26,
            decoration: BoxDecoration(color: Colors.blue, borderRadius: BorderRadius.circular(6)),
            child: Center(
              child: InkWell(
                onTap: () => _doSave(_inputContent),
                child: const Text(
                  'save',
                  style: TextStyle(fontSize: 12, color: Colors.white),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  get bottomContent {
    return Expanded(
        child: Container(
      padding: const EdgeInsets.only(left: 12, top: 12, right: 12),
      child: ListView.builder(
        itemCount: noteList.length,
        itemBuilder: (BuildContext _, int index) => _itemWidget(index),
      ),
    ));
  }

  get updateWidget {
    return Container(
      margin: const EdgeInsets.only(left: 12, top: 12, right: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
              margin: const EdgeInsets.only(right: 12),
              width: 66,
              child: TextField(
                onChanged: (text) => _updateId = int.parse(text),
                controller: _updateIdController,
                cursorColor: Colors.red,
                style: const TextStyle(fontSize: 12, color: Colors.white, fontWeight: FontWeight.w400),
                // 输入框样式
                decoration: InputDecoration(
                    // 圆角
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(6), borderSide: const BorderSide(width: 0, style: BorderStyle.none)),
                    filled: true,
                    // 输入框样式的大小约束
                    constraints: const BoxConstraints(maxHeight: 30),
                    fillColor: Colors.redAccent,
                    contentPadding: const EdgeInsets.only(left: 10),
                    hintStyle: const TextStyle(fontSize: 12, color: Colors.white),
                    hintText: '请输入id'),
              )),
          Expanded(
            child: TextField(
              onChanged: (text) => _updateContent = text,
              controller: _updateContentController,
              cursorColor: Colors.red,
              style: const TextStyle(fontSize: 12, color: Colors.white, fontWeight: FontWeight.w400),
              // 输入框样式
              decoration: InputDecoration(
                  // 圆角
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(6), borderSide: const BorderSide(width: 0, style: BorderStyle.none)),
                  filled: true,
                  // 输入框样式的大小约束
                  constraints: const BoxConstraints(maxHeight: 30),
                  fillColor: Colors.redAccent,
                  contentPadding: const EdgeInsets.only(left: 10),
                  hintStyle: const TextStyle(fontSize: 12, color: Colors.white),
                  hintText: '请输入要更新的内容'),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(left: 12),
            width: 44,
            height: 26,
            decoration: BoxDecoration(color: Colors.blue, borderRadius: BorderRadius.circular(6)),
            child: Center(
              child: InkWell(
                onTap: () => _doUpdate(_updateId, _updateContent),
                child: const Text(
                  'update',
                  style: TextStyle(fontSize: 12, color: Colors.white),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _doInit();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: const Size.fromHeight(36),
          child: AppBar(
            backgroundColor: Theme.of(context).colorScheme.inversePrimary,
            title: const Text('sqflite', style: TextStyle(fontSize: 12, color: Colors.white)),
          )),
      body: Column(
        children: [
          const SizedBox(height: 8),
          Text(
            '总数: $_count',
            style: const TextStyle(fontSize: 14, color: Colors.pink),
          ),
          topInput,
          Container(
            margin: const EdgeInsets.only(left: 36, top: 12, right: 36),
            height: 26,
            decoration: BoxDecoration(color: Colors.blue, borderRadius: BorderRadius.circular(6)),
            child: Center(
              child: InkWell(
                onTap: () => _loadAll(),
                child: const Text(
                  'Refresh',
                  style: TextStyle(fontSize: 12, color: Colors.white),
                ),
              ),
            ),
          ),
          updateWidget,
          bottomContent,
        ],
      ),
    );
  }

  void _doInit() async {
    storage = await HiStorage.instance(dbName: 'test');
    noteDao = storage;
    _loadAll();
  }

  @override
  void dispose() {
    super.dispose();
    storage.destroy();
  }

  ///保存数据
  void _doSave(String value) {
    if (value.isNotEmpty) {
      noteDao.saveNote(NoteModel(content: value));
      _loadAll();
      _controller.clear();
    }
  }

  void _doUpdate(int? id, String content) {
    debugPrint('_doUpdate id: $id --- content:$content');
    if (id != null && content.isNotEmpty) {
      noteDao.update(NoteModel(id: id, content: content));
      _loadAll();
      _updateContentController.clear();
      _updateIdController.clear();
    }
  }

  ///  查询数据
  void _loadAll() async {
    var list = await noteDao.getAllNote();
    setState(() {
      noteList = list;
    });
    _getCount();
  }

  _itemWidget(int index) {
    NoteModel model = noteList[index];
    // return Text('id: ${model.id}, content:${model.content}', style: const TextStyle(fontSize: 12, color: Colors.redAccent));
    return SizedBox(
      height: 28,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('${model.id} - ${model.content ?? ''}', style: const TextStyle(fontSize: 12, color: Colors.redAccent)),
          Container(
            margin: const EdgeInsets.only(left: 12),
            width: 44,
            height: 18,
            decoration: BoxDecoration(color: Colors.blue, borderRadius: BorderRadius.circular(6)),
            child: Center(
              child: InkWell(
                onTap: () => _doDelete(model.id),
                child: const Text(
                  'delete',
                  style: TextStyle(fontSize: 10, color: Colors.white),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  _doDelete(int? id) {
    if (id != null) {
      noteDao.deleteNote(id);
      _loadAll();
    }
  }

  void _getCount() async {
    var count = await noteDao.getNoteCount();
    setState(() {
      _count = count;
    });
  }
}
