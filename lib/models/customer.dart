
class Customer{

  String location;
  String name;
  String code;
  String? id;
  String address;

  Customer({
    required this.location,
    required this.name,
    this.id,
    this.code = '',
    required this.address,
  });

}