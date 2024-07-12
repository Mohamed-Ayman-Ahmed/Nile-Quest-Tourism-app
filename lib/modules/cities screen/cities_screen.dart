import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:nile_quest/model/cities_items/citiesitems.dart';
import 'package:nile_quest/places/alex_screen/alex_screen.dart';
import 'package:nile_quest/places/aswan_screen/aswan_screen.dart';
import 'package:nile_quest/places/cairo_screen/cairo_screen.dart';
import 'package:nile_quest/places/luxor_screen/luxor_screen.dart';
import 'package:nile_quest/places/matruh_screen/matruh_screen.dart';
import 'package:nile_quest/places/sharm%20el-shaikh_screen/sharm%20el-shaikh_screen.dart';
import 'package:nile_quest/places/sinai_screen/sinai_screen.dart';
import '../../shared/styles/colors.dart';

class CitiesScreen extends StatefulWidget {
  @override
  State<CitiesScreen> createState() => _CitiesScreenState();
}

class _CitiesScreenState extends State<CitiesScreen> {
  bool loading = false;

  List<Cities> item = [
    Cities(name: 'Alexandria', images: 'assets/images/alex.jpg'),
    Cities(name: 'Cairo', images: 'assets/images/cairo.jpg'),
    Cities(name: 'Matruh', images: 'assets/images/matruh.jpg'),
    Cities(name: 'Luxor', images: 'assets/images/luxor.jpg'),
    Cities(name: 'Aswan', images: 'assets/images/aswan.jpg'),
    Cities(name: 'Sharm El-Shaikh', images: 'assets/images/sharm.jpg'),
    Cities(name: 'South Sinai', images: 'assets/images/South Sinai .jpg'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 70.0,
        title: Text(
          'Cities',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        automaticallyImplyLeading: false,
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
                    loading = true;
                  });
                  await Future.delayed(Duration(seconds: 1));
                  setState(() {
                    loading = false;
                  });
                },
                icon: Icon(Icons.refresh),
                color: Colors.white,
                iconSize: 30.0,
              ),
            ),
          )
        ],
      ),
      body: Container(
          color: Color.fromARGB(0, 255, 255, 255),
          child: loading
              ? Center(
                  child: SpinKitFoldingCube(
                  color: mainColor,
                  size: 50,
                ))
              : ListView.separated(
                  scrollDirection: Axis.vertical,
                  itemBuilder: (context, index) =>
                      buildcities(item[index], index),
                  separatorBuilder: (context, index) => SizedBox(height: 5.0),
                  itemCount: item.length)),
    );
  }

  Widget buildcities(Cities items, int index) => GestureDetector(
        onTap: () {
          switch (index) {
            case 0:
              Navigator.push(
                context,
                PageRouteBuilder(
                  transitionDuration: Duration(milliseconds: 500),
                  pageBuilder: (context, animation, secondaryAnimation) =>
                      Alex(),
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
                      Cairo(),
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
                      Matruh(),
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
                      Luxor(),
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
                      Aswan(),
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

            case 5:
              Navigator.push(
                context,
                PageRouteBuilder(
                  transitionDuration: Duration(milliseconds: 500),
                  pageBuilder: (context, animation, secondaryAnimation) =>
                      Sharm(),
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

            case 6:
              Navigator.push(
                context,
                PageRouteBuilder(
                  transitionDuration: Duration(milliseconds: 500),
                  pageBuilder: (context, animation, secondaryAnimation) =>
                      Sinai(),
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
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 5.0,
              ),
              Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Color.fromRGBO(0, 0, 0, 0.4),
                          offset: Offset(0, 4),
                          blurRadius: 9,
                          spreadRadius: -4,
                        )
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10.0),
                      child: Image(
                        image: AssetImage(items.images!),
                        width: double.infinity,
                        height: 170.0,
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                  Text(
                    '${items.name}',
                    style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                        fontSize: 30.0),
                  )
                ],
              )
            ],
          ),
        ),
      );
}
