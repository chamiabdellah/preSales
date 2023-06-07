
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

  Customer.fromJson(MapEntry<String, dynamic> json):
    id = json.key,
    name = json.value['name'],
    address = json.value['address'],
    longitude = json.value['longitude'].toDouble(),
    latitude = json.value['latitude'].toDouble(),
    code = json.value['code'];

  Map toJson() => {
    'name': name,
    'address': address,
    'longitude' : longitude,
    'latitude' : latitude,
    'code': '$longitude;$latitude:$name',
  };
}