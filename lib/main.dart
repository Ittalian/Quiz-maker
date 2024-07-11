import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
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
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Container(
        alignment: Alignment.topCenter,
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('question_statement').snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return const Text("エラーが発生しました");
            }
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }
            final list = snapshot.requireData.docs
                .map<String>((DocumentSnapshot document) {
              final documentData = document.data()! as Map<String, dynamic>;
              return documentData['value']!.toString();
            }).toList();

            final reverseList = list.reversed.toList();

            return ListView.builder(
              itemCount: reverseList.length,
              itemBuilder: (context, index) {
                return Center(
                  child: Text(
                    reverseList[index],
                    style: const TextStyle(fontSize: 20),
                  ),
                );
              },
            );
          },
        ),
      ),
      //   floatingActionButton: FloatingActionButton(
      //     onPressed: ,
      //     tooltip: 'Increment',
      //     child: const Icon(Icons.add),
    );
  }
}
