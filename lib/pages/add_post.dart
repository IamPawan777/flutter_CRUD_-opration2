import 'package:crud_operation2/component/botton_icon.dart';
import 'package:crud_operation2/utility/utiles.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class AddPostScreen extends StatefulWidget {
  const AddPostScreen({super.key});

  @override
  State<AddPostScreen> createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  
  final postController = TextEditingController();
  bool loading = false;
  final databaseRef = FirebaseDatabase.instance.ref('Student');        // create database.. name 'Employee'


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      backgroundColor: Colors.black54,
        title: const Text("Add Post", style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          children: [
            SizedBox(height: 40,),
            TextFormField(
              maxLines: 5,
              controller: postController,                     //  controller
              decoration: const InputDecoration(
                hintText: 'What is in your mind?',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 40,),

            RoundButton(title: 'Add', 
              loading: loading,
              onTap: (){
                setState(() {
                  loading = true;
                });

              String idd = DateTime.now().millisecondsSinceEpoch.toString();

              databaseRef.child(idd).set({           // table. add data
                // 'id': 'pawanbisht',
                'id': idd,                       // **column...add data from text field....as a key-value
                'name': postController.text.toString(),        
              }).then((value){                   //future function i.e completed or not
                Utils().toastMessage('Post added');
                setState(() {
                  loading = false;
                });
              }).onError((error, stackTrace) {            // error catch
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