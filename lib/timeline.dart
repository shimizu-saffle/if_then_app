import 'package:flutter/material.dart';
import 'package:if_then_app/add/add_page.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:if_then_app/ifThen_list_controllers.dart';

class TimeLine extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('If Then Plans'),
      ),
      body: Consumer(
        builder: (context, watch, child) {
          final itList = watch(ItListProvider).itList;
          return ListView(
            children: itList
                .map(
                  (ifthen) => ListTile(
                    title: Text(ifthen.ifText!),
                    subtitle: Text(ifthen.thenText!),
                  ),
                )
                .toList(),
          );
        },
      ),
      floatingActionButton: Consumer(
        builder: (context, model, child) {
          return FloatingActionButton(
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddPage(),
                  fullscreenDialog: true,
                ),
              );
            },
            child: Icon(Icons.add),
          );
        },
      ),
    );
  }
}
