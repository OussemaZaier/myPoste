import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:intl/intl.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/main.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

import 'MyHomePage.dart';

class SendMoney extends StatefulWidget {
  SendMoney({Key? key, required this.index}) : super(key: key);
  int index;

  @override
  State<SendMoney> createState() => _SendMoneyState();
}

class _SendMoneyState extends State<SendMoney> {
  final cardNumber = TextEditingController();

  final amount = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppLocalizations.of(context)!.sendmon,
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Divider(
                  height: 20,
                  thickness: 2,
                ),
                SizedBox(
                  height: 15,
                ),
                TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'can\'t be empty';
                    }
                  },
                  controller: cardNumber,
                  decoration: InputDecoration(
                    hintText: '9999 9999 9999 9999',
                    labelText: AppLocalizations.of(context)!.cardNumber,
                    suffixIcon: Icon(
                      Icons.credit_card,
                      size: 35,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.next,
                ),
                SizedBox(
                  height: 15,
                ),
                SizedBox(
                  height: 15,
                ),
                TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'can\'t be empty';
                    }
                  },
                  controller: amount,
                  decoration: InputDecoration(
                    hintText: '99999999',
                    labelText: AppLocalizations.of(context)!.amount,
                    suffixIcon: Icon(
                      Icons.money,
                      size: 35,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.next,
                ),
                SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  onPressed: sendMoney,
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(15),
                    child: Center(
                      child: Text(
                        AppLocalizations.of(context)!.send,
                      ),
                    ),
                  ),
                  style: ButtonStyle(
                    elevation: MaterialStateProperty.all<double>(10),
                    shadowColor: MaterialStateProperty.all<Color>(Colors.blue),
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
        databaseReference
            .collectionGroup('Cards')
            .where("card_number", isEqualTo: cardNumber.text)
            .get()
            .then((qSnap) {
          qSnap.docs[0].reference.update({
            'balance': (double.parse(qSnap.docs[0]['balance']) +
                    double.parse(amount.text))
                .toString()
          });
        });
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
          'receiver': cardNumber.text,
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
    final databaseReference = FirebaseFirestore.instance;
    databaseReference
        .collectionGroup('Cards')
        .where("card_number", isEqualTo: cardNumber.text)
        .get()
        .then(
          ((qSnap) => {
                if (qSnap.docs.length != 0)
                  {check()}
                else
                  {
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
                    ).show()
                  }
              }),
          onError: (e) => print("Error completing: $e error********"),
        );
  }
}
