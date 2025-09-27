import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:proj1/models/customer.dart';
import 'package:proj1/providers/list_of_customers_provider.dart';
import 'package:proj1/utils/DialogMessagesLib.dart';
import 'package:proj1/utils/LoadingIndicator.dart';
import 'package:proj1/widgets/AddressCardWithMaps.dart';
import 'package:proj1/widgets/PhoneCardWithActions.dart';

class CustomerDetailsTab extends ConsumerWidget {
  final Customer customer;

  const CustomerDetailsTab({
    Key? key,
    required this.customer,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SingleChildScrollView(
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
            child: customer.picture != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      customer.picture!,
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
                _buildDetailCard("Nom du client", customer.name, Icons.person),
                const SizedBox(height: 16),
                _buildDetailCard("Nom du gérant", customer.managerName ?? "Non spécifié", Icons.manage_accounts),
                const SizedBox(height: 16),
                if (customer.phoneNumber != null)
                  PhoneCardWithActions(
                    label: "Numéro de téléphone",
                    phoneNumber: customer.phoneNumber!,
                  ),
                if (customer.phoneNumber != null) const SizedBox(height: 16),
                AddressCardWithMaps(
                  label: "Adresse",
                  address: customer.address,
                  latitude: customer.latitude,
                  longitude: customer.longitude,
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    if (customer.city != null)
                      Expanded(
                        child: _buildDetailCard("Ville", customer.city!, Icons.location_city),
                      ),
                    if (customer.city != null && customer.region != null)
                      const SizedBox(width: 16),
                    if (customer.region != null)
                      Expanded(
                        child: _buildDetailCard("Région", customer.region!, Icons.map),
                      ),
                  ],
                ),
                const SizedBox(height: 30),
                
                // Delete Button
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () => _deleteCustomer(context, ref),
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
    );
  }

  Widget _buildDetailCard(String label, String value, IconData icon) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.grey.shade600),
          const SizedBox(width: 12),
          Expanded(
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
          ),
        ],
      ),
    );
  }

  void _deleteCustomer(BuildContext context, WidgetRef ref) async {
    final confirmed = await DialogMessagesLib.showConfirmationDialog(
      context: context,
      title: 'Confirmer la suppression',
      content: 'Êtes-vous sûr de vouloir supprimer le client "${customer.name}" ?',
      confirmText: 'Supprimer',
      confirmColor: Colors.red,
    );
    
    if (confirmed == true) {
      LoadingIndicator.showLoadingIndicator(context, "Suppression du client");
      try {
        await ref.read(listOfCustomersProvider.notifier).deleteCustomer(customer);
        if (context.mounted) {
          LoadingIndicator.hideLoadingIndicator(context);
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Le client "${customer.name}" a été supprimé avec succès'),
              backgroundColor: Colors.green,
            ),
          );
        }
      } catch (e) {
        if (context.mounted) {
          LoadingIndicator.hideLoadingIndicator(context);
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