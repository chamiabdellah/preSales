
class Customer{

  double longitude;
  double latitude;
  String name;
  String code;
  String? id;
  String address;

  Customer({
    required this.name,
    required this.longitude,
    required this.latitude,
    this.id,
    this.code = '',
    required this.address,
  });

}