// import 'package:flutter/material.dart';
//
// void main() => runApp(MyApp());
//
// class MyApp extends StatelessWidget {
//   static const String _title = 'Flutter Code Sample';
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: _title,
//       home: HomePage(),
//     );
//   }
// }
//
// class HomePage extends StatefulWidget {
//   @override
//   _HomePageState createState() => _HomePageState();
// }
//
// class _HomePageState extends State<HomePage> {
//   int _selectedIndex = 0;
//   late PageController _pageController;
//
//   static List<Widget> _pageList = [
//     CustomPage(pannelColor: Colors.cyan, title: 'Home'),
//     CustomPage(pannelColor: Colors.green, title: 'Settings'),
//     CustomPage(pannelColor: Colors.pink, title: 'Search')
//   ];
//
//   void _onPageChanged(int index) {
//     setState(() {
//       _selectedIndex = index;
//     });
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     _pageController = PageController(
//       initialPage: _selectedIndex,
//     );
//   }
//
//   @override
//   void dispose() {
//     _pageController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('サンプル2'),
//       ),
//       body: PageView(
//         controller: _pageController,
//         onPageChanged: _onPageChanged,
//         children: _pageList,
//       ),
//       bottomNavigationBar: BottomNavigationBar(
//         items: const <BottomNavigationBarItem>[
//           BottomNavigationBarItem(
//             icon: Icon(Icons.home),
//             title: Text('Home'),
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.settings),
//             title: Text('Setting'),
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.search),
//             title: Text('Search'),
//           ),
//         ],
//         currentIndex: _selectedIndex,
//         onTap: (index) {
//           _selectedIndex = index;
//
//           _pageController.animateToPage(index,
//               duration: Duration(milliseconds: 300), curve: Curves.easeIn);
//         },
//       ),
//     );
//   }
// }
//
// class CustomPage extends StatelessWidget {
//   final Color pannelColor;
//   final String title;
//
//   CustomPage({required this.pannelColor, required this.title});
//
//   @override
//   Widget build(BuildContext context) {
//     final titleTextStyle = Theme.of(context).textTheme.title;
//     return Container(
//       child: Center(
//         child: Container(
//           width: 200,
//           height: 200,
//           decoration: BoxDecoration(
//               color: pannelColor,
//               borderRadius: BorderRadius.all(Radius.circular(20.0))),
//           child: Center(
//             child: Text(
//               title,
//               style: TextStyle(
//                 fontSize: titleTextStyle!.fontSize,
//                 color: titleTextStyle.color,
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
