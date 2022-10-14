import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../controllers/if_then_list_controller.dart';
import '../controllers/login_controller.dart';
import 'add_edit_page.dart';
import 'login_page.dart';

class MyIfThenListPage extends HookConsumerWidget {
  const MyIfThenListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '\u{1F4AD}  あなたのイフゼン  \u{1F4AD}',
          style: GoogleFonts.yuseiMagic(),
        ),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () async {
              await showDialog<SimpleDialog>(
                context: context,
                builder: (context) {
                  return SimpleDialog(
                    children: <Widget>[
                      Center(
                        child: SimpleDialogOption(
                          child: const Text('ログアウト'),
                          onPressed: () async {
                            Navigator.of(context).pop();
                            await showDialog<Consumer>(
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
                                            await logOutController
                                                .logout()
                                                .then((value) {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute<LoginPage>(
                                                  builder: (context) =>
                                                      const LoginPage(),
                                                ),
                                              );
                                            });
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
      body: Consumer(
        builder: (context, watch, child) {
          final ifThenList = ref.watch(myifThenListProvider).myIfThenList;
          final deleteController = ref.watch(ifThenListProvider);
          return ListView(
            children: ifThenList
                .map(
                  (ifThen) => Card(
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
                                      ifThen.ifText!,
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
                                      ifThen.thenText!,
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
                                    await showDialog<SimpleDialog>(
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
                                                    MaterialPageRoute<AddPage>(
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
                                                  Navigator.of(context).pop();
                                                  await showDialog<AlertDialog>(
                                                    context: context,
                                                    builder: (context) {
                                                      return AlertDialog(
                                                        title: Text(
                                                          '「${ifThen.ifText!}${ifThen.thenText!}」を削除しますか？',
                                                        ),
                                                        actions: <Widget>[
                                                          ElevatedButton(
                                                            child: const Text(
                                                              'OK',
                                                            ),
                                                            onPressed:
                                                                () async {
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
                                    return IconButton(
                                      onPressed: () {},
                                      icon: const Icon(
                                        Icons.star,
                                        size: 18,
                                        color: Colors.amberAccent,
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
                  ),
                )
                .toList(),
          );
        },
      ),
      floatingActionButton: Consumer(
        builder: (context, model, child) {
          return FloatingActionButton(
            backgroundColor: Colors.deepOrange,
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute<AddPage>(
                  builder: (context) => const AddPage(),
                  fullscreenDialog: true,
                ),
              );
            },
            child: const Icon(Icons.add, color: Colors.white),
          );
        },
      ),
    );
  }
}
