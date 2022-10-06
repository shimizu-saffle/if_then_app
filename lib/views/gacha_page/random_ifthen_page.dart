import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../controllers/login_controller.dart';
import '../../controllers/random_ifthen_controller.dart';
import '../login_page.dart';
import 'present_page.dart';

class IfThenMixerPage extends HookConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Text('\u{1F973}  イフゼンガチャ  \u{1F973}',
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
                                      ref.watch(LogOutProvider);
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
      body: Container(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset('images/gachagacha.png'),
            Consumer(builder: (context, watch, child) {
              final randomController = ref.watch(randomProvider);
              return ElevatedButton(
                child: Text('回す'),
                onPressed: () async {
                  await randomController.checkTodayTurnGachaTimes();
                  final canTurn = ref.watch(randomProvider).canTurn;
                  if (canTurn) {
                    randomController.countTurningGacha();
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PresentPage(),
                        fullscreenDialog: true,
                      ),
                    );
                  } else {
                    await showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text(
                              'ガチャを回せるのは\n1日5回までだよ\u{1F60C}\nまた明日回してね\u{1F365}'),
                          actions: <Widget>[
                            ElevatedButton(
                              child: Text('うん'),
                              onPressed: () async {
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        );
                      },
                    );
                  }
                },
              );
            })
          ],
        ),
      ),
    );
  }
}
