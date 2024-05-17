import 'package:crud_operation2/Firestore/home_page_firestore.dart';
import 'package:crud_operation2/component/botton_icon.dart';
import 'package:crud_operation2/pages/forgot_password.dart';
import 'package:crud_operation2/pages/home_page.dart';
import 'package:crud_operation2/pages/login_phone_no.dart';
import 'package:crud_operation2/pages/signup_page.dart';
import 'package:crud_operation2/pages/upload_image.dart';
import 'package:crud_operation2/utility/utiles.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  
  bool loading = false;
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final _auth = FirebaseAuth.instance;

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }



  void login() {
    setState(() {
      loading = true;
    });
    _auth.signInWithEmailAndPassword(
      email: emailController.text, 
      password: passwordController.text.toString()).then((value) {
        Utils().toastMessage(value.user!.email.toString());
        
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          // return HomePage();
          return HomePageFireStore();
          // return UploadImageScreen();
          
        })
        ); 

      setState(() {
        loading = false;
      });

    }).onError((error, stackTrace) {
      debugPrint(error.toString());
        Utils().toastMessage(error.toString());
        
      setState(() {
        loading = false;
      });
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,       //back arrow
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
          // crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Form( 
              key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      controller: emailController,
                      decoration: const InputDecoration(
                      hintText: 'E-mail',
                // helperText: 'e.g. abc@gamail.com',
                prefixIcon: Icon(Icons.email_outlined)
              ),
              validator: (value) {
                if(value!.isEmpty){
                  return 'Please enter e-mail';
                }
                return null;
              },
            ),

            const SizedBox(height: 10,),
            TextFormField(
              keyboardType: TextInputType.text,
              controller: passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                hintText: 'Password',
                // helperText: 'e.g. Abc123',
                prefixIcon: Icon(Icons.lock_open_outlined)
              ),
              validator: (value) {
                if(value!.isEmpty){
                  return 'please enter password';
                }
                return null;
              },
            ),
            const SizedBox(height: 50,)
                  ],
                )
            ),
      
            
            RoundButton(
              title: 'Log In',
              loading: loading,
              onTap: (){
                if(_formKey.currentState!.validate()){
                  login();
                }
              },
            ),

            // SizedBox(height: 20,),

            Align(
              alignment: Alignment.bottomRight,
              child: TextButton(onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return ForgotPasswordPage();
                }));

              }, child: Text('Forget Password?')),
            ),
      
            SizedBox(height: 10,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Don't have an account?"),
                TextButton(onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return const SignUpPage();
                  },));
                }, 
                child: const Text('Sign up'))
              ],
            ),
      
            SizedBox(height: 50),
      
            InkWell(
              onTap:() {
                Navigator.push(context, MaterialPageRoute(builder: (context){
                  return LoginWithPhoneNo();
                }));
              },
              child: Container(
                height: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  border: Border.all(color: Colors.black,)
                ),
                child: const Center(child: 
                  Text("Login with mobile",)
                )
              ),
            ),
      
      
          ],
        ),
      ),
    );
  }
}
