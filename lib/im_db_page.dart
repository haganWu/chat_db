import 'package:chat_db/database/hi_storage.dart';
import 'package:flutter/material.dart';

class IMDBPage extends StatefulWidget {
  const IMDBPage({Key? key}) : super(key: key);

  @override
  State<IMDBPage> createState() => _IMDBPageState();
}

class _IMDBPageState extends State<IMDBPage> {
  late HiStorage storage;

  @override
  void initState() {
    super.initState();
    _doInit();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('sqflite')),
      body: const Column(
        children: [
          Text('sqflite')
        ],
      ),

    );
  }

  void _doInit() async{
    storage = await HiStorage.instance(dbName: 'test');
  }

  @override
  void dispose() {
    super.dispose();
    storage.destroy();
  }
}
