import 'package:firebase_auth/firebase_auth.dart'; // استيراد مكتبة Firebase Auth
import 'package:firebase_core/firebase_core.dart'; // استيراد مكتبة Firebase Core
import 'package:flutter/material.dart'; // استيراد مكتبة Flutter Material
import 'package:nnoteboke/costmertextfiled.dart'; // استيراد ملف costmertextfiled.dart
import 'Homepage.dart'; // استيراد صفحة الصفحة الرئيسية
import 'auth/login.dart'; // استيراد ملف تسجيل الدخول
import 'auth/register.dart'; // استيراد ملف التسجيل

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // التأكد من تهيئة Flutter

  await Firebase.initializeApp(); // تهيئة Firebase

  runApp(MyApp()); // تشغيل التطبيق
}

class MyApp extends StatefulWidget {
  MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: (light) // إعداد سمة التطبيق بناءً على الوضع النهاري أو الليلي
          ?  ThemeData(
          appBarTheme: AppBarTheme(
              elevation: 2,
              shadowColor: Colors.purple[600],
              color: Colors.white,
              iconTheme: IconThemeData(color: Colors.purple)))
          : ThemeData(
          appBarTheme: AppBarTheme(
              elevation: 2,
              shadowColor: Colors.black,
              color: Colors.grey[600],
              iconTheme: IconThemeData(color: Colors.white))),
      home: (FirebaseAuth.instance.currentUser != null &&
          FirebaseAuth.instance.currentUser!.emailVerified)
          ? Homepage() // إذا كان المستخدم مسجَّل الدخول وقام بتأكيد بريده الإلكتروني، اعرض صفحة الصفحة الرئيسية
          : login(), // في حالة أخرى، اعرض صفحة تسجيل الدخول
      routes: {
        'register': (context) => regiser(), // تحديد مسار لصفحة التسجيل
        'login': (context) => login(), // تحديد مسار لصفحة تسجيل الدخول
        'homepage': (context) => Homepage(), // تحديد مسار لصفحة الصفحة الرئيسية
      },
    );
  }
}
