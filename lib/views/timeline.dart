import 'package:flutter/material.dart';
import 'package:if_then_app/views/add_edit_page.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:if_then_app/controllers/ifthen_controller.dart';
import 'package:if_then_app/views/home_page.dart';

class TimeLinePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('If-Then Plans'),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: Icon(Icons.more_vert),
            onPressed: () async {
              await showDialog(
                context: context,
                builder: (BuildContext context) {
                  return SimpleDialog(
                    children: <Widget>[
                      Center(
                        child: SimpleDialogOption(
                          child: const Text('ログアウト'),
                          onPressed: () async {
                            await showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text('ログアウトしますか？'),
                                  actions: <Widget>[
                                    ElevatedButton(
                                      child: Text('OK'),
                                      onPressed: () async {
                                        await Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => HomePage(),
                                          ),
                                        );
                                      },
                                    ),
                                  ],
                                );
                              },
                            );
                            Navigator.of(context).pop();
                          },
                        ),
                      ),
                    ],
                  );
                },
              );
            },
          )
        ],
      ),
      body: Consumer(
        builder: (context, watch, child) {
          final ifthenList = watch(IfThenListProvider).ifThenList;
          final deleteController = watch(IfThenListProvider);
          return ListView(
            children: ifthenList
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
                          icon: Icon(Icons.more_vert),
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
