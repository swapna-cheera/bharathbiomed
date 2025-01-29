import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:widget_zoom/widget_zoom.dart';
import '../models/product.dart';

class SlideshowScreen extends StatelessWidget {
  final List<Product> selectedProducts;

  const SlideshowScreen({super.key, required this.selectedProducts});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          CarouselSlider(
            options: CarouselOptions(
              height: MediaQuery.of(context).size.height,
              viewportFraction: 1.0,
              enlargeCenterPage: true,
              autoPlay: false,
              enableInfiniteScroll: false,
            ),
            items: selectedProducts.map((product) {
              return Builder(
                builder: (BuildContext context) {
                  return WidgetZoom(
                    heroAnimationTag: product.id,
                    zoomWidget: Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: CachedNetworkImageProvider(product.imageUrl),
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  );
                },
              );
            }).toList(),
          ),
          Positioned(
            top: 40,
            right: 10,
            child: IconButton(
              icon: const Icon(
                Icons.close,
                size: 30,
                color: Colors.black,
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ),
        ],
      ),
    );
  }
}
