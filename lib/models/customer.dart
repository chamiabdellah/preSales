
class Customer{

  double longitude;
  double latitude;
  String name;
  String code;
  String? id;
  String address;
  String? picture;
  String? phoneNumber;
  DateTime? creationDate;

  Customer({
    required this.name,
    required this.longitude,
    required this.latitude,
    this.id,
    this.code = '',
    required this.address,
    this.picture,
    this.phoneNumber,
    this.creationDate,
  });

  Customer.fromJson(MapEntry<String, dynamic> json):
    id = json.key,
    name = json.value['name'],
    address = json.value['address'],
    longitude = json.value['longitude'].toDouble(),
    latitude = json.value['latitude'].toDouble(),
    code = json.value['code'],
    picture = json.value['picture'],
    phoneNumber = json.value['phoneNumber'],
    creationDate = DateTime.tryParse(json.value['creationDate'] ?? "");

  Map<String,dynamic> toJson() => {
    'name': name,
    'address': address,
    'longitude' : longitude,
    'latitude' : latitude,
    'code': '$longitude;$latitude:$name',
    'picture': picture,
    'phoneNumber': phoneNumber,
    'creationDate': creationDate?.toString(),
  };
}