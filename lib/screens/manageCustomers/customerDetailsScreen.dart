import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:proj1/models/customer.dart';
import 'package:proj1/providers/list_of_customers_provider.dart';
import 'package:proj1/screens/manageCustomers/addCustomerScreen.dart';
import 'package:proj1/utils/DialogMessagesLib.dart';

class CustomerDetailsScreen extends ConsumerStatefulWidget {
  const CustomerDetailsScreen({Key? key, required this.customer}) : super(key: key);

  final Customer customer;

  @override
  ConsumerState<CustomerDetailsScreen> createState() => _CustomerDetailsScreenState();
}

class _CustomerDetailsScreenState extends ConsumerState<CustomerDetailsScreen> {
  late Customer currentCustomer;

  @override
  void initState() {
    super.initState();
    currentCustomer = widget.customer;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(currentCustomer.name),
        actions: [
          IconButton(
            onPressed: () async {
              final updatedCustomer = await Navigator.push<Customer>(
                context,
                MaterialPageRoute(
                  builder: (context) => AddCustomerScreen(editCustomer: currentCustomer),
                ),
              );
              if (updatedCustomer != null) {
                setState(() {
                  currentCustomer = updatedCustomer;
                });
              }
            },
            icon: const Icon(Icons.edit),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Customer Image
            Container(
              height: 200,
              width: double.infinity,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8),
              ),
              margin: const EdgeInsets.all(16),
              child: currentCustomer.picture != null
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        currentCustomer.picture!,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => const Center(
                          child: Icon(Icons.person, size: 80, color: Colors.grey),
                        ),
                      ),
                    )
                  : const Center(
                      child: Icon(Icons.person, size: 80, color: Colors.grey),
                    ),
            ),
            const SizedBox(height: 20),
            
            // Customer Details
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  _buildDetailCard("Nom du client", currentCustomer.name),
                  const SizedBox(height: 16),
                  _buildDetailCard("Nom du gérant", currentCustomer.managerName ?? "Non spécifié"),
                  const SizedBox(height: 16),
                  if (currentCustomer.phoneNumber != null)
                    _buildDetailCard("Numéro de téléphone", currentCustomer.phoneNumber!),
                  if (currentCustomer.phoneNumber != null) const SizedBox(height: 16),
                  _buildDetailCard("Adresse", currentCustomer.address),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      if (currentCustomer.city != null)
                        Expanded(
                          child: _buildDetailCard("Ville", currentCustomer.city!),
                        ),
                      if (currentCustomer.city != null && currentCustomer.region != null)
                        const SizedBox(width: 16),
                      if (currentCustomer.region != null)
                        Expanded(
                          child: _buildDetailCard("Région", currentCustomer.region!),
                        ),
                    ],
                  ),
                  const SizedBox(height: 30),
                  
                  // Delete Button
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: _deleteCustomer,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red.shade300,
                        foregroundColor: Colors.white,
                      ),
                      child: const Text(
                        "Supprimer le client",
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailCard(String label, String value) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.grey,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
  
  void _deleteCustomer() async {
    final confirmed = await DialogMessagesLib.showConfirmationDialog(
      context: context,
      title: 'Confirmer la suppression',
      content: 'Êtes-vous sûr de vouloir supprimer le client "${currentCustomer.name}" ?',
      confirmText: 'Supprimer',
      confirmColor: Colors.red,
    );
    
    if (confirmed == true) {
      try {
        await ref.read(listOfCustomersProvider.notifier).deleteCustomer(currentCustomer);
        if (mounted) {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Le client "${currentCustomer.name}" a été supprimé avec succès'),
              backgroundColor: Colors.green,
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Erreur lors de la suppression: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }
}