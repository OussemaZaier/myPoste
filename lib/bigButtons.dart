import 'package:flutter/material.dart';

class BigButtons extends StatelessWidget {
  final String imgPath;
  final String mainText;
  final String secondText;
  final VoidCallback fct;
  const BigButtons({
    Key? key,
    required this.imgPath,
    required this.mainText,
    required this.secondText,
    required this.fct,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: fct,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Image.asset(
                imgPath,
                width: 40,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    mainText,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    secondText,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: Colors.grey.shade800),
                  ),
                ],
              ),
              Icon(Icons.arrow_forward)
            ],
          ),
        ),
      ),
    );
  }
}
