import 'package:flutter/material.dart';
import 'package:proj1/models/customer.dart';
import 'package:proj1/screens/manageCustomers/addCustomerScreen.dart';

class CustomerDetailsScreen extends StatefulWidget {
  const CustomerDetailsScreen({Key? key, required this.customer}) : super(key: key);

  final Customer customer;

  @override
  State<CustomerDetailsScreen> createState() => _CustomerDetailsScreenState();
}

class _CustomerDetailsScreenState extends State<CustomerDetailsScreen> {
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