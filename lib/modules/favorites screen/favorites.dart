// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:lottie/lottie.dart';
import 'package:nile_quest/modules/details_screen/details_screen.dart';
import 'package:nile_quest/modules/hotel_details_screen/hotel_details.dart';
import 'package:nile_quest/shared/styles/colors.dart';

class FavoritesScreen extends StatefulWidget {
  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  bool loading = false;
  User? _currentUser;
  List<Map<String, dynamic>> _favoritePlaces = [];
  List<Map<String, dynamic>> _favoriteHotels = [];
  bool isLoading = true;
  @override
  void initState() {
    super.initState();
    _getCurrentUser();
    _getFavoritePlaces();
    _getFavoriteHotels();
  }

  Future<void> _getCurrentUser() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
        _currentUser = user;
      });
    }
  }

  Future<void> _getFavoritePlaces() async {
    if (_currentUser != null && mounted) {
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await FirebaseFirestore.instance
              .collection('users')
              .doc(_currentUser!.uid)
              .collection('favorites')
              .get();
      List<Map<String, dynamic>> fetchedPlaces = [];
      querySnapshot.docs.forEach((doc) {
        fetchedPlaces.add(doc.data());
      });
      if (mounted) {
        setState(() {
          _favoritePlaces = fetchedPlaces;
          isLoading = false;
        });
      }
    }
  }

  Future<void> _getFavoriteHotels() async {
    if (_currentUser != null && mounted) {
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await FirebaseFirestore.instance
              .collection('users')
              .doc(_currentUser!.uid)
              .collection('favoritehotels')
              .get();
      List<Map<String, dynamic>> fetchedHotels = [];
      querySnapshot.docs.forEach((doc) {
        fetchedHotels.add(doc.data());
      });
      if (mounted) {
        setState(() {
          _favoriteHotels = fetchedHotels;
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 70.0,
          automaticallyImplyLeading: false,
          title: Padding(
            padding: const EdgeInsets.only(left: 4.0),
            child: Text(
              'Favorites',
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
            ),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 20.0),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.0),
                  color: mainColor,
                ),
                width: 45.0,
                child: IconButton(
                  onPressed: () async {
                    setState(() {
                      isLoading = true;
                      Center(
                          child: SpinKitFoldingCube(
                        color: mainColor,
                        size: 50,
                      ));
                    });
                    await _getFavoritePlaces();
                    await _getFavoriteHotels();
                    setState(() {
                      isLoading = false;
                    });
                  },
                  icon: Icon(Icons.refresh),
                  color: Colors.white,
                  iconSize: 30.0,
                ),
              ),
            )
          ],
          bottom: TabBar(
              labelColor: mainColor,
              dividerColor: mainColor,
              indicatorColor: mainColor,
              labelStyle:
                  TextStyle(fontSize: 20.0, fontWeight: FontWeight.w500),
              tabs: [
                Tab(text: ('Saved Places')),
                Tab(text: ('Saved Hotels')),
              ]),
        ),
        body: Visibility(
          visible: isLoading,
          child: Center(
              child: SpinKitFoldingCube(
            color: mainColor,
            size: 50,
          )),
          replacement: TabBarView(children: [
            _favoritePlaces.isEmpty
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                        Lottie.asset('assets/lottie/a.json',
                            animate: true, height: 300),
                        Text('No Places Saved Yet',
                            style: TextStyle(
                                fontSize: 20.0,
                                fontWeight: FontWeight.w500,
                                color: Color.fromARGB(125, 0, 0, 0)))
                      ])
                : ListView.builder(
                    itemCount: _favoritePlaces.length,
                    itemBuilder: (context, index) {
                      Map<String, dynamic> place = _favoritePlaces[index];
                      return InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => DetailsScreen(
                                        asset: place['asset'],
                                        tag: place['name'],
                                        location: place['location'],
                                        description: place['description'],
                                        history: place['history'],
                                        time:
                                            place['time'].replaceAll(".", "\n"),
                                        price: place['price']
                                            .replaceAll(".", "\n"),
                                        map: place['map'],
                                      )));
                        },
                        child: Container(
                          margin: EdgeInsets.only(
                              left: 10, right: 10, bottom: 7, top: 5),
                          height: 210,
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: Color.fromRGBO(0, 0, 0, 0.4),
                                offset: Offset(0, 4),
                                blurRadius: 9,
                                spreadRadius: -4,
                              )
                            ],
                            borderRadius: BorderRadius.circular(10),
                            color: Color.fromARGB(255, 234, 234, 234),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Hero(
                                tag: place['name'],
                                child: ClipRRect(
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(10)),
                                  child: FancyShimmerImage(
                                    shimmerDuration:
                                        Duration(milliseconds: 500),
                                    errorWidget:
                                        Icon(Icons.error_outline_outlined),
                                    imageUrl: place['asset'],
                                    boxFit: BoxFit.fill,
                                    width: double.infinity,
                                    height: 170.0,
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 7,
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.4,
                                      child: Text(
                                        place['name'],
                                        maxLines: 1,
                                        style: TextStyle(
                                            overflow: TextOverflow.ellipsis,
                                            color: Colors.black,
                                            fontSize: 15),
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.location_pin,
                                          color: Colors.black,
                                        ),
                                        Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.3,
                                          child: Text(
                                            place['location'],
                                            maxLines: 1,
                                            style: TextStyle(
                                                overflow: TextOverflow.ellipsis,
                                                color: Colors.black,
                                                fontSize: 15),
                                          ),
                                        )
                                      ],
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      );
                    },
                  ),
            _favoriteHotels.isEmpty
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                        Lottie.asset('assets/lottie/a.json',
                            animate: true, height: 300),
                        Text('No Hotels Saved Yet',
                            style: TextStyle(
                                fontSize: 20.0,
                                fontWeight: FontWeight.w500,
                                color: Color.fromARGB(125, 0, 0, 0)))
                      ])
                : ListView.builder(
                    itemCount: _favoriteHotels.length,
                    itemBuilder: (context, index) {
                      Map<String, dynamic> place = _favoriteHotels[index];
                      return InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => HotelDetails(
                                        asset: place['asset'],
                                        tag: place['name'],
                                        location: place['location'],
                                        description: place['description'],
                                        hotelLink: place['link'],
                                        language: place['language'],
                                        price: place['price']
                                            .replaceAll(".", "\n"),
                                        map: place['map'],
                                      )));
                        },
                        child: Container(
                          margin: EdgeInsets.only(
                              left: 10, right: 10, bottom: 7, top: 5),
                          height: 170,
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: Color.fromRGBO(0, 0, 0, 0.4),
                                offset: Offset(0, 4),
                                blurRadius: 9,
                                spreadRadius: -4,
                              )
                            ],
                            borderRadius: BorderRadius.circular(10),
                            color: Color.fromARGB(255, 234, 234, 234),
                          ),
                          child: Stack(
                              alignment: Alignment.bottomCenter,
                              children: [
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Hero(
                                      tag: place['name'],
                                      child: ClipRRect(
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(10)),
                                        child: FancyShimmerImage(
                                          shimmerDuration:
                                              Duration(milliseconds: 500),
                                          errorWidget: Icon(
                                              Icons.error_outline_outlined),
                                          imageUrl: place['asset'],
                                          boxFit: BoxFit.fill,
                                          width: double.infinity,
                                          height: 170.0,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Color.fromRGBO(0, 0, 0, 0.5),
                                        offset: Offset(0, 1),
                                        blurRadius: 5,
                                        spreadRadius: 1,
                                      )
                                    ],
                                  ),
                                  child: Padding(
                                    padding:
                                        const EdgeInsetsDirectional.symmetric(
                                            horizontal: 8.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.4,
                                          child: Text(
                                            place['name'],
                                            maxLines: 1,
                                            style: TextStyle(
                                              fontFamily: "Arial",
                                              fontWeight: FontWeight.w500,
                                              overflow: TextOverflow.ellipsis,
                                              color: Colors.white,
                                              fontSize: 18,
                                            ),
                                          ),
                                        ),
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.location_pin,
                                              color: Colors.white,
                                            ),
                                            Container(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.3,
                                              child: Text(
                                                place['location'],
                                                maxLines: 1,
                                                style: TextStyle(
                                                  fontFamily: "Arial",
                                                  fontWeight: FontWeight.w500,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  color: Colors.white,
                                                  fontSize: 18,
                                                ),
                                              ),
                                            )
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                )
                              ]),
                        ),
                      );
                    },
                  ),
          ]),
        ),
      ),
    );
  }
}
