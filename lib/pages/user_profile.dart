// import 'dart:developer';

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:coding_cloud_admin/firebase/firebase_service.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/widgets.dart';
// import 'package:google_fonts/google_fonts.dart';

// import '../widgets/user_profile_widget.dart';

// class UserProfile extends StatefulWidget {
//   final DocumentSnapshot documentSnapshot;
//   const UserProfile({super.key, required this.documentSnapshot});

//   @override
//   State<UserProfile> createState() => _UserProfileState();
// }

// class _UserProfileState extends State<UserProfile> {
//   late Map<String, dynamic>? userData = {};
//   @override
//   void initState() {
//     // TODO: implement initState
//     getData();
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("${userData!['name']}'s Profile"),
//       ),
//       body: Container(
//         width: double.infinity,
//         margin: const EdgeInsets.all(16),
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Container(
//               decoration: const BoxDecoration(
//                 boxShadow: [
//                   BoxShadow(
//                       offset: Offset(0, 10),
//                       blurRadius: 20,
//                       spreadRadius: -2,
//                       color: Colors.black38),
//                 ],
//               ),
//               child: ClipRRect(
//                 borderRadius: BorderRadius.circular(20),
//                 child: Image(
//                   image: NetworkImage(
//                     userData!['profileUrl'],
//                   ),
//                   height: 300,
//                   width: 300,
//                   fit: BoxFit.cover,
//                 ),
//               ),
//             ),
//             const SizedBox(
//               width: 20,
//             ),
//             Column(
//               children: [
//                 Text(
//                   userData!['name'] ?? " ",
//                   style: GoogleFonts.montserrat(
//                       fontSize: 50, fontWeight: FontWeight.w600),
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.only(left: 48),
//                   child: Text(
//                     userData!['phone']?? " ",
//                     style: GoogleFonts.montserrat(
//                         fontSize: 25, fontWeight: FontWeight.w400),
//                   ),
//                 ),
//               ],
//             ),
//             const SizedBox(
//               height: 30,
//             ),
//             Container(
//               padding: const EdgeInsets.all(8),
//               decoration: BoxDecoration(
//                   color: Colors.grey[300],
//                   borderRadius: BorderRadius.circular(20)),
//               child: Column(
//                 children: [
//                   SizedBox(
//                     width: double.infinity,
//                     child: Row(
//                       children: [
//                         infoWidget('Email', userData!['email'] ?? " "),
//                         infoWidget('Education', userData!['education'] ?? " "),
//                         infoWidget('Passout Year', userData!['passoutYear']?? " "),
//                         infoWidget('Referral ID ', userData!['refferalID']?? " "),
//                       ],
//                     ),
//                   ),
//                   Row(
//                     children: [
//                       infoWidget('State', userData!['state']?? " "),
//                       infoWidget('City', userData!['city']?? " "),
//                       infoWidget('Address', userData!['address']?? " "),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//             const SizedBox(
//               height: 30,
//             ),
//             Padding(
//               padding: const EdgeInsets.only(left: 20),
//               child: Text(
//                 "Referrals",
//                 style: GoogleFonts.montserrat(
//                     fontSize: 30, fontWeight: FontWeight.w600),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   // Future<void> getData() async {
//   //   Map<String, dynamic> data =
//   //       widget.documentSnapshot.data() as Map<String, dynamic>;
//   //   print('Data from document: $data');

//   //   var collection =
//   //       FirebaseFirestore.instance.collection('users/${widget.documentSnapshot.id}/refferedTo');
//   //   var tempdata = await collection.get();

//   //   late List<Map<String, dynamic>> tempList = [];
//   //   for (var element in tempdata.docs) {
//   //     tempList.add(element.data());
//   //   }
//   //   print(tempList);
//   //   setState(() {
//   //     userData = data;
//   //   });
//   // }
//   Future<void> getData() async {
//   try {
//     Map<String, dynamic> userDataMap =
//         widget.documentSnapshot.data() as Map<String, dynamic>;
//     print('Data from document: $userDataMap');

//     var collection = FirebaseFirestore.instance
//         .collection('users/${widget.documentSnapshot.id}/refferedTo');
//     var querySnapshot = await collection.get();

//     List<Map<String, dynamic>> tempList = [];
//     querySnapshot.docs.forEach((doc) {
//       tempList.add(doc.data());
//     });

//     print(tempList);

//     setState(() {
//       userData = userDataMap;
//       // Assuming you want to update userData with data from the subcollection
//       // If not, modify this accordingly
//       userData!['referredTo'] = tempList;
//     });
//   } catch (e) {
//     print('Error fetching data: $e');
//   }
// }

// }

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';

import '../widgets/user_profile_widget.dart';

class UserProfile extends StatelessWidget {
  final DocumentSnapshot documentSnapshot;

  const UserProfile({required this.documentSnapshot});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${documentSnapshot['name']}'s Profile"),
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(documentSnapshot.id)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || !snapshot.data!.exists) {
            return Center(child: Text('Document does not exist'));
          }

          var userData = snapshot.data!.data() as Map<String, dynamic>;
          return SingleChildScrollView(
            child: Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Animate(
                        effects: const [ScaleEffect(), FadeEffect()],
                        child: Container(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Image(
                              image: NetworkImage(
                                userData['profileUrl'],
                              ),
                              height: 280,
                              width: 280,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 30,
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            userData['name'] ?? " ",
                            style: GoogleFonts.montserrat(
                                fontSize: 50, fontWeight: FontWeight.w600),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 16),
                            child: Text(
                              userData['phone'] ?? " ",
                              style: GoogleFonts.montserrat(
                                  fontSize: 25, fontWeight: FontWeight.w400),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(20)),
                    child: Column(
                      children: [
                        SizedBox(
                          width: double.infinity,
                          child: Row(
                            children: [
                              infoWidget('Email', userData['email'] ?? " "),
                              infoWidget(
                                  'Education', userData['education'] ?? " "),
                              infoWidget('Passout Year',
                                  userData['passoutYear'] ?? " "),
                              infoWidget('Referral ID ',
                                  userData['refferalID'] ?? " "),
                            ],
                          ),
                        ),
                        Row(
                          children: [
                            infoWidget('State', userData['state'] ?? " "),
                            infoWidget('City', userData['city'] ?? " "),
                            infoWidget('Address', userData['address'] ?? " "),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 20),
                    child: Text(
                      "Referrals",
                      style: GoogleFonts.montserrat(
                          fontSize: 30, fontWeight: FontWeight.w600),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                    height: 300,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('users')
                          .doc(documentSnapshot.id)
                          .collection('refferedTo')
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        }

                        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                          return Center(child: Text('No data available'));
                        }
                        return ListView.builder(
                          itemCount: snapshot.data!.docs.length,
                          // itemCount:5,
                          itemBuilder: (context, index) {
                            var doc = snapshot.data!.docs[index];
                            var data = doc.data() as Map<String, dynamic>;
                            return Padding(
                              padding:
                                  const EdgeInsets.only(left: 16.0, top: 16),
                              child: ListTile(
                                leading: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.network(
                                    data['profileUrl'],
                                    height: 100,
                                    width: 50,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                title: Text(
                                  data['name'],
                                  style: GoogleFonts.montserrat(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w600),
                                ),
                                subtitle: Text(data['phone']),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
