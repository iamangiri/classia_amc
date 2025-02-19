import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

Widget buildSlider(List<String> images) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Column(
      children: [
        CarouselSlider(
          options: CarouselOptions(
            autoPlay: true,
            enlargeCenterPage: true,
            viewportFraction: 1.0, // Ensures full-width coverage
            aspectRatio: 16 / 9, // Adjust aspect ratio as needed
            enableInfiniteScroll: true,
            autoPlayInterval: Duration(seconds: 3),
            autoPlayAnimationDuration: Duration(milliseconds: 800),
            autoPlayCurve: Curves.fastOutSlowIn,
            enlargeStrategy: CenterPageEnlargeStrategy.height,
          ),
          items: images.map((image) {
            return ClipRRect(
              borderRadius: BorderRadius.circular(16), // Border radius applied
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  image: DecorationImage(
                    image: NetworkImage(image),
                    fit: BoxFit.cover, // Ensures full coverage
                  ),
                ),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 10), // Spacing between slider and dots
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            images.length,
            (index) => Container(
              width: 8,
              height: 8,
              margin: EdgeInsets.symmetric(horizontal: 4),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.blueAccent, // Dots color
              ),
            ),
          ),
        ),
      ],
    ),
  );
}
