import 'dart:convert';
import 'dart:developer';

import 'dart:html';

import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker_web/image_picker_web.dart';

import 'package:universal_html/html.dart' as html;

class AddSliderImages extends StatefulWidget {
  const AddSliderImages({super.key});

  @override
  State<AddSliderImages> createState() => _AddSliderImagesState();
}

class _AddSliderImagesState extends State<AddSliderImages> {
  Uint8List? _byte;
  html.File? _imageFile;
  String? _imageName;
  Future<void> _pickImage() async {
    html.File imageFile = await ImagePickerWeb.getImageAsFile() as File;
    if (imageFile != null) {
      setState(() {
        _imageFile = imageFile;
        _imageName = imageFile.name;
        log("${_imageName}");
      });
      loadImage();
    }
  }

  void loadImage() {
    final reader = html.FileReader();
    reader.readAsDataUrl(_imageFile!);
    reader.onLoadEnd.listen((event) {
      var _byteData = const Base64Decoder()
          .convert(reader.result.toString().split(",").last);
      setState(() {
        _byte = _byteData;
      });
      uploadImage();
    });
  }

  Future<void> uploadImage() async{
    var fstorage = FirebaseStorage.instance.ref('sliderImages/$_imageName');
     UploadTask uploadTask = fstorage.putBlob(_byte);
     await uploadTask;
     String durl = await fstorage.getDownloadURL();
     log(durl);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(" Add Slider Images "),
      ),
      body: Column(
        children: [
          _byte != null
              ? Container(
                height: 400,
                  child: Image.memory(
                    _byte!,
                    fit: BoxFit.cover,
                  ), 
                )
              : IconButton(
                  onPressed: _pickImage, icon: Icon(Icons.add_a_photo)),
          ElevatedButton(onPressed: _pickImage, child: Text(" Pick "))
        ],
      ),
    );
  }
}
