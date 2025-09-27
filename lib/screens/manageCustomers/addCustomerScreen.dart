
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
import 'package:proj1/widgets/PickOrTakeImage.dart';

import '../../models/customer.dart';

class AddCustomerScreen extends ConsumerStatefulWidget {
  const AddCustomerScreen({Key? key, this.editCustomer}) : super(key: key);
  
  final Customer? editCustomer;

  @override
  ConsumerState<AddCustomerScreen> createState() => _AddCustomerScreenState();
}

class _AddCustomerScreenState extends ConsumerState<AddCustomerScreen> {
  final _customerFormKey = GlobalKey<FormState>();
  TextEditingController? customerNameController = TextEditingController();
  TextEditingController? phoneNumberController = TextEditingController();
  TextEditingController? managerNameController = TextEditingController();
  TextEditingController? addressController = TextEditingController();
  TextEditingController? cityController = TextEditingController();
  TextEditingController? regionController = TextEditingController();

  double? latitude;
  double? longitude;
  String? address;
  File? _customerImage;
  bool _useClientNameAsManager = true;
  bool _isLoadingLocation = false;

  void getAddressFromLocation(Position position) async {

    List<Placemark> listPlaceMark = await placemarkFromCoordinates(position.latitude, position.longitude);
    final Placemark placemark = listPlaceMark[0];

    setState(() {
      address = "${placemark.locality}, ${placemark.administrativeArea} ${placemark.subAdministrativeArea}, ${placemark.name}, ${placemark.postalCode}";
      addressController!.text = address!;
      cityController!.text = placemark.locality ?? '';
      regionController!.text = placemark.administrativeArea ?? '';
    });
  }

  void _getUserLocation() async {
    setState(() {
      _isLoadingLocation = true;
    });

    try{
      if(!mounted) return;
      Position? currentPosition = await GeoUtil.getUserLocation(context);
      if(currentPosition == null) {
        setState(() {
          _isLoadingLocation = false;
        });
        return;
      }

      getAddressFromLocation(currentPosition);

      setState(() {
        latitude = currentPosition.latitude;
        longitude = currentPosition.longitude;
        _isLoadingLocation = false;
        placemarkFromCoordinates(latitude!, longitude!);
      });
    } catch(e){
      setState(() {
        _isLoadingLocation = false;
      });
      return;
    }
  }

  @override
  void initState() {
    super.initState();
    if (widget.editCustomer != null) {
      _loadCustomerData();
    } else {
      _getUserLocation();
    }
  }
  
  void _loadCustomerData() {
    final customer = widget.editCustomer!;
    customerNameController!.text = customer.name;
    phoneNumberController!.text = customer.phoneNumber ?? '';
    managerNameController!.text = customer.managerName ?? '';
    addressController!.text = customer.address;
    cityController!.text = customer.city ?? '';
    regionController!.text = customer.region ?? '';
    latitude = customer.latitude;
    longitude = customer.longitude;
    address = customer.address;
    _useClientNameAsManager = customer.managerName == customer.name;
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
      
      LoadingIndicator.showLoadingIndicator(context, widget.editCustomer != null ? "Modification du client" : "Ajout du client");
      
      String? imagePath;
      if (_customerImage != null) {
        imagePath = await uploadImage();
      }
      
      final Customer customer = Customer(
        id: widget.editCustomer?.id,
        address: addressController!.text,
        city: cityController!.text,
        region: regionController!.text,
        latitude: latitude!,
        longitude: longitude!,
        name: customerNameController!.value.text,
        picture: imagePath ?? widget.editCustomer?.picture,
        phoneNumber: phoneNumberController!.value.text.isEmpty ? null : phoneNumberController!.value.text,
        creationDate: widget.editCustomer?.creationDate ?? DateTime.now(),
        managerName: managerNameController!.value.text,
      );
      
      if (widget.editCustomer != null) {
        await ref.read(listOfCustomersProvider.notifier).updateCustomer(customer);
      } else {
        await ref.read(listOfCustomersProvider.notifier).addCustomer(customer);
      }
      
       if(mounted) {
         LoadingIndicator.hideLoadingIndicator(context);
         Navigator.of(context).pop(widget.editCustomer != null ? customer : null);
         final snackBar = SnackBar(
           duration: const Duration(seconds: 5),
           content: Text(
               widget.editCustomer != null 
                 ? 'Le client ${customer.name} a été modifié avec succès'
                 : 'Le client ${customer.name} a été ajouté avec succès'),
         );
         ScaffoldMessenger.of(context).showSnackBar(snackBar);
       }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.editCustomer != null ? "Modifier le client" : "Ajouter un client"),
        ),
        body: SingleChildScrollView(
          child: Form(
            key: _customerFormKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                PickOrTakeImage(
                  onPick: setCustomerImage,
                  image: _customerImage,
                  initialImageUrl: widget.editCustomer?.picture,
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
                      prefixIcon: Icon(Icons.person),
                    ),
                    validator: ValidationLib.nonEmptyField,
                    onChanged: (value) => _onClientNameChanged(),
                    enabled: widget.editCustomer == null,
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
                    prefixIcon: Icons.manage_accounts,
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
                    prefixIcon: Icons.phone,
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: TextFormField(
                    controller: addressController,
                    decoration: InputDecoration(
                      labelText: "Adresse",
                      border: const UnderlineInputBorder(),
                      prefixIcon: const Icon(Icons.location_on),
                      suffixIcon: _isLoadingLocation
                          ? const Padding(
                              padding: EdgeInsets.all(12.0),
                              child: SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(strokeWidth: 2),
                              ),
                            )
                          : null,
                    ),
                    validator: ValidationLib.nonEmptyField,
                    maxLines: 2,
                    keyboardType: TextInputType.multiline,
                    enabled: !_isLoadingLocation,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: cityController,
                          decoration: InputDecoration(
                            labelText: "Ville",
                            border: const UnderlineInputBorder(),
                            prefixIcon: const Icon(Icons.location_city),
                            suffixIcon: _isLoadingLocation
                                ? const Padding(
                                    padding: EdgeInsets.all(12.0),
                                    child: SizedBox(
                                      width: 16,
                                      height: 16,
                                      child: CircularProgressIndicator(strokeWidth: 2),
                                    ),
                                  )
                                : null,
                          ),
                          validator: ValidationLib.nonEmptyField,
                          enabled: !_isLoadingLocation,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: TextFormField(
                          controller: regionController,
                          decoration: InputDecoration(
                            labelText: "Région",
                            border: const UnderlineInputBorder(),
                            prefixIcon: const Icon(Icons.map),
                            suffixIcon: _isLoadingLocation
                                ? const Padding(
                                    padding: EdgeInsets.all(12.0),
                                    child: SizedBox(
                                      width: 16,
                                      height: 16,
                                      child: CircularProgressIndicator(strokeWidth: 2),
                                    ),
                                  )
                                : null,
                          ),
                          validator: ValidationLib.nonEmptyField,
                          enabled: !_isLoadingLocation,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: ElevatedButton.icon(
                    onPressed: _getUserLocation,
                    icon: const Icon(Icons.location_on),
                    label: const Text("Obtenir la localisation"),
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 45),
                    ),
                  ),
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
                      child: Text(
                        widget.editCustomer != null ? "Sauvegarder" : "Ajouter",
                        style:
                            TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
