import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../controllers/ifthen_list_controller.dart';
import '../controllers/login_controller.dart';
import '../models/if_then.dart';
import 'add_edit_page.dart';
import 'login_page.dart';

class TimeLinePage extends HookConsumerWidget {
  const TimeLinePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '\u{1F4E3}  みんなのイフゼン  \u{1F4E3}',
          style: GoogleFonts.yuseiMagic(),
        ),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () async {
              await showDialog(
                context: context,
                builder: (context) {
                  return SimpleDialog(
                    children: <Widget>[
                      Center(
                        child: SimpleDialogOption(
                          child: const Text('ログアウト'),
                          onPressed: () async {
                            await showDialog(
                              context: context,
                              builder: (context) {
                                return Consumer(
                                  builder: (context, watch, child) {
                                    final logOutController =
                                        ref.watch(logOutProvider);
                                    return AlertDialog(
                                      title: const Text('ログアウトしますか？'),
                                      actions: <Widget>[
                                        ElevatedButton(
                                          child: const Text('OK'),
                                          onPressed: () async {
                                            Navigator.of(context).pop();
                                            await logOutController.logout();
                                            await Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    const LoginPage(),
                                              ),
                                            );
                                          },
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                            );
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
      body: TimeLineCard(),
    );
  }
}

class TimeLineCard extends HookConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Consumer(
      builder: (context, watch, child) {
        final deleteController = ref.watch(ifThenListProvider);
        return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
          stream: FirebaseFirestore.instance
              .collection('itList')
              .orderBy('createdAt', descending: true)
              .snapshots(),
          builder: (
            context,
            snapshot,
          ) {
            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if (snapshot.hasError) {
              return const Text('Something went wrong');
            }
            return ListView(
              children: snapshot.data!.docs.map((document) {
                final data = document.data();
                final ifThen = IfThen(document);
                return Card(
                  elevation: 3,
                  child: Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(10, 20, 0, 20),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  const SizedBox(
                                    width: 13,
                                  ),
                                  Text(
                                    'if',
                                    style: GoogleFonts.yuseiMagic(
                                      textStyle: const TextStyle(
                                        color: Colors.deepOrange,
                                        fontSize: 15,
                                        fontWeight: FontWeight.w300,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 24,
                                  ),
                                  Text(
                                    '${ifThen.ifText}',
                                    style: const TextStyle(height: 2),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Text(
                                    'Then',
                                    style: GoogleFonts.yuseiMagic(
                                      textStyle: const TextStyle(
                                        color: Colors.deepOrange,
                                        fontSize: 15,
                                        fontWeight: FontWeight.w300,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    '${ifThen.thenText}',
                                    style: const TextStyle(height: 2),
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
                                icon: const Icon(Icons.more_vert),
                                onPressed: () async {
                                  await showDialog(
                                    context: context,
                                    builder: (context) {
                                      return SimpleDialog(
                                        children: <Widget>[
                                          Center(
                                            child: SimpleDialogOption(
                                              onPressed: () async {
                                                Navigator.of(context).pop();
                                                await Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        AddPage(
                                                      ifThen: ifThen,
                                                    ),
                                                    fullscreenDialog: true,
                                                  ),
                                                );
                                              },
                                              child: const Text('編集'),
                                            ),
                                          ),
                                          Center(
                                            child: SimpleDialogOption(
                                              onPressed: () async {
                                                await showDialog(
                                                  context: context,
                                                  builder: (context) {
                                                    return AlertDialog(
                                                      title: Text(
                                                        '「${ifThen.ifText}${ifThen.thenText}」を削除しますか？',
                                                      ),
                                                      actions: <Widget>[
                                                        ElevatedButton(
                                                          child:
                                                              const Text('OK'),
                                                          onPressed: () async {
                                                            Navigator.of(
                                                              context,
                                                            ).pop();
                                                            await deleteController
                                                                .ifThenDelete(
                                                              ifThen,
                                                            );
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
                            : Consumer(
                                builder: (context, watch, child) {
                                  final ifThenListController =
                                      ref.watch(ifThenListProvider);
                                  return IconButton(
                                    onPressed: () {
                                      data['favoriteUserId'].contains(
                                        FirebaseAuth.instance.currentUser?.uid,
                                      )
                                          ? ifThenListController
                                              .deleteFavoriteUserId(ifThen)
                                          : ifThenListController
                                              .saveFavoriteUserId(ifThen);
                                    },
                                    //currentUser以外のユーザーに表示されるアイコンボタン
                                    icon: Icon(
                                      Icons.star,
                                      size: 18,
                                      color: //配列の中にユーザーIDがあれば trueで黄色、なければ Falseでグレーを表示
                                          data['favoriteUserId'].contains(
                                        FirebaseAuth.instance.currentUser?.uid,
                                      )
                                              ? Colors.amberAccent
                                              : Colors.grey,
                                    ),
                                  );
                                },
                              ),
                      ),
                      const SizedBox(
                        width: 15,
                      )
                    ],
                  ),
                );
              }).toList(),
            );
          },
        );
      },
    );
  }
}
