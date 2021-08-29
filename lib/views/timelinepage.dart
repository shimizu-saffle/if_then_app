import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:if_then_app/controllers/login_controller.dart';
import 'package:if_then_app/views/add_edit_page.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:if_then_app/controllers/ifthen_list_controller.dart';
import 'package:if_then_app/views/account_page/login_page.dart';

class TimeLinePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('みんなのイフゼン'),
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
          final ifThenList = watch(IfThenListProvider).ifThenList;
          final deleteController = watch(IfThenListProvider);
          return ListView(
            children: ifThenList
                .map(
                  (ifThen) => Card(
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Spacer(
                                    flex: 5,
                                  ),
                                  Text(
                                    'if',
                                    style: GoogleFonts.pottaOne(
                                      textStyle: TextStyle(
                                        color: Colors.blue,
                                        fontSize: 15,
                                        fontWeight: FontWeight.w300,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    '${ifThen.ifText!}',
                                    style: TextStyle(height: 2.0),
                                  ),
                                  Spacer(
                                    flex: 100,
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Spacer(
                                    flex: 5,
                                  ),
                                  Text(
                                    'Then',
                                    style: GoogleFonts.pottaOne(
                                      textStyle: TextStyle(
                                        color: Colors.blue,
                                        fontSize: 15,
                                        fontWeight: FontWeight.w300,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    '${ifThen.thenText!}',
                                    style: TextStyle(height: 2.0),
                                  ),
                                  Spacer(
                                    flex: 100,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Container(
                          child: FirebaseAuth.instance.currentUser?.uid ==
                                  ifThen.userId
                              //currentUserに表示されるアイコンボタン
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
                                                    builder:
                                                        (BuildContext context) {
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
                              : Consumer(builder: (context, watch, child) {
                                  final favoriteIfThenController =
                                      watch(favoriteIfThenProvider);
                                  final saveFavoriteController =
                                      watch(IfThenListProvider);
                                  return IconButton(
                                    onPressed: () {
                                      favoriteIfThenController
                                          .changeColor(ifThen);
                                      //  三項演算子を使ってFavoriteコレクションに追加するメソッドと削除するメソッドを呼び分け
                                      favoriteIfThenController.favorite
                                          ?
                                          //itListドキュメントにfavoriteUserという配列型のフィールドを持たせて
                                          //フィールドの値にはFirebaseAuth.instance.currentUser!.uidを入れるメソッド
                                          saveFavoriteController
                                              .saveFavoriteUserId(ifThen)
                                          : favoriteIfThenController
                                              .deleteFavoriteIfThen(ifThen);
                                    },
                                    //currentUser以外のユーザーに表示されるアイコンボタン
                                    icon: Icon(
                                      Icons.star,
                                      size: 18.0,
                                      //変数favoriteが共通してしまってるのが原因だと考えています
                                      color: favoriteIfThenController.favorite
                                          ? Colors.amberAccent
                                          : Colors.grey,
                                    ),
                                  );
                                }),
                        ),
                      ],
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
