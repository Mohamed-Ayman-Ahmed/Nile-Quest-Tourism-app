import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:nile_quest/model/hotels_items/hotel.dart';
import 'package:nile_quest/modules/hotel_details_screen/hotel_details.dart';
import 'package:nile_quest/shared/styles/colors.dart';

class Hotels extends StatefulWidget {
  const Hotels({Key? key}) : super(key: key);

  @override
  State<Hotels> createState() => _HotelsState();
}

class _HotelsState extends State<Hotels> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  bool isLoading = true;
  List<HotelsModel> items = [];

  @override
  void initState() {
    super.initState();
    fetchUserProfile();
  }

  Future<void> fetchUserProfile() async {
    User? user = _firebaseAuth.currentUser;
    if (user != null) {
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await _firestore.collection('Hotels').get();
      List<HotelsModel> fetchedItems = [];
      querySnapshot.docs.forEach((doc) {
        fetchedItems.add(
          HotelsModel(
            name: doc.data()['Name'] ?? '',
            images: doc.data()['Images'] ?? '',
            location: doc.data()['Location'] ?? '',
            price: (doc.data()['Room Price'] ?? '').replaceAll(".", "\n"),
            description: doc.data()['Description'] ?? '',
            hotelLink: doc.data()['Hotel Link'] ?? '',
            language: doc.data()['Languages Spoken'] ?? '',
            map: doc.data()['map'] ?? '',
          ),
        );
      });
      setState(() {
        items = fetchedItems;
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 70,
        automaticallyImplyLeading: false,
        title: Stack(children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Hotels',
                style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(Icons.arrow_back_outlined),
              ),
            ],
          ),
        ]),
      ),
      body: Visibility(
        visible: isLoading,
        child: Center(
          child: SpinKitFoldingCube(
            color: mainColor,
            size: 50,
          ),
        ),
        replacement: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ListView.builder(
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    HotelsModel item = items[index];
                    return InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => HotelDetails(
                                      asset: item.images!,
                                      tag: item.name!,
                                      location: item.location!,
                                      description: item.description!,
                                      price: item.price!,
                                      hotelLink: item.hotelLink!,
                                      language: item.language!,
                                      map: item.map!,
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
                        child:
                            Stack(alignment: Alignment.bottomCenter, children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Hero(
                                tag: item.name!,
                                child: ClipRRect(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(10)),
                                    child: FancyShimmerImage(
                                      shimmerDuration:
                                          Duration(milliseconds: 500),
                                      errorWidget:
                                          Icon(Icons.error_outline_outlined),
                                      imageUrl: item.images!,
                                      boxFit: BoxFit.fill,
                                      width: double.infinity,
                                      height: 170.0,
                                    )),
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
                                ]),
                            child: Padding(
                              padding: const EdgeInsetsDirectional.symmetric(
                                  horizontal: 8.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    width:
                                        MediaQuery.of(context).size.width * 0.4,
                                    child: Text(
                                      "${item.name}",
                                      maxLines: 1,
                                      style: TextStyle(
                                          fontFamily: "Arial",
                                          fontWeight: FontWeight.w500,
                                          overflow: TextOverflow.ellipsis,
                                          color: Colors.white,
                                          fontSize: 18),
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.location_pin,
                                        color: Colors.white,
                                      ),
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.3,
                                        child: Text(
                                          "${item.location}",
                                          maxLines: 1,
                                          style: TextStyle(
                                              fontFamily: "Arial",
                                              fontWeight: FontWeight.w500,
                                              overflow: TextOverflow.ellipsis,
                                              color: Colors.white,
                                              fontSize: 18),
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
                  }),
            )
          ],
        ),
      ),
    );
  }
}
