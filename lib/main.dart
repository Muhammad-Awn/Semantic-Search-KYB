import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:logger/logger.dart';

// Create a global logger instance
final Logger logger = Logger();

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

  Map<String, dynamic>? _searchResult; // Nullable Map instead of String

  void _onSearch() async {
    String inputText = _textController.text;
    if (inputText.isEmpty) return;

    // 127.0.0.1 for testing on local device
    final response = await http.get(
      Uri.parse('http://192.168.18.6:8000/search?query=$inputText'),
    );

    /*
    if (response.statusCode == 200) {
      final result = jsonDecode(response.body);
      setState(() {
        _searchResult = result['best_match'];
      });
      logger.w("Fetched data successfully: $result");
      logger.w("Response body: ${response.body}");
    } else {
      logger.w("Failed to fetch data");
    }
    */

    if (response.statusCode == 200) {
      try {
        final Map<String, dynamic> result = jsonDecode(response.body);

        setState(() {
          _searchResult = result;
        });
        logger.w("Fetched data successfully: $_searchResult");
      } catch (e) {
        logger.e("Error decoding JSON: $e");
      }
    } else {
      logger.w("Failed to fetch data. Status Code: ${response.statusCode}");
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
          crossAxisAlignment:
              CrossAxisAlignment.start, // Align text to the left
          children: <Widget>[
            TextField(
              controller: _textController,
              decoration: const InputDecoration(labelText: 'Enter a sentence'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(onPressed: _onSearch, child: const Text('Search')),
            const SizedBox(height: 20),

            // Display search results using RichText
            if (_searchResult != null)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Best Matches:",
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 10),

                  RichText(
                    text: TextSpan(
                      style: Theme.of(context).textTheme.bodyLarge,
                      children: [
                        const TextSpan(
                          text: "Quran: ",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        TextSpan(
                          text: "${_searchResult?['first_match']['id']}   ",
                        ),
                        TextSpan(
                          text: "${_searchResult?['first_match']['text']}   ",
                          style: const TextStyle(color: Colors.blue),
                        ),
                        TextSpan(
                          text: "(${_searchResult?['first_match']['score']})",
                          style: const TextStyle(fontStyle: FontStyle.italic),
                        ),
                      ],
                    ),
                  ),

                  RichText(
                    text: TextSpan(
                      style: Theme.of(context).textTheme.bodyLarge,
                      children: [
                        const TextSpan(
                          text: "Quran: ",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        TextSpan(
                          text: "${_searchResult?['second_match']['id']}   ",
                        ),
                        TextSpan(
                          text: "${_searchResult?['second_match']['text']}   ",
                          style: const TextStyle(color: Colors.blue),
                        ),
                        TextSpan(
                          text: "(${_searchResult?['second_match']['score']})",
                          style: const TextStyle(fontStyle: FontStyle.italic),
                        ),
                      ],
                    ),
                  ),

                  RichText(
                    text: TextSpan(
                      style: Theme.of(context).textTheme.bodyLarge,
                      children: [
                        const TextSpan(
                          text: "Quran: ",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        TextSpan(
                          text: "${_searchResult?['third_match']['id']}   ",
                        ),
                        TextSpan(
                          text: "${_searchResult?['third_match']['text']}   ",
                          style: const TextStyle(color: Colors.blue),
                        ),
                        TextSpan(
                          text: "(${_searchResult?['third_match']['score']})",
                          style: const TextStyle(fontStyle: FontStyle.italic),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
