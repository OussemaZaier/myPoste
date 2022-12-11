import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_gen/gen_l10n/main.dart';
import 'package:month_year_picker/month_year_picker.dart';
import 'package:intl/intl.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

import 'MyHomePage.dart';

class AddCard extends StatefulWidget {
  const AddCard({Key? key}) : super(key: key);

  @override
  State<AddCard> createState() => _AddCardState();
}

class _AddCardState extends State<AddCard> {
  final cardNumber = TextEditingController();
  final cardValidation = TextEditingController();
  final cardCVC = TextEditingController();
  final cardID = TextEditingController();
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
                  AppLocalizations.of(context)!.add,
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
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'can\'t be empty';
                          }
                        },
                        controller: cardValidation,
                        readOnly: true,
                        decoration: InputDecoration(
                          hintText: '09/00',
                          labelText: AppLocalizations.of(context)!.exp,
                          suffixIcon: Icon(
                            Icons.event,
                            size: 35,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        onTap: () async {
                          final dateChoosed = await showMonthYearPicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(2022),
                            lastDate: DateTime(2200),
                          );
                          if (dateChoosed != null) {
                            cardValidation.text = DateFormat('MM/yyyy')
                                .format(dateChoosed)
                                .toString();
                          }
                        },
                      ),
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    Expanded(
                      child: TextFormField(
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'can\'t be empty';
                          }
                        },
                        controller: cardCVC,
                        decoration: InputDecoration(
                          hintText: '999',
                          labelText: AppLocalizations.of(context)!.cvc,
                          suffixIcon: Icon(
                            Icons.info,
                            size: 35,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        keyboardType: TextInputType.number,
                        textInputAction: TextInputAction.next,
                      ),
                    ),
                  ],
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
                  controller: cardID,
                  decoration: InputDecoration(
                    hintText: '99999999',
                    labelText: AppLocalizations.of(context)!.cin,
                    suffixIcon: Icon(
                      Icons.perm_identity,
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
                  onPressed: addCardToBD,
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(15),
                    child: Center(
                      child: Text(
                        AppLocalizations.of(context)!.add,
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

  void addCardToBD() async {
    if (cardNumber.text.isEmpty ||
        cardValidation.text.isEmpty ||
        cardCVC.text.isEmpty ||
        cardID.text.isEmpty) {
      Alert(
        context: context,
        title: AppLocalizations.of(context)!.alert,
        desc: AppLocalizations.of(context)!.nullfield,
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
      FocusScope.of(context).unfocus();
      final FirebaseAuth auth = FirebaseAuth.instance;
      final databaseReference = FirebaseFirestore.instance;
      final User? user = auth.currentUser;
      databaseReference
          .collection('Users')
          .doc(user!.uid.toString())
          .get()
          .then((DocumentSnapshot documentSnapshot) {
        if (documentSnapshot.exists) {
          print('Document data: ${documentSnapshot.data()}');
          databaseReference
              .collection('Users')
              .doc(user.uid.toString())
              .collection('Cards')
              .doc(cardNumber.text)
              .set({
            'card_number': cardNumber.text,
            'card validation': cardValidation.text,
            'card CVC': cardCVC.text,
            'card id': cardID.text,
            'balance': (Random().nextDouble() * 256).toStringAsFixed(3),
          }).then((value) {
            Alert(
              context: context,
              title: AppLocalizations.of(context)!.add,
              desc: AppLocalizations.of(context)!.added,
              image: Icon(
                Icons.check,
                color: Colors.green,
                size: 50,
              ),
              buttons: [
                DialogButton(
                  onPressed: () {
                    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
                      builder: (BuildContext context) {
                        return MyHomePage();
                      },
                    ), (route) => false);
                  },
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
          }).catchError((error) {
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
          });
          ;
        } else {
          print('Document does not exist on the database');
        }
      });
    }
  }
}
