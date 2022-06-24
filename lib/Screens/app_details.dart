import 'package:admin_panel_vyam/Screens/add_app_details.dart';
import 'package:admin_panel_vyam/services/CustomTextFieldClass.dart';
import 'package:admin_panel_vyam/services/deleteMethod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:markdown_editable_textinput/format_markdown.dart';
import 'package:markdown_editable_textinput/markdown_text_input.dart';

class appDetails extends StatefulWidget {
  const appDetails({Key? key}) : super(key: key);

  @override
  State<appDetails> createState() => _appDetailsState();
}

class _appDetailsState extends State<appDetails> {
  CollectionReference? appdetailStream;
  @override
  void initState() {
    appdetailStream = FirebaseFirestore.instance.collection('app_details');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("App Details"),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 10.0,
          ),
          StreamBuilder<DocumentSnapshot>(
            stream: appdetailStream!.doc('contact_us').snapshots(),
            builder: (context, AsyncSnapshot snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              }
              if (snapshot.data == null) {
                return Container();
              }
              String aemail = snapshot.data.get('email').toString();
              return Column(
                children: [
                  TextButton(
                      child: Container(
                        color: Colors.white54,
                        padding: EdgeInsets.only(right: 200),
                        child: Text(
                          "Contact",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 25.0,
                          ),
                        ),
                      ),
                      onPressed: () {
                        // print(snapshot.data['email']);
                        Get.to(
                          () => ContactUs(
                            email: snapshot.data.get('email').toString(),
                            instaId: snapshot.data['instaId'].toString(),
                            phonenumber:
                                snapshot.data['phonenumber'].toString(),
                            website: snapshot.data['website'].toString(),
                          ),
                        );
                      })
                ],
              );
            },
          ),
          const SizedBox(
            height: 70,
          ),
          StreamBuilder<DocumentSnapshot>(
            stream: appdetailStream!.doc('about_us').snapshots(),
            builder: (context, AsyncSnapshot snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              }
              if (snapshot.data == null) {
                return Container();
              }
              return Column(
                children: [
                  TextButton(
                      child: Container(
                        color: Colors.white54,
                        padding: EdgeInsets.only(right: 200),
                        child: Text(
                          "About",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 25.0,
                          ),
                        ),
                      ),
                      onPressed: () {
                        // print(snapshot.data['email']);
                        Get.to(
                          () => AboutUs(
                            about: snapshot.data.get('about').toString(),
                          ),
                        );
                      })
                ],
              );
            },
          ),
          const SizedBox(
            height: 70,
          ),
          StreamBuilder<DocumentSnapshot>(
            stream: appdetailStream!.doc('t&c').snapshots(),
            builder: (context, AsyncSnapshot snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              }
              if (snapshot.data == null) {
                return Container();
              }
              return Column(
                children: [
                  TextButton(
                      child: Container(
                        color: Colors.white54,
                        padding: EdgeInsets.only(right: 200),
                        child: Text(
                          "Terms And Conditions",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 25.0,
                          ),
                        ),
                      ),
                      onPressed: () {
                        // print(snapshot.data['email']);
                        Get.to(
                          () => TandC(
                            tnc: snapshot.data.get('tnc').toString(),
                          ),
                        );
                      })
                ],
              );
            },
          ),
          const SizedBox(
            height: 70,
          ),
          StreamBuilder<DocumentSnapshot>(
            stream: appdetailStream!.doc('privacy_policy').snapshots(),
            builder: (context, AsyncSnapshot snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              }
              if (snapshot.data == null) {
                return Container();
              }
              return Column(
                children: [
                  TextButton(
                      child: Container(
                        color: Colors.white54,
                        padding: EdgeInsets.only(right: 200),
                        child: const Text(
                          "Policy Policy",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 25.0,
                          ),
                        ),
                      ),
                      onPressed: () {
                        // print(snapshot.data['email']);
                        Get.to(
                          () => PrivacyPolicy(
                            policy: snapshot.data.get('policy').toString(),
                          ),
                        );
                      })
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

//Contact Us
class ContactUs extends StatefulWidget {
  const ContactUs({
    required this.email,
    required this.instaId,
    required this.phonenumber,
    required this.website,
    Key? key,
  }) : super(key: key);

  final String email;
  final String instaId;
  final String phonenumber;
  final String website;

  @override
  State<ContactUs> createState() => _ContactUsState();
}

class _ContactUsState extends State<ContactUs> {
  final TextEditingController _email = TextEditingController();
  final TextEditingController _instaId = TextEditingController();
  final TextEditingController _phonenumber = TextEditingController();
  final TextEditingController _website = TextEditingController();
  CollectionReference? appdetailStream;

  @override
  void initState() {
    _email.text = widget.email;
    _instaId.text = widget.instaId;
    _phonenumber.text = widget.phonenumber;
    _website.text = widget.website;
    appdetailStream = FirebaseFirestore.instance.collection('app_details');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Contact Us"),
      ),
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 5),
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: StreamBuilder<QuerySnapshot>(
            stream: appdetailStream!.snapshots(),
            builder: (context, AsyncSnapshot snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              }
              if (snapshot.data == null) {
                return Container();
              }
              return Container(
                child: Column(
                  children: [
                    customTextField(hinttext: "Email", addcontroller: _email),
                    customTextField(
                        hinttext: "Instagram User Name",
                        addcontroller: _instaId),
                    customTextField(
                        hinttext: "Phone Number", addcontroller: _phonenumber),
                    customTextField(
                        hinttext: "Website Link", addcontroller: _website),
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Center(
                        child: ElevatedButton(
                          onPressed: () async {
                            print("/////");
                            print('${widget.email}');

                            DocumentReference documentReference =
                                FirebaseFirestore.instance
                                    .collection('app_details')
                                    .doc('contact_us');
                            Map<String, dynamic> data = {
                              'email': _email.text,
                              'instaId': _instaId.text,
                              'phonenumber': _phonenumber.text,
                              'website': _website.text,
                            };
                            await FirebaseFirestore.instance
                                .collection('app_details')
                                .doc('contact_us')
                                .update(data);
                            print("after");
                            Navigator.pop(context);
                          },
                          child: const Text('Done'),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

//About Us
class AboutUs extends StatefulWidget {
  const AboutUs({required this.about, Key? key}) : super(key: key);
  final String about;

  @override
  State<AboutUs> createState() => _AboutUsState();
}

class _AboutUsState extends State<AboutUs> {
  TextEditingController controller = TextEditingController();
  List<MarkdownType> actions = const [
    MarkdownType.bold,
    MarkdownType.italic,
    MarkdownType.title,
    MarkdownType.link,
    MarkdownType.list
  ];
  String descriptionn = 'About Us';
  @override
  void initState() {
    controller.text = widget.about;
    descriptionn = widget.about;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("About Us"),
      ),
      body: Column(
        children: [
          Container(
            margin: EdgeInsets.all(8),
            child: MarkdownTextInput(
              (String value) => setState(() => descriptionn = value),
              descriptionn,
              label: 'Description',
              actions: actions,
              controller: controller,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Center(
              child: ElevatedButton(
                onPressed: () async {
                  print("/////");
                  print('${widget.about}');

                  DocumentReference documentReference = FirebaseFirestore
                      .instance
                      .collection('app_details')
                      .doc('about_us');
                  Map<String, dynamic> data = {
                    'about': descriptionn,
                  };
                  await FirebaseFirestore.instance
                      .collection('app_details')
                      .doc('about_us')
                      .update(data);
                  print("after");
                  Navigator.pop(context);
                },
                child: const Text('Done'),
              ),
            ),
          )
        ],
      ),
    );
  }
}

//T and C
class TandC extends StatefulWidget {
  TandC({required this.tnc, Key? key}) : super(key: key);
  String tnc;

  @override
  State<TandC> createState() => _TandC();
}

class _TandC extends State<TandC> {
  TextEditingController controller = TextEditingController();
  List<MarkdownType> actions = const [
    MarkdownType.bold,
    MarkdownType.italic,
    MarkdownType.title,
    MarkdownType.link,
    MarkdownType.list
  ];
  String descriptionn = 'Terms And Conditions';
  @override
  void initState() {
    controller.text = widget.tnc;
    descriptionn = widget.tnc;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Terms And Conditions"),
      ),
      body: Column(
        children: [
          Container(
            margin: EdgeInsets.all(8),
            child: MarkdownTextInput(
              (String value) => setState(() => descriptionn = value),
              descriptionn,
              label: 'Description',
              actions: actions,
              controller: controller,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Center(
              child: ElevatedButton(
                onPressed: () async {
                  print("/////");
                  print('${widget.tnc}');

                  DocumentReference documentReference = FirebaseFirestore
                      .instance
                      .collection('app_details')
                      .doc('t&c');
                  Map<String, dynamic> data = {
                    'tnc': descriptionn,
                  };
                  await FirebaseFirestore.instance
                      .collection('app_details')
                      .doc('t&c')
                      .update(data);
                  print("after");
                  Navigator.pop(context);
                },
                child: const Text('Done'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

//Privacy Policy
class PrivacyPolicy extends StatefulWidget {
  PrivacyPolicy({required this.policy, Key? key}) : super(key: key);

  String policy;

  @override
  State<PrivacyPolicy> createState() => _PrivacyPolicy();
}

class _PrivacyPolicy extends State<PrivacyPolicy> {
  TextEditingController controller = TextEditingController();
  List<MarkdownType> actions = const [
    MarkdownType.bold,
    MarkdownType.italic,
    MarkdownType.title,
    MarkdownType.link,
    MarkdownType.list
  ];
  String descriptionn = 'Privacy Policy';
  @override
  void initState() {
    controller.text = widget.policy;
    descriptionn = widget.policy;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Privacy Policy"),
      ),
      body: Column(
        children: [
          Container(
            margin: EdgeInsets.all(8),
            child: MarkdownTextInput(
              (String value) => setState(() => descriptionn = value),
              descriptionn,
              label: 'Description',
              actions: actions,
              controller: controller,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Center(
              child: ElevatedButton(
                onPressed: () async {
                  print("/////");
                  print('${widget.policy}');

                  DocumentReference documentReference = FirebaseFirestore
                      .instance
                      .collection('app_details')
                      .doc('privacy_policy');
                  Map<String, dynamic> data = {
                    'policy': descriptionn,
                  };
                  await FirebaseFirestore.instance
                      .collection('app_details')
                      .doc('privacy_policy')
                      .update(data);
                  print("after");
                  Navigator.pop(context);
                },
                child: const Text('Done'),
              ),
            ),
          )
        ],
      ),
    );
  }
}
