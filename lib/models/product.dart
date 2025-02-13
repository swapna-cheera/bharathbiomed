class Product {
  final String id;
  final String name;
  final String info;
  final List<String> departments;
  final String imageUrl;

  Product({
    required this.id,
    required this.name,
    required this.info,
    required this.departments,
    required this.imageUrl,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'],
      info: json['info'],
      departments: List<String>.from(json['departments']),
      imageUrl: json['imageUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'info': info,
      'departments': departments,
      'imageUrl': imageUrl,
    };
  }
}
