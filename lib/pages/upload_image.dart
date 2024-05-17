import 'dart:io';

import 'package:crud_operation2/component/botton_icon.dart';
import 'package:crud_operation2/utility/utiles.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class UploadImageScreen extends StatefulWidget {
  const UploadImageScreen({super.key});

  @override
  State<UploadImageScreen> createState() => _UploadImageScreenState();
}

class _UploadImageScreenState extends State<UploadImageScreen> {

  bool loading = false;
  File? _image;
  final picker = ImagePicker();             // pic image from gallary

  firebase_storage.FirebaseStorage storage = firebase_storage.FirebaseStorage.instance;
  DatabaseReference databaseRef = FirebaseDatabase.instance.ref('Post');

  Future getImageGallery() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery, imageQuality: 80);
    setState(() {
      if(pickedFile != null) {
        _image = File(pickedFile.path);
      }
      else {
        print('no image picked');
      }
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.limeAccent,
        title: Text('Upload Image', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),),
      ),

      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: InkWell(
                onTap: () {
                  getImageGallery();
                },
                child: Container(
                  height: 200,
                  width: 200,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black, width: 4)
                  ),
                  child: _image != null ? Image.file(_image!.absolute) :
                  Icon(Icons.image),
                ),
              ),
            ),
            SizedBox(height: 50,),
            RoundButton(title: 'Upload', loading: loading, onTap: ()async{
              
              setState(() {
                loading = true;
              });
              firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance.ref('/folderName'+'1224');
              firebase_storage.UploadTask uploadTask = ref.putFile(_image!.absolute);

              Future.value(uploadTask).then((value) {

                var newUrl = ref.getDownloadURL();
                databaseRef.child('1').set({
                  'id': '1221',
                  'title': newUrl.toString(),
                }).then((value) {
                  setState(() {
                    loading = false;
                  });
                  Utils().toastMessage('Uploaded');                
                }).onError((error, stackTrace) {
                  setState(() {
                    loading = false;
                  });
                  // Utils().toastMessage(error.toString());
                });              

              }).onError((error, stackTrace){
                Utils().toastMessage(error.toString());
                setState(() {
                    loading = false;
                });
              });
              

              

            })
          ],
        ),
      ),
    );
  }
}