import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_gen/gen_l10n/main.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:my_bank/MyHomePage.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class SendMoneyToPhone extends StatefulWidget {
  SendMoneyToPhone({Key? key, required this.index}) : super(key: key);
  int index;

  @override
  State<SendMoneyToPhone> createState() => _SendMoneyToPhoneState();
}

class _SendMoneyToPhoneState extends State<SendMoneyToPhone> {
  final emailController = TextEditingController();
  final amount = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'lib/img/phone.jpg',
                  height: MediaQuery.of(context).size.height / 3,
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  padding: EdgeInsets.only(
                    left: 30,
                    right: 30,
                  ),
                  height: 80,
                  child: TextFormField(
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
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.next,
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  padding: EdgeInsets.only(
                    left: 30,
                    right: 30,
                  ),
                  height: 80,
                  child: TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'can\'t be empty';
                      }
                    },
                    controller: amount,
                    decoration: InputDecoration(
                      hintText: '999',
                      labelText: AppLocalizations.of(context)!.amount,
                      prefixIcon: Icon(Icons.money),
                      suffixIcon: amount.text.isEmpty
                          ? Container(
                              width: 0,
                            )
                          : IconButton(
                              onPressed: () {
                                amount.clear();
                              },
                              icon: Icon(Icons.close),
                            ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.next,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    sendMoney();
                  },
                  child: Text(
                    AppLocalizations.of(context)!.send,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void check() {
    FocusScope.of(context).unfocus();
    final databaseReference = FirebaseFirestore.instance;
    databaseReference
        .collectionGroup('Cards')
        .where("card_number", isEqualTo: widget.index.toString())
        .get()
        .then((qSnap) {
      if ((double.parse(qSnap.docs[0]['balance']) -
              double.parse(amount.text)) >=
          0) {
        qSnap.docs[0].reference.update({
          'balance': (double.parse(qSnap.docs[0]['balance']) -
                  double.parse(amount.text))
              .toString()
        });
        var now = DateTime.now();
        var formatter = DateFormat('yyyy-MM-dd');
        String formattedDate = formatter.format(now);
        final _transactionsStream = FirebaseFirestore.instance
            .collection('Users')
            .doc(FirebaseAuth.instance.currentUser!.uid.toString())
            .collection('Cards')
            .doc(widget.index.toString())
            .collection('History')
            .add({
          'amount': amount.text,
          'receiver': emailController.text,
          'date': formattedDate,
        });
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) => MyHomePage(),
          ),
          (route) => false,
        );
      } else {
        Alert(
          context: context,
          title: AppLocalizations.of(context)!.alert,
          desc: AppLocalizations.of(context)!.unfound,
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
      }
    });
  }

  void sendMoney() async {
    if (emailController.text.length == 8) {
      check();
    } else {
      Alert(
        context: context,
        title: AppLocalizations.of(context)!.alert,
        desc: AppLocalizations.of(context)!.invalid,
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
    }
  }
}
