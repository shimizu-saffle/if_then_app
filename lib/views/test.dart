// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_todo_app/Status.dart';
// import 'package:flutter_todo_app/task_detail.dart';
// import 'package:flutter_todo_app/task_logic.dart';
//
// class TaskList extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Flexible(
//       child: buildTaskList(),
//     );
//   }
//
//   Widget buildTaskList() {
//     return StreamBuilder<QuerySnapshot>(
//       stream: FirebaseFirestore.instance
//           .collection('tasks')
//           .orderBy('createdAt', descending: true)
//           .snapshots(),
//       builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
//         if (!snapshot.hasData) {
//           return const Center(
//             child: const CircularProgressIndicator(),
//           );
//         }
//         if (snapshot.hasError) {
//           return const Text('Something went wrong');
//         }
//         return ListView(
//           children: snapshot.data!.docs.map((DocumentSnapshot document) {
//             final data = document.data()! as Map<String, dynamic>;
//             return Card(
//               child: ListTile(
//                 leading: IconButton(
//                   icon: data['status'] == TaskLogic.statusToString(Status.doing)
//                       ? const Icon(Icons.check_box_outline_blank)
//                       : const Icon(Icons.check_box),
//                   onPressed: () {
//                     TaskLogic.toggle(data['id'].toString());
//                   },
//                 ),
//                 title: Text('${data['taskName']}'),
//                 onTap: () {
//                   Navigator.push(
//                       context,
//                       MaterialPageRoute<void>(
//                         builder: (context) => TaskDetail(data['id'].toString()),
//                       ));
//                 },
//               ),
//             );
//           }).toList(),
//         );
//       },
//     );
//   }
// }
