import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
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
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const HomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pidgy Talk'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'Welcome to Pidgy Talk!',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
