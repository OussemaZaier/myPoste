import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_gen/gen_l10n/main.dart';
import 'package:my_bank/MyHomePage.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
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
    return SafeArea(
      child: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 15),
            child: Column(
              children: [
                SvgPicture.asset(
                  'lib/img/login.svg',
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
                  child: Text(AppLocalizations.of(context)!.login),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future SignInMethod() async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
    } on FirebaseAuthException catch (e) {
      print(e);
    }

    // Navigator.push(
    //   context,
    //   MaterialPageRoute(
    //     builder: (context) => const MyHomePage(),
    //   ),
    // );
  }
}
