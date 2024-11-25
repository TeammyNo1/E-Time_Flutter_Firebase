import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart'; // สำหรับ kIsWeb
import 'screenuser/login_user.dart'; // นำเข้าหน้า Login
import 'screenuser/home_user.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (kIsWeb) {
    // สำหรับการใช้งานบนเว็บ
    await Firebase.initializeApp(
      options: FirebaseOptions(
        apiKey: "AIzaSyCyqzwausi7kA1QCK7dQtRkaNXqnbxltXM",
        authDomain: "project1-b5fb9.firebaseapp.com",
        projectId: "project1-b5fb9",
        storageBucket: "project1-b5fb9.firebasestorage.app",
        messagingSenderId: "672259303616",
        appId: "1:672259303616:web:6f06128d504b5af1f32525",
        measurementId: "G-3SB9MGL85Z",
      ),
    );
  } else {
    // สำหรับการใช้งานบน Android หรือ iOS
    await Firebase.initializeApp();
  }

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'E-Time',
      initialRoute: '/login_user', // เปลี่ยนเป็นหน้า Login ก่อน
      routes: {
        '/home': (context) => HomePage(), // Home page route
        '/login_user': (context) => LoginPage(), // Login page route
      },
      onUnknownRoute: (settings) {
        return MaterialPageRoute(builder: (context) => LoginPage());
      },
    );
  }
}
