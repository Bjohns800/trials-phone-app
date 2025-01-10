import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'results_page.dart'; // Make sure you import the results page

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Controllers for text fields
  final TextEditingController _playerNumberController = TextEditingController();
  final TextEditingController _scoreController = TextEditingController();

  List<Map<String, dynamic>> _submittedResults = [];
  // State to track if the request is in progress
  bool _isSending = false;

  // Function to send data to the server
  Future<void> sendResults() async {
    final String playerNumber = _playerNumberController.text;
    final String score = _scoreController.text;

    if (playerNumber.isEmpty || score.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill out both fields')),
      );
      return;
    }

    setState(() {
      _isSending = true;
    });

    final url = Uri.parse('http://10.0.2.2:5000/submit_score'); // Replace with your server URL

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'player_id': playerNumber,
          'score': score,
        }),
      );

      if (response.statusCode == 200) {
        // Only add the result to the list if the response is successful
        setState(() {
          _submittedResults.add({
            'player_id': playerNumber,
            'score': score,
          });
          print('Added result: $playerNumber - $score');
          print('Current results: $_submittedResults');
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Results sent successfully')),
        );
        _playerNumberController.clear();
        _scoreController.clear();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to send results: ${response.statusCode}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      setState(() {
        _isSending = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Welcome to the Home Page'),
            const SizedBox(height: 20),
            TextField(
              controller: _playerNumberController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Player Number',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _scoreController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Score',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            _isSending
                ? const Text('Sending results...')
                : ElevatedButton(
                    onPressed: sendResults,
                    child: const Text('Send Results'),
                  ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ResultsPage(submittedResults: _submittedResults),
                  ),
                );
              },
              child: const Text('View Results'),
            ),
          ],
        ),
      ),
    );
  }
}
