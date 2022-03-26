import 'package:admin_panel_vyam/Screens//login_page.dart';
import 'package:admin_panel_vyam/sidebarnav.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyCda5p31iGswCodulgMqLELDARSg21NRR4",
      appId: "1:307925634075:android:538a578d411d2af008fcbe",
      messagingSenderId:
          "307925634075-eor486qatoohnsg2hlcc0ehe55v6b77r.apps.googleusercontent.com",
      projectId: "vyam-f99ab",
    ),
  );
  runApp(const HomePage());
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Vyam Admin Panel',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
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
