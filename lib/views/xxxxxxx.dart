import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:if_then_app/controllers/xxxxxxxx_controller.dart';

class Xxxxxxx extends HookConsumerWidget {
  const Xxxxxxx({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final xxxxxxx = ref.watch(xxxxxxxControllerProvider);
    return Scaffold(
      body: ElevatedButton(
        onPressed: () {
          xxxxxxx.uuidAdd();
        },
        child: Text('aaaa'),
      ),
    );
  }
}
