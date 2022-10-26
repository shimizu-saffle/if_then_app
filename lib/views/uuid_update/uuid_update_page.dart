import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../controllers/uuid_update_controller.dart';

class UuidUpdatePage extends HookConsumerWidget {
  const UuidUpdatePage({super.key});

  @override
  Widget build(BuildContext context, ref) {
    if (kDebugMode) {
      final uuidUpdate = ref.watch(uuidUpdateControllerProvider);
      return Scaffold(
        body: Center(
          child: ElevatedButton(
            onPressed: () {
              uuidUpdate.uuidAdd();
            },
            child: const Text('絶対押すなよ'),
          ),
        ),
      );
    }
    return const SizedBox();
  }
}
