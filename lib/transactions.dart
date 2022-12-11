import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:my_bank/card.dart';
import 'package:my_bank/transaction.dart' as tr;
import 'package:flutter_gen/gen_l10n/main.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

class Transactions extends StatefulWidget {
  Transactions({Key? key, required this.index}) : super(key: key);
  int index;
  @override
  State<Transactions> createState() => _TransactionsState();
}

class _TransactionsState extends State<Transactions> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    cardWidget cd;
    var controller = PageController(viewportFraction: 0.1);
    final _transactionsStream = FirebaseFirestore.instance
        .collection('Users')
        .doc(FirebaseAuth.instance.currentUser!.uid.toString())
        .collection('Cards')
        .doc(widget.index.toString())
        .collection('History')
        .snapshots();
    final databaseReference = FirebaseFirestore.instance;
    databaseReference
        .collectionGroup('Cards')
        .where("card_number", isEqualTo: widget.index.toString())
        .get()
        .then((qSnap) {
      cd = new cardWidget(
          balance: double.parse(qSnap.docs[0]['balance']),
          lastThreeCardNumbers: int.parse(qSnap.docs[0]['card_number']
              .substring(qSnap.docs[0]['card_number'].length - 3)),
          expDate: qSnap.docs[0]['card validation'],
          balanceText: AppLocalizations.of(context)!.balance,
          imgId: 1);
    });
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Container(
              height: MediaQuery.of(context).size.height - 50,
              child: StreamBuilder<QuerySnapshot>(
                stream: _transactionsStream,
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return Text('Something went wrong');
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Text("Loading");
                  }
                  return ListView(
                    scrollDirection: Axis.vertical,
                    children:
                        snapshot.data!.docs.map((DocumentSnapshot document) {
                      Map<String, dynamic> data =
                          document.data()! as Map<String, dynamic>;

                      return
                          ///////////////////////////////////////:
                          ///
                          ///

                          tr.Transaction(
                        amount: data['amount'],
                        receiver: data['receiver'],
                        date: data['date'],
                      );
                    }).toList(),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
