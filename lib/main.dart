import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:pidgy_talk/views/screens/splash_screen.dart';
import 'firebase_options.dart';



void main() async{
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  try {
    FirebaseApp app = await Firebase.initializeApp();
    print('✅ Firebase initialized successfully: ${app.name}');
  } catch (e) {
    print('❌ Firebase failed to initialize: $e');
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pidgy Talk',
      theme: ThemeData(primaryColorLight: Colors.grey),
      home: const SplashScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

