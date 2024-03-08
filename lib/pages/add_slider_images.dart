import 'dart:convert';

// ignore: avoid_web_libraries_in_flutter
import 'dart:html';

import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:image_picker_web/image_picker_web.dart';

import 'package:universal_html/html.dart' as html;

class AddSliderImages extends StatefulWidget {
  const AddSliderImages({super.key});

  @override
  State<AddSliderImages> createState() => _AddSliderImagesState();
}

class _AddSliderImagesState extends State<AddSliderImages> {
  late List<String>? sliderImagesUrls = [];
  final List<Uint8List> _bytes = [];
  final List<html.File> _imageFiles = [];
  final List<String> _imageNames = [];
  int _imageCount = 0;

  Future<void> _pickImage() async {
    if (_imageCount < 3) {
      html.File imageFile = await ImagePickerWeb.getImageAsFile() as File;
      // ignore: unnecessary_null_comparison
      if (imageFile != null) {
        setState(() {
          _imageFiles.add(imageFile);
          _imageNames.add(imageFile.name);
          _imageCount++;
        });
        loadImage(imageFile);
      }
    }
  }

  void loadImage(html.File imageFile) {
    final reader = html.FileReader();
    reader.readAsDataUrl(imageFile);
    reader.onLoadEnd.listen((event) {
      var byteData = const Base64Decoder()
          .convert(reader.result.toString().split(",").last);
      setState(() {
        _bytes.add(byteData);
      });
      if (_imageCount == 3) {
        // uploadImages();
        setState(() {
          isEnabled = !isEnabled;
        });
      }
    });
  }

  Future<void> uploadImages() async {
    for (int i = 0; i < _bytes.length; i++) {
      Uint8List byteData = _bytes[i];
      String imageName = _imageNames[i];
      var fstorage = FirebaseStorage.instance.ref('sliderImages/$imageName');
      UploadTask uploadTask = fstorage.putBlob(
          byteData, SettableMetadata(contentType: 'image/jpg'));
      await uploadTask;
      uploadTask.then((p0) => {
            showDialog(
                context: context,
                builder: (context) => AlertDialog(
                      title: Text(" Uploaded "),
                    ))
          });
      String downloadUrl = await fstorage.getDownloadURL();
      debugPrint(downloadUrl);
    }
  }

  bool isEnabled = false;

  @override
  void initState() {
    getSliderImages();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(" Add Slider Images "),
      ),
      body: Column(
        children: [
          sliderImagesUrls!.isEmpty
              ? Center(
                  child: Text("No Slider Images "),
                )
              : Expanded(
                  flex: 4,
                  child: Padding(
                    padding: const EdgeInsets.only(
                        bottom: 24.0, top: 16, left: 5, right: 5),
                    child: sliderImagesUrls!.isEmpty
                        ? const Center(child: CircularProgressIndicator())
                        : ListView.builder(
                            itemCount: sliderImagesUrls!.length,
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, index) {
                              return Animate(
                                effects: const [
                                  FadeEffect(
                                      duration: Duration(milliseconds: 500)),
                                  ScaleEffect(
                                      duration: Duration(milliseconds: 500)),
                                ],
                                child: Container(
                                  height: 300,
                                  width: 400,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(19),
                                      border: Border.all(
                                          color: Colors.grey,
                                          width: 2,
                                          style: BorderStyle.solid,
                                          strokeAlign:
                                              BorderSide.strokeAlignOutside),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey
                                              .withOpacity(0.9), // Shadow color
                                          spreadRadius: -5, // Spread radius
                                          blurRadius: 16, // Blur radius
                                          offset: const Offset(0, 8), // Offset
                                        ),
                                      ]),
                                  margin: const EdgeInsets.all(12),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(20),
                                    child: Stack(
                                      children: [
                                        sliderImagesUrls![index].isEmpty
                                            ? const CircularProgressIndicator()
                                            : Image.network(
                                                sliderImagesUrls![index],
                                                height: double.infinity,
                                                fit: BoxFit.cover,
                                              ),
                                        Positioned(
                                          bottom: 5,
                                          right: 10,
                                          child: Expanded(
                                            child: Container(
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceAround,
                                                children: [
                                                  IconButton(
                                                    style: ButtonStyle(
                                                      backgroundColor:
                                                          const MaterialStatePropertyAll(
                                                        Colors.white,
                                                      ),
                                                      shape:
                                                          MaterialStatePropertyAll(
                                                        RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(10),
                                                        ),
                                                      ),
                                                    ),
                                                    onPressed: () {
                                                      String filename =
                                                          sliderImagesUrls![
                                                                  index]
                                                              .split("/")
                                                              .last
                                                              .split("%2F")
                                                              .last
                                                              .split("?")
                                                              .first
                                                              .replaceAll(
                                                                  "%20", " ");
                                                      updateImage(filename);
                                                    },
                                                    icon: const Icon(
                                                      Icons.edit,
                                                      color: Colors.black,
                                                      size: 24,
                                                    ),
                                                  ),
                                                  const SizedBox(width: 10),
                                                  IconButton(
                                                    style: ButtonStyle(
                                                      backgroundColor:
                                                          const MaterialStatePropertyAll(
                                                        Colors.white,
                                                      ),
                                                      shape:
                                                          MaterialStatePropertyAll(
                                                        RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(10),
                                                        ),
                                                      ),
                                                    ),
                                                    onPressed: () {
                                                      String filename =
                                                          sliderImagesUrls![
                                                                  index]
                                                              .split("/")
                                                              .last
                                                              .split("%2F")
                                                              .last
                                                              .split("?")
                                                              .first
                                                              .replaceAll(
                                                                  "%20", " ");
                                                      print(filename);

                                                      FirebaseStorage.instance
                                                          .ref()
                                                          .child(
                                                              'sliderImages/$filename')
                                                          .delete();

                                                      getSliderImages();
                                                    },
                                                    icon: const Icon(
                                                      Icons.delete,
                                                      color: Colors.black,
                                                      size: 24,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                  ),
                ),
          Expanded(
            flex: 4,
            child: Padding(
              padding: const EdgeInsets.only(
                  bottom: 24.0, top: 16, left: 5, right: 5),
              child: ListView.builder(
                itemCount: _bytes.length,
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  return Animate(
                    effects: const [
                      FadeEffect(duration: Duration(milliseconds: 500)),
                      ScaleEffect(duration: Duration(milliseconds: 500)),
                    ],
                    child: Container(
                      height: 300,
                      width: 400,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(19),
                          border: Border.all(
                              color: Colors.grey,
                              width: 2,
                              style: BorderStyle.solid,
                              strokeAlign: BorderSide.strokeAlignOutside),
                          boxShadow: [
                            BoxShadow(
                              color:
                                  Colors.grey.withOpacity(0.9), // Shadow color
                              spreadRadius: -5, // Spread radius
                              blurRadius: 16, // Blur radius
                              offset: const Offset(0, 12), // Offset
                            ),
                          ]),
                      margin: const EdgeInsets.all(12),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Stack(children: [
                          Image.memory(
                            _bytes[index],
                            height: double.infinity,
                            fit: BoxFit.cover,
                          ),
                          Positioned(
                            top: 0,
                            right: 0,
                            child: IconButton(
                              style: ButtonStyle(
                                backgroundColor: const MaterialStatePropertyAll(
                                  Colors.white,
                                ),
                                shape: MaterialStatePropertyAll(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                              ),
                              onPressed: () {
                                setState(() {
                                  setState(() {
                                    _bytes.removeAt(index);
                                    _imageFiles.removeAt(index);
                                    _imageNames.removeAt(index);
                                    _imageCount--;
                                    isEnabled = false;
                                  });
                                });
                              },
                              icon: const Icon(
                                Icons.close,
                                color: Colors.black,
                                size: 24,
                              ),
                            ),
                          )
                        ]),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  margin: const EdgeInsets.all(8),
                  width: 200,
                  child: ElevatedButton(
                    onPressed: _pickImage,
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.blue, // Text color
                      padding: const EdgeInsets.symmetric(
                          vertical: 16, horizontal: 24), // Button padding
                      shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(8)), // Button border
                    ),
                    child: const Text(
                      'Pick 3 Images ',
                      style: TextStyle(fontSize: 16), // Text style
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(8),
                  margin: const EdgeInsets.all(8),
                  width: 200,
                  child: ElevatedButton(
                    onPressed: isEnabled ? uploadImages : null,
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.blue, // Text color
                      padding: const EdgeInsets.symmetric(
                          vertical: 16, horizontal: 24), // Button padding
                      shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(8)), // Button border
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Icon(Icons.upload),
                        Text(
                          'Upload ',
                          style: TextStyle(
                            fontSize: 16,
                          ), // Text style
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Future<void> getSliderImages() async {
    List<String> imageUrls = [];

    // Get reference to the specific path in Firebase Storage
    Reference storageRef = FirebaseStorage.instance.ref().child('sliderImages');

    try {
      // List all items (images) under the specified path
      final result = await storageRef.listAll();

      // Iterate through the items and get download URLs
      await Future.forEach(result.items, (Reference ref) async {
        String downloadUrl = await ref.getDownloadURL();
        imageUrls.add(downloadUrl);
      });
    } catch (e) {
      print('Error fetching images: $e');
    }
    setState(() {
      sliderImagesUrls = imageUrls;
    });
    print(imageUrls);
  }

  Future<void> updateImage(String prevFilename) async {
    // Pick the new Image
    html.File newImageFile = await ImagePickerWeb.getImageAsFile() as File;
    String newImageName = newImageFile.name;

    final reader = html.FileReader();
    reader.readAsDataUrl(newImageFile);
    reader.onLoadEnd.listen((event) {
      var tempByteData = const Base64Decoder()
          .convert(reader.result.toString().split(",").last);
      // Upload the new image data
      uploadImage(prevFilename, newImageName, tempByteData);
    });
  }

  Future<void> uploadImage(
      String prevFilename, String newImageName, Uint8List newByteData) async {
    // Delete the previous image
    var prevImageRef =
        FirebaseStorage.instance.ref('sliderImages/$prevFilename');
    await prevImageRef.delete();

    // Upload the new image
    var fstorage = FirebaseStorage.instance.ref('sliderImages/$newImageName');
    UploadTask uploadTask = fstorage.putBlob(
        newByteData, SettableMetadata(contentType: 'image/jpg'));

    // Wait for the upload to complete
    await uploadTask;

    // Handle success or failure
    if (uploadTask.snapshot.state == TaskState.success) {
      // Image uploaded successfully
      // showDialog(
      //   context: context,
      //   builder: (context) => AlertDialog(
      //     title: Text("Image Updated"),
      //   ),
      // );
      getSliderImages();
    } else {
      // Image upload failed
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("Image Update Failed"),
        ),
      );
    }
  }
}
