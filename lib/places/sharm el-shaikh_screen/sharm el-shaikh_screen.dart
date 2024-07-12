import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:nile_quest/model/places_items/places.dart';
import 'package:nile_quest/modules/details_screen/details_screen.dart';

class Sharm extends StatefulWidget {
  const Sharm({super.key});

  @override
  State<Sharm> createState() => _SharmState();
}

class _SharmState extends State<Sharm> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  List<Places> items = [];

  @override
  void initState() {
    super.initState();
    fetchUserProfile();
  }

  Future<void> fetchUserProfile() async {
    User? user = _firebaseAuth.currentUser;
    if (user != null) {
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await _firestore.collection('Sharm El-sheikh').get();
      List<Places> fetchedItems = [];
      querySnapshot.docs.forEach((doc) {
        fetchedItems.add(
          Places(
            name: doc.data()['Name'] ?? '',
            images: doc.data()['Images'] ?? '',
            location: doc.data()['Location'] ?? '',
            price: (doc.data()['Ticket Price'] ?? '').replaceAll(".", "\n"),
            description: doc.data()['Full Description'] ?? '',
            history: doc.data()['History'] ?? '',
            openingHours:
                (doc.data()['Opening Hours'] ?? '').replaceAll(".", "\n"),
            Map: doc.data()['map'] ?? '',
          ),
        );
      });
      setState(() {
        items = fetchedItems;
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
                'Sharm El-Shaikh',
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
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: ListView.builder(
                itemCount: items.length,
                itemBuilder: (context, index) {
                  Places item = items[index];
                  return InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => DetailsScreen(
                                    asset: item.images!,
                                    tag: item.name!,
                                    location: item.location!,
                                    description: item.description!,
                                    history: item.history!,
                                    time: item.openingHours!,
                                    price: item.price!,
                                    map: item.Map!,
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
                            tag: item.name!,
                            child: ClipRRect(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(10)),
                              child: FancyShimmerImage(
                                shimmerDuration: Duration(milliseconds: 500),
                                errorWidget: Icon(Icons.error_outline_outlined),
                                imageUrl: item.images!,
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
                            padding:
                                const EdgeInsets.symmetric(horizontal: 10.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.4,
                                  child: Text(
                                    "${item.name}",
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
                                      width: MediaQuery.of(context).size.width *
                                          0.3,
                                      child: Text(
                                        "${item.location}",
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
                }),
          )
        ],
      ),
    );
  }
}
