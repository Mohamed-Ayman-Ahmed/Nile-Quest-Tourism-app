import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class IntroPage1 extends StatelessWidget {
  const IntroPage1({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 100,
        ),
        Container(
          height: MediaQuery.of(context).size.height * 0.50,
          child:
              Lottie.asset('assets/lottie/intropage1.json', fit: BoxFit.fill),
        ),
        Column(
          children: [
            SizedBox(
              height: 30,
            ),
            Text(
              'Congratulations!',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 25,
                  fontFamily: 'Roboto',
                  letterSpacing: 1),
            ),
            SizedBox(
              height: 15,
            ),
            Text(
              'You just got a front-row ticket to',
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
            ),
            Text(
              'experience Egypt\'s most remarkable',
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
            ),
            Text(
              'spots like never before',
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
            ),
          ],
        ),
      ],
    );
  }
}
