
import 'package:coding_cloud_admin/pages/add_slider_images.dart';
import 'package:coding_cloud_admin/pages/users_data.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Dashboard"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Wrap(
          spacing: 30,
          children: [
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AddSliderImages(),
                  ),
                );
              },
              child: Container(
                height: 250,
                width: 300,
                padding: const EdgeInsets.only(bottom: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.blueAccent[100],
                  border: Border.all(
                    style: BorderStyle.solid,
                    width: 2,
                    strokeAlign: BorderSide.strokeAlignOutside,
                    color: Colors.black54.withOpacity(0.5),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.4),
                      spreadRadius: 3,
                      blurRadius: 16,
                      offset: const Offset(0, 15),
                    )
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(21),
                        border: const Border(
                          bottom: BorderSide(
                              style: BorderStyle.solid,
                              color: Colors.black54,
                              width: 2,
                              strokeAlign: BorderSide.strokeAlignOutside),
                        ),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Image.asset(
                          'assets/images/addImages.bmp',
                          height: 180,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Center(
                      child: Text(
                        "Slider Images",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.montserrat(
                          fontSize: 25,
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const Users(),
                  ),
                );
              },
              child: Container(
                height: 250,
                width: 300,
                padding: const EdgeInsets.only(bottom: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.blueAccent[100],
                  border: Border.all(
                    style: BorderStyle.solid,
                    width: 2,
                    strokeAlign: BorderSide.strokeAlignOutside,
                    color: Colors.black54.withOpacity(0.5),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.4),
                      spreadRadius: 3,
                      blurRadius: 16,
                      offset: const Offset(0, 15),
                    )
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(21),
                        border: const Border(
                          bottom: BorderSide(
                              style: BorderStyle.solid,
                              color: Colors.black54,
                              width: 2,
                              strokeAlign: BorderSide.strokeAlignOutside),
                        ),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Image.asset(
                          'assets/images/users.jpg',
                          height: 180,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Center(
                      child: Text(
                        "Users",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.montserrat(
                          fontSize: 25,
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
