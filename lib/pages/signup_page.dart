import 'package:crud_operation2/component/botton_icon.dart';
import 'package:crud_operation2/pages/login_page.dart';
import 'package:crud_operation2/utility/utiles.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<SignUpPage> {
  
  bool loading = false;

  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;      //0000000000

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black12,
        title: (const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Sign",
              style: TextStyle(
                  color: Colors.red, fontSize: 25, fontWeight: FontWeight.bold),
            ),
            Text(
              "Up",
              style: TextStyle(
                  color: Colors.blue,
                  fontSize: 25,
                  fontWeight: FontWeight.bold),
            )
          ],
        )),
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
                  return 'Enter email';
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
                  return 'Enter password';
                }
                return null;
              },
            ),
            const SizedBox(height: 50,)
                  ],
                )
            ),

            
            RoundButton(
              title: 'Sign Up',
              loading: loading,
              onTap: (){
                if(_formKey.currentState!.validate()){
                 signUp();
                }
              },
            ),

            const SizedBox(height: 10,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Already have an account?"),    

                TextButton(onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute( builder: (context) {
                    return const LoginPage();
                  },)
                  );
                }, 
                child: const Text('Login'))

              ],
            )

          ],
        ),
      ),
    );
  }


  
  void signUp() {
     setState(() {                // circular loading process
        loading= true;
      });
      _auth.createUserWithEmailAndPassword(
        email: emailController.text.toString(), 
        password: passwordController.text.toString()
      ).then((value) {
      setState(() {
        loading= false;
      });
      }).onError((error, stackTrace) {                  // catch error and show
        Utils().toastMessage(error.toString());
        setState(() {
        loading= false;
      });
      });
  }

}
