
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:proj1/providers/list_of_customers_provider.dart';
import 'package:proj1/utils/GeoUtils.dart';
import 'package:proj1/utils/LoadingIndicator.dart';
import 'package:proj1/utils/ValidationLib.dart';
import 'package:proj1/widgets/OutlineTextField.dart';
import 'package:proj1/widgets/userCoordinates.dart';
import 'package:proj1/widgets/PickImageCamera.dart';

import '../../models/customer.dart';

class AddCustomerScreen extends ConsumerStatefulWidget {
  const AddCustomerScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<AddCustomerScreen> createState() => _AddCustomerScreenState();
}

class _AddCustomerScreenState extends ConsumerState<AddCustomerScreen> {
  final _customerFormKey = GlobalKey<FormState>();
  TextEditingController? customerNameController = TextEditingController();
  TextEditingController? phoneNumberController = TextEditingController();
  TextEditingController? managerNameController = TextEditingController();

  double? latitude;
  double? longitude;
  String? address;
  File? _customerImage;
  bool _useClientNameAsManager = true;

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
      Position? currentPosition = await GeoUtil.getUserLocation(context);
      if(currentPosition == null) return ;

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

  void setCustomerImage(File imageFile) {
    setState(() {
      _customerImage = imageFile;
    });
  }

  void _onClientNameChanged() {
    if (_useClientNameAsManager) {
      managerNameController!.text = customerNameController!.text;
    }
  }

  void _onToggleChanged(bool value) {
    setState(() {
      _useClientNameAsManager = value;
      if (value) {
        managerNameController!.text = customerNameController!.text;
      }
    });
  }

  String? validatePhoneNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Numéro de téléphone requis';
    }
    if (!RegExp(r'^0\d{9}$').hasMatch(value)) {
      return 'Le numéro doit contenir 10 chiffres et commencer par \'0\'';
    }
    return null;
  }

  Future<String?> uploadImage() async {
    if (_customerImage == null) return null;
    final storageRef = FirebaseStorage.instance
        .ref()
        .child('customer_images')
        .child('${customerNameController!.value.text}_${DateTime.now().millisecondsSinceEpoch}.jpeg');
    await storageRef.putFile(_customerImage!);
    return await storageRef.getDownloadURL();
  }

  void addCustomer() async {
    if(_customerFormKey.currentState!.validate()){
      if (address == null || latitude == null || longitude == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Veuillez sélectionner une localisation en appuyant sur l\'icône de localisation'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }
      
      LoadingIndicator.showLoadingIndicator(context, "Ajout du client");
      
      String? imagePath;
      if (_customerImage != null) {
        imagePath = await uploadImage();
      }
      
      final Customer customer = Customer(
        address: address!,
        latitude: latitude!,
        longitude: longitude!,
        code: '${longitude};${latitude}:${customerNameController!.value.text}',
        name: customerNameController!.value.text,
        picture: imagePath,
        phoneNumber: phoneNumberController!.value.text.isEmpty ? null : phoneNumberController!.value.text,
        creationDate: DateTime.now(),
        managerName: managerNameController!.value.text,
      );
      
       await ref.read(listOfCustomersProvider.notifier).addCustomer(customer);
       if(mounted) {
         LoadingIndicator.hideLoadingIndicator(context);
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
        body: SingleChildScrollView(
          child: Form(
            key: _customerFormKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
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
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: TextFormField(
                    controller: customerNameController,
                    decoration: const InputDecoration(
                      labelText: "Nom du client",
                      border: UnderlineInputBorder(),
                    ),
                    validator: ValidationLib.nonEmptyField,
                    onChanged: (value) => _onClientNameChanged(),
                  ),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Row(
                    children: [
                      Switch(
                        value: _useClientNameAsManager,
                        onChanged: _onToggleChanged,
                      ),
                      const SizedBox(width: 8),
                      const Text('Utiliser le nom du client comme gérant'),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: OutlineTextField(
                    labelText: "Nom du gérant",
                    controller: managerNameController,
                    validationFunc: ValidationLib.nonEmptyField,
                    isEnabled: !_useClientNameAsManager,
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: OutlineTextField(
                    labelText: "Numéro de téléphone",
                    controller: phoneNumberController,
                    textInputType: TextInputType.phone,
                    validationFunc: validatePhoneNumber,
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                PickImageCamera(
                  onPick: setCustomerImage,
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
                //const Expanded(child: SizedBox()),
                 Flexible(
                   child: Padding(
                    padding: const EdgeInsets.all(30.0),
                    child: UserCoordinates(
                      longitude: longitude,
                      latitude: latitude,
                      address: address,
                    ),
                ),
                 ),
              ],
            ),
          ),
        ));
  }
}
