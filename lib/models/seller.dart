class Seller {
  final String id;
  final String name;

  Seller({
    required this.id,
    required this.name,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
  };

  factory Seller.fromJson(Map<String, dynamic> json) => Seller(
    id: json['id'],
    name: json['name'],
  );
}