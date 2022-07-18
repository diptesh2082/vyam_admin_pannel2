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
      apiKey: "AIzaSyB0bPGwnXX0G1ueIvMMz18VhjQZOVVVUps",
      authDomain: "vyam-2.firebaseapp.com",
      projectId: "vyam-2",
      storageBucket: "vyam-2.appspot.com",
      messagingSenderId: "649320715683",
      appId: "1:649320715683:web:4938b14e4ac5bfa8683616",
    ),
  );
  runApp(const HomePage());
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      // scrollBehavior: const MaterialScrollBehavior().copyWith(
      //   dragDevices: {
      //     PointerDeviceKind.mouse,
      //     PointerDeviceKind.touch,
      //     PointerDeviceKind.stylus,
      //     PointerDeviceKind.unknown
      //   },
      // ),
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
