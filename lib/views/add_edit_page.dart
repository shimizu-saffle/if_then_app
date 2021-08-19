import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:if_then_app/controllers/fcm_controller.dart';
import 'package:if_then_app/models/ifthen.dart';
import 'package:if_then_app/controllers/ifthen_controller.dart';

class AddPage extends StatelessWidget {
  AddPage({this.ifThen});
  final IfThen? ifThen;
  @override
  Widget build(BuildContext context) {
    //ifThen　が　null　じゃなければ　true
    final bool isUpdate = ifThen != null;
    final ifTextEditingController = TextEditingController();
    final thenTextEditingController = TextEditingController();

    if (isUpdate) {
      ifTextEditingController.text = ifThen!.ifText!;
      thenTextEditingController.text = ifThen!.thenText!;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(isUpdate ? 'edit' : 'add'),
      ),
      body: Consumer(
        builder: (context, watch, child) {
          final addController = watch(AddProvider);
          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                TextField(
                  controller: ifTextEditingController,
                  decoration:
                      InputDecoration(labelText: "IF", hintText: "〇〇な時"),
                  onChanged: (text) {
                    addController.newIfText = text;
                  },
                ),
                TextField(
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
                Consumer(builder: (context, watch, child) {
                  final GetTokenController = watch(FcmProvider);
                  return ElevatedButton(
                    onPressed: () async {
                      if (isUpdate) {
                        await addController.ifThenUpdate(ifThen!);
                      } else {
                        await addController.ifThenAdd();
                      }
                      GetTokenController.getSetToken();
                      Navigator.of(context).pop();
                    },
                    child: Text(isUpdate ? '更新する' : '追加する'),
                  );
                })
              ],
            ),
          );
        },
      ),
    );
  }
}
