import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final String backendUrl = "http://your_backend_url:5000"; // Replace with your Flask server URL
  TextEditingController dietController = TextEditingController();
  TextEditingController workoutController = TextEditingController();
  TextEditingController runController = TextEditingController();
  TextEditingController aiController = TextEditingController();
  String aiResponse = "";

  Future<void> logDiet() async {
    final response = await http.post(
      Uri.parse('$backendUrl/log_diet'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'meal': dietController.text}),
    );
    print(response.body);
  }

  Future<void> logWorkout() async {
    final response = await http.post(
      Uri.parse('$backendUrl/log_workout'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'exercise': workoutController.text}),
    );
    print(response.body);
  }

  Future<void> logRun() async {
    final response = await http.post(
      Uri.parse('$backendUrl/log_run'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'distance': runController.text}),
    );
    print(response.body);
  }

  Future<void> askAI() async {
    final response = await http.post(
      Uri.parse('$backendUrl/ask_ai'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'message': aiController.text}),
    );
    setState(() {
      aiResponse = json.decode(response.body)['response'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Fitness Assistant")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: dietController,
              decoration: InputDecoration(labelText: "Log your meal"),
            ),
            ElevatedButton(onPressed: logDiet, child: Text("Log Diet")),
            SizedBox(height: 20),
            TextField(
              controller: workoutController,
              decoration: InputDecoration(labelText: "Log your workout"),
            ),
            ElevatedButton(onPressed: logWorkout, child: Text("Log Workout")),
            SizedBox(height: 20),
            TextField(
              controller: runController,
              decoration: InputDecoration(labelText: "Log your run (distance)"),
            ),
            ElevatedButton(onPressed: logRun, child: Text("Log Run")),
            SizedBox(height: 20),
            TextField(
              controller: aiController,
              decoration: InputDecoration(labelText: "Ask the AI assistant"),
            ),
            ElevatedButton(onPressed: askAI, child: Text("Ask AI")),
            SizedBox(height: 20),
            Text("AI Response: $aiResponse"),
          ],
        ),
      ),
    );
  }
}
