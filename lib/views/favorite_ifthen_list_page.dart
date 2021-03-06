import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:if_then_app/controllers/login_controller.dart';
import 'package:if_then_app/views/add_edit_page.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:if_then_app/controllers/ifthen_list_controller.dart';
import 'package:if_then_app/views/login_page.dart';

class FavoriteIfThenListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('\u{1F4AB}  お気に入りのイフゼン  \u{1F4AB}',
            style: GoogleFonts.yuseiMagic()),
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
                                  final logOutController =
                                      watch(LogOutProvider);
                                  return AlertDialog(
                                    title: Text('ログアウトしますか？'),
                                    actions: <Widget>[
                                      ElevatedButton(
                                        child: Text('OK'),
                                        onPressed: () async {
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
          final myFavoriteIfThenList =
              watch(myFavoriteIfThenListProvider).myFavoriteIfThenList;
          final deleteController = watch(IfThenListProvider);
          return ListView(
            children: myFavoriteIfThenList
                .map(
                  (ifThen) => Card(
                    child: Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(10, 20, 0, 20),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    SizedBox(
                                      width: 13,
                                    ),
                                    Text(
                                      'if',
                                      style: GoogleFonts.yuseiMagic(
                                        textStyle: TextStyle(
                                          color: Colors.deepOrange,
                                          fontSize: 15,
                                          fontWeight: FontWeight.w300,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 24,
                                    ),
                                    Text(
                                      '${ifThen.ifText!}',
                                      style: TextStyle(height: 2.0),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text(
                                      'Then',
                                      style: GoogleFonts.yuseiMagic(
                                        textStyle: TextStyle(
                                          color: Colors.deepOrange,
                                          fontSize: 15,
                                          fontWeight: FontWeight.w300,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      '${ifThen.thenText!}',
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
                                  final ifThenListController =
                                      watch(IfThenListProvider);
                                  return IconButton(
                                    onPressed: () {
                                      ifThen.favoriteUserId!.contains(
                                              FirebaseAuth
                                                  .instance.currentUser?.uid)
                                          ? ifThenListController
                                              .deleteFavoriteUserId(ifThen)
                                          : ifThenListController
                                              .saveFavoriteUserId(ifThen);
                                    },
                                    icon: Icon(
                                      Icons.star,
                                      size: 18.0,
                                      color: ifThen.favoriteUserId!.contains(
                                              FirebaseAuth
                                                  .instance.currentUser?.uid)
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
                  ),
                )
                .toList(),
          );
        },
      ),
    );
  }
}
