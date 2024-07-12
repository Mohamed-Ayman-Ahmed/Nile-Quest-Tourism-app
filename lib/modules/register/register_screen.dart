import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:nile_quest/modules/login/login_screen.dart';
import 'package:nile_quest/services/firebase_auth_service.dart';
import 'package:nile_quest/services/toast.dart';
import 'package:nile_quest/shared/styles/colors.dart';

class RegisterScreen extends StatefulWidget {
  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final FirebaseAuthService _auth = FirebaseAuthService();

  TextEditingController emailcontroller = TextEditingController();
  TextEditingController passwordcontroller = TextEditingController();
  TextEditingController conpasscontroller = TextEditingController();
  var formkey = GlobalKey<FormState>();

  @override
  void dispose() {
    emailcontroller.dispose();
    passwordcontroller.dispose();
    conpasscontroller.dispose();
    super.dispose();
  }

  bool areSame() {
    return passwordcontroller.text == conpasscontroller.text;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: formkey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 50.0,
                ),
                Text(
                  'Register',
                  style: TextStyle(
                      fontSize: 35.0,
                      fontWeight: FontWeight.bold,
                      color: mainColor),
                ),
                Text(
                  'Hello user,',
                  style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w500),
                ),
                Text(
                  'do have a great journey.',
                  style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w500),
                ),
                SizedBox(
                  height: 10.0,
                ),
                TextFormField(
                  controller: emailcontroller,
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
                      labelText: 'Email', border: OutlineInputBorder()),
                ),
                SizedBox(
                  height: 10.0,
                ),
                TextFormField(
                  controller: passwordcontroller,
                  keyboardType: TextInputType.visiblePassword,
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
                      labelText: 'Password', border: OutlineInputBorder()),
                ),
                SizedBox(
                  height: 10.0,
                ),
                TextFormField(
                  controller: conpasscontroller,
                  keyboardType: TextInputType.visiblePassword,
                  onFieldSubmitted: (value) {
                    print(value);
                  },
                  onChanged: (value) {
                    print(value);
                  },
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'please enter your password';
                    }
                    if (!areSame()) {
                      return 'please enter the same password';
                    } else {
                      return null;
                    }
                  },
                  decoration: InputDecoration(
                      labelText: 'Confirm password',
                      border: OutlineInputBorder()),
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
                        _signup();
                      }
                    },
                    child: Text(
                      'Sign up',
                      style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ),
                ),
                SizedBox(
                  height: 10.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Already have an account?'),
                    TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text(
                          'Login',
                          style: TextStyle(color: mainColor),
                        ))
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _signup() async {
    String email = emailcontroller.text;
    String password = passwordcontroller.text;

    User? user = await _auth.SignUPWithEmailAndPassword(
      email,
      password,
    );
    if (user != null) {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('favorites');
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('favoritehotels');
      await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
        'name': "",
        'phone': "",
        'address': "",
      });

      showToast(message: "User Registered Successfully");
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
      print("some error happened");
    }
  }
}
