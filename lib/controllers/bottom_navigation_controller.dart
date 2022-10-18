import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final bottomNavigationProvider =
    ChangeNotifierProvider<BottomNavigationController>(
  (ref) => BottomNavigationController(),
);

class BottomNavigationController extends ChangeNotifier {
  int _currentIndex = 0;

  int get currentIndex => _currentIndex;

  set currentIndex(int index) {
    _currentIndex = index;
    notifyListeners();
  }

  void pageChanged(int index) {
    _currentIndex = index;
    notifyListeners();
  }
}
