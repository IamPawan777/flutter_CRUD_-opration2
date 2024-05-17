import 'package:crud_operation2/component/botton_icon.dart';
import 'package:crud_operation2/utility/utiles.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
 
  final emailController = TextEditingController();
  final auth = FirebaseAuth.instance;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber,
        title: Text('Forgot Password', style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            SizedBox(height: 50,),
            
            TextFormField(
              controller: emailController,
              decoration: InputDecoration(
                hintText: 'Email',
              ),
            ),
            
            SizedBox(height: 30,),

            RoundButton(title: 'forgot', onTap: (){
              auth.sendPasswordResetEmail(email: emailController.text.toString()).then((value) {
                Utils().toastMessage('Sent email to recover password, please check email');
              }).onError((error, stackTrace) {
                Utils().toastMessage(error.toString());
              });
            })
            
          ],
        ),
      ),
    );
  }
}