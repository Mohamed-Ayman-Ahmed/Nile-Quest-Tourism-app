import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class IntroPage2 extends StatelessWidget {
  const IntroPage2({super.key});

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
              Lottie.asset('assets/lottie/intropage2.json', fit: BoxFit.fill),
        ),
        Column(
          children: [
            SizedBox(
              height: 30,
            ),
            Text(
              'Live the Experience!',
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
              'Immerse yourself and get into any',
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
            ),
            Text(
              'experience with just one click on',
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
            ),
            Text(
              'any place!',
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
            ),
          ],
        ),
      ],
    );
  }
}
