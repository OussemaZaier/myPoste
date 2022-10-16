import 'package:flutter/material.dart';

class cardWidget extends StatelessWidget {
  final double balance;
  final int lastThreeCardNumbers;
  final int expMonth;
  final int expYear;
  final int imgId;
  final String balanceText;
  const cardWidget(
      {Key? key,
      required this.balance,
      required this.lastThreeCardNumbers,
      required this.expMonth,
      required this.expYear,
      required this.balanceText,
      required this.imgId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('lib/img/${imgId}.png'),
          fit: BoxFit.cover,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                height: 10,
              ),
              Text(
                balanceText,
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                '\$${balance}',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '*** *** **${lastThreeCardNumbers}',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    '${expMonth}/${expYear}',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ]),
      ),
    );
  }
}
