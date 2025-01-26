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
      body: Stack(
        children: [
          CarouselSlider(
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
                      // height: MediaQuery.of(context).size.height,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage(
                            product.imageUrl,
                          ),
                          fit: BoxFit.fitWidth,
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
