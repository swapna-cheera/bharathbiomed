// ignore_for_file: use_key_in_widget_constructors

import 'package:flutter/material.dart';
import '/widgets/category_product_list.dart';
import '../models/product.dart';
import 'slideshow_screen.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

final List<Product> allProducts = [
  //Dental
  Product(
    id: 'p1',
    imageUrl: 'assets/dental/1.jpg',
    category: "DENTAL",
  ),
  Product(
    id: 'p2',
    imageUrl: 'assets/dental/2.jpg',
    category: "DENTAL",
  ),
  Product(
    id: 'p3',
    imageUrl: 'assets/dental/3.jpg',
    category: "DENTAL",
  ),
  Product(
    id: 'p4',
    imageUrl: 'assets/dental/4.jpg',
    category: "DENTAL",
  ),
  Product(
    id: 'p5',
    imageUrl: 'assets/dental/5.jpg',
    category: "DENTAL",
  ),
  Product(
    id: 'p6',
    imageUrl: 'assets/dental/6.jpg',
    category: "DENTAL",
  ),
  Product(
    id: 'p7',
    imageUrl: 'assets/dental/7.jpg',
    category: "DENTAL",
  ),
  Product(
    id: 'p8',
    imageUrl: 'assets/dental/8.jpg',
    category: "DENTAL",
  ),
  Product(
    id: 'p9',
    imageUrl: 'assets/dental/9.jpg',
    category: "DENTAL",
  ),
  Product(
    id: 'p10',
    imageUrl: 'assets/dental/10.jpg',
    category: "DENTAL",
  ),
  Product(
    id: 'p11',
    imageUrl: 'assets/dental/11.jpg',
    category: "DENTAL",
  ),

  //ENT
  Product(
    id: 'pent1',
    imageUrl: 'assets/ent/1.jpg',
    category: "ENT",
  ),
  Product(
    id: 'pent2',
    imageUrl: 'assets/ent/2.jpg',
    category: "ENT",
  ),
  Product(
    id: 'pent3',
    imageUrl: 'assets/ent/3.jpg',
    category: "ENT",
  ),
  Product(
    id: 'pent4',
    imageUrl: 'assets/ent/4.jpg',
    category: "ENT",
  ),
  Product(
    id: 'pent5',
    imageUrl: 'assets/ent/5.jpg',
    category: "ENT",
  ),
  Product(
    id: 'pent6',
    imageUrl: 'assets/ent/6.jpg',
    category: "ENT",
  ),
  Product(
    id: 'pent7',
    imageUrl: 'assets/ent/7.jpg',
    category: "ENT",
  ),
  Product(
    id: 'pent8',
    imageUrl: 'assets/ent/8.jpg',
    category: "ENT",
  ),
  Product(
    id: 'pent9',
    imageUrl: 'assets/ent/9.jpg',
    category: "ENT",
  ),
  Product(
    id: 'pent10',
    imageUrl: 'assets/ent/10.jpg',
    category: "ENT",
  ),
  Product(
    id: 'pent11',
    imageUrl: 'assets/ent/11.jpg',
    category: "ENT",
  ),
  Product(
    id: 'pent12',
    imageUrl: 'assets/ent/12.jpg',
    category: "ENT",
  ),

//GYNIC
  Product(
    id: 'pgynic1',
    imageUrl: 'assets/gynic/1.jpg',
    category: "GYNIC",
  ),
  Product(
    id: 'pgynic2',
    imageUrl: 'assets/gynic/2.jpg',
    category: "GYNIC",
  ),
  Product(
    id: 'pgynic3',
    imageUrl: 'assets/gynic/3.jpg',
    category: "GYNIC",
  ),
  Product(
    id: 'pgynic4',
    imageUrl: 'assets/gynic/4.jpg',
    category: "GYNIC",
  ),
  Product(
    id: 'pgynic5',
    imageUrl: 'assets/gynic/5.jpg',
    category: "GYNIC",
  ),
  Product(
    id: 'pgynic7',
    imageUrl: 'assets/gynic/7.jpg',
    category: "GYNIC",
  ),
  Product(
    id: 'pgynic8',
    imageUrl: 'assets/gynic/8.jpg',
    category: "GYNIC",
  ),
  Product(
    id: 'pgynic9',
    imageUrl: 'assets/gynic/9.jpg',
    category: "GYNIC",
  ),
  Product(
    id: 'pgynic10',
    imageUrl: 'assets/gynic/10.jpg',
    category: "GYNIC",
  ),
  Product(
    id: 'pgynic11',
    imageUrl: 'assets/gynic/11.jpg',
    category: "GYNIC",
  ),
  Product(
    id: 'pgynic12',
    imageUrl: 'assets/gynic/12.jpg',
    category: "GYNIC",
  ),

  //ORTHO
  Product(
    id: 'portho1',
    imageUrl: 'assets/ortho/1.jpg',
    category: "ORTHO",
  ),
  Product(
    id: 'portho2',
    imageUrl: 'assets/ortho/2.jpg',
    category: "ORTHO",
  ),
  Product(
    id: 'portho3',
    imageUrl: 'assets/ortho/3.jpg',
    category: "ORTHO",
  ),
  Product(
    id: 'portho4',
    imageUrl: 'assets/ortho/4.jpg',
    category: "ORTHO",
  ),
  Product(
    id: 'portho5',
    imageUrl: 'assets/ortho/5.jpg',
    category: "ORTHO",
  ),
  Product(
    id: 'portho6',
    imageUrl: 'assets/ortho/6.jpg',
    category: "ORTHO",
  ),
  Product(
    id: 'portho7',
    imageUrl: 'assets/ortho/7.jpg',
    category: "ORTHO",
  ),
  Product(
    id: 'portho8',
    imageUrl: 'assets/ortho/8.jpg',
    category: "ORTHO",
  ),
  Product(
    id: 'portho9',
    imageUrl: 'assets/ortho/9.jpg',
    category: "ORTHO",
  ),
  Product(
    id: 'portho10',
    imageUrl: 'assets/ortho/10.jpg',
    category: "ORTHO",
  ),

  //PHYSICIAN
  Product(
    id: 'pphysician1',
    imageUrl: 'assets/physician/1.jpg',
    category: "PHYSICIAN",
  ),
  Product(
    id: 'pphysician2',
    imageUrl: 'assets/physician/2.jpg',
    category: "PHYSICIAN",
  ),
  Product(
    id: 'pphysician3',
    imageUrl: 'assets/physician/3.jpg',
    category: "PHYSICIAN",
  ),
  Product(
    id: 'pphysician4',
    imageUrl: 'assets/physician/4.jpg',
    category: "PHYSICIAN",
  ),
  Product(
    id: 'pphysician5',
    imageUrl: 'assets/physician/5.jpg',
    category: "PHYSICIAN",
  ),
  Product(
    id: 'pphysician6',
    imageUrl: 'assets/physician/6.jpg',
    category: "PHYSICIAN",
  ),
  Product(
    id: 'pphysician7',
    imageUrl: 'assets/physician/7.jpg',
    category: "PHYSICIAN",
  ),
  Product(
    id: 'pphysician8',
    imageUrl: 'assets/physician/8.jpg',
    category: "PHYSICIAN",
  ),
  Product(
    id: 'pphysician9',
    imageUrl: 'assets/physician/9.jpg',
    category: "PHYSICIAN",
  ),
  Product(
    id: 'pphysician10',
    imageUrl: 'assets/physician/10.jpg',
    category: "PHYSICIAN",
  ),
  Product(
    id: 'pphysician11',
    imageUrl: 'assets/physician/11.jpg',
    category: "PHYSICIAN",
  ),
  Product(
    id: 'pphysician12',
    imageUrl: 'assets/physician/12.jpg',
    category: "PHYSICIAN",
  ),
  Product(
    id: 'pphysician14',
    imageUrl: 'assets/physician/14.jpg',
    category: "PHYSICIAN",
  ),
  Product(
    id: 'pphysician15',
    imageUrl: 'assets/physician/15.jpg',
    category: "PHYSICIAN",
  ),

  //SURGEN
  Product(
    id: 'psurgen1',
    imageUrl: 'assets/surgen/1.jpg',
    category: "SURGEN",
  ),
  Product(
    id: 'psurgen2',
    imageUrl: 'assets/surgen/2.jpg',
    category: "SURGEN",
  ),
  Product(
    id: 'psurgen3',
    imageUrl: 'assets/surgen/3.jpg',
    category: "SURGEN",
  ),
  Product(
    id: 'psurgen4',
    imageUrl: 'assets/surgen/4.jpg',
    category: "SURGEN",
  ),
  Product(
    id: 'psurgen5',
    imageUrl: 'assets/surgen/5.jpg',
    category: "SURGEN",
  ),
  Product(
    id: 'psurgen6',
    imageUrl: 'assets/surgen/6.jpg',
    category: "SURGEN",
  ),
  Product(
    id: 'psurgen7',
    imageUrl: 'assets/surgen/7.jpg',
    category: "SURGEN",
  ),
  Product(
    id: 'psurgen8',
    imageUrl: 'assets/surgen/8.jpg',
    category: "SURGEN",
  ),
  Product(
    id: 'psurgen9',
    imageUrl: 'assets/surgen/9.jpg',
    category: "SURGEN",
  ),
  Product(
    id: 'psurgen10',
    imageUrl: 'assets/surgen/10.jpg',
    category: "SURGEN",
  ),
  Product(
    id: 'psurgen11',
    imageUrl: 'assets/surgen/11.jpg',
    category: "SURGEN",
  ),

  //
  Product(
    id: 'pantifungal1',
    imageUrl: 'assets/antifungal/6.jpg',
    category: "GYNIC",
  ),
  Product(
    id: 'pantifungal1',
    imageUrl: 'assets/antifungal/13.jpg',
    category: "PHYSICIAN",
  ),
];

class ProductListScreen extends StatefulWidget {
  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FlutterNativeSplash.remove();
    });
  }

  @override
  Widget build(BuildContext context) {
    // ignore: unused_local_variable
    final categories =
        allProducts.map((product) => product.category).toSet().toList();

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
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.builder(
          itemCount: categories.length,
          itemBuilder: (ctx, i) {
            final category = categories[i];
            final categoryProducts = allProducts
                .where((product) => product.category == category)
                .toList();
            return CategoryProductList(
              category: category,
              products: categoryProducts,
            );
          },
        ),
      ),
      // ListView.builder(
      //   itemCount: allProducts.length,
      //   itemBuilder: (ctx, i) => ProductItem(allProducts[i]),
      // ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(
          Icons.play_arrow,
        ),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const SlideshowScreen(),
            ),
          );
        },
      ),
    );
  }
}
