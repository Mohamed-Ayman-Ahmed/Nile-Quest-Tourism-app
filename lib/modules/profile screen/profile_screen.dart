import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:giffy_dialog/giffy_dialog.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nile_quest/modules/login/login_screen.dart';
import 'package:nile_quest/modules/to%20do/Todo_screen.dart';
import 'package:nile_quest/services/firebase_auth_service.dart';
import 'package:nile_quest/services/toast.dart';
import 'package:nile_quest/shared/styles/colors.dart';

class ProfileScreen extends StatefulWidget {
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool enabled = false;
  bool isButtonClicked = false;
  bool isOperationCompleted = false;
  var nameController = TextEditingController();
  var emailController = TextEditingController();
  var phoneController = TextEditingController();
  var addressController = TextEditingController();
  String? imageUrl;
  final FirebaseAuthService _auth = FirebaseAuthService();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  File? selectedImage;

  Future pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        selectedImage = File(pickedFile.path);
      });

      String uid = FirebaseAuth.instance.currentUser!.uid;
      String fileName = '$uid.jpg';

      Reference ref = FirebaseStorage.instance
          .ref()
          .child("profile_images")
          .child(fileName);
      UploadTask uploadTask = ref.putFile(selectedImage!);
      TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => null);

      String imageUrl = await taskSnapshot.ref.getDownloadURL();

      setState(() {
        this.imageUrl = imageUrl;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    fetchUserDetails();
    fetchUserProfile();
  }

  @override
  void dispose() {
    if (!isOperationCompleted) {}
    super.dispose();
  }

  Future<void> deleteAccount() async {
    User? user = _firebaseAuth.currentUser;
    if (user != null) {
      String uid = user.uid;
      CollectionReference users =
          FirebaseFirestore.instance.collection('users');

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return GiffyDialog.lottie(
            Lottie.asset("assets/lottie/delete.json", height: 200),
            title: Text(
              'Account Deletion',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            content: Text(
              'Are you sure you want to delete your account?',
              textAlign: TextAlign.center,
              style: TextStyle(fontFamily: 'Arial', fontSize: 16),
            ),
            actions: <Widget>[
              TextButton(
                child: Text(
                  'Cancel',
                  style:
                      TextStyle(color: mainColor, fontWeight: FontWeight.bold),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              Container(
                color: Colors.grey,
                width: 0.3,
                height: 20,
              ),
              TextButton(
                child: Text(
                  'Delete',
                  style:
                      TextStyle(color: mainColor, fontWeight: FontWeight.bold),
                ),
                onPressed: () async {
                  try {
                    await user.delete();
                    await _deleteUserDocumentAndSubcollections(
                        users.doc(uid), uid);
                    showToast(message: "Account deleted");
                  } catch (e) {
                    showToast(
                      message:
                          "Please logout and login again before deleting the account.",
                    );
                  }
                  Navigator.of(context).pushReplacement(
                    PageRouteBuilder(
                      transitionDuration: Duration(milliseconds: 500),
                      pageBuilder: (context, animation, secondaryAnimation) =>
                          PopScope(
                        canPop: false,
                        child: LoginScreen(),
                      ),
                      transitionsBuilder:
                          (context, animation, secondaryAnimation, child) {
                        var begin = Offset(0, 1);
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
              ),
            ],
          );
        },
      );
    }
  }

  Future<void> _deleteUserDocumentAndSubcollections(
      DocumentReference userRef, String uid) async {
    await userRef.collection('favorites').get().then((querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        doc.reference.delete();
      });
    });
    await userRef.collection('favoritehotels').get().then((querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        doc.reference.delete();
      });
    });
    await userRef.collection('todoItems').get().then((querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        doc.reference.delete();
      });
    });

    // Delete profile picture from Cloud Storage
    String profilePicturePath = 'profile_images/$uid.jpg';
    Reference profilePictureRef =
        FirebaseStorage.instance.ref().child(profilePicturePath);
    try {
      await profilePictureRef.delete();
      print('Profile picture deleted successfully');
    } catch (e) {
      print('Error deleting profile picture: $e');
    }

    await userRef.delete();
    print('User document deleted successfully');
  }

  Future<void> fetchUserDetails() async {
    User? user = _firebaseAuth.currentUser;
    if (user != null) {
      setState(() {
        emailController.text = user.email ?? '';
      });
    }
  }

  Future<void> fetchUserProfile() async {
    User? user = _firebaseAuth.currentUser;
    if (user != null) {
      DocumentSnapshot<Map<String, dynamic>> snapshot =
          await _firestore.collection('users').doc(user.uid).get();
      if (snapshot.exists) {
        setState(() {
          nameController.text = snapshot.data()?['name'] ?? '';
          phoneController.text = snapshot.data()?['phone'] ?? '';
          addressController.text = snapshot.data()?['address'] ?? '';
          imageUrl = snapshot.data()?['profilePicture'];
        });
      }
    }
  }

  Future<void> saveProfile() async {
    User? user = _firebaseAuth.currentUser;
    if (user != null) {
      await _firestore.collection('users').doc(user.uid).set({
        'name': nameController.text,
        'phone': phoneController.text,
        'address': addressController.text,
        'profilePicture': imageUrl,
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 70.0,
        title: Text(
          'Profile',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        automaticallyImplyLeading: false,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.0),
                color:
                    isButtonClicked ? Color.fromARGB(100, 0, 0, 0) : mainColor,
              ),
              width: 45.0,
              child: IconButton(
                onPressed: () async {
                  await saveProfile();
                  setState(() {
                    enabled = !enabled;
                    isButtonClicked = !isButtonClicked;
                  });
                },
                icon: Icon(Icons.edit),
                color: Colors.white,
                iconSize: 30.0,
              ),
            ),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 20.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Stack(alignment: Alignment.topLeft, children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(15.0),
                      child: imageUrl != null
                          ? FancyShimmerImage(
                              shimmerDuration: Duration(milliseconds: 500),
                              errorWidget: Icon(Icons.error_outline_outlined),
                              imageUrl: imageUrl!,
                              width: 120,
                              height: 120,
                              boxFit: BoxFit.cover,
                            )
                          : Image.asset(
                              'assets/images/profile.jpg',
                              fit: BoxFit.cover,
                              width: 120.0,
                              height: 120.0,
                            ),
                    ),
                    IconButton(
                      onPressed: () {
                        if (enabled == true) {
                          pickImage();
                        }
                      },
                      icon: Icon(
                        Icons.add_a_photo,
                      ),
                    )
                  ]),
                ],
              ),
              SizedBox(
                height: 50.0,
              ),
              TextFormField(
                cursorColor: mainColor,
                controller: nameController,
                enabled: enabled,
                decoration: InputDecoration(
                  hintText: 'Name',
                ),
              ),
              SizedBox(
                height: 20.0,
              ),
              TextFormField(
                cursorColor: mainColor,
                controller: emailController,
                enabled: false,
                decoration: InputDecoration(
                  hintText: 'Email',
                ),
              ),
              SizedBox(
                height: 20.0,
              ),
              TextFormField(
                cursorColor: mainColor,
                controller: phoneController,
                keyboardType: TextInputType.phone,
                enabled: enabled,
                decoration: InputDecoration(
                  hintText: 'Phone',
                ),
              ),
              SizedBox(
                height: 20.0,
              ),
              TextFormField(
                cursorColor: mainColor,
                controller: addressController,
                enabled: enabled,
                decoration: InputDecoration(
                  hintText: 'Address',
                ),
              ),
              SizedBox(
                height: 50.0,
              ),
              Container(
                width: double.infinity,
                height: 50.0,
                child: MaterialButton(
                  elevation: 0,
                  highlightElevation: 0,
                  color: mainColor,
                  shape: ContinuousRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  onPressed: () {
                    Navigator.push(
                      context,
                      PageRouteBuilder(
                        transitionDuration: Duration(milliseconds: 500),
                        pageBuilder: (context, animation, secondaryAnimation) =>
                            TodoListPage(),
                        transitionsBuilder:
                            (context, animation, secondaryAnimation, child) {
                          var begin = Offset(0, 1);
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
                    'Todo List',
                    style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                ),
              ),
              SizedBox(
                height: 20.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width * 0.3,
                    height: 50.0,
                    child: MaterialButton(
                      elevation: 0,
                      highlightElevation: 0,
                      color: mainColor,
                      shape: ContinuousRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      onPressed: () async {
                        await _auth.signOut();
                        Navigator.of(context).pushReplacement(
                          PageRouteBuilder(
                            transitionDuration: Duration(milliseconds: 500),
                            pageBuilder:
                                (context, animation, secondaryAnimation) =>
                                    LoginScreen(),
                            transitionsBuilder: (context, animation,
                                secondaryAnimation, child) {
                              var begin = Offset(0, 1);
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
                        showToast(message: "Successfully signed out");
                      },
                      child: Text(
                        'Log Out',
                        style: TextStyle(
                            fontSize:
                                20.0 * MediaQuery.of(context).size.width / 360,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.5,
                    height: 50.0,
                    child: MaterialButton(
                      elevation: 0,
                      highlightElevation: 0,
                      color: Color.fromARGB(217, 244, 67, 54),
                      shape: ContinuousRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      onPressed: deleteAccount,
                      child: Text(
                        'Delete Account',
                        style: TextStyle(
                          fontSize:
                              20.0 * MediaQuery.of(context).size.width / 360,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 20.0,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
