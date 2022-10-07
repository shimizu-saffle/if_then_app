import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../controllers/random_ifthen_controller.dart';

class PresentPage extends HookConsumerWidget {
  const PresentPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '\u{1F973}  イフゼンガチャ  \u{1F973}',
          style: GoogleFonts.yuseiMagic(),
        ),
        leading: Container(),
      ),
      body: SizedBox(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(
              height: 10,
            ),
            const Text(
              'みんなのイフゼンの中からランダムに\nIfとThenを組み合わせたイフゼンだよ\u{1F450}',
              style: TextStyle(fontSize: 17),
            ),
            const SizedBox(
              height: 30,
            ),
            Consumer(
              builder: (context, watch, child) {
                final randomController = ref.watch(randomProvider);
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
                                    '${randomController.randomIfText}',
                                    style: const TextStyle(
                                      height: 2,
                                      fontSize: 15,
                                    ),
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
                                    '${randomController.randomThenText}',
                                    style: const TextStyle(
                                      height: 2,
                                      fontSize: 15,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
            const SizedBox(
              height: 40,
            ),
            const Text('このイフゼンをあなたのイフゼンに保存する？', style: TextStyle(fontSize: 17)),
            const SizedBox(
              height: 30,
            ),
            Consumer(
              builder: (context, watch, child) {
                final randomController = ref.watch(randomProvider);
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () async {
                        await randomController.addRandomToMyIfThen();
                        await randomController.getRandomIfThen();
                        await Navigator.pushNamed(context, 'RootPage');
                      },
                      child: const Text('はい'),
                    ),
                    const SizedBox(
                      width: 40,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        randomController.getRandomIfThen();
                        Navigator.of(context).pop();
                      },
                      child: const Text('いいえ'),
                    ),
                  ],
                );
              },
            ),
            const SizedBox(
              height: 100,
            )
          ],
        ),
      ),
    );
  }
}
