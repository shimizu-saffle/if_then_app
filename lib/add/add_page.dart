import 'package:flutter/material.dart';
import 'package:if_then_app/add/add_controllers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('add'),
      ),
      body: Consumer(
        builder: (context, watch, child) {
          final addList = watch(AddProvider);
          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                TextField(
                  decoration:
                      InputDecoration(labelText: "IF", hintText: "〇〇な時"),
                ),
                TextField(
                  decoration:
                      InputDecoration(labelText: "THEN", hintText: "〇〇する"),
                ),
                SizedBox(
                  height: 16,
                ),
                ElevatedButton(onPressed: () {}, child: Text('追加する'))
              ],
            ),
          );
        },
      ),
    );
  }
}
