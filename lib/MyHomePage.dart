import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_gen/gen_l10n/main.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:my_bank/main.dart';
import 'package:my_bank/settings.dart';
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
  int cardNumbers = 2;
  final _PageIndicatorController = PageController();
  @override
  Widget build(BuildContext context) {
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
                      builder: (context) => const Settings(),
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
                          //Locale _locale = await setLocale(language.languageCode);
                          // MyApp.setLocale(context, Locale(account., ''));
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
                child: PageView(
                  controller: _PageIndicatorController,
                  scrollDirection: Axis.horizontal,
                  children: [
                    cardWidget(
                      balance: 123,
                      expMonth: 10,
                      expYear: 24,
                      lastThreeCardNumbers: 534,
                      imgId: 1,
                      balanceText: AppLocalizations.of(context)!.balance,
                    ),
                    cardWidget(
                      balance: 8900,
                      expMonth: 09,
                      expYear: 23,
                      lastThreeCardNumbers: 987,
                      imgId: 2,
                      balanceText: AppLocalizations.of(context)!.balance,
                    ),
                  ],
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
                      print('button 1 pressed');
                    },
                    imgPath: 'lib/img/send.png',
                    textData: AppLocalizations.of(context)!.send,
                  ),
                  Buttons(
                    fct: () {
                      print('button 2 pressed');
                    },
                    imgPath: 'lib/img/send.png',
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
                  print('statistics clicked');
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
                  print('transaction clicked');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
