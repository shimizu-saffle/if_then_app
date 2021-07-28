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
          final deleteController = watch(ItListProvider);
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
                            await showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return SimpleDialog(
                                  children: <Widget>[
                                    Center(
                                      child: SimpleDialogOption(
                                        onPressed: () async {
                                          await Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  AddPage(ifThen: ifthen),
                                              fullscreenDialog: true,
                                            ),
                                          );
                                          Navigator.of(context).pop();
                                        },
                                        child: const Text('編集'),
                                      ),
                                    ),
                                    Center(
                                      child: SimpleDialogOption(
                                        onPressed: () async {
                                          await showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                title: Text(
                                                    '「${ifthen.ifText!}${ifthen.thenText!}」を削除しますか？'),
                                                actions: <Widget>[
                                                  ElevatedButton(
                                                    child: Text('OK'),
                                                    onPressed: () async {
                                                      Navigator.of(context)
                                                          .pop();
                                                      await deleteController
                                                          .ifThenDelete(ifthen);
                                                    },
                                                  ),
                                                ],
                                              );
                                            },
                                          );
                                          Navigator.of(context).pop();
                                        },
                                        child: const Text('削除'),
                                      ),
                                    ),
                                  ],
                                );
                              },
                            );
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
