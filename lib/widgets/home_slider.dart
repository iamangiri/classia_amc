

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

Widget buildSlider(List<String> images) {
  return CarouselSlider(
    options: CarouselOptions(
      autoPlay: true,
      enlargeCenterPage: true,
    ),
    items: images.map((image) {
      return Container(
        margin: EdgeInsets.all(8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          image: DecorationImage(
            image: NetworkImage(image),
            fit: BoxFit.cover,
          ),
        ),
      );
    }).toList(),
  );
}