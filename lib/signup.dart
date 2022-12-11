import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_gen/gen_l10n/main.dart';
import 'package:my_bank/MyHomePage.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:firebase_core/firebase_core.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final passwordController = TextEditingController();
  bool visible = false;
  final emailController = TextEditingController();
  @override
  void initState() {
    super.initState();
    emailController.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 15),
              child: Column(
                children: [
                  SvgPicture.asset(
                    'lib/img/signup.svg',
                    height: MediaQuery.of(context).size.height / 4,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    'my Bank',
                    style: TextStyle(fontSize: 50),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  ///////////phone///////////
                  TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'can\'t be empty';
                      }
                    },
                    controller: emailController,
                    decoration: InputDecoration(
                      hintText: '99 999 999',
                      labelText: AppLocalizations.of(context)!.phone,
                      prefixIcon: Icon(Icons.phone),
                      suffixIcon: emailController.text.isEmpty
                          ? Container(
                              width: 0,
                            )
                          : IconButton(
                              onPressed: () {
                                emailController.clear();
                              },
                              icon: Icon(Icons.close),
                            ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  ///////////password///////////
                  TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'can\'t be null';
                      }
                      if (value.length < 6) {
                        return 'at least 6 caracters';
                      }
                    },
                    controller: passwordController,
                    obscureText: !visible,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      hintText: '******',
                      labelText: AppLocalizations.of(context)!.password,
                      prefixIcon: Icon(Icons.lock),
                      suffixIcon: visible
                          ? IconButton(
                              onPressed: () {
                                setState(() {
                                  visible = false;
                                });
                              },
                              icon: Icon(Icons.visibility))
                          : IconButton(
                              onPressed: () {
                                setState(() {
                                  visible = true;
                                });
                              },
                              icon: Icon(Icons.visibility_off)),
                    ),
                  ),
                  TextButton(
                    onPressed: SignInMethod,
                    child: Text(AppLocalizations.of(context)!.signup),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future SignInMethod() async {
    if (passwordController.text.isEmpty) {
      Alert(
        context: context,
        title: AppLocalizations.of(context)!.alert,
        desc: AppLocalizations.of(context)!.empty,
        image: Image.asset(
          "lib/img/delete.png",
          height: 100,
        ),
        buttons: [
          DialogButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              AppLocalizations.of(context)!.cancel,
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
              ),
            ),
          )
        ],
      ).show();
    } else {
      try {
        await Firebase.initializeApp();
        UserCredential user =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text,
          password: passwordController.text,
        );
        User? updateUser = FirebaseAuth.instance.currentUser;
        userSetup(emailController.text);
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
          builder: (BuildContext context) {
            return MyHomePage();
          },
        ), (route) => false);
      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          print('weak password');
        } else if (e.code == 'email-already-in-use') {
          print('email used');
        }
      } catch (e) {
        print(e.toString());
      }
    }
  }

  // Navigator.push(
  //   context,
  //   MaterialPageRoute(
  //     builder: (context) => const MyHomePage(),
  //   ),
  // );
}

Future<void> userSetup(String emailUser) async {
  CollectionReference users = FirebaseFirestore.instance.collection('Users');
  FirebaseAuth auth = FirebaseAuth.instance;
  String uid = auth.currentUser!.uid.toString();
  users.doc(uid).set({'email': emailUser, 'uid': uid});
  return;
}
