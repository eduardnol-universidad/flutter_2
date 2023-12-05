import 'package:ac7/LoginPage.dart';
import 'package:ac7/RecipiesList.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorSchemeSeed: Colors.greenAccent,
        brightness: Brightness.dark,
        useMaterial3: true,
      ),
      home: StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
       builder: (context, snapshot) {
        if (snapshot.hasData) {
        return const MyHomePage(title: "Flutter App");
        } else {
       return const LoginPage();}}
    ),
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

  void _incrementCounter() {
    TextEditingController textFieldControllerName = TextEditingController();
    TextEditingController textFieldControllerDescription = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return  AlertDialog(
          title: const Text('Alert'),
          content: Wrap(
            children: [Column(
              children: [
                TextFormField(
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter a Name';
                      }
                      return null;
                    },
                  controller: textFieldControllerName,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Enter your Recipie Name',
                  )
                        ),
                TextFormField(
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter a Description';
                    }
                    return null;
                  },
                  controller: textFieldControllerDescription,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Enter your Recipie Description',
                  ),
                ),
              ],
            ),],
          ),
        actions: <Widget>[ElevatedButton(onPressed: () {updateDataToFirebase(textFieldControllerName.text, textFieldControllerDescription.text);
          Navigator.of(context).pop();}, child: const Text("Save"))],);
      },
    );
  }

  void updateDataToFirebase(String recipieName, String recipieDescription) async {

    if (recipieName.isEmpty || recipieDescription.isEmpty) {
      return;
    }
    await FirebaseFirestore.instance.collection('recipies').add({
      'name': recipieName,
      'description': recipieDescription,
    });
    //Show snackbar
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Recipie Added'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            tooltip: 'Logout',

            icon: const Icon(Icons.logout),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
            },
          ),],
        title: Text(widget.title),
      ),
      body: const Center(
        child: RecipiesList()),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
