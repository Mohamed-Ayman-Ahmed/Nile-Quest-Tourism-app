import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:nile_quest/model/places_items/places.dart';
import 'package:nile_quest/modules/details_screen/details_screen.dart';
import 'package:nile_quest/shared/styles/colors.dart';

class Beach extends StatefulWidget {
  const Beach({Key? key}) : super(key: key);

  @override
  State<Beach> createState() => _BeachState();
}

class _BeachState extends State<Beach> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  bool isloading = true;

  List<Places> items = [];

  @override
  void initState() {
    super.initState();
    fetchTemples(); // Call the method to fetch temple data.
  }

  Future<void> fetchTemples() async {
    User? user = _firebaseAuth.currentUser;
    if (user != null) {
      // Fetch data from 'Aswan' collection
      QuerySnapshot<Map<String, dynamic>> AswanSnapshot = await _firestore
          .collection('Aswan')
          .where('beach', isEqualTo: true)
          .get();

      // Fetch data from 'Cairo' collection
      QuerySnapshot<Map<String, dynamic>> CairoSnapshot = await _firestore
          .collection('Cairo')
          .where('beach', isEqualTo: true)
          .get();

      // Fetch data from 'Alex' collection
      QuerySnapshot<Map<String, dynamic>> AlexandriaSnapshot = await _firestore
          .collection('Alexandria')
          .where('beach', isEqualTo: true)
          .get();
      // Fetch data from 'Alex' collection
      QuerySnapshot<Map<String, dynamic>> LuxorSnapshot = await _firestore
          .collection('Luxor')
          .where('beach', isEqualTo: true)
          .get();
      // Fetch data from 'Alex' collection
      QuerySnapshot<Map<String, dynamic>> MatruhSnapshot = await _firestore
          .collection('Matruh')
          .where('beach', isEqualTo: true)
          .get();
      // Fetch data from 'Alex' collection
      QuerySnapshot<Map<String, dynamic>> SharmElsheikhSnapshot =
          await _firestore
              .collection('Sharm El-sheikh')
              .where('beach', isEqualTo: true)
              .get();
      // Fetch data from 'Alex' collection
      QuerySnapshot<Map<String, dynamic>> southsinaiSnapshot = await _firestore
          .collection('south sinai')
          .where('beach', isEqualTo: true)
          .get();
      List<Places> fetchedItems = [];
      AswanSnapshot.docs.forEach((doc) {
        fetchedItems.add(
          Places(
            name: doc.data()['Name'] ?? '',
            images: doc.data()['Images'] ?? '',
            location: doc.data()['Location'] ?? '',
            price: (doc.data()['Ticket Price'] ?? '').replaceAll(".", "\n"),
            description: doc.data()['Description'] ?? '',
            history: doc.data()['History'] ?? '',
            openingHours:
                (doc.data()['Opening Hours'] ?? '').replaceAll(".", "\n"),
            Map: doc.data()['map'] ?? '',
          ),
        );
      });
      CairoSnapshot.docs.forEach((doc) {
        fetchedItems.add(
          Places(
            name: doc.data()['Name'] ?? '',
            images: doc.data()['Images'] ?? '',
            location: doc.data()['Location'] ?? '',
            price: (doc.data()['Ticket Price'] ?? '').replaceAll(".", "\n"),
            description: doc.data()['Description'] ?? '',
            history: doc.data()['History'] ?? '',
            openingHours:
                (doc.data()['Opening Hours'] ?? '').replaceAll(".", "\n"),
            Map: doc.data()['map'] ?? '',
          ),
        );
      });
      AlexandriaSnapshot.docs.forEach((doc) {
        fetchedItems.add(
          Places(
            name: doc.data()['Name'] ?? '',
            images: doc.data()['Images'] ?? '',
            location: doc.data()['Location'] ?? '',
            price: (doc.data()['Ticket Price'] ?? '').replaceAll(".", "\n"),
            description: doc.data()['Description'] ?? '',
            history: doc.data()['History'] ?? '',
            openingHours:
                (doc.data()['Opening Hours'] ?? '').replaceAll(".", "\n"),
            Map: doc.data()['map'] ?? '',
          ),
        );
      });
      LuxorSnapshot.docs.forEach((doc) {
        fetchedItems.add(
          Places(
            name: doc.data()['Name'] ?? '',
            images: doc.data()['Images'] ?? '',
            location: doc.data()['Location '] ?? '',
            price: (doc.data()['Ticket Price '] ?? '').replaceAll(".", "\n"),
            description: doc.data()['Description'] ?? '',
            history: doc.data()['History'] ?? '',
            openingHours:
                (doc.data()['Opening Hours'] ?? '').replaceAll(".", "\n"),
            Map: doc.data()['map'] ?? '',
          ),
        );
      });
      MatruhSnapshot.docs.forEach((doc) {
        fetchedItems.add(
          Places(
            name: doc.data()['Name'] ?? '',
            images: doc.data()['Images'] ?? '',
            location: doc.data()['Location'] ?? '',
            price: (doc.data()['Ticket Price'] ?? '').replaceAll(".", "\n"),
            description: doc.data()['Description'] ?? '',
            history: doc.data()['History'] ?? '',
            openingHours:
                (doc.data()['Opening Hours'] ?? '').replaceAll(".", "\n"),
            Map: doc.data()['map'] ?? '',
          ),
        );
      });
      SharmElsheikhSnapshot.docs.forEach((doc) {
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
      southsinaiSnapshot.docs.forEach((doc) {
        fetchedItems.add(
          Places(
            name: doc.data()['Name'] ?? '',
            images: doc.data()['Images'] ?? '',
            location: doc.data()['Location '] ?? '',
            price: (doc.data()['Ticket Price'] ?? '').replaceAll(".", "\n"),
            description: doc.data()['Description'] ?? '',
            history: doc.data()['History'] ?? '',
            openingHours:
                (doc.data()['Opening Hours'] ?? '').replaceAll(".", "\n"),
            Map: doc.data()['map'] ?? '',
          ),
        );
      });
      setState(() {
        items = fetchedItems;
        isloading = false;
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
                'Beaches',
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
        visible: isloading,
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
                                  ),
                                  /* Image.asset(
                                    item.images!,
                                    fit: BoxFit.fill,
                                    width: double.infinity,
                                    height: 170.0,
                                  ),*/
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
                                ]),
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10.0),
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
