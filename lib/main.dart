import 'package:flutter/material.dart';
import 'package:if_then_app/add_page.dart';

//↓アプリを開いた時に最初に読み込まれるメソッド
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'If Then Plans',
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('If Then Plans'),
      ),
      body: ListView(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddPage(),
              fullscreenDialog: true,
            ),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
