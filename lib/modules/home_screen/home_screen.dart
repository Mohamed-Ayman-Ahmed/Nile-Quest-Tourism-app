// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:nile_quest/model/categories/categories.dart';
import 'package:nile_quest/model/hotels_items/hotel.dart';
import 'package:nile_quest/model/places_items/places.dart';
import 'package:nile_quest/modules/ai_screen/ai_screen.dart';
import 'package:nile_quest/modules/details_screen/details_screen.dart';
import 'package:nile_quest/modules/hotel_details_screen/hotel_details.dart';
import 'package:nile_quest/modules/search_screen/search.dart';
import 'package:nile_quest/places/beach/beach_screen.dart';
import 'package:nile_quest/places/hotels_screen/hotels_screen.dart';
import 'package:nile_quest/places/museums_screen/museum_screen.dart';
import 'package:nile_quest/places/religion_screen/religion_screen.dart';
import 'package:nile_quest/places/temple_screen/temple_screen.dart';
import 'package:nile_quest/shared/styles/colors.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  int currentIndex = 0;
  bool isLoading = true;
  bool isFav = false;
  String text = '';
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  Color categoryfont = Colors.white;
  List<Places> recCards = [];
  List<Places> popCards = [];
  List<HotelsModel> pophotels = [];

  @override
  void initState() {
    super.initState();
    fetchUserProfilePopular();
    fetchUserProfileRecommended();
    fetchUserProfile();
    fetchRecommended();
  }

  Future<void> fetchRecommended() async {
    User? user = _firebaseAuth.currentUser;
    if (user != null && mounted) {
      // Add mounted check here
      List<Map<String, String>> collectionsAndDocumentIds = [
        {"collection": "Hotels", "documentId": "Iberotel Luxor"},
        {"collection": "Hotels", "documentId": "Pyramisa Hotel Luxor"},
        {"collection": "Hotels", "documentId": "Savoy Sharm El Sheikh"},
        {"collection": "Hotels", "documentId": "Almanara Hotel Marsa Matrouh"},
        {"collection": "Hotels", "documentId": "Triumph White Sands Hotel"},
      ];
      List<HotelsModel> fetchedHotels = [];

      for (var item in collectionsAndDocumentIds) {
        String collectionName = item['collection']!;
        String documentId = item['documentId']!;

        DocumentSnapshot<Map<String, dynamic>> docSnapshot =
            await FirebaseFirestore.instance
                .collection(collectionName)
                .doc(documentId)
                .get();

        if (mounted) {
          // Add mounted check before accessing state
          if (docSnapshot.exists) {
            var docData = docSnapshot.data();
            var asset = docData?['Images'] ?? docData?['Images '] ?? '';
            var location = docData?['Location'] ?? docData?['Location '] ?? '';
            var price = docData?['Room Price'] ?? docData?['Room Price '] ?? '';
            var des = docData?['Description'] ??
                docData?['Description '] ??
                docData?['Full Description'] ??
                '';
            var link = docData?['Hotel Link'] ?? docData?['Hotel Link '] ?? '';
            fetchedHotels.add(
              HotelsModel(
                name: docData!['Name'] ?? '',
                images: asset,
                location: location,
                price: price.replaceAll(".", "\n"),
                description: des,
                language: docData['Languages Spoken'] ?? '',
                hotelLink: link,
                map: docData['map'] ?? '',
              ),
            );
          }
        }
      }

      if (mounted) {
        // Add mounted check before calling setState
        setState(() {
          pophotels = fetchedHotels;
        });
      }
    }
  }

  Future<void> fetchUserProfileRecommended() async {
    User? user = _firebaseAuth.currentUser;
    if (user != null && mounted) {
      // Add mounted check here
      List<Map<String, String>> collectionsAndDocumentIds = [
        {"collection": "Cairo", "documentId": "Cairo Tower"},
        {"collection": "Aswan", "documentId": "Kom Ombo Temple"},
        {"collection": "Alexandria", "documentId": "Qaitbay Citadel"},
        {"collection": "Luxor", "documentId": "Temple Of Karnak"},
        {"collection": "Matruh", "documentId": "El Alamein"},
      ];
      List<Places> fetchedItems = [];

      for (var item in collectionsAndDocumentIds) {
        String collectionName = item['collection']!;
        String documentId = item['documentId']!;

        DocumentSnapshot<Map<String, dynamic>> docSnapshot =
            await _firestore.collection(collectionName).doc(documentId).get();

        if (mounted) {
          // Add mounted check before accessing state
          if (docSnapshot.exists) {
            var docData = docSnapshot.data();
            var asset = docData?['Images'] ?? docData?['Images '] ?? '';
            var location = docData?['Location'] ?? docData?['Location '] ?? '';
            var price =
                docData?['Ticket Price'] ?? docData?['Ticket Price '] ?? '';
            var des = docData?['Description'] ??
                docData?['Description '] ??
                docData?['Full Description'] ??
                '';
            var time =
                docData?['Opening Hours'] ?? docData?['Opening Hours '] ?? '';
            fetchedItems.add(
              Places(
                name: docData!['Name'] ?? '',
                images: asset,
                location: location,
                price: price.replaceAll(".", "\n"),
                description: des,
                history: docData['History'] ?? '',
                openingHours: time.replaceAll(".", "\n"),
                Map: docData['map'] ?? '',
              ),
            );
          }
        }
      }

      if (mounted) {
        // Add mounted check before calling setState
        setState(() {
          recCards = fetchedItems;
        });
      }
    }
  }

  Future<void> fetchUserProfilePopular() async {
    User? user = _firebaseAuth.currentUser;
    if (user != null && mounted) {
      // Add mounted check here
      List<Map<String, String>> collectionsAndDocumentIds = [
        {"collection": "Cairo", "documentId": "Pyramids Of Giza"},
        {"collection": "Cairo", "documentId": "Baron Empain Palace"},
        {"collection": "Matruh", "documentId": "Siwa Oasis"},
        {"collection": "Alexandria", "documentId": "Bibliotheca Alexandr"},
        {"collection": "Luxor", "documentId": "Luxor Temple"},
      ];
      List<Places> fetchedCards = [];

      for (var item in collectionsAndDocumentIds) {
        String collectionName = item['collection']!;
        String documentId = item['documentId']!;

        DocumentSnapshot<Map<String, dynamic>> docSnapshot =
            await _firestore.collection(collectionName).doc(documentId).get();

        if (mounted) {
          // Add mounted check before accessing state
          if (docSnapshot.exists) {
            var docData = docSnapshot.data();
            var asset = docData?['Images'] ?? docData?['Images '] ?? '';
            var location = docData?['Location'] ?? docData?['Location '] ?? '';
            var price =
                docData?['Ticket Price'] ?? docData?['Ticket Price '] ?? '';
            var des = docData?['Description'] ??
                docData?['Description '] ??
                docData?['Full Description'] ??
                '';
            var time =
                docData?['Opening Hours'] ?? docData?['Opening Hours '] ?? '';
            fetchedCards.add(
              Places(
                name: docData!['Name'] ?? '',
                images: asset,
                location: location,
                price: price.replaceAll(".", "\n"),
                description: des,
                history: docData['History'] ?? '',
                openingHours: time.replaceAll(".", "\n"),
                Map: docData['map'] ?? '',
              ),
            );
          }
        }
      }

      if (mounted) {
        // Add mounted check before calling setState
        setState(() {
          popCards = fetchedCards;
          isLoading = false;
        });
      }
    }
  }

  Future<void> fetchUserProfile() async {
    User? user = _firebaseAuth.currentUser;
    if (user != null) {
      DocumentSnapshot<Map<String, dynamic>> snapshot =
          await _firestore.collection('users').doc(user.uid).get();
      if (snapshot.exists) {
        setState(() {
          text = snapshot.data()?['name'] ?? '';
        });
      }
    }
  }

  String greeting() {
    var hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Good Morning.';
    } else if (hour < 18) {
      return 'Good Afternoon.';
    } else {
      return 'Good Evening.';
    }
  }

  List<CategoryCards> categories = [
    CategoryCards(
      category: 'Hotels',
    ),
    CategoryCards(
      category: 'Temples',
    ),
    CategoryCards(
      category: 'Museums',
    ),
    CategoryCards(
      category: 'Religions',
    ),
    CategoryCards(
      category: 'Beaches',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 70.0,
        automaticallyImplyLeading: false,
        title: Padding(
          padding: const EdgeInsetsDirectional.symmetric(horizontal: 5.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Hello, $text',
                style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.w400,
                    fontFamily: 'Poppins'),
              ),
              SizedBox(
                height: 2.0,
              ),
              Text(
                greeting(),
                style: TextStyle(
                    fontSize: 25.0,
                    fontWeight: FontWeight.w900,
                    fontFamily: 'Poppins'),
              ),
            ],
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.0),
                    color: mainColor,
                  ),
                  width: 45.0,
                  child: IconButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        PageRouteBuilder(
                          transitionDuration: Duration(milliseconds: 500),
                          pageBuilder:
                              (context, animation, secondaryAnimation) =>
                                  AiScreen(),
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
                    icon: Icon(Icons.bolt_outlined),
                    color: Colors.white,
                    iconSize: 30.0,
                  ),
                ),
                Text(
                  'AI Guide',
                  style: TextStyle(
                      fontSize: 15.0,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Poppins'),
                ),
              ],
            ),
          ),
        ],
      ),
      body: Visibility(
        visible: isLoading,
        child: Center(
          child: SpinKitFoldingCube(
            color: mainColor,
            size: 50,
          ),
        ),
        replacement: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: [
              SizedBox(
                height: 5.0,
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    PageRouteBuilder(
                      transitionDuration: Duration(milliseconds: 500),
                      pageBuilder: (context, animation, secondaryAnimation) =>
                          Search(),
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
                child: Padding(
                  padding:
                      const EdgeInsetsDirectional.symmetric(horizontal: 15.0),
                  child: Container(
                    height: 53.0,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        color: searchColor),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 15.0,
                        ),
                        Icon(
                          Icons.search,
                          color: Colors.grey,
                        ),
                        SizedBox(
                          width: 8.0,
                        ),
                        Text(
                          'Find Places',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 20.0,
              ),
              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 35.0,
                      child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) =>
                              categoryBuild(categories[index], index),
                          itemCount: categories.length),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 15.0,
              ),
              Column(
                children: [
                  Padding(
                    padding:
                        const EdgeInsetsDirectional.symmetric(horizontal: 15.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          'Popular',
                          style: TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Mont'),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  SizedBox(
                    height: 280.0,
                    child: Row(
                      children: [
                        Expanded(
                          child: PageView.builder(
                            padEnds: false,
                            physics: BouncingScrollPhysics(),
                            controller: PageController(
                                initialPage: 0, viewportFraction: 1),
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, index) {
                              Places popularCard = popCards[index];
                              return InkWell(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => DetailsScreen(
                                              asset: popularCard.images!,
                                              tag: popularCard.name!,
                                              location: popularCard.location!,
                                              description:
                                                  popularCard.description!,
                                              history: popularCard.history!,
                                              time: popularCard.openingHours!,
                                              price: popularCard.price!,
                                              map: popularCard.Map!)));
                                },
                                child: Column(
                                  children: [
                                    Padding(
                                      padding:
                                          const EdgeInsetsDirectional.symmetric(
                                              horizontal: 15.0),
                                      child: Hero(
                                        tag: popularCard.name!,
                                        child: Container(
                                          width: double.infinity,
                                          height: 230,
                                          decoration: BoxDecoration(
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Color.fromRGBO(
                                                      0, 0, 0, 0.4),
                                                  offset: Offset(0, 4),
                                                  blurRadius: 9,
                                                  spreadRadius: -2,
                                                )
                                              ],
                                              borderRadius:
                                                  BorderRadius.circular(20.0)),
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(20.0),
                                            child: FancyShimmerImage(
                                              imageUrl: popularCard.images!,
                                              boxFit: BoxFit.fill,
                                              shimmerDuration:
                                                  Duration(milliseconds: 500),
                                              errorWidget: Icon(
                                                  Icons.error_outline_outlined),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 12,
                                    ),
                                    Text(
                                      '${popularCard.name}',
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'Roboto'),
                                    ),
                                  ],
                                ),
                              );
                            },
                            itemCount: popCards.length,
                            onPageChanged: (value) {
                              currentIndex = value;
                              setState(() {});
                            },
                          ),
                        )
                      ],
                    ),
                  ),
                  TabPageSelector(
                    borderStyle: BorderStyle.none,
                    indicatorSize: 10,
                    color: Color.fromRGBO(217, 217, 217, 1),
                    selectedColor: mainColor,
                    controller: popCards.isNotEmpty
                        ? TabController(
                            length: popCards.length,
                            vsync: this,
                            initialIndex: currentIndex)
                        : null,
                  ),
                  SizedBox(
                    height: 5,
                  )
                ],
              ),
              Column(
                children: [
                  Padding(
                    padding:
                        const EdgeInsetsDirectional.symmetric(horizontal: 15.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text("Recommended",
                            style: TextStyle(
                                fontSize: 18,
                                fontFamily: 'Mont',
                                fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                  SizedBox(height: 5.0),
                  SizedBox(
                    height: 169,
                    child: Row(children: [
                      Expanded(
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: recCards.length,
                          itemBuilder: (context, index) {
                            Places recommendedCard = recCards[index];
                            return InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => DetailsScreen(
                                              asset: recommendedCard.images!,
                                              tag: recommendedCard.name!,
                                              location:
                                                  recommendedCard.location!,
                                              description:
                                                  recommendedCard.description!,
                                              history: recommendedCard.history!,
                                              time:
                                                  recommendedCard.openingHours!,
                                              price: recommendedCard.price!,
                                              map: recommendedCard.Map!,
                                            )));
                              },
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(left: 15.0),
                                    child: Container(
                                      width: 230,
                                      height: 140,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(12.0)),
                                      child: ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(12.0),
                                        child: Hero(
                                          tag: recommendedCard.name!,
                                          child: FancyShimmerImage(
                                            shimmerDuration:
                                                Duration(milliseconds: 500),
                                            imageUrl: recommendedCard.images!,
                                            boxFit: BoxFit.fill,
                                            errorWidget: Icon(
                                                Icons.error_outline_outlined),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 15.0),
                                    child: Text(
                                      '${recommendedCard.name!}',
                                      style: TextStyle(
                                          color:
                                              Color.fromRGBO(130, 130, 130, 1),
                                          fontSize: 15.0,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'Roboto'),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ]),
                  ),
                ],
              ),
              SizedBox(
                height: 15,
              ),
              Padding(
                padding:
                    const EdgeInsetsDirectional.symmetric(horizontal: 15.0),
                child: Container(
                  width: double.infinity,
                  height: 0.3,
                  color: Colors.grey,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding:
                        const EdgeInsetsDirectional.symmetric(horizontal: 15.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Popular Hotels",
                            style: TextStyle(
                                fontSize: 20,
                                fontFamily: 'Mont',
                                fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                  SizedBox(height: 5.0),
                  Container(
                    width: double.infinity,
                    child: SingleChildScrollView(
                      child: Column(children: [
                        ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          scrollDirection: Axis.vertical,
                          itemCount: pophotels.length,
                          itemBuilder: (context, index) {
                            HotelsModel recommended = pophotels[index];
                            return InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => HotelDetails(
                                      asset: recommended.images!,
                                      tag: recommended.name!,
                                      location: recommended.location!,
                                      description: recommended.description!,
                                      hotelLink: recommended.hotelLink!,
                                      language: recommended.language!,
                                      price: recommended.price!,
                                      map: recommended.map!,
                                    ),
                                  ),
                                );
                              },
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(15.0),
                                    child: Container(
                                      width: double.infinity,
                                      height: 180,
                                      decoration: BoxDecoration(
                                          boxShadow: [
                                            BoxShadow(
                                              color:
                                                  Color.fromRGBO(0, 0, 0, 0.4),
                                              offset: Offset(0, 4),
                                              blurRadius: 9,
                                              spreadRadius: -2,
                                            )
                                          ],
                                          borderRadius:
                                              BorderRadius.circular(20.0)),
                                      child: ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(12.0),
                                        child: Hero(
                                          tag: recommended.name!,
                                          child: FancyShimmerImage(
                                            shimmerDuration:
                                                Duration(milliseconds: 500),
                                            imageUrl: recommended.images!,
                                            boxFit: BoxFit.fill,
                                            errorWidget: Icon(
                                                Icons.error_outline_outlined),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 20.0),
                                    child: Text(
                                      '${recommended.name!}',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 17.0,
                                        fontWeight: FontWeight.w500,
                                        fontFamily: 'Roboto',
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ]),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget categoryBuild(CategoryCards cat, int index) => Padding(
        padding: const EdgeInsets.only(left: 15.0),
        child: MaterialButton(
          height: 20.0,
          elevation: 0,
          highlightColor: Colors.transparent,
          highlightElevation: 0,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          color: categoryColor,
          onPressed: () {
            switch (index) {
              case 0:
                Navigator.push(
                  context,
                  PageRouteBuilder(
                    transitionDuration: Duration(milliseconds: 500),
                    pageBuilder: (context, animation, secondaryAnimation) =>
                        Hotels(),
                    transitionsBuilder:
                        (context, animation, secondaryAnimation, child) {
                      var begin = Offset(1, 0);
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
                break;

              case 1:
                Navigator.push(
                  context,
                  PageRouteBuilder(
                    transitionDuration: Duration(milliseconds: 500),
                    pageBuilder: (context, animation, secondaryAnimation) =>
                        Temple(),
                    transitionsBuilder:
                        (context, animation, secondaryAnimation, child) {
                      var begin = Offset(1, 0);
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
                break;

              case 2:
                Navigator.push(
                  context,
                  PageRouteBuilder(
                    transitionDuration: Duration(milliseconds: 500),
                    pageBuilder: (context, animation, secondaryAnimation) =>
                        Museum(),
                    transitionsBuilder:
                        (context, animation, secondaryAnimation, child) {
                      var begin = Offset(1, 0);
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
                break;

              case 3:
                Navigator.push(
                  context,
                  PageRouteBuilder(
                    transitionDuration: Duration(milliseconds: 500),
                    pageBuilder: (context, animation, secondaryAnimation) =>
                        Religion(),
                    transitionsBuilder:
                        (context, animation, secondaryAnimation, child) {
                      var begin = Offset(1, 0);
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
                break;

              case 4:
                Navigator.push(
                  context,
                  PageRouteBuilder(
                    transitionDuration: Duration(milliseconds: 500),
                    pageBuilder: (context, animation, secondaryAnimation) =>
                        Beach(),
                    transitionsBuilder:
                        (context, animation, secondaryAnimation, child) {
                      var begin = Offset(1, 0);
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
                break;
              default:
                print('Error');
                break;
            }
          },
          child: Text(
            '${cat.category}',
            style: TextStyle(
                fontSize: 20, fontWeight: FontWeight.bold, color: categoryfont),
          ),
        ),
      );
}
