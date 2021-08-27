import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:if_then_app/controllers/login_controller.dart';
import 'package:if_then_app/views/add_edit_page.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:if_then_app/controllers/ifthen_list_controller.dart';
import 'package:if_then_app/views/account_page/login_page.dart';

class MyIfThenListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('あなたのイフゼン'),
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
                                return Consumer(
                                    builder: (context, watch, child) {
                                  final logOutController = watch(LogInProvider);
                                  return AlertDialog(
                                    title: Text('ログアウトしますか？'),
                                    actions: <Widget>[
                                      ElevatedButton(
                                        child: Text('OK'),
                                        onPressed: () async {
                                          //Googleアカウントのログアウトができた。メールログインの状態でこのメソッド呼んだらエラー出ちゃうかも
                                          logOutController.logout();
                                          await Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => LoginPage(),
                                            ),
                                          );
                                        },
                                      ),
                                    ],
                                  );
                                });
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
          final ifThenList = watch(myIfThenListProvider).myIfThenList;
          final deleteController = watch(IfThenListProvider);
          return ListView(
            children: ifThenList
                .map(
                  (ifThen) => Card(
                    child: Padding(
                      padding: const EdgeInsets.all(10.5),
                      child: ListTile(
                        title: Text(
                          '${ifThen.ifText!}\n${ifThen.thenText!}',
                          style: TextStyle(height: 2.0),
                        ),
                        trailing:
                            //ここに三項演算子で
                            FirebaseAuth.instance.currentUser?.uid ==
                                    ifThen.userId
                                ? IconButton(
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
                                                            AddPage(
                                                                ifThen: ifThen),
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
                                                      builder: (BuildContext
                                                          context) {
                                                        return AlertDialog(
                                                          title: Text(
                                                              '「${ifThen.ifText!}${ifThen.thenText!}」を削除しますか？'),
                                                          actions: <Widget>[
                                                            ElevatedButton(
                                                              child: Text('OK'),
                                                              onPressed:
                                                                  () async {
                                                                Navigator.of(
                                                                        context)
                                                                    .pop();
                                                                await deleteController
                                                                    .ifThenDelete(
                                                                        ifThen);
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
                                  )
                                : null,
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
