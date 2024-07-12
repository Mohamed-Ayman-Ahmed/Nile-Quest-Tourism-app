/*import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';



class PrefetchImageDemo extends StatefulWidget {
  final String title;

  const PrefetchImageDemo({
    super.key,
    required this.title,
  });

  @override
  State<StatefulWidget> createState() {
    return _PrefetchImageDemoState();
  }
}

class _PrefetchImageDemoState extends State<PrefetchImageDemo> {
  final List<String> images = [
    "assets/images/Abu_Simbel.jpg",
    "assets/images/h.webp",
    "assets/images/p.jpg",
    "assets/images/2.webp",
  ];

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      images.forEach((imageUrl) {
        precacheImage(NetworkImage(imageUrl), context);
      });
    });
    super.initState();
  }

  CarouselController c = CarouselController();
  CarouselController c2 = CarouselController();
  bool isPlay = false;

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    int val = 0;
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.black,
          //Color.fromARGB(255, 30, 26, 26),
          automaticallyImplyLeading: false,
          toolbarHeight: 0.0),
      body: Container(
        color: Colors.black,
        // Color.fromARGB(255, 30, 26, 26),
        child: Stack(
          children: [
            CarouselSlider(
              carouselController: c,
              options: CarouselOptions(
                autoPlay: isPlay,
                onPageChanged: (i, b) {
                  c2.jumpToPage(i);
                  setState(() {});
                },
                height: height,
                viewportFraction: 1.0,
                enlargeCenterPage: true,
              ),
              items: List.generate(
                  images.length,
                  (index) => Container(
                        child: Center(
                            child: Image.asset(
                          images[index],
                          fit: BoxFit.fitWidth,
                          // height: height,
                        )),
                      )),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Align(
                alignment: Alignment.topRight,
                child: Container(
                  decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: //Colors.black,
                          Color.fromARGB(80, 158, 158, 158)),
                  child: IconButton(
                    icon: isPlay == false
                        ? const Icon(
                            Icons.play_arrow,
                            color: Colors.white,
                            size: 40,
                          )
                        : const Icon(
                            Icons.pause,
                            color: Colors.white,
                            size: 40,
                          ),
                    onPressed: () {
                      if (isPlay == false) {
                        isPlay = true;
                        setState(() {});
                      } else {
                        isPlay = false;
                        setState(() {});
                      }
                    },
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Align(
                alignment: Alignment.topLeft,
                child: Container(
                  width: MediaQuery.of(context).size.width * 1,
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(
                          Icons.arrow_back,
                          color: Colors.white,
                          size: 20,
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.6,
                        child: Text(
                          """${widget.title}""",
                          style: TextStyle(
                              color: Colors.white,
                              overflow: TextOverflow.ellipsis,
                              fontWeight: FontWeight.bold,
                              fontSize: 15),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: CarouselSlider.builder(
                  itemCount: images.length,
                  carouselController: c2,
                  options: CarouselOptions(
                    autoPlay: isPlay,
                    autoPlayAnimationDuration: Duration(seconds: 100),
                    autoPlayCurve: Curves.easeInQuart,
                    onPageChanged: (i, b) {
                      print(i);
                      setState(() {
                        val = i;
                      });
                      c.jumpToPage(i);
                    },
                    aspectRatio: 3.3,
                    viewportFraction: 0.4,
                    enlargeCenterPage: true,
                  ),
                  itemBuilder: (context, index, realIdx) {
                    return Image.asset(images[index],
                        fit: BoxFit.cover, width: 200);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}*/
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:nile_quest/shared/styles/colors.dart';

class PrefetchImageDemo extends StatefulWidget {
  final String title;

  const PrefetchImageDemo({
    Key? key,
    required this.title,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _PrefetchImageDemoState();
  }
}

class _PrefetchImageDemoState extends State<PrefetchImageDemo> {
  List<String> images = [];
  bool isloading = true;

  @override
  void initState() {
    super.initState();
    fetchImages();
  }

  /*Future<void> fetchImages() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('Alexandria')
        .where('Name', isEqualTo: widget.title)
        .get();

    List<String> imageURLs = [];
    querySnapshot.docs.forEach((doc) {
      imageURLs.add(doc['Images']);
      imageURLs.add(doc['Images2']);
      imageURLs.add(doc['Images3']);
    });

    setState(() {
      images = imageURLs;
      isloading = false;
    });
  }*/
  Future<void> fetchImages() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('Cairo')
        .where('Name', isEqualTo: widget.title)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      var document = querySnapshot.docs.first;
      images = [
        document['Images'],
        document['Images2'],
        document['Images3'],
      ];
    } else {
      querySnapshot = await FirebaseFirestore.instance
          .collection('Alexandria')
          .where('Name', isEqualTo: widget.title)
          .get();
      if (querySnapshot.docs.isNotEmpty) {
        var document = querySnapshot.docs.first;
        images = [
          document['Images'],
          document['Images2'],
          document['Images3'],
        ];
      } else {
        querySnapshot = await FirebaseFirestore.instance
            .collection('Aswan')
            .where('Name', isEqualTo: widget.title)
            .get();

        if (querySnapshot.docs.isNotEmpty) {
          var document = querySnapshot.docs.first;
          images = [
            document['Images'],
            document['Images2'],
            document['Images3'],
          ];
        } else {
          querySnapshot = await FirebaseFirestore.instance
              .collection('Luxor')
              .where('Name', isEqualTo: widget.title)
              .get();

          if (querySnapshot.docs.isNotEmpty) {
            var document = querySnapshot.docs.first;
            images = [
              document['Images'],
              document['Images2'],
              document['Images3'],
            ];
          } else {
            // Try fetching from Sinai collection
            querySnapshot = await FirebaseFirestore.instance
                .collection('south sinai')
                .where('Name', isEqualTo: widget.title)
                .get();

            if (querySnapshot.docs.isNotEmpty) {
              var document = querySnapshot.docs.first;
              images = [
                document['Images'],
                document['Images2'],
                document['Images3'],
              ];
            } else {
              // Try fetching from Collection6
              querySnapshot = await FirebaseFirestore.instance
                  .collection('Matruh')
                  .where('Name', isEqualTo: widget.title)
                  .get();

              if (querySnapshot.docs.isNotEmpty) {
                var document = querySnapshot.docs.first;
                images = [
                  document['Images'],
                  document['Images2'],
                  document['Images3'],
                ];
              } else {
                // Try fetching from Collection7
                querySnapshot = await FirebaseFirestore.instance
                    .collection('Sharm El-sheikh')
                    .where('Name', isEqualTo: widget.title)
                    .get();

                if (querySnapshot.docs.isNotEmpty) {
                  var document = querySnapshot.docs.first;
                  images = [
                    document['Images'],
                    document['Images2'],
                    document['Images3'],
                  ];
                } /*else {
                  // Try fetching from Collection7
                  querySnapshot = await FirebaseFirestore.instance
                      .collection('Hotels')
                      .where('Name', isEqualTo: widget.title)
                      .get();

                  if (querySnapshot.docs.isNotEmpty) {
                    var document = querySnapshot.docs.first;
                    images = [
                      document['Images'],
                      document['Images2'],
                      document['Images3'],
                    ];
                  }
                }*/
              }
            }
          }
        }
      }
    }

    setState(() {
      isloading = false;
    });
  }

  CarouselController c = CarouselController();
  CarouselController c2 = CarouselController();
  bool isPlay = false;

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    // ignore: unused_local_variable
    int val = 0;
    return Scaffold(
      /* appBar: AppBar(
        backgroundColor: Colors.black,
        automaticallyImplyLeading: false,
        toolbarHeight: 0.0,
      ),*/
      body: Container(
        color: Colors.black,
        child: Visibility(
          visible: isloading,
          child: Center(
            child: SpinKitFoldingCube(
              color: mainColor,
              size: 50,
            ),
          ),
          replacement: Padding(
            padding: const EdgeInsets.only(top: 40.0),
            child: Stack(
              children: [
                CarouselSlider(
                  carouselController: c,
                  options: CarouselOptions(
                    autoPlay: isPlay,
                    onPageChanged: (i, b) {
                      c2.jumpToPage(i);
                      setState(() {});
                    },
                    height: height,
                    viewportFraction: 1.0,
                    enlargeCenterPage: true,
                  ),
                  items: List.generate(
                    images.length,
                    (index) => Container(
                      child: Center(
                        child: Image.network(
                          images[index],
                          fit: BoxFit.fitWidth,
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Align(
                    alignment: Alignment.topRight,
                    child: Container(
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color.fromARGB(80, 158, 158, 158),
                      ),
                      child: IconButton(
                        icon: isPlay == false
                            ? const Icon(
                                Icons.play_arrow,
                                color: Colors.white,
                                size: 40,
                              )
                            : const Icon(
                                Icons.pause,
                                color: Colors.white,
                                size: 40,
                              ),
                        onPressed: () {
                          if (isPlay == false) {
                            isPlay = true;
                            setState(() {});
                          } else {
                            isPlay = false;
                            setState(() {});
                          }
                        },
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Container(
                      width: MediaQuery.of(context).size.width * 1,
                      child: Row(
                        children: [
                          IconButton(
                            icon: const Icon(
                              Icons.arrow_back,
                              color: Colors.white,
                              size: 20,
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width * 0.6,
                            child: Text(
                              widget.title,
                              style: const TextStyle(
                                color: Colors.white,
                                overflow: TextOverflow.ellipsis,
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: CarouselSlider.builder(
                      itemCount: images.length,
                      carouselController: c2,
                      options: CarouselOptions(
                        autoPlay: isPlay,
                        autoPlayAnimationDuration: const Duration(seconds: 100),
                        autoPlayCurve: Curves.easeInQuart,
                        onPageChanged: (i, b) {
                          setState(() {
                            val = i;
                          });
                          c.jumpToPage(i);
                        },
                        aspectRatio: 3.3,
                        viewportFraction: 0.4,
                        enlargeCenterPage: true,
                      ),
                      itemBuilder: (context, index, realIdx) {
                        return Image.network(
                          images[index],
                          fit: BoxFit.cover,
                          width: 200,
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
