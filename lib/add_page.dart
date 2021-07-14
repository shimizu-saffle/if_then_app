import 'package:flutter/material.dart';

//↓アプリを開いた時に最初に読み込まれるメソッド
// void main() {
//   runApp(AddPage());
// }

class AddPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('YouTubeクローン'),
        ),
        body: Container(),
      ),
    );
  }
}
