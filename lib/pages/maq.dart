// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';

// class MCQForm extends StatefulWidget {
//   @override
//   _MCQFormState createState() => _MCQFormState();
// }

// class _MCQFormState extends State<MCQForm> {
//   List<Map<String, dynamic>> mcqList = [];

//   void onDeleteQuestion(int index) {
//     setState(() {
//       mcqList.removeAt(index);
//     });
//   }

//   void onSubmit() {
//     // for (var mcq in mcqList) {
//     //   print('Question: ${mcq['question']}');
//     //   print('Options: ${mcq['options']}');
//     // }
//     print(mcqList);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('MCQ Form'),
//       ),
//       body: Column(
//         children: [
//           Expanded(
//             child: ListView.builder(
//               itemCount: mcqList.length,
//               itemBuilder: (context, index) {
//                 return MCQCard(
//                   index: index + 1,
//                   questionController:
//                       TextEditingController(text: mcqList[index]['question']),
//                   optionControllers: List.generate(
//                       4,
//                       (i) => TextEditingController(
//                           text: mcqList[index]['options'][i])),
//                   onDelete: () => onDeleteQuestion(index),
//                   onUpdate: (question, options) {
//                     setState(() {
//                       mcqList[index]['question'] = question;
//                       mcqList[index]['options'] = options;
//                     });
//                   },
//                 );
//               },
//             ),
//           ),
//           ElevatedButton(
//             onPressed: onSubmit,
//             child: Text('Submit'),
//           ),
//         ],
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           setState(() {
//             mcqList.add({
//               'question': '',
//               'options': ['', '', '', '']
//             });
//           });
//         },
//         child: Icon(Icons.add),
//       ),
//     );
//   }
// }

// class MCQCard extends StatelessWidget {
//   final int index;
//   final TextEditingController questionController;
//   final List<TextEditingController> optionControllers;
//   final VoidCallback onDelete;
//   final Function(String, List<String>) onUpdate;

//   MCQCard({
//     required this.index,
//     required this.questionController,
//     required this.optionControllers,
//     required this.onDelete,
//     required this.onUpdate,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       elevation: 4,
//       margin: EdgeInsets.symmetric(vertical: 8),
//       child: Padding(
//         padding: EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text(
//                   'Question $index',
//                   style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                 ),
//                 IconButton(
//                   onPressed: onDelete,
//                   icon: Icon(Icons.delete),
//                 ),
//               ],
//             ),
//             SizedBox(height: 8),
//             TextFormField(
//               showCursor: true,
//               textDirection: TextDirection.ltr,
//               textAlign: TextAlign.left,
//               style:  GoogleFonts.montserrat(
//                   fontSize: 30,
//                   fontWeight: FontWeight.w600,
//                 ),
//               controller: questionController,
//               decoration: InputDecoration(
//                 hintText: 'Question',
//                 hintStyle: GoogleFonts.montserrat(
//                   fontSize: 30,
//                   fontWeight: FontWeight.w600,
//                 ),
//               ),
//               onChanged: (value) => onUpdate(
//                   value,
//                   optionControllers
//                       .map((controller) => controller.text)
//                       .toList()),
//             ),
//             SizedBox(height: 12),
//             for (var i = 0; i < 4; i++)
//               TextFormField(
//                 controller: optionControllers[i],
//                 decoration: InputDecoration(labelText: 'Option ${i + 1}'),
//                 onChanged: (value) => onUpdate(
//                     questionController.text,
//                     optionControllers
//                         .map((controller) => controller.text)
//                         .toList()),
//               ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class MCQForm extends StatefulWidget {
  @override
  _MCQFormState createState() => _MCQFormState();
}

class _MCQFormState extends State<MCQForm> {
  List<Map<String, dynamic>> mcqList = [];

  void onDeleteQuestion(int index) {
    setState(() {
      mcqList.removeAt(index);
    });
  }

void onSubmit() async {
  final CollectionReference mcqCollection =
      FirebaseFirestore.instance.collection('mcqs');

  // Create a map to store all questions and options
  Map<String, dynamic> mcqsData = {'Test heading': {}};

  // Add each question and options to the map
  for (int i = 0; i < mcqList.length; i++) {
    mcqsData['Test heading']['Question ${i + 1}'] =
        mcqList[i]['questionController'].text;
    mcqsData['Test heading']['Options ${i + 1}'] = mcqList[i]
            ['optionControllers']
        .map((controller) => controller.text)
        .toList();
  }

  // Add the map as a single document to Firestore
  await mcqCollection.add(mcqsData);

  print('MCQs added to Firestore');
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('MCQ Form'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: mcqList.length,
              itemBuilder: (context, index) {
                return MCQCard(
                  index: index + 1,
                  questionController: mcqList[index]['questionController'],
                  optionControllers: mcqList[index]['optionControllers'],
                  onDelete: () => onDeleteQuestion(index),
                );
              },
            ),
          ),
          ElevatedButton(
            onPressed: onSubmit,
            child: Text('Submit'),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            mcqList.add({
              'questionController': TextEditingController(),
              'optionControllers':
                  List.generate(4, (_) => TextEditingController(text: '')),
            });
          });
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

class MCQCard extends StatelessWidget {
  final int index;
  final TextEditingController questionController;
  final List<TextEditingController> optionControllers;
  final VoidCallback onDelete;

  MCQCard({
    required this.index,
    required this.questionController,
    required this.optionControllers,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Question $index',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  onPressed: onDelete,
                  icon: Icon(Icons.delete),
                ),
              ],
            ),
            SizedBox(height: 8),
            TextFormField(
              controller: questionController,
              decoration: InputDecoration(labelText: 'Question'),
            ),
            SizedBox(height: 12),
            for (var i = 0; i < 4; i++)
              TextFormField(
                controller: optionControllers[i],
                decoration: InputDecoration(labelText: 'Option ${i + 1}'),
              ),
          ],
        ),
      ),
    );
  }
}
