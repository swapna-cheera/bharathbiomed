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
    title: 'Pensiclav 625',
    description:
        'Amoxycillin and Potassium Clavulanate Tablets IP 500mg /125mg',
    imageUrl: 'assets/dental/1.jpg',
    category: "DENTAL",
  ),
  Product(
    id: 'p2',
    title: 'Dolorock Plus',
    description: 'Aceclofenac 100mg + Paracetamol 325mg Tablets',
    imageUrl: 'assets/dental/2.jpg',
    category: "DENTAL",
  ),
  Product(
    id: 'p3',
    title: 'Dolorock SP',
    description:
        'Aceclofenac 100 mg, Paracetamol 325 mg & Serratiopeptidase 15mg Tablets',
    imageUrl: 'assets/dental/3.jpg',
    category: "DENTAL",
  ),
  Product(
    id: 'p4',
    title: 'Panpeel-40',
    description: 'Pantoprazole 40 mg Tablets As Gastro-Resistant Pellets',
    imageUrl: 'assets/dental/4.jpg',
    category: "DENTAL",
  ),
  Product(
    id: 'p5',
    title: 'Panpeel-D',
    description:
        'Pantoprazole 40 mg (As Gastro-Resistant Pellets) + Domperidone 30 mg Capsules (As prolonged-release Pellets)',
    imageUrl: 'assets/dental/5.jpg',
    category: "DENTAL",
  ),
  Product(
    id: 'p6',
    title: 'Visepod-CV',
    description: 'Cerpodoxime 200 mg & Clavulanate 125 mg',
    imageUrl: 'assets/dental/6.jpg',
    category: "DENTAL",
  ),
  Product(
    id: 'p7',
    title: 'Visepod-200',
    description: 'Cefpodoxime Proxtil 200 mg',
    imageUrl: 'assets/dental/7.jpg',
    category: "DENTAL",
  ),
  Product(
    id: 'p8',
    title: 'Oflonorm-OZ',
    description: 'Ornidazole 500 mg + Ofloxacin 200 mg Tablets',
    imageUrl: 'assets/dental/8.jpg',
    category: "DENTAL",
  ),
  Product(
    id: 'p9',
    title: 'VITATHON',
    description: 'Lycopene +Green Tea Extract + Vitamins + Minerals',
    imageUrl: 'assets/dental/9.jpg',
    category: "DENTAL",
  ),
  Product(
    id: 'p10',
    title: 'Emisoft-MD',
    description: 'Ondansetron 4 mg Orally Disinterating Tablets I.P',
    imageUrl: 'assets/dental/10.jpg',
    category: "DENTAL",
  ),
  Product(
    id: 'p11',
    title: 'F TOTAL Tabs',
    description: 'Ferrous Ascorbate 100mg. + Folic Acid 1.5mg & Zinc 22.5mg',
    imageUrl: 'assets/dental/11.jpg',
    category: "DENTAL",
  ),

  //ENT
  Product(
    id: 'pent1',
    title: 'Pensiclav 625',
    description:
        'Amoxycillin and Potassium Clavulanate Tablets IP 500mg /125mg',
    imageUrl: 'assets/ent/1.jpg',
    category: "ENT",
  ),
  Product(
    id: 'pent2',
    title: 'Dolorock Plus',
    description: 'Aceclofenac 100mg + Paracetamol 325mg Tablets',
    imageUrl: 'assets/ent/2.jpg',
    category: "ENT",
  ),
  Product(
    id: 'pent3',
    title: 'Dolorock SP',
    description:
        'Aceclofenac 100 mg, Paracetamol 325 mg & Serratiopeptidase 15mg Tablets',
    imageUrl: 'assets/ent/3.jpg',
    category: "ENT",
  ),
  Product(
    id: 'pent4',
    title: 'Panpeel-40',
    description: 'Pantoprazole 40 mg Tablets As Gastro-Resistant Pellets',
    imageUrl: 'assets/ent/4.jpg',
    category: "ENT",
  ),
  Product(
    id: 'pent5',
    title: 'Panpeel-D',
    description:
        'Pantoprazole 40 mg (As Gastro-Resistant Pellets) + Domperidone 30 mg Capsules (As prolonged-release Pellets)',
    imageUrl: 'assets/ent/5.jpg',
    category: "ENT",
  ),
  Product(
    id: 'pent6',
    title: 'Visepod-CV',
    description: 'Cerpodoxime 200 mg & Clavulanate 125 mg',
    imageUrl: 'assets/ent/6.jpg',
    category: "ENT",
  ),
  Product(
    id: 'pent7',
    title: 'Visepod-200',
    description: 'Cefpodoxime Proxtil 200 mg',
    imageUrl: 'assets/ent/7.jpg',
    category: "ENT",
  ),
  Product(
    id: 'pent8',
    title: 'Oflonorm-OZ',
    description: 'Ornidazole 500 mg + Ofloxacin 200 mg Tablets',
    imageUrl: 'assets/ent/8.jpg',
    category: "ENT",
  ),
  Product(
    id: 'pent9',
    title: 'VITATHON',
    description: 'Lycopene +Green Tea Extract + Vitamins + Minerals',
    imageUrl: 'assets/ent/9.jpg',
    category: "ENT",
  ),
  Product(
    id: 'pent10',
    title: 'Emisoft-MD',
    description: 'Ondansetron 4 mg Orally Disinterating Tablets I.P',
    imageUrl: 'assets/ent/10.jpg',
    category: "ENT",
  ),
  Product(
    id: 'pent11',
    title: 'F TOTAL Tabs',
    description: 'Ferrous Ascorbate 100mg. + Folic Acid 1.5mg & Zinc 22.5mg',
    imageUrl: 'assets/ent/11.jpg',
    category: "ENT",
  ),
  Product(
    id: 'pent12',
    title: 'F TOTAL Tabs',
    description: 'Ferrous Ascorbate 100mg. + Folic Acid 1.5mg & Zinc 22.5mg',
    imageUrl: 'assets/ent/12.jpg',
    category: "ENT",
  ),

//GYNIC
  Product(
    id: 'pgynic1',
    title: 'Pensiclav 625',
    description:
        'Amoxycillin and Potassium Clavulanate Tablets IP 500mg /125mg',
    imageUrl: 'assets/gynic/1.jpg',
    category: "GYNIC",
  ),
  Product(
    id: 'pgynic2',
    title: 'Dolorock Plus',
    description: 'Aceclofenac 100mg + Paracetamol 325mg Tablets',
    imageUrl: 'assets/gynic/2.jpg',
    category: "GYNIC",
  ),
  Product(
    id: 'pgynic3',
    title: 'Dolorock SP',
    description:
        'Aceclofenac 100 mg, Paracetamol 325 mg & Serratiopeptidase 15mg Tablets',
    imageUrl: 'assets/gynic/3.jpg',
    category: "GYNIC",
  ),
  Product(
    id: 'pgynic4',
    title: 'Panpeel-40',
    description: 'Pantoprazole 40 mg Tablets As Gastro-Resistant Pellets',
    imageUrl: 'assets/gynic/4.jpg',
    category: "GYNIC",
  ),
  Product(
    id: 'pgynic5',
    title: 'Panpeel-D',
    description:
        'Pantoprazole 40 mg (As Gastro-Resistant Pellets) + Domperidone 30 mg Capsules (As prolonged-release Pellets)',
    imageUrl: 'assets/gynic/5.jpg',
    category: "GYNIC",
  ),
  Product(
    id: 'pgynic6',
    title: 'Visepod-CV',
    description: 'Cerpodoxime 200 mg & Clavulanate 125 mg',
    imageUrl: 'assets/gynic/6.jpg',
    category: "GYNIC",
  ),
  Product(
    id: 'pgynic7',
    title: 'Visepod-200',
    description: 'Cefpodoxime Proxtil 200 mg',
    imageUrl: 'assets/gynic/7.jpg',
    category: "GYNIC",
  ),
  Product(
    id: 'pgynic8',
    title: 'Oflonorm-OZ',
    description: 'Ornidazole 500 mg + Ofloxacin 200 mg Tablets',
    imageUrl: 'assets/gynic/8.jpg',
    category: "GYNIC",
  ),
  Product(
    id: 'pgynic9',
    title: 'VITATHON',
    description: 'Lycopene +Green Tea Extract + Vitamins + Minerals',
    imageUrl: 'assets/gynic/9.jpg',
    category: "GYNIC",
  ),
  Product(
    id: 'pgynic10',
    title: 'Emisoft-MD',
    description: 'Ondansetron 4 mg Orally Disinterating Tablets I.P',
    imageUrl: 'assets/gynic/10.jpg',
    category: "GYNIC",
  ),
  Product(
    id: 'pgynic11',
    title: 'F TOTAL Tabs',
    description: 'Ferrous Ascorbate 100mg. + Folic Acid 1.5mg & Zinc 22.5mg',
    imageUrl: 'assets/gynic/11.jpg',
    category: "GYNIC",
  ),
  Product(
    id: 'pgynic12',
    title: 'F TOTAL Tabs',
    description: 'Ferrous Ascorbate 100mg. + Folic Acid 1.5mg & Zinc 22.5mg',
    imageUrl: 'assets/gynic/12.jpg',
    category: "GYNIC",
  ),

  //ORTHO
  Product(
    id: 'portho1',
    title: 'Pensiclav 625',
    description:
        'Amoxycillin and Potassium Clavulanate Tablets IP 500mg /125mg',
    imageUrl: 'assets/ortho/1.jpg',
    category: "ORTHO",
  ),
  Product(
    id: 'portho2',
    title: 'Dolorock Plus',
    description: 'Aceclofenac 100mg + Paracetamol 325mg Tablets',
    imageUrl: 'assets/ortho/2.jpg',
    category: "ORTHO",
  ),
  Product(
    id: 'portho3',
    title: 'Dolorock SP',
    description:
        'Aceclofenac 100 mg, Paracetamol 325 mg & Serratiopeptidase 15mg Tablets',
    imageUrl: 'assets/ortho/3.jpg',
    category: "ORTHO",
  ),
  Product(
    id: 'portho4',
    title: 'Panpeel-40',
    description: 'Pantoprazole 40 mg Tablets As Gastro-Resistant Pellets',
    imageUrl: 'assets/ortho/4.jpg',
    category: "ORTHO",
  ),
  Product(
    id: 'portho5',
    title: 'Panpeel-D',
    description:
        'Pantoprazole 40 mg (As Gastro-Resistant Pellets) + Domperidone 30 mg Capsules (As prolonged-release Pellets)',
    imageUrl: 'assets/ortho/5.jpg',
    category: "ORTHO",
  ),
  Product(
    id: 'portho6',
    title: 'Visepod-CV',
    description: 'Cerpodoxime 200 mg & Clavulanate 125 mg',
    imageUrl: 'assets/ortho/6.jpg',
    category: "ORTHO",
  ),
  Product(
    id: 'portho7',
    title: 'Visepod-200',
    description: 'Cefpodoxime Proxtil 200 mg',
    imageUrl: 'assets/ortho/7.jpg',
    category: "ORTHO",
  ),
  Product(
    id: 'portho8',
    title: 'Oflonorm-OZ',
    description: 'Ornidazole 500 mg + Ofloxacin 200 mg Tablets',
    imageUrl: 'assets/ortho/8.jpg',
    category: "ORTHO",
  ),
  Product(
    id: 'portho9',
    title: 'VITATHON',
    description: 'Lycopene +Green Tea Extract + Vitamins + Minerals',
    imageUrl: 'assets/ortho/9.jpg',
    category: "ORTHO",
  ),
  Product(
    id: 'portho10',
    title: 'Emisoft-MD',
    description: 'Ondansetron 4 mg Orally Disinterating Tablets I.P',
    imageUrl: 'assets/ortho/10.jpg',
    category: "ORTHO",
  ),

  //PHYSICIAN
  Product(
    id: 'pphysician1',
    title: 'Pensiclav 625',
    description:
        'Amoxycillin and Potassium Clavulanate Tablets IP 500mg /125mg',
    imageUrl: 'assets/physician/1.jpg',
    category: "PHYSICIAN",
  ),
  Product(
    id: 'pphysician2',
    title: 'Dolorock Plus',
    description: 'Aceclofenac 100mg + Paracetamol 325mg Tablets',
    imageUrl: 'assets/physician/2.jpg',
    category: "PHYSICIAN",
  ),
  Product(
    id: 'pphysician3',
    title: 'Dolorock SP',
    description:
        'Aceclofenac 100 mg, Paracetamol 325 mg & Serratiopeptidase 15mg Tablets',
    imageUrl: 'assets/physician/3.jpg',
    category: "PHYSICIAN",
  ),
  Product(
    id: 'pphysician4',
    title: 'Panpeel-40',
    description: 'Pantoprazole 40 mg Tablets As Gastro-Resistant Pellets',
    imageUrl: 'assets/physician/4.jpg',
    category: "PHYSICIAN",
  ),
  Product(
    id: 'pphysician5',
    title: 'Panpeel-D',
    description:
        'Pantoprazole 40 mg (As Gastro-Resistant Pellets) + Domperidone 30 mg Capsules (As prolonged-release Pellets)',
    imageUrl: 'assets/physician/5.jpg',
    category: "PHYSICIAN",
  ),
  Product(
    id: 'pphysician6',
    title: 'Visepod-CV',
    description: 'Cerpodoxime 200 mg & Clavulanate 125 mg',
    imageUrl: 'assets/physician/6.jpg',
    category: "PHYSICIAN",
  ),
  Product(
    id: 'pphysician7',
    title: 'Visepod-200',
    description: 'Cefpodoxime Proxtil 200 mg',
    imageUrl: 'assets/physician/7.jpg',
    category: "PHYSICIAN",
  ),
  Product(
    id: 'pphysician8',
    title: 'Oflonorm-OZ',
    description: 'Ornidazole 500 mg + Ofloxacin 200 mg Tablets',
    imageUrl: 'assets/physician/8.jpg',
    category: "PHYSICIAN",
  ),
  Product(
    id: 'pphysician9',
    title: 'VITATHON',
    description: 'Lycopene +Green Tea Extract + Vitamins + Minerals',
    imageUrl: 'assets/physician/9.jpg',
    category: "PHYSICIAN",
  ),
  Product(
    id: 'pphysician10',
    title: 'Emisoft-MD',
    description: 'Ondansetron 4 mg Orally Disinterating Tablets I.P',
    imageUrl: 'assets/physician/10.jpg',
    category: "PHYSICIAN",
  ),
  Product(
    id: 'pphysician11',
    title: 'Pensiclav 625',
    description:
        'Amoxycillin and Potassium Clavulanate Tablets IP 500mg /125mg',
    imageUrl: 'assets/physician/11.jpg',
    category: "PHYSICIAN",
  ),
  Product(
    id: 'pphysician12',
    title: 'Dolorock Plus',
    description: 'Aceclofenac 100mg + Paracetamol 325mg Tablets',
    imageUrl: 'assets/physician/12.jpg',
    category: "PHYSICIAN",
  ),
  Product(
    id: 'pphysician13',
    title: 'Dolorock SP',
    description:
        'Aceclofenac 100 mg, Paracetamol 325 mg & Serratiopeptidase 15mg Tablets',
    imageUrl: 'assets/physician/13.jpg',
    category: "PHYSICIAN",
  ),
  Product(
    id: 'pphysician14',
    title: 'Panpeel-40',
    description: 'Pantoprazole 40 mg Tablets As Gastro-Resistant Pellets',
    imageUrl: 'assets/physician/14.jpg',
    category: "PHYSICIAN",
  ),
  Product(
    id: 'pphysician15',
    title: 'Panpeel-D',
    description:
        'Pantoprazole 40 mg (As Gastro-Resistant Pellets) + Domperidone 30 mg Capsules (As prolonged-release Pellets)',
    imageUrl: 'assets/physician/15.jpg',
    category: "PHYSICIAN",
  ),

  //SURGEN
  Product(
    id: 'psurgen1',
    title: 'Pensiclav 625',
    description:
        'Amoxycillin and Potassium Clavulanate Tablets IP 500mg /125mg',
    imageUrl: 'assets/surgen/1.jpg',
    category: "SURGEN",
  ),
  Product(
    id: 'psurgen2',
    title: 'Dolorock Plus',
    description: 'Aceclofenac 100mg + Paracetamol 325mg Tablets',
    imageUrl: 'assets/surgen/2.jpg',
    category: "SURGEN",
  ),
  Product(
    id: 'psurgen3',
    title: 'Dolorock SP',
    description:
        'Aceclofenac 100 mg, Paracetamol 325 mg & Serratiopeptidase 15mg Tablets',
    imageUrl: 'assets/surgen/3.jpg',
    category: "SURGEN",
  ),
  Product(
    id: 'psurgen4',
    title: 'Panpeel-40',
    description: 'Pantoprazole 40 mg Tablets As Gastro-Resistant Pellets',
    imageUrl: 'assets/surgen/4.jpg',
    category: "SURGEN",
  ),
  Product(
    id: 'psurgen5',
    title: 'Panpeel-D',
    description:
        'Pantoprazole 40 mg (As Gastro-Resistant Pellets) + Domperidone 30 mg Capsules (As prolonged-release Pellets)',
    imageUrl: 'assets/surgen/5.jpg',
    category: "SURGEN",
  ),
  Product(
    id: 'psurgen6',
    title: 'Visepod-CV',
    description: 'Cerpodoxime 200 mg & Clavulanate 125 mg',
    imageUrl: 'assets/surgen/6.jpg',
    category: "SURGEN",
  ),
  Product(
    id: 'psurgen7',
    title: 'Visepod-200',
    description: 'Cefpodoxime Proxtil 200 mg',
    imageUrl: 'assets/surgen/7.jpg',
    category: "SURGEN",
  ),
  Product(
    id: 'psurgen8',
    title: 'Oflonorm-OZ',
    description: 'Ornidazole 500 mg + Ofloxacin 200 mg Tablets',
    imageUrl: 'assets/surgen/8.jpg',
    category: "SURGEN",
  ),
  Product(
    id: 'psurgen9',
    title: 'VITATHON',
    description: 'Lycopene +Green Tea Extract + Vitamins + Minerals',
    imageUrl: 'assets/surgen/9.jpg',
    category: "SURGEN",
  ),
  Product(
    id: 'psurgen10',
    title: 'Emisoft-MD',
    description: 'Ondansetron 4 mg Orally Disinterating Tablets I.P',
    imageUrl: 'assets/surgen/10.jpg',
    category: "SURGEN",
  ),
  Product(
    id: 'psurgen11',
    title: 'Pensiclav 625',
    description:
        'Amoxycillin and Potassium Clavulanate Tablets IP 500mg /125mg',
    imageUrl: 'assets/surgen/11.jpg',
    category: "SURGEN",
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
