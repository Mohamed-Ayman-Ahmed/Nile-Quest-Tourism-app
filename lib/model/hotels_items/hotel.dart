import 'package:flutter/material.dart';

class HotelsModel {
  String? description;
  String? hotelLink;
  String? images;
  String? language;
  String? location;
  String? name;
  String? price;
  String? map;

  HotelsModel(
      {@required this.description,
      @required this.hotelLink,
      @required this.images,
      @required this.language,
      @required this.location,
      @required this.name,
      @required this.map,
      @required this.price});
}
