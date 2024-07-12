import 'package:flutter/material.dart';
import 'package:nile_quest/modules/intro_screens/intro_page1.dart';
import 'package:nile_quest/modules/intro_screens/intro_page2.dart';
import 'package:nile_quest/modules/intro_screens/intro_page3.dart';
import 'package:nile_quest/modules/login/login_screen.dart';
import 'package:nile_quest/shared/styles/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({super.key});

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  PageController _controller = PageController();
  String buttonText = 'Continue';

  void _nextPage() {
    if (_controller.page == 2) {
      _markIntroScreenShown();
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          transitionDuration: Duration(milliseconds: 500),
          pageBuilder: (context, animation, secondaryAnimation) =>
              LoginScreen(),
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
    } else {
      _controller.nextPage(
        duration: Duration(milliseconds: 500),
        curve: Curves.ease,
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _checkIfFirstTime();
  }

  void _checkIfFirstTime() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isFirstTime = prefs.getBool('first_time') ?? true;
    if (!isFirstTime) {
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          transitionDuration: Duration(milliseconds: 500),
          pageBuilder: (context, animation, secondaryAnimation) =>
              LoginScreen(),
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
    }
  }

  void _markIntroScreenShown() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('first_time', false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView(
            controller: _controller,
            children: [
              IntroPage1(),
              IntroPage2(),
              IntroPage3(),
            ],
            onPageChanged: (int index) {
              setState(() {
                buttonText = index == 2 ? 'Get me started' : 'Continue';
              });
            },
          ),
          Container(
            alignment: Alignment(0, 0.70),
            child: SmoothPageIndicator(
              controller: _controller,
              count: 3,
              effect: WormEffect(
                activeDotColor: mainColor,
                dotColor: Color.fromRGBO(217, 217, 217, 1),
                dotWidth: 10,
                dotHeight: 10,
              ),
            ),
          ),
          AnimatedSwitcher(
            duration: Duration(milliseconds: 300),
            child: Container(
              key: ValueKey<String>(buttonText),
              alignment: Alignment(0, 0.90),
              child: Padding(
                padding:
                    const EdgeInsetsDirectional.symmetric(horizontal: 15.0),
                child: MaterialButton(
                  elevation: 0,
                  hoverElevation: 0,
                  highlightElevation: 0,
                  shape: ContinuousRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  color: mainColor,
                  height: 60,
                  minWidth: double.infinity,
                  onPressed: _nextPage,
                  child: Text(
                    buttonText,
                    style: TextStyle(
                        fontFamily: 'Abz',
                        fontWeight: FontWeight.bold,
                        fontSize: 25,
                        color: Colors.white),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
