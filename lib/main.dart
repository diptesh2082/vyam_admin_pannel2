import 'package:admin_panel_vyam/Screens//login_page.dart';
import 'package:admin_panel_vyam/sidebarnav.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
        apiKey: "AIzaSyD-lbw_9Rs2jniKN2iVZ1zhh_9dtFvN7IM",
        authDomain: "vyam-f99ab.firebaseapp.com",
        projectId: "vyam-f99ab_AAs",
        storageBucket: "vyam-f99ab.appspot.com",
        messagingSenderId: "307925634075",
        appId: "1:307925634075:web:a895e0e16b2db1ae08fcbe",
        measurementId: "G-N5WNBKEP64"),
  );
  runApp(const HomePage());
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      scrollBehavior: const MaterialScrollBehavior().copyWith(
        dragDevices: {
          PointerDeviceKind.mouse,
          PointerDeviceKind.touch,
          PointerDeviceKind.stylus,
          PointerDeviceKind.unknown
        },
      ),
      title: 'Vyam Admin Panel',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.purple,
        fontFamily: 'Poppins',
      ),
      home: const MainPage(),
    );
  }
}

class MainPage extends StatelessWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return const SideNavBar1();
          } else {
            return const LoginPage();
          }
        },
      ),
    );
  }
}
