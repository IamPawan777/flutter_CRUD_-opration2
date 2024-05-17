import 'package:crud_operation2/component/botton_icon.dart';
import 'package:crud_operation2/pages/add_post.dart';
import 'package:crud_operation2/pages/home_page.dart';
import 'package:crud_operation2/utility/utiles.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class VerifyCodeScreen extends StatefulWidget {
  final String verificationId;
  const VerifyCodeScreen({super.key, required this.verificationId});

  @override
  State<VerifyCodeScreen> createState() => _VerifyCodeScreenState();
}

class _VerifyCodeScreenState extends State<VerifyCodeScreen> {

  bool loading = false;
  final VarificationCodeController = TextEditingController();
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
              "Veri",
              style: TextStyle(
                  color: Colors.red, fontSize: 25, fontWeight: FontWeight.bold),
            ),
            Text(
              "fy",
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
              controller: VarificationCodeController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: '6 digit code'
              ),
            ),
            SizedBox(height: 50,),
            
            RoundButton(title: 'Veify', loading: loading, onTap: () async {
              setState(() {
                loading = true;
              });
              final credential = PhoneAuthProvider.credential(
                verificationId: widget.verificationId, 
                smsCode: VarificationCodeController.text.toString()
              );

              try{
                await auth.signInWithCredential(credential);
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return HomePage();
                }));
              }catch(e){
                setState(() {
                  loading = false;
                });
              Utils().toastMessage(e.toString());
              }
            })



          ],
        ),
      ),
    );
  }
}