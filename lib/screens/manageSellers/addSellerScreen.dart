import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:proj1/providers/list_of_sellers_provider.dart';
import 'package:proj1/utils/LoadingIndicator.dart';
import 'package:proj1/utils/ValidationLib.dart';
import 'package:proj1/widgets/OutlineTextField.dart';
import 'package:proj1/widgets/PickImageCamera.dart';

class AddSellerScreen extends ConsumerStatefulWidget {
  const AddSellerScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<AddSellerScreen> createState() => _AddSellerScreenState();
}

class _AddSellerScreenState extends ConsumerState<AddSellerScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  
  String _selectedRole = 'Vendeur';
  File? _profileImage;
  bool _imageError = false;

  final List<String> _roles = ['Vendeur', 'Manager', 'Admin'];

  void _setProfileImage(File imageFile) {
    setState(() {
      _profileImage = imageFile;
      _imageError = false;
    });
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email requis';
    }
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
      return 'Email invalide';
    }
    return null;
  }

  void _addSeller() async {
    if (_formKey.currentState!.validate()) {
      if (_profileImage == null) {
        setState(() {
          _imageError = true;
        });
        return;
      }

      LoadingIndicator.showLoadingIndicator(context, "Création du vendeur en cours");
      
      try {
        await ref.read(listOfSellersProvider.notifier).addSeller(
          name: _nameController.text,
          email: _emailController.text,
          password: _passwordController.text,
          role: _selectedRole,
          profileImage: _profileImage!,
        );
        
        if (mounted) {
          LoadingIndicator.hideLoadingIndicator(context);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Vendeur ${_nameController.text} ajouté avec succès')),
          );
          Navigator.pop(context);
        }
      } catch (e) {
        if (mounted) {
          LoadingIndicator.hideLoadingIndicator(context);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Erreur: $e')),
          );
        }
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ajouter Vendeur'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              OutlineTextField(
                labelText: 'Nom',
                validationFunc: ValidationLib.nonEmptyField,
                controller: _nameController,
              ),
              const SizedBox(height: 16),
              OutlineTextField(
                labelText: 'Email',
                validationFunc: _validateEmail,
                controller: _emailController,
                textInputType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _passwordController,
                decoration: const InputDecoration(
                  labelText: 'Mot de passe',
                  border: UnderlineInputBorder(),
                ),
                obscureText: true,
                validator: ValidationLib.nonEmptyField,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedRole,
                decoration: const InputDecoration(
                  labelText: 'Rôle',
                  border: OutlineInputBorder(),
                ),
                items: _roles.map((role) => DropdownMenuItem(
                  value: role,
                  child: Text(role),
                )).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedRole = value!;
                  });
                },
              ),
              const SizedBox(height: 16),
              PickImageCamera(onPick: _setProfileImage),
              if (_imageError)
                const Text(
                  'Veuillez ajouter une photo de profil',
                  style: TextStyle(color: Colors.red),
                ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _addSeller,
                  child: const Text('Ajouter Vendeur'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}