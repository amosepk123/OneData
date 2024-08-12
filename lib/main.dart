import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:responsive_framework/responsive_wrapper.dart';
import 'Login/Wrapper.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: FirebaseOptions(
        apiKey: "AIzaSyD-2QqAZh3-m_7RxbVkuZd9EtS7Lp0ZpGw",
        messagingSenderId: "919424416673",
        projectId: "fir-1d22f",
        appId: "1:919424416673:web:23860aa6a075ddccf8a9e0",
      )
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'OneData',
      debugShowCheckedModeBanner: false,
      home: Wrapper(),
      builder: (context, child) => ResponsiveWrapper.builder(
        EasyLoading.init()(context, child),
        maxWidth: 1200,
        minWidth: 480,
        defaultScale: true,
        breakpoints: [
          ResponsiveBreakpoint.resize(480, name: MOBILE),
          ResponsiveBreakpoint.autoScale(800, name: TABLET),
          ResponsiveBreakpoint.resize(1000, name: DESKTOP),
        ],
        background: Container(color: Color(0xFFF5F5F5)),
      ),
      initialRoute: "/",
    );
  }
}

