import 'package:flutter/material.dart';
import 'package:proj1/models/customer.dart';
import 'package:proj1/screens/manageCustomers/addCustomerScreen.dart';

class CustomerDetailsScreen extends StatelessWidget {
  const CustomerDetailsScreen({Key? key, required this.customer}) : super(key: key);

  final Customer customer;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(customer.name),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddCustomerScreen(editCustomer: customer),
                ),
              );
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
                  _buildDetailCard("Nom du client", customer.name),
                  const SizedBox(height: 16),
                  _buildDetailCard("Nom du gérant", customer.managerName ?? "Non spécifié"),
                  const SizedBox(height: 16),
                  if (customer.phoneNumber != null)
                    _buildDetailCard("Numéro de téléphone", customer.phoneNumber!),
                  if (customer.phoneNumber != null) const SizedBox(height: 16),
                  _buildDetailCard("Adresse", customer.address),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      if (customer.city != null)
                        Expanded(
                          child: _buildDetailCard("Ville", customer.city!),
                        ),
                      if (customer.city != null && customer.region != null)
                        const SizedBox(width: 16),
                      if (customer.region != null)
                        Expanded(
                          child: _buildDetailCard("Région", customer.region!),
                        ),
                    ],
                  ),
                  const SizedBox(height: 30),
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
}