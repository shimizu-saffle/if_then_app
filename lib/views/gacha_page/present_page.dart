import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:if_then_app/controllers/random_ifthen_controller.dart';

class PresentPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Container(),
      ),
      body: Container(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'みんなのイフゼンの中からランダムに\nIfとThenを組み合わせたイフゼンだよ\u{1F450}',
              style: TextStyle(fontSize: 17),
            ),
            SizedBox(
              height: 10,
            ),
            Consumer(builder: (context, watch, child) {
              final randomController = watch(randomProvider);
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
                                  '${randomController.randomIfText}',
                                  style: TextStyle(height: 2.0, fontSize: 15),
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
                                  '${randomController.randomThenText}',
                                  style: TextStyle(height: 2.0, fontSize: 15),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                elevation: 3,
              );
            }),
            SizedBox(
              height: 30,
            ),
            Text('このイフゼンをあなたのイフゼンに保存する？', style: TextStyle(fontSize: 17)),
            SizedBox(
              height: 30,
            ),
            Consumer(builder: (context, watch, child) {
              final randomController = watch(randomProvider);
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ElevatedButton(
                      onPressed: () async {
                        randomController.addRandomToMyIfThen();
                        randomController.getRandomIfThen();
                        await Navigator.pushNamed(context, 'RootPage');
                      },
                      child: Text('はい')),
                  SizedBox(
                    width: 40,
                  ),
                  ElevatedButton(
                      onPressed: () {
                        randomController.getRandomIfThen();
                        Navigator.of(context).pop();
                      },
                      child: Text('いいえ')),
                ],
              );
            }),
            SizedBox(
              height: 170,
            )
          ],
        ),
      ),
    );
  }
}
