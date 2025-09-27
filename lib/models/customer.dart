
class Customer{

  double longitude;
  double latitude;
  String name;
  String? id;
  String address;
  String? city;
  String? region;
  String? picture;
  String? phoneNumber;
  DateTime? creationDate;
  String? managerName;

  Customer({
    required this.name,
    required this.longitude,
    required this.latitude,
    this.id,
    required this.address,
    this.city,
    this.region,
    this.picture,
    this.phoneNumber,
    this.creationDate,
    this.managerName,
  });

  Customer.fromJson(MapEntry<String, dynamic> json):
    id = json.key,
    name = json.value['name'],
    address = json.value['address'],
    city = json.value['city'],
    region = json.value['region'],
    longitude = json.value['longitude'].toDouble(),
    latitude = json.value['latitude'].toDouble(),
    picture = json.value['picture'],
    phoneNumber = json.value['phoneNumber'],
    creationDate = DateTime.tryParse(json.value['creationDate'] ?? ""),
    managerName = json.value['managerName'];

  Map<String,dynamic> toJson() => {
    'name': name,
    'address': address,
    'city': city,
    'region': region,
    'longitude' : longitude,
    'latitude' : latitude,
    'picture': picture,
    'phoneNumber': phoneNumber,
    'creationDate': creationDate?.toString(),
    'managerName': managerName,
  };
}