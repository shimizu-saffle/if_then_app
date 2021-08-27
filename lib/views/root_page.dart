import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:if_then_app/controllers/bottomn_navigation_controller.dart';
import 'package:if_then_app/views/favorite_ifthen_list_page.dart';
import 'package:if_then_app/views/random_ifthen_page.dart';
import 'package:if_then_app/views/timelinepage.dart';

import 'favorite_itthen_list_page.dart';

class RootPage extends StatelessWidget {
  // 表示するページをリスト形式で宣言します
  List<Widget> _pageList = <Widget>[
    MyIfThenListPage(),
    TimeLinePage(),
    IfThenMixerPage(),
    FavoriteIfThenListPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, watch, child) {
      final bottomNavigationController = watch(bottomNavigationProvider);
      return Scaffold(
        body: _pageList[bottomNavigationController.currentIndex],
        bottomNavigationBar: BottomNavigationBar(
          unselectedItemColor: Colors.tealAccent,
          selectedItemColor: Colors.blue,
          currentIndex: bottomNavigationController.currentIndex,
          onTap: (index) {
            // indexで今タップしたアイコンの番号にアクセスできます。
            bottomNavigationController.currentIndex =
                index; // indexをモデルに渡したときに notifyListeners(); を呼んでいます。
          },
          items: [
            BottomNavigationBarItem(
              icon: Icon(
                Icons.cottage,
              ),
              label: '',
            ),
            BottomNavigationBarItem(
                icon: Icon(FontAwesomeIcons.globeAsia), label: ''),
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.star_rate,
                ),
                label: ''),
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.shuffle,
                ),
                label: ''),
          ],
        ),
      );
    });
  }
}
