import 'package:flutter/material.dart';

class TitleModel {
  final String title, key ;
  int? id ;
  MaterialColor? color ;
  TitleModel({
    required this.title,
    required this.key,
    this.id,
    this.color,
  });


}
