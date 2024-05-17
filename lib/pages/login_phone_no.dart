import 'package:crud_operation2/component/botton_icon.dart';
import 'package:crud_operation2/pages/verify_code.dart';
import 'package:crud_operation2/utility/utiles.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginWithPhoneNo extends StatefulWidget {
  const LoginWithPhoneNo({super.key});

  @override
  State<LoginWithPhoneNo> createState() => _LoginWithPhoneNoState();
}

class _LoginWithPhoneNoState extends State<LoginWithPhoneNo> {

  bool loading = false;
  final phoneNoController = TextEditingController();
  final auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

        // automaticallyImplyLeading: false,       //back arrow
        centerTitle: true,
        backgroundColor: Colors.black12,
        title: (const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Log",
              style: TextStyle(
                  color: Colors.red, fontSize: 25, fontWeight: FontWeight.bold),
            ),
            Text(
              "In",
              style: TextStyle(
                  color: Colors.blue,
                  fontSize: 25,
                  fontWeight: FontWeight.bold),
            )
          ],
        )
        ),
      ),
      
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(height: 50,),
            
            TextFormField(
              controller: phoneNoController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: '+91 123 4567 123'
              ),
            ),
            SizedBox(height: 50,),
            
            RoundButton(title: 'Login', loading: loading, onTap: (){
              setState(() {
                loading = true;
              });

            auth.verifyPhoneNumber(
              phoneNumber: phoneNoController.text,
              verificationCompleted: (_){
                setState(() {
                  loading = false;
                });
              }, 
              verificationFailed: (e){
                setState(() {
                  loading = false;
                });
                Utils().toastMessage(e.toString());
              }, 
              codeSent: (String verificationId, int? token){
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return VerifyCodeScreen(verificationId: verificationId,);
                }
                ));
                setState(() {
                  loading = false;
                });
              }, 
              codeAutoRetrievalTimeout: (e){
                Utils().toastMessage(e.toString());
                setState(() {
                  loading = false;
                });
              }
            );
            })



          ],
        ),
      ),
    );
  }
}