import 'package:chat_db/database/hi_storage.dart';
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
  List<String> noteList = [];
  String _inputContent = '';
  final _controller = TextEditingController();

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
      padding: const EdgeInsets.only(left: 12, right: 12),
      child: ListView.builder(
        itemCount: noteList.length,
        itemBuilder: (BuildContext _, int index) => _itemWidget(index),
      ),
    ));
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
      noteDao.saveNode(value);
      _loadAll();
      _controller.clear();
    }
  }

  ///  查询数据
  void _loadAll() async {
    var list = await noteDao.getAllNote();
    setState(() {
      noteList = list;
    });
  }

  _itemWidget(int index) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [Text(noteList[index], style: const TextStyle(fontSize: 12, color: Colors.redAccent))],
    );
  }
}
