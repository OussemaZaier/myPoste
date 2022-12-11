import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class Transaction extends StatelessWidget {
  final String amount;
  final String receiver;
  final String date;
  Transaction(
      {Key? key,
      required this.amount,
      required this.receiver,
      required this.date})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 30, left: 30, right: 30),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(5.0),
        child: Container(
          height: 100.0,
          width: double.infinity,
          margin:
              const EdgeInsets.only(bottom: 6.0), //Same as `blurRadius` i guess
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15.0),
            color: Color.fromARGB(100, 0, 8, 193),
            boxShadow: [
              BoxShadow(
                color: Colors.grey,
                offset: Offset(0.0, 1.0), //(x,y)
                blurRadius: 6.0,
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    receiver,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 25,
                    ),
                  ),
                  Text(
                    date,
                    style: TextStyle(
                      color: Color.fromRGBO(255, 255, 255, 120),
                      fontWeight: FontWeight.w300,
                      fontSize: 20,
                    ),
                  )
                ],
              ),
              Text(
                '$amount \$',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
