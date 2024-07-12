
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:nile_quest/modules/chat_ai/chat_ai.dart';
import 'package:nile_quest/services/toast.dart';
import 'package:nile_quest/shared/styles/colors.dart';
import 'package:url_launcher/link.dart';

class HotelDetails extends StatefulWidget {
  HotelDetails({
    super.key,
    required this.asset,
    required this.tag,
    required this.location,
    required this.description,
    required this.price,
    required this.hotelLink,
    required this.language,
    required this.map,
  });
  final String asset;
  final String tag;
  final String location;
  final String description;
  final String price;
  final String hotelLink;
  final String language;
  final String map;
  @override
  State<HotelDetails> createState() => _HotelDetailsState();
}

class _HotelDetailsState extends State<HotelDetails> {
  User? _currentUser;
  int maxLines = 5;
  bool _isfav = false;
  bool isExpanded = false;
  double _ratingValue = 0;
  String _reportText = '';
  final CollectionReference ratingsCollection =
      FirebaseFirestore.instance.collection('ratings');

  @override
  void initState() {
    super.initState();
    _getCurrentUser();
    _checkIfFavorite();
  }

  Future<void> _checkIfFavorite() async {
    if (_currentUser != null) {
      final favoriteRef = FirebaseFirestore.instance
          .collection('users')
          .doc(_currentUser!.uid)
          .collection('favoritehotels')
          .doc(widget.tag);

      final favoriteDoc = await favoriteRef.get();
      setState(() {
        _isfav = favoriteDoc.exists;
      });
    }
  }

  set isfav(bool value) {
    if (_currentUser != null) {
      final favoritesRef = FirebaseFirestore.instance
          .collection('users')
          .doc(_currentUser!.uid)
          .collection('favoritehotels')
          .doc(widget.tag);
      value
          ? favoritesRef.set({
              'name': widget.tag,
              'asset': widget.asset,
              'location': widget.location,
              'description': widget.description,
              'link': widget.hotelLink,
              'price': widget.price,
              'language': widget.language,
              'map': widget.map,
            })
          : favoritesRef.delete();
    }
    setState(() {
      _isfav = value;
    });
  }

  Future<void> _getCurrentUser() async {
    final user = FirebaseAuth.instance.currentUser;
    setState(() {
      _currentUser = user;
    });
  }

  void _submitRatingAndReport() {
    if (_ratingValue == 0) {
      showToast(message: 'Please provide a rating');
      return;
    } else {
      ratingsCollection.add({
        'rating': _ratingValue,
        'report': _reportText,
        'itemid': widget.tag,
      }).then((value) {
        _ratingValue = 0;
        _reportText = '';
      });
      showToast(message: 'Thanks For Your Feedback');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBody: true,
        floatingActionButton: ClipRRect(
          borderRadius: BorderRadius.circular(20.0),
          child: Container(
            width: 50,
            height: 50,
            child: FloatingActionButton(
                backgroundColor: mainColor,
                onPressed: () {
                  showCupertinoModalPopup(
                    context: context,
                    builder: (BuildContext context) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(30.0),
                              topRight: Radius.circular(30.0)),
                          child:
                              Stack(alignment: Alignment.topRight, children: [
                            Container(
                              width: MediaQuery.of(context).size.width * 1,
                              height: MediaQuery.of(context).size.height * 0.8,
                              child: ChatAi(),
                            ),
                            IconButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              icon: Icon(Icons.clear, color: Colors.grey),
                            ),
                          ]),
                        ),
                      );
                    },
                  );
                },
                child: Icon(
                  Icons.bolt_outlined,
                  size: 30.0,
                  color: Colors.white,
                )),
          ),
        ),
        body: CustomScrollView(slivers: <Widget>[
          SliverAppBar(
            expandedHeight: 300.0,
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                children: [
                  Hero(
                    tag: widget.tag,
                    child: ClipRRect(
                      child: FancyShimmerImage(
                        shimmerDuration: Duration(milliseconds: 500),
                        errorWidget: Icon(Icons.error_outline_outlined),
                        imageUrl: "${widget.asset}",
                        boxFit: BoxFit.fill,
                        width: double.infinity,
                        height: 400,
                      ),
                    ),
                  ),
                  Positioned(
                      bottom: 7,
                      right: 7,
                      child: Container(
                        width: 40,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle, color: Colors.grey),
                        child: IconButton(
                          icon: Icon(
                            Icons.photo_library_outlined,
                            color: Colors.white,
                            size: 25,
                          ),
                          onPressed: () {
                            /* Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => PrefetchImageDemo(
                                      title: "${widget.tag}",
                                    )));*/
                          },
                        ),
                      )),
                ],
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                SizedBox(
                  height: 15,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsetsDirectional.symmetric(
                          horizontal: 15.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width * 0.7,
                            child: Text(
                              "${widget.tag}",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 20,
                                  letterSpacing: 1,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Arial'),
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              setState(() {
                                isfav = !_isfav;
                              });
                            },
                            icon: _isfav
                                ? Icon(
                                    Icons.favorite,
                                    color: mainColor,
                                    size: 30,
                                  )
                                : Icon(
                                    Icons.favorite_border_outlined,
                                    color: mainColor,
                                    size: 30,
                                  ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 5.0,
                    ),
                    Padding(
                      padding: const EdgeInsetsDirectional.symmetric(
                          horizontal: 15.0),
                      child: Text(
                        "${widget.location}",
                        style: TextStyle(
                            fontFamily: 'Arial',
                            color: const Color.fromARGB(255, 133, 131, 131),
                            fontSize: 15,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                    SizedBox(
                      height: 15.0,
                    ),
                    Padding(
                      padding: const EdgeInsetsDirectional.symmetric(
                          horizontal: 15.0),
                      child: Container(
                        width: double.infinity,
                        height: 0.3,
                        color: Colors.grey,
                      ),
                    ),
                    SizedBox(
                      height: 15.0,
                    ),
                    Padding(
                      padding: const EdgeInsetsDirectional.symmetric(
                          horizontal: 15.0),
                      child: Row(
                        children: [
                          Container(
                            width: 40,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle, color: mainColor),
                            child: IconButton(
                              icon: Icon(
                                Icons.description_outlined,
                                color: Colors.white,
                                size: 25,
                              ),
                              onPressed: () {},
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            "Description",
                            style: TextStyle(
                                fontFamily: 'Arial',
                                letterSpacing: 1,
                                color: Colors.black,
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 5.0,
                    ),
                    Padding(
                      padding: const EdgeInsetsDirectional.symmetric(
                          horizontal: 10.0),
                      child: AnimatedCrossFade(
                        duration: Duration(milliseconds: 150),
                        crossFadeState: isExpanded
                            ? CrossFadeState.showSecond
                            : CrossFadeState.showFirst,
                        firstChild: Container(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            '${widget.description}',
                            style: TextStyle(
                              fontFamily: 'Arial',
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                            maxLines: 5,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        secondChild: Container(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            '${widget.description}',
                            style: TextStyle(
                              fontFamily: 'Arial',
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                            maxLines: 1000,
                            overflow: TextOverflow.visible,
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          isExpanded = !isExpanded;
                        });
                      },
                      child: Padding(
                        padding: const EdgeInsetsDirectional.symmetric(
                            horizontal: 15.0),
                        child: Text(
                          isExpanded ? "Show Less" : "Show More...",
                          style: TextStyle(
                            fontFamily: 'Arial',
                            decoration: TextDecoration.underline,
                            decorationColor: mainColor,
                            color: mainColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 15.0,
                    ),
                    Padding(
                      padding: const EdgeInsetsDirectional.symmetric(
                          horizontal: 15.0),
                      child: Container(
                        width: double.infinity,
                        height: 0.3,
                        color: Colors.grey,
                      ),
                    ),
                    SizedBox(
                      height: 15.0,
                    ),
                    Padding(
                      padding: const EdgeInsetsDirectional.symmetric(
                          horizontal: 15.0),
                      child: Link(
                        target: LinkTarget.blank,
                        uri: Uri.parse("${widget.hotelLink}"),
                        builder: (context, followlink) => GestureDetector(
                          onTap: followlink,
                          child: Row(
                            children: [
                              Container(
                                width: 40,
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle, color: mainColor),
                                child: IconButton(
                                  icon: Icon(
                                    Icons.link,
                                    color: Colors.white,
                                    size: 25,
                                  ),
                                  onPressed: () {
                                    followlink!();
                                  },
                                ),
                              ),
                              SizedBox(
                                width: 10.0,
                              ),
                              Text("Visit Hotel Website",
                                  style: TextStyle(
                                    fontFamily: "Arial",
                                    color: Colors.black,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 20,
                                    decoration: TextDecoration.underline,
                                  )),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 15.0,
                    ),
                    Padding(
                      padding: const EdgeInsetsDirectional.symmetric(
                          horizontal: 15.0),
                      child: Container(
                        width: double.infinity,
                        height: 0.3,
                        color: Colors.grey,
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Padding(
                      padding: const EdgeInsetsDirectional.symmetric(
                          horizontal: 15.0),
                      child: Link(
                        uri: Uri.parse(
                          "${widget.map}",
                        ),
                        target: LinkTarget.self,
                        builder: (context, FollowLink) => GestureDetector(
                          onTap: () {
                            FollowLink!();
                          },
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Container(
                                    width: 40,
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: mainColor),
                                    child: IconButton(
                                      icon: Icon(
                                        Icons.place,
                                        color: Colors.white,
                                        size: 25,
                                      ),
                                      onPressed: () {
                                        FollowLink!();
                                      },
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  const Text("Location On Map",
                                      style: TextStyle(
                                        fontFamily: "Arial",
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20,
                                      )),
                                ],
                              ),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(20.0),
                                child: Image.asset(
                                  'assets/images/map3.jpg',
                                  fit: BoxFit.fitWidth,
                                  height: 200,
                                  width: double.infinity,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 15.0,
                    ),
                    Padding(
                      padding: const EdgeInsetsDirectional.symmetric(
                          horizontal: 15.0),
                      child: Container(
                        width: double.infinity,
                        height: 0.3,
                        color: Colors.grey,
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Padding(
                      padding: const EdgeInsetsDirectional.symmetric(
                          horizontal: 15.0),
                      child: Row(
                        children: [
                          Container(
                            width: 40,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle, color: mainColor),
                            child: IconButton(
                              icon: Icon(
                                Icons.language_outlined,
                                color: Colors.white,
                                size: 25,
                              ),
                              onPressed: () {},
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            "Spoken Languages",
                            style: TextStyle(
                                fontFamily: 'Arial',
                                letterSpacing: 1,
                                color: Colors.black,
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Padding(
                        padding: const EdgeInsetsDirectional.symmetric(
                            horizontal: 15.0),
                        child: Text(
                          '${widget.language}',
                          style: TextStyle(
                              fontFamily: 'Arial',
                              color: Colors.black,
                              fontSize: 15,
                              fontWeight: FontWeight.w500),
                        )),
                    SizedBox(
                      height: 15.0,
                    ),
                    Padding(
                      padding: const EdgeInsetsDirectional.symmetric(
                          horizontal: 15.0),
                      child: Container(
                        width: double.infinity,
                        height: 0.3,
                        color: Colors.grey,
                      ),
                    ),
                    SizedBox(
                      height: 15.0,
                    ),
                    Padding(
                      padding: const EdgeInsetsDirectional.symmetric(
                          horizontal: 15.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 40,
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle, color: mainColor),
                                child: IconButton(
                                  icon: Icon(
                                    Icons.price_change_outlined,
                                    color: Colors.white,
                                    size: 25,
                                  ),
                                  onPressed: () {},
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              const Text("Room Pricing",
                                  style: TextStyle(
                                    fontFamily: 'Arial',
                                    letterSpacing: 1,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                  )),
                            ],
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Padding(
                              padding: const EdgeInsetsDirectional.symmetric(
                                  horizontal: 5.0),
                              child: Text('${widget.price}',
                                  style: TextStyle(
                                      fontFamily: 'Arial',
                                      color: Colors.black,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500))),
                          SizedBox(
                            height: 15.0,
                          ),
                          Padding(
                            padding: const EdgeInsetsDirectional.symmetric(
                                horizontal: 15.0),
                            child: Container(
                              width: double.infinity,
                              height: 0.3,
                              color: Colors.grey,
                            ),
                          ),
                          SizedBox(
                            height: 15.0,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    width: 40,
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: mainColor),
                                    child: IconButton(
                                      icon: Icon(
                                        Icons.rate_review_outlined,
                                        color: Colors.white,
                                        size: 25,
                                      ),
                                      onPressed: () {},
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  const Text("Rating",
                                      style: TextStyle(
                                        fontFamily: 'Arial',
                                        letterSpacing: 1,
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20,
                                      )),
                                ],
                              ),
                              Center(
                                child: RatingBar.builder(
                                    initialRating: _ratingValue,
                                    minRating: 0,
                                    direction: Axis.horizontal,
                                    allowHalfRating: true,
                                    itemCount: 5,
                                    itemPadding:
                                        EdgeInsets.symmetric(horizontal: 5.0),
                                    itemBuilder: (context, _) => Icon(
                                          Icons.star,
                                          color: mainColor,
                                        ),
                                    onRatingUpdate: (value) {
                                      _ratingValue = value;
                                    }),
                              ),
                              SizedBox(
                                height: 15.0,
                              ),
                              Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10.0),
                                    color: searchColor),
                                child: TextFormField(
                                    cursorColor: mainColor,
                                    keyboardType: TextInputType.name,
                                    onChanged: (value) {
                                      _reportText = value;
                                    },
                                    decoration: InputDecoration(
                                      prefixIcon: Icon(
                                          Icons.rate_review_outlined,
                                          color: Colors.grey),
                                      hintText: 'Send Report',
                                      hintStyle: TextStyle(color: Colors.grey),
                                      border: OutlineInputBorder(
                                          borderSide: BorderSide.none),
                                    )),
                              ),
                              SizedBox(
                                height: 20.0,
                              ),
                              Container(
                                height: 50.0,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5.0),
                                  color: mainColor,
                                ),
                                child: MaterialButton(
                                  onPressed: () {
                                    _submitRatingAndReport();
                                  },
                                  child: Text(
                                    'Submit',
                                    style: TextStyle(
                                        fontSize: 20.0,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 30.0,
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          )
        ]));
  }
}
