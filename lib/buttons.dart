import 'package:flutter/material.dart';

class Buttons extends StatelessWidget {
  final String textData;
  final String imgPath;
  final VoidCallback fct;
  const Buttons({
    Key? key,
    required this.textData,
    required this.imgPath,
    required this.fct,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          child: Material(
            elevation: 10,
            borderRadius: BorderRadius.circular(20),
            child: Container(
              height: 60,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: Image.asset(imgPath),
                ),
              ),
            ),
          ),
          onTap: fct,
        ),
        SizedBox(
          height: 7,
        ),
        Text(
          textData,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.grey.shade800,
          ),
        )
      ],
    );
  }
}
