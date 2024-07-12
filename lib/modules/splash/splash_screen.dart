/*import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:nile_quest/modules/intro/intro_screen.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
        colors: [
          Color.fromRGBO(253, 227, 81, 1),
          Color.fromRGBO(88, 82, 42, 1),
        ],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      )),
      child: AnimatedSplashScreen(
        splash: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              LottieBuilder.asset('assets/lottie/d.json'),
              Text(
                'Nile Quest',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 35.0,
                  fontStyle: FontStyle.italic,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
        nextScreen: IntroScreen(),
        splashIconSize: 400,
        duration: 1500,
        backgroundColor: Colors.transparent,
      ),
    );
  }
}*/

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:nile_quest/modules/onboarding_screen/onboarding_screen.dart';

class SplashScreen extends StatefulWidget {
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  void navigateToNextScreen() {
    Future.delayed(Duration(seconds: 5), () {
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          transitionDuration: Duration(milliseconds: 500),
          pageBuilder: (context, animation, secondaryAnimation) =>
              OnBoardingScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            var begin = Offset(1.0, 0.0);
            var end = Offset.zero;
            var curve = Curves.ease;
            var tween =
                Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
            return SlideTransition(
              position: animation.drive(tween),
              child: child,
            );
          },
        ),
      );
    });
  }

  @override
  void initState() {
    super.initState();
    navigateToNextScreen();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromRGBO(253, 227, 81, 1),
              Color.fromRGBO(88, 82, 42, 1),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 40.0,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Explore",
                      style: TextStyle(
                        shadows: [
                          Shadow(
                            blurRadius: 75.0,
                            color: Colors.black,
                            offset: Offset(0, -0),
                          ),
                        ],
                        fontSize: 34.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontFamily: 'Roboto',
                      ),
                    ),
                    Text(
                      "Discover favourite tourism",
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: 23.0,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      "spots",
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Center(
              child: Row(
                children: [
                  Stack(
                    alignment: Alignment(1.9, 0),
                    children: [
                      CircleAvatar(
                        radius: 150.0,
                        backgroundImage:
                            AssetImage('assets/images/The Karnak .jpg'),
                      ),
                      CircleAvatar(
                        radius: 80.0,
                        backgroundImage:
                            AssetImage('assets/images/Egypt Museum.jpg'),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 3.0),
                        child: Container(
                          width: 300.0,
                          height: 300.0,
                          decoration: BoxDecoration(
                            border: Border(
                              top: BorderSide(
                                width: 3.0,
                                color: Color.fromARGB(255, 218, 144, 41),
                              ),
                              bottom: BorderSide(
                                width: 3.0,
                                color: Color.fromARGB(255, 218, 144, 41),
                              ),
                              right: BorderSide(
                                width: 3.0,
                                color: Color.fromARGB(255, 218, 144, 41),
                              ),
                              left: BorderSide(
                                width: 3.0,
                                color: Color.fromARGB(255, 218, 144, 41),
                              ),
                            ),
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(350.0),
                              topRight: Radius.circular(350.0),
                              topLeft: Radius.circular(180.0),
                              bottomRight: Radius.circular(180.0),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 0.0),
                        child: Container(
                          width: 160.0,
                          height: 160.0,
                          decoration: BoxDecoration(
                            border: Border(
                              top: BorderSide(
                                width: 3.0,
                                color: Color.fromARGB(255, 218, 144, 41),
                              ),
                              bottom: BorderSide(
                                width: 3.0,
                                color: Color.fromARGB(255, 218, 144, 41),
                              ),
                              right: BorderSide(
                                width: 3.0,
                                color: Color.fromARGB(255, 218, 144, 41),
                              ),
                              left: BorderSide(
                                width: 3.0,
                                color: Color.fromARGB(255, 218, 144, 41),
                              ),
                            ),
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(250.0),
                              topRight: Radius.circular(220.0),
                              topLeft: Radius.circular(400.0),
                              bottomRight: Radius.circular(400.0),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 25.0,
            ),
            Expanded(
              child: Center(
                child: Stack(alignment: Alignment.center, children: [
                  Lottie.asset('assets/lottie/e.json',
                      animate: true, width: 250),
                  Text(
                    'Nile Quest',
                    style: TextStyle(
                      //fontWeight: FontWeight.bold,
                      fontFamily: 'Lobster',
                      fontSize: 30.0,
                      //fontStyle: FontStyle.italic,
                      color: Colors.white,
                    ),
                  )
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
