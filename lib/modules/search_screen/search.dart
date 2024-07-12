import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nile_quest/modules/details_screen/details_screen.dart';
import 'package:nile_quest/modules/hotel_details_screen/hotel_details.dart';
import 'package:nile_quest/shared/styles/colors.dart';
import 'dart:async';

class Search extends StatefulWidget {
  const Search({Key? key}) : super(key: key);

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  TextEditingController _searchController = TextEditingController();
  List<String> searchResults = [];
  Timer? _debounce;

  @override
  void dispose() {
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void searchPlaces(String searchText) {
    setState(() {
      searchResults.clear(); // Clear existing results
    });

    if (searchText.isEmpty) return;

    final List<Future<QuerySnapshot>> futures = [
      FirebaseFirestore.instance.collection('Alexandria').get(),
      FirebaseFirestore.instance.collection('Aswan').get(),
      FirebaseFirestore.instance.collection('Cairo').get(),
      FirebaseFirestore.instance.collection('Luxor').get(),
      FirebaseFirestore.instance.collection('Matruh').get(),
      FirebaseFirestore.instance.collection('south sinai').get(),
      FirebaseFirestore.instance.collection('Sharm El-sheikh').get(),
      FirebaseFirestore.instance.collection('Hotels').get(),
    ];

    Future.wait(futures).then((List<QuerySnapshot> results) {
      setState(() {
        for (QuerySnapshot querySnapshot in results) {
          searchResults.addAll(querySnapshot.docs
              .map((doc) => doc['Name'] as String)
              .where((name) =>
                  name.toLowerCase().contains(searchText.toLowerCase()))
              .toList());
        }
      });
    }).catchError((error) {
      print("Error searching across collections: $error");
    });
  }

  void _onTextChanged(String value) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      searchPlaces(value);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 45.0,
        automaticallyImplyLeading: false,
        title: Stack(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.search, color: mainColor, size: 40.0),
                Text(
                  'Search',
                  style: TextStyle(
                    fontSize: 30.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
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
          ],
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(
            height: 20.0,
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Container(
              height: 53.0,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  color: searchColor),
              child: TextFormField(
                autofocus: true,
                controller: _searchController,
                cursorColor: mainColor,
                keyboardType: TextInputType.name,
                onChanged: _onTextChanged,
                decoration: InputDecoration(
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                          icon: Icon(Icons.clear, color: Colors.grey),
                          onPressed: () {
                            setState(() {
                              _searchController.clear();
                              searchResults.clear();
                            });
                          },
                        )
                      : Icon(Icons.search, color: Colors.grey),
                  hintText: 'Find Places',
                  hintStyle: TextStyle(color: Colors.grey),
                  border: OutlineInputBorder(borderSide: BorderSide.none),
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: searchResults.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(searchResults[index]),
                  onTap: () {
                    _onPlaceSelected(searchResults[index]);
                    onPlaceSelected(searchResults[index]);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _onPlaceSelected(String placeName) {
    // List of collection names
    List<String> collectionNames = [
      'Alexandria',
      'Aswan',
      'Cairo',
      'Luxor',
      'Matruh',
      'south sinai',
      'Sharm El-sheikh'
    ];

    // Iterate over each collection name
    for (String collectionName in collectionNames) {
      FirebaseFirestore.instance
          .collection(collectionName)
          .doc(placeName)
          .get()
          .then((snapshot) {
        if (snapshot.exists) {
          var data = snapshot.data();
          var asset = data?['Images'] ?? data?['Images '] ?? '';
          var location = data?['Location'] ?? data?['Location '] ?? '';
          var price = data?['Ticket Price'] ?? data?['Ticket Price '] ?? '';
          var des = data?['Description'] ??
              data?['Description '] ??
              data?['Full Description'] ??
              '';
          var time = data?['Opening Hours'] ?? data?['Opening Hours '] ?? '';
          Navigator.push(
            context,
            PageRouteBuilder(
              transitionDuration: Duration(milliseconds: 500),
              pageBuilder: (context, animation, secondaryAnimation) =>
                  DetailsScreen(
                tag: placeName,
                price: price.replaceAll(".", "\n"),
                asset: asset,
                location: location,
                description: des,
                time: time.replaceAll(".", "\n"),
                history: data?['history'] ?? '',
                map: data?['map'],
              ),
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
        }
      }).catchError((error) {
        print(
            "Error getting place details from $collectionName collection: $error");
      });
    }
  }

  void onPlaceSelected(String placeName) {
    // List of collection names
    List<String> collectionNames = [
      'Hotels',
    ];

    // Iterate over each collection name
    for (String collectionName in collectionNames) {
      FirebaseFirestore.instance
          .collection(collectionName)
          .doc(placeName)
          .get()
          .then((snapshot) {
        if (snapshot.exists) {
          var data = snapshot.data();
          var asset = data?['Images'] ?? data?['Images '] ?? '';
          var location = data?['Location'] ?? data?['Location '] ?? '';
          var price = data?['Room Price'] ?? data?['Room Price'] ?? '';
          var des = data?['Description'] ??
              data?['Description '] ??
              data?['Full Description'] ??
              '';
          var link = data?['Hotel Link'] ?? data?['Hotel Link'] ?? '';
          var lang =
              data?['Languages Spoken'] ?? data?['Languages Spoken'] ?? '';
          Navigator.push(
            context,
            PageRouteBuilder(
              transitionDuration: Duration(milliseconds: 500),
              pageBuilder: (context, animation, secondaryAnimation) =>
                  HotelDetails(
                tag: placeName,
                price: price.replaceAll(".", "\n"),
                asset: asset,
                location: location,
                description: des,
                hotelLink: link,
                language: lang,
                map: data?['map'],
              ),
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
        }
      }).catchError((error) {
        print(
            "Error getting place details from $collectionName collection: $error");
      });
    }
  }
}
