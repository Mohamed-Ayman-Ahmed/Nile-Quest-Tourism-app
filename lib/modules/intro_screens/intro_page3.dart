import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class IntroPage3 extends StatelessWidget {
  const IntroPage3({super.key});

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
              Lottie.asset('assets/lottie/intropage3.json', fit: BoxFit.fill),
        ),
        Column(
          children: [
            SizedBox(
              height: 30,
            ),
            Text(
              'You are READY!',
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
              'Now you are all set and about to start an',
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
            ),
            Text(
              'unforgettable experience into Egypt\'s',
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
            ),
            Text(
              'exceptional sites!',
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
            ),
          ],
        ),
      ],
    );
  }
}
