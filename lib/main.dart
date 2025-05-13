import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:logger/logger.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

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

  Map<String, dynamic>? _searchResult;
  File? _image;
  final ImagePicker _picker = ImagePicker();
  String? _ocrText;

  void _onSearch() {
    String inputText = _textController.text;
    if (inputText.isEmpty) return;

    _performSemanticSearch(inputText);
  }

  Future<void> _performSemanticSearch(String query) async {
    final response = await http.get(
      Uri.parse('http://192.168.18.6:8000/search?query=$query'),
    );

    if (response.statusCode == 200) {
      try {
        final Map<String, dynamic> result = jsonDecode(response.body);

        setState(() {
          _searchResult = result;
        });
        logger.w("Fetched semantic search result: $_searchResult");
      } catch (e) {
        logger.e("Error decoding JSON: $e");
      }
    } else {
      logger.w("Semantic search failed. Status Code: ${response.statusCode}");
    }
  }

  Future<void> _performOCR(File image) async {
    final request = http.MultipartRequest(
      'POST',
      Uri.parse('http://192.168.18.6:8000/extract-text/'),
    );

    request.files.add(await http.MultipartFile.fromPath('file', image.path));

    final response = await request.send();

    if (response.statusCode == 200) {
      final responseData = await response.stream.bytesToString();
      final data = json.decode(responseData);

      setState(() {
        _ocrText = data['complete_text'];
      });

      logger.i("OCR result: $_ocrText");
    } else {
      logger.e("OCR failed. Status Code: ${response.statusCode}");
    }
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
        _ocrText = null; // Clear previous OCR result
      });
      _showImagePopup();
    }
  }

  void _showImagePopup() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content:
              _image != null
                  ? Image.file(_image!, fit: BoxFit.contain)
                  : const Text("No image selected"),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("Close"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog first
                if (_image != null) {
                  _performOCR(_image!);
                }
              },
              child: const Text("Perform OCR"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: <Widget>[
            TextField(
              controller: _textController,
              decoration: const InputDecoration(labelText: 'Enter a sentence'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(onPressed: _onSearch, child: const Text('Search')),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _pickImage,
              child: const Text('Pick Image from Gallery'),
            ),
            const SizedBox(height: 20),

            if (_ocrText != null) ...[
              Text(
                "OCR Result:",
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              Text(_ocrText!, style: const TextStyle(color: Colors.black87)),
              const SizedBox(height: 20),
            ],

            if (_searchResult != null) ...[
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
                    TextSpan(text: "${_searchResult?['first_match']['id']}   "),
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
              const SizedBox(height: 8),

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
              const SizedBox(height: 8),

              RichText(
                text: TextSpan(
                  style: Theme.of(context).textTheme.bodyLarge,
                  children: [
                    const TextSpan(
                      text: "Quran: ",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    TextSpan(text: "${_searchResult?['third_match']['id']}   "),
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
          ],
        ),
      ),
    );
  }
}
