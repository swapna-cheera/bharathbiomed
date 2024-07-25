import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/models/selected_products.dart';
import 'package:widget_zoom/widget_zoom.dart';

class SlideshowScreen extends StatelessWidget {
  const SlideshowScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final selectedProducts =
        Provider.of<SelectedProductsChangeNotifier>(context).selectedProducts;
    debugPrint('selectedProducts ${selectedProducts.length}');
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Bharathbiomed Pharma',
          style: TextStyle(
            color: Color.fromARGB(
              255,
              48,
              112,
              176,
            ),
          ),
        ),
      ),
      body:
          // PageView.builder(
          //   itemCount: selectedProducts.length,
          //   itemBuilder: (context, index) {
          //     final product = selectedProducts[index];
          //     return Container(
          //       width:
          //           MediaQuery.of(context).size.width, // Set width to screen width
          //       height: MediaQuery.of(context).size.height - 10,
          //       decoration: BoxDecoration(
          //         image: DecorationImage(
          //           image: AssetImage(product.imageUrl),
          //           fit: BoxFit.cover,
          //         ),
          //       ),
          //     ); // Replace with actual image URLs
          //   },
          // ),
          Padding(
        padding: const EdgeInsets.all(8.0),
        child: CarouselSlider(
          disableGesture: false,
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
                debugPrint('Product Id ${product.id} ${product.imageUrl}');
                return WidgetZoom(
                  heroAnimationTag: product.id,
                  zoomWidget: Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    margin: const EdgeInsets.symmetric(horizontal: 5.0),
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(
                          product.imageUrl,
                        ),
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                );
              },
            );
          }).toList(),
        ),
      ),
    );
  }
}
