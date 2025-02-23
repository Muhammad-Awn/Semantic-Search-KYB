import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'KnowYourBooks',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(title: 'KnowYourBooks'),
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
  final TextEditingController _textController = TextEditingController();

  String? _searchResult;

  void _onSearch() async {
    String inputText = _textController.text;
    if (inputText.isEmpty) return;

    final response = await http.get(
      Uri.parse('http://127.0.0.1:8000/search?query=$inputText'),
    );

    if (response.statusCode == 200) {
      final result = jsonDecode(response.body);
      setState(() {
        _searchResult = result['best_match'];
      });
    } else {
      print("Failed to fetch data");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: _textController,
              decoration: const InputDecoration(labelText: 'Enter a sentence'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(onPressed: _onSearch, child: const Text('Search')),
            const SizedBox(height: 20),
            if (_searchResult != null)
              Text(
                "Best Match: $_searchResult",
                style: Theme.of(context).textTheme.titleLarge,
              ),
          ],
        ),
      ),
    );
  }
}
