import 'package:crud_operation2/Firestore/home_page_firestore.dart';
import 'package:crud_operation2/pages/add_post.dart';
import 'package:crud_operation2/pages/home_page.dart';
import 'package:crud_operation2/pages/login_page.dart';
import 'package:crud_operation2/pages/upload_image.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CRUD 2',
      theme: ThemeData(
       
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const UploadImageScreen(),
    );
  }
}

