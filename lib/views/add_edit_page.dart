import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:if_then_app/models/ifthen.dart';
import 'package:if_then_app/controllers/ifthen_list_controller.dart';

class AddPage extends StatelessWidget {
  AddPage({this.ifThen});
  final IfThen? ifThen;
  @override
  Widget build(BuildContext context) {
    final bool isUpdate = ifThen != null;
    final ifTextEditingController = TextEditingController();
    final thenTextEditingController = TextEditingController();

    if (isUpdate) {
      ifTextEditingController.text = ifThen!.ifText!;
      thenTextEditingController.text = ifThen!.thenText!;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('イフゼン', style: GoogleFonts.yuseiMagic()),
      ),
      body: Consumer(
        builder: (context, watch, child) {
          final addController = watch(AddProvider);
          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                TextField(
                  maxLength: 17,
                  maxLines: 1,
                  controller: ifTextEditingController,
                  decoration: InputDecoration(
                    labelText: "IF",
                    hintText: "〇〇な時",
                  ),
                  onChanged: (text) {
                    addController.newIfText = text;
                  },
                ),
                TextField(
                  maxLength: 17,
                  maxLines: 1,
                  controller: thenTextEditingController,
                  decoration:
                      InputDecoration(labelText: "THEN", hintText: "〇〇する"),
                  onChanged: (text) {
                    addController.newThenText = text;
                  },
                ),
                SizedBox(
                  height: 16,
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (isUpdate) {
                      if (addController.newIfText.isEmpty) {
                        throw (showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text('IFを入力してね\u{1F64F}'),
                              actions: <Widget>[
                                ElevatedButton(
                                  child: Text('わかった'),
                                  onPressed: () async {
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            );
                          },
                        ));
                      } else if (addController.newThenText.isEmpty) {
                        throw (showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text('THENを入力してね\u{1F64F}'),
                              actions: <Widget>[
                                ElevatedButton(
                                  child: Text('わかった'),
                                  onPressed: () async {
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            );
                          },
                        ));
                      }
                      await addController.ifThenUpdate(ifThen!);
                    } else {
                      if (addController.newIfText.isEmpty) {
                        throw (showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text('IFを入力してね\u{1F64F}'),
                              actions: <Widget>[
                                ElevatedButton(
                                  child: Text('わかった'),
                                  onPressed: () async {
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            );
                          },
                        ));
                      } else if (addController.newThenText.isEmpty) {
                        throw (showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text('THENを入力してね\u{1F64F}'),
                              actions: <Widget>[
                                ElevatedButton(
                                  child: Text('わかった'),
                                  onPressed: () async {
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            );
                          },
                        ));
                      }
                      await addController.ifThenAdd();
                    }
                    Navigator.of(context).pop();
                  },
                  child: Text(isUpdate ? '更新する' : '追加する'),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
