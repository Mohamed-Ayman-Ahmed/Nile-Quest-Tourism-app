import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:nile_quest/layouts/home_layout.dart';
import 'package:nile_quest/modules/password/password.dart';
import 'package:nile_quest/modules/register/register_screen.dart';
import 'package:nile_quest/services/firebase_auth_service.dart';
import 'package:nile_quest/shared/styles/colors.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final FirebaseAuthService _auth = FirebaseAuthService();

  TextEditingController emailcontontroller = TextEditingController();

  TextEditingController passwordcontroller = TextEditingController();

  var formkey = GlobalKey<FormState>();

  bool ispass = true;
  bool isLoading = false;

  @override
  void dispose() {
    emailcontontroller.dispose();
    passwordcontroller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    checkCurrentUser();
  }

  void checkCurrentUser() async {
    if (await _auth.isUserLoggedIn()) {
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          transitionDuration: Duration(milliseconds: 500),
          pageBuilder: (context, animation, secondaryAnimation) => HomeLayout(),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Form(
          key: formkey,
          child: SingleChildScrollView(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              SizedBox(
                height: 50.0,
              ),
              Text(
                "Hello",
                style: TextStyle(
                    fontSize: 35.0,
                    fontWeight: FontWeight.bold,
                    color: mainColor),
              ),
              Text(
                "Welcome Back,",
                style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w500),
              ),
              Text(
                "please enter your details.",
                style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w500),
              ),
              SizedBox(
                height: 20.0,
              ),
              TextFormField(
                  controller: emailcontontroller,
                  keyboardType: TextInputType.emailAddress,
                  onFieldSubmitted: (value) {
                    print(value);
                  },
                  onChanged: (value) {
                    print(value);
                  },
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'please enter your email';
                    } else {
                      return null;
                    }
                  },
                  decoration: InputDecoration(
                    labelText: 'Email,Phone & Username',
                    border: OutlineInputBorder(),
                  )),
              SizedBox(
                height: 20.0,
              ),
              TextFormField(
                  controller: passwordcontroller,
                  keyboardType: TextInputType.visiblePassword,
                  obscureText: ispass,
                  onFieldSubmitted: (value) {
                    print(value);
                  },
                  onChanged: (value) {
                    print(value);
                  },
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'please enter your password';
                    } else {
                      return null;
                    }
                  },
                  decoration: InputDecoration(
                      labelText: "Password",
                      border: OutlineInputBorder(),
                      suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              ispass = !ispass;
                            });
                          },
                          icon: Icon(
                            ispass == false
                                ? Icons.visibility
                                : Icons.visibility_off,
                          )))),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          PageRouteBuilder(
                            transitionDuration: Duration(milliseconds: 500),
                            pageBuilder:
                                (context, animation, secondaryAnimation) =>
                                    PasswordScreen(),
                            transitionsBuilder: (context, animation,
                                secondaryAnimation, child) {
                              var begin = Offset(1.0, 0.0);
                              var end = Offset.zero;
                              var curve = Curves.ease;

                              var tween = Tween(begin: begin, end: end)
                                  .chain(CurveTween(curve: curve));

                              return SlideTransition(
                                position: animation.drive(tween),
                                child: child,
                              );
                            },
                          ),
                        );
                      },
                      child: Text(
                        'Forgot password?',
                        style: TextStyle(color: Colors.black),
                      )),
                ],
              ),
              SizedBox(
                height: 30.0,
              ),
              Container(
                width: double.infinity,
                height: 50.0,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5.0),
                  color: mainColor,
                ),
                child: MaterialButton(
                  onPressed: () {
                    if (formkey.currentState!.validate()) {
                      _signin();
                    }
                  },
                  child: Text(
                    'Sign in',
                    style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                ),
              ),
              SizedBox(
                height: 40.0,
              ),
              Row(
                children: <Widget>[
                  Expanded(
                    child: Container(
                      height: 1.0,
                      color: Colors.black,
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 3.0),
                    child: Text("OR",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.w400,
                            fontFamily: 'Abz')),
                  ),
                  Expanded(
                    child: Container(
                      height: 1.0,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                      onPressed: () {
                        signInWithGoogle(context);
                      },
                      icon: Image.asset('assets/icon/google.png')),
                  IconButton(
                      onPressed: () {
                        signInWithFacebook(context);
                      },
                      icon: Image.asset('assets/icon/facebook.png')),
                ],
              ),
              SizedBox(
                height: 5,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Don't have an account?",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          PageRouteBuilder(
                            transitionDuration: Duration(milliseconds: 500),
                            pageBuilder:
                                (context, animation, secondaryAnimation) =>
                                    RegisterScreen(),
                            transitionsBuilder: (context, animation,
                                secondaryAnimation, child) {
                              var begin = Offset(1.0, 0.0);
                              var end = Offset.zero;
                              var curve = Curves.ease;

                              var tween = Tween(begin: begin, end: end)
                                  .chain(CurveTween(curve: curve));

                              return SlideTransition(
                                position: animation.drive(tween),
                                child: child,
                              );
                            },
                          ),
                        );
                      },
                      child: Text("Register Now",
                          style: TextStyle(
                              color: mainColor, fontWeight: FontWeight.bold)))
                ],
              ),
            ]),
          ),
        ),
      ),
    );
  }

  Future<void> handleSuccessfulSignIn(BuildContext context) async {
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        transitionDuration: Duration(milliseconds: 500),
        pageBuilder: (context, animation, secondaryAnimation) => HomeLayout(),
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

  Future signInWithGoogle(BuildContext context) async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    await _firebaseCredential(context, credential);
  }

  Future signInWithFacebook(BuildContext context) async {
    final LoginResult loginResult =
        await FacebookAuth.instance.login(permissions: ['email']);
    final OAuthCredential facebookAuthCredential =
        FacebookAuthProvider.credential(loginResult.accessToken!.token);

    await _firebaseCredential(context, facebookAuthCredential);
  }

  Future _firebaseCredential(
      BuildContext context, AuthCredential credential) async {
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);

      String providerId = credential.providerId;
      List<String> signInMethods = await FirebaseAuth.instance
          .fetchSignInMethodsForEmail(userCredential.user!.email!);

      if (signInMethods.contains(providerId)) {
      } else {
        await FirebaseAuth.instance.currentUser!.linkWithCredential(credential);
      }

      await handleSuccessfulSignIn(context);
    } on FirebaseAuthException {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
              'An account already exists with the same email address but different sign-in method.')));
    }
  }

  void _signin() async {
    setState(() {
      isLoading = true;
    });
    String email = emailcontontroller.text;
    String password = passwordcontroller.text;

    User? user = await _auth.signInWithEmailAndPassword(email, password);
    if (user != null) {
      print("User sign in Successfully");
      await _auth.storeUserCredentials(email, password);
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          transitionDuration: Duration(milliseconds: 500),
          pageBuilder: (context, animation, secondaryAnimation) => HomeLayout(),
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
      print("some error happened");
      setState(() {
        isLoading = false;
      });
    }
  }
}
