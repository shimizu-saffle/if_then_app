import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:if_then_app/controllers/bottom_navigation_controller.dart';
import 'package:if_then_app/views/favorite_ifthen_list_page.dart';
import 'package:if_then_app/views/my_ifthen_list_page.dart';
import 'package:if_then_app/views/gacha_page/random_ifthen_page.dart';
import 'package:if_then_app/views/timelinepage.dart';

// ignore: must_be_immutable
class RootPage extends StatelessWidget {
  PageController pageController = PageController(
    initialPage: 0,
    keepPage: true,
  );

  Widget buildPageView() {
    return Consumer(builder: (context, watch, child) {
      final bottomNavigationController = watch(bottomNavigationProvider);
      return PageView(
        controller: pageController,
        onPageChanged: (index) {
          bottomNavigationController.pageChanged(index);
        },
        children: <Widget>[
          MyIfThenListPage(),
          TimeLinePage(),
          FavoriteIfThenListPage(),
          IfThenMixerPage(),
        ],
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, watch, child) {
      final bottomNavigationController = watch(bottomNavigationProvider);
      return Scaffold(
        body: buildPageView(),
        bottomNavigationBar: BottomNavigationBar(
          unselectedItemColor: Colors.grey,
          selectedItemColor: Colors.deepOrange,
          currentIndex: bottomNavigationController.currentIndex,
          onTap: (index) {
            // indexで今タップしたアイコンの番号にアクセスできます。
            bottomNavigationController.currentIndex =
                index; // indexをモデルに渡したときに notifyListeners(); を呼んでいます。
            pageController.animateToPage(index,
                duration: Duration(milliseconds: 500), curve: Curves.ease);
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
