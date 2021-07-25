import 'package:flutter/material.dart';
import 'package:if_then_app/add/add_page.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:if_then_app/ifThen_list_controllers.dart';

class TimeLine extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('If Then'),
      ),
      body: Consumer(
        builder: (context, watch, child) {
          final itList = watch(ItListProvider).itList;
          final deleteController = watch(DeleteProvider);
          return ListView(
            children: itList
                .map(
                  (ifthen) => Card(
                    child: Padding(
                      padding: const EdgeInsets.all(10.5),
                      child: ListTile(
                        title: Text(
                          '${ifthen.ifText!}\n${ifthen.thenText!}',
                          style: TextStyle(height: 2.0),
                        ),
                        trailing: IconButton(
                          onPressed: () async {
                            await deleteController.ifThenDelete();
                          },
                          icon: Icon(Icons.more_vert),
                        ),
                      ),
                    ),
                    elevation: 3,
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
