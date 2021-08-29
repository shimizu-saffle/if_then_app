import 'package:cloud_firestore/cloud_firestore.dart';
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
        title: const Text('\u{1F4AB}  みんなのイフゼン  \u{1F4AB}'),
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
      body: MyFavoriteIfThenListCard(),
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

class MyFavoriteIfThenListCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, watch, child) {
        final deleteController = watch(IfThenListProvider);
        return StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('itList')
                .orderBy('createdAt', descending: true)
                // .where('favoriteUserId',
                //     arrayContains: FirebaseAuth.instance.currentUser?.uid)
                .snapshots(),
            builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (!snapshot.hasData) {
                return const Center(
                  child: const CircularProgressIndicator(),
                );
              }
              if (snapshot.hasError) {
                return const Text('Something went wrong');
              }
              // snapshotからデータを取り出して使う
              // 取得したドキュメントから必要なデータを取り出す
              return ListView(
                children: snapshot.data!.docs.map((DocumentSnapshot document) {
                  final data = document.data()! as Map<String, dynamic>;
                  return Card(
                    child: Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    SizedBox(
                                      width: 13,
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
                                    SizedBox(
                                      width: 24,
                                    ),
                                    Text(
                                      '${data['ifText']}',
                                      style: TextStyle(height: 2.0),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
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
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      '${data['thenText']}',
                                      style: TextStyle(height: 2.0),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          child: FirebaseAuth.instance.currentUser?.uid ==
                                  data['userId']
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
                                                              ifThen:
                                                                  data['id']),
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
                                                            '「${data['ifText']}${data['thenText']}」を削除しますか？'),
                                                        actions: <Widget>[
                                                          ElevatedButton(
                                                            child: Text('OK'),
                                                            onPressed:
                                                                () async {
                                                              // Navigator.of(
                                                              //         context)
                                                              //     .pop();
                                                              // await deleteController
                                                              //     .ifThenDelete(
                                                              //         ifThen);
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
                                  final ifThenListController =
                                      watch(IfThenListProvider);
                                  return IconButton(
                                    onPressed: () {
                                      // favoriteIfThenController
                                      //     .changeColor();
                                      // //  三項演算子を使ってFavoriteコレクションに追加するメソッドと削除するメソッドを呼び分け
                                      // favoriteIfThenController.favorite
                                      //     ?
                                      //     //itListドキュメントにfavoriteUserという配列型のフィールドを持たせて
                                      //     //フィールドの値にはFirebaseAuth.instance.currentUser!.uidを入れるメソッド
                                      //     ifThenListController
                                      //         .saveFavoriteUserId(ifThen)
                                      //     : ifThenListController
                                      //         .deleteFavoriteUserId(ifThen);
                                    },
                                    //currentUser以外のユーザーに表示されるアイコンボタン
                                    icon: Icon(
                                      Icons.star,
                                      size: 18.0,
                                      color: //配列の中にユーザーIDがあれば trueで黄色、なければ Falseでグレーを表示
                                          data['favoriteUserId'].contains(
                                                  FirebaseAuth.instance
                                                      .currentUser?.uid)
                                              ? Colors.amberAccent
                                              : Colors.grey,
                                    ),
                                  );
                                }),
                        ),
                        SizedBox(
                          width: 15,
                        )
                      ],
                    ),
                    elevation: 3,
                  );
                }).toList(),
              );
            });
      },
    );
  }
}
