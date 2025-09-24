import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:proj1/screens/menuScreen.dart';
import 'package:proj1/services/SecureStorageService.dart';
import 'package:proj1/providers/user_credentials_provider.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _loadSavedCredentials();
  }

  Future<void> _loadSavedCredentials() async {
    final credentials = await SecureStorageService().getCredentials();
    if (credentials['email'] != null) {
      emailController.text = credentials['email']!;
    }
    final password = await SecureStorageService().getPassword();
    if (password != null) {
      passwordController.text = password;
    }
  }

  Future<void> loginUser() async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
      final tokenResult = await FirebaseAuth.instance.currentUser?.getIdTokenResult(false);
      print(tokenResult?.claims);
      var tokenId = await userCredential.user?.getIdToken(true);
      final role = tokenResult!.claims?["role"];
      print(userCredential.credential);
      print(userCredential.user.toString());
      SecureStorageService().saveCredentials(userCredential.user?.email ?? "", tokenId ?? "", role);
      await SecureStorageService().savePassword(passwordController.text.trim());
      
      // Fetch user data by ID
      try {
        await ref.read(userCredentialsProvider.notifier).fetchUserById(userCredential.user!.uid);
      } catch (e) {
        print('Error fetching user data: $e');
      }
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Login Successful! Welcome ${userCredential.user?.email}')),
      );
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (ctx) => const MenuScreen()));
    } on FirebaseAuthException {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Login Failed')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.email),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: passwordController,
              decoration: const InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.lock),
              ),
              obscureText: true,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: loginUser,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Text('Login'),
            ),
          ],
        ),
      ),
    );
  }
}
