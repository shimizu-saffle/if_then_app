import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../controllers/login_controller.dart';
import '../../controllers/random_if_then_controller.dart';
import '../login_page.dart';
import 'present_page.dart';

class IfThenMixerPage extends HookConsumerWidget {
  const IfThenMixerPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '\u{1F973}  イフゼンガチャ  \u{1F973}',
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
      body: SizedBox(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('images/gachagacha.png'),
            Consumer(
              builder: (context, watch, child) {
                final randomController = ref.watch(randomProvider);
                return ElevatedButton(
                  child: const Text('回す'),
                  onPressed: () async {
                    await randomController.checkTodayTurnGachaTimes();
                    final canTurn = ref.watch(randomProvider).canTurn;
                    if (canTurn) {
                      await randomController.countTurningGacha();
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const PresentPage(),
                          fullscreenDialog: true,
                        ),
                      );
                    } else {
                      await showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: const Text(
                              'ガチャを回せるのは\n1日5回までだよ\u{1F60C}\nまた明日回してね\u{1F365}',
                            ),
                            actions: <Widget>[
                              ElevatedButton(
                                child: const Text('うん'),
                                onPressed: () {
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
              },
            )
          ],
        ),
      ),
    );
  }
}
