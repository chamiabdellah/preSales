
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:proj1/providers/list_of_customers_provider.dart';
import 'package:proj1/utils/GeoUtils.dart';
import 'package:proj1/utils/ValidationLib.dart';
import 'package:proj1/widgets/OutlineTextField.dart';
import 'package:proj1/widgets/userCoordinates.dart';

import '../../models/customer.dart';

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

  void getAddressFromLocation(Position position) async {

    List<Placemark> listPlaceMark = await placemarkFromCoordinates(position.latitude, position.longitude);
    final Placemark placemark = listPlaceMark[0];

    setState(() {
      address = "${placemark.locality}, ${placemark.administrativeArea} ${placemark.subAdministrativeArea}, ${placemark.name}, ${placemark.postalCode}";
    });
  }

  void _getUserLocation() async {

    try{
      if(!mounted) return;
      Position currentPosition = await GeoUtil.getUserLocation(context);
      getAddressFromLocation(currentPosition);

      setState(() {
        latitude = currentPosition.latitude;
        longitude = currentPosition.longitude;
        placemarkFromCoordinates(latitude!, longitude!);
      });
    } catch(e){
      // add an error message when failed.
      return;
    }

  }

  void addCustomer() async {
    final Customer customer = Customer(
      address: address!,
      latitude: latitude!,
      longitude: longitude!,
      name: customerNameController!.value.text,
    );

    if(_customerFormKey.currentState!.validate()){
       Future<void> future = ref.read(listOfCustomersProvider.notifier).addCustomer(customer);
       await future;
       if(mounted) {
         Navigator.of(context).pop();
         final snackBar = SnackBar(
           duration: const Duration(seconds: 5),
           content: Text(
               'Le client ${customer.name} a été ajouté avec succès'),
         );
         ScaffoldMessenger.of(context).showSnackBar(snackBar);
       }
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
