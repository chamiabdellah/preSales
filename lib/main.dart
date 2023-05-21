import 'package:flutter/material.dart';
import 'package:proj1/screens/addArticleScreen.dart';
import 'package:proj1/screens/listOfArticlesScreen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PreSales App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Liste des articles'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        actions: [
          InkWell(
            onTap: () { 
              Navigator.push(context, MaterialPageRoute(builder: (ctx) => const AddArticleScreen()));
            },
            child: const Padding(
              padding: EdgeInsets.only(right: 20.0),
                child : Icon(
                  size: 35,
                Icons.add,  // add custom icons also
              ),
            ),
          ),
        ],
        title: Text(widget.title),
      ),
      body: const ListOfArticles(),
      floatingActionButton: FloatingActionButton(
        onPressed: (){},
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
