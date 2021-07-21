import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final AddProvider = ChangeNotifierProvider<AddController>(
  (ref) => AddController(),
);

class AddController extends ChangeNotifier {}
