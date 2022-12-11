import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_gen/gen_l10n/main.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:my_bank/addCard.dart';
import 'package:my_bank/main.dart';
import 'package:my_bank/sendMoney.dart';
import 'package:my_bank/sendMoneyToPhone.dart';
import 'package:my_bank/settings.dart' as Settings;
import 'package:my_bank/statistics.dart';
import 'package:my_bank/transactions.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import 'bigButtons.dart';
import 'buttons.dart';
import 'card.dart';
import 'classes/account.dart';
import 'classes/language.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String userName = "oussema";
  int i = 0;
  final _PageIndicatorController = PageController();

  final databaseReference = FirebaseFirestore.instance;
  final Stream<QuerySnapshot> _cardsStream = FirebaseFirestore.instance
      .collection('Users')
      .doc(FirebaseAuth.instance.currentUser!.uid.toString())
      .collection('Cards')
      .snapshots();
  int cardNumbers = 1;
  int index = 0;
  // var x = StreamBuilder(
  //   stream: FirebaseFirestore.instance
  //       .collection('Users')
  //       .doc(FirebaseAuth.instance.currentUser!.uid.toString())
  //       .collection('Cards')
  //       .snapshots(),
  //   builder: (context, snapshot) {
  //     if (snapshot.hasData) {
  //       return Container();
  //     } else {
  //       return = snapshot.data!.docs.length;
  //     }
  //   },
  // );
  @override
  Widget build(BuildContext context) {
    _onPageViewChange(int page) {
      print("Current Page: " + page.toString());
    }

    return Scaffold(
      // appBar: AppBar(
      //   backgroundColor: Colors.white,
      //   shadowColor: Colors.white,
      //   title: Text(
      //     AppLocalizations.of(context)!.helloMsg(userName),
      //     style: TextStyle(color: Colors.black),
      //   ),
      //   titleSpacing: 10,
      //   actions: <Widget>[
      //   ],
      // ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: Icon(
          Icons.monetization_on,
          size: 32,
        ),
        backgroundColor: Colors.pink,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        color: Colors.grey.shade200,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                onPressed: () {},
                icon: Icon(
                  Icons.home,
                  size: 32,
                ),
              ),
              IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => (Settings.Settings()),
                    ),
                  );
                },
                icon: Icon(
                  Icons.settings,
                  size: 32,
                ),
              ),
            ],
          ),
        ),
      ),
      backgroundColor: Colors.grey.shade300,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Text(
                      AppLocalizations.of(context)!.helloMsg(userName),
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 23,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 0),
                    child: DropdownButton<Language>(
                      underline: const SizedBox(),
                      icon: const Icon(
                        Icons.language,
                        color: Colors.black,
                        size: 30,
                      ),
                      isDense: true,
                      onChanged: (Language? language) async {
                        if (language != null) {
                          //Locale _locale = await setLocale(language.languageCode);
                          MyApp.setLocale(
                              context, Locale(language.languageCode, ''));
                        }
                      },
                      items: Language.languageList()
                          .map<DropdownMenuItem<Language>>(
                            (e) => DropdownMenuItem<Language>(
                              value: e,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: <Widget>[
                                  Text(
                                    e.flag,
                                    style: const TextStyle(fontSize: 30),
                                  ),
                                  Text(e.name)
                                ],
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 0),
                    child: DropdownButton<Account>(
                      underline: const SizedBox(),
                      icon: const Icon(
                        Icons.add,
                        color: Colors.black,
                        size: 30,
                      ),
                      isDense: true,
                      onChanged: (Account? account) async {
                        if (account != null) {
                          if (account.type == 'e-dinar') {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) {
                                  return const AddCard();
                                },
                              ),
                            );
                          } else if (account.type == 'smart') {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) {
                                  return const AddCard();
                                },
                              ),
                            );
                          }
                        }
                      },
                      items: Account.accountList()
                          .map<DropdownMenuItem<Account>>(
                            (e) => DropdownMenuItem<Account>(
                              value: e,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: <Widget>[Text(e.type)],
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),

              Container(
                height: MediaQuery.of(context).size.height / 3.6,
                child: StreamBuilder<QuerySnapshot>(
                  stream: _cardsStream,
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasError) {
                      return Text('Something went wrong');
                    }

                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Text("Loading");
                    }
                    cardNumbers = snapshot.data!.docs.length;

                    return PageView(
                      controller: _PageIndicatorController,
                      onPageChanged: (int page) {
                        index =
                            int.parse(snapshot.data!.docs[page]['card_number']);
                      },
                      scrollDirection: Axis.horizontal,
                      children:
                          snapshot.data!.docs.map((DocumentSnapshot document) {
                        Map<String, dynamic> data =
                            document.data()! as Map<String, dynamic>;
                        if (i > 3) {
                          i = 1;
                        } else {
                          i++;
                        }
                        if (index == 0) {
                          index = int.parse(data['card_number']);
                        }
                        return
                            ///////////////////////////////////////:
                            ///
                            ///

                            cardWidget(
                          balance: double.parse(
                              double.parse(data['balance']).toStringAsFixed(3)),
                          expDate: data['card validation'],
                          lastThreeCardNumbers: int.parse(data['card_number']
                              .substring(data['card_number'].length - 3)),
                          imgId: i,
                          balanceText: AppLocalizations.of(context)!.balance,
                        );
                      }).toList(),
                    );
                  },
                ),
              ),
              //indicator
              SizedBox(
                height: 20,
              ),
              SmoothPageIndicator(
                controller: _PageIndicatorController,
                count: cardNumbers,
                effect: ExpandingDotsEffect(
                  activeDotColor: Colors.grey.shade800,
                  dotHeight: 10,
                  dotWidth: 10,
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Buttons(
                    fct: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return SendMoney(index: index);
                          },
                        ),
                      );
                    },
                    imgPath: 'lib/img/send.png',
                    textData: AppLocalizations.of(context)!.send,
                  ),
                  Buttons(
                    fct: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return SendMoneyToPhone(index: index);
                          },
                        ),
                      );
                    },
                    imgPath: 'lib/img/online-transfer.png',
                    textData: AppLocalizations.of(context)!.send,
                  ),
                  Buttons(
                    fct: () {
                      print('button 3 pressed');
                    },
                    imgPath: 'lib/img/bill.png',
                    textData: AppLocalizations.of(context)!.bill,
                  ),
                ],
              ),
              //transaction & statistics
              SizedBox(
                height: 15,
              ),
              BigButtons(
                imgPath: 'lib/img/statistic.png',
                mainText: AppLocalizations.of(context)!.statistics,
                secondText: AppLocalizations.of(context)!.statisticsText,
                fct: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return Statistics(index: index);
                      },
                    ),
                  );
                },
              ),
              SizedBox(
                height: 10,
              ),
              BigButtons(
                imgPath: 'lib/img/transaction.png',
                mainText: AppLocalizations.of(context)!.transactions,
                secondText: AppLocalizations.of(context)!.transactionsText,
                fct: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return Transactions(
                          index: index,
                        );
                      },
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
