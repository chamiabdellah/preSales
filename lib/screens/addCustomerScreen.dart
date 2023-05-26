
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:proj1/providers/list_of_customers_provider.dart';
import 'package:proj1/utils/ValidationLib.dart';
import 'package:proj1/widgets/OutlineTextField.dart';
import 'package:proj1/widgets/userCoordinates.dart';

import '../models/customer.dart';

class AddCustomerScreen extends ConsumerStatefulWidget {
  const AddCustomerScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<AddCustomerScreen> createState() => _AddCustomerScreenState();
}

class _AddCustomerScreenState extends ConsumerState<AddCustomerScreen> {
  final _customerFormKey = GlobalKey<FormState>();
  TextEditingController? customerNameController = TextEditingController();

  double? latitude;
  double? longitude;
  String? address;

  Future<bool> _handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Localisation est désactivé sur votre téléphone.')));
      return false;
    }
    permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Location permissions are denied')));
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      final bool isAllowed = await Geolocator.openAppSettings();
      if(isAllowed && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Location permissions are permanently denied, we cannot request permissions.')));
      }
      return false;
    }
    return true;
  }

  void getAddressFromLocation(Position position) async {

    List<Placemark> listPlaceMark = await placemarkFromCoordinates(position.latitude, position.longitude);
    final Placemark placemark = listPlaceMark[0];

    setState(() {
      address = "${placemark.locality}, ${placemark.administrativeArea} ${placemark.subAdministrativeArea}, ${placemark.name}, ${placemark.postalCode}";
    });
  }

  void _getUserLocation() async {
    bool isPermitted = await _handleLocationPermission();

    if(!isPermitted) return;
    Position currentPosition = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high,
        forceAndroidLocationManager: true);

    getAddressFromLocation(currentPosition);

    setState(() {
      latitude = currentPosition.latitude;
      longitude = currentPosition.longitude;
      placemarkFromCoordinates(latitude!, longitude!);
    });
  }

  void addCustomer(){
    final Customer customer = Customer(
      address: address!,
      location: '$latitude+$longitude',
      name: customerNameController!.value.text,
    );

    if(_customerFormKey.currentState!.validate()){
      ref.read(listOfCustomersProvider.notifier).addCustomer(customer);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Ajouter un client"),
        ),
        body: Form(
          key: _customerFormKey,
          child: Column(
            children: [
              InkWell(
                onTap: _getUserLocation,
                child: Container(
                  decoration: const BoxDecoration(
                    border: Border(bottom: BorderSide(width: 1)),
                    color: Colors.white54,
                  ),
                  height: 200,
                  width: double.infinity,
                  child: const Icon(
                    Icons.location_on_outlined,
                    size: 100,
                  ),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              OutlineTextField(
                labelText: "Nom du client",
                controller: customerNameController,
                validationFunc: ValidationLib.nonEmptyField,
              ),
              const SizedBox(
                height: 30,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: SizedBox(
                  width: double.infinity,
                  height: 60,
                  child: ElevatedButton(
                    onPressed: addCustomer,
                    child: const Text(
                      "Ajouter",
                      style:
                          TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
              const Expanded(child: SizedBox()),
               Padding(
                padding: const EdgeInsets.all(30.0),
                child: UserCoordinates(
                  longitude: longitude,
                  latitude: latitude,
                  address: address,
                ),
              ),
            ],
          ),
        ));
  }
}
