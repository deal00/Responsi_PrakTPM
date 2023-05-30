import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class DetailScreen extends StatelessWidget {
  final String agentUuid;

  DetailScreen({required this.agentUuid});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Agent Detail'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: FutureBuilder(
        future: _fetchAgentDetails(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final agent = snapshot.data as Map<String, dynamic>;
            return Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.network(agent['fullPortrait']),
                  SizedBox(height: 10),
                  Text(
                    'Name: ${agent['displayName']}',
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    'Description: ${agent['description']}',
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    'Role: ${agent['role']}',
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    'Abilities:',
                    textAlign: TextAlign.center,
                  ),
                  for (var ability in agent['abilities'])
                    Text(
                      '- ${ability['displayName']}',
                      textAlign: TextAlign.center,
                    ),
                ],
              ),
            );
          }
        },
      ),
    );
  }

  Future<Map<String, dynamic>> _fetchAgentDetails() async {
    final response =
    await http.get(Uri.parse('https://valorant-api.com/v1/agents/$agentUuid'));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['data'];
    } else {
      throw Exception('Failed to fetch agent details');
    }
  }
}
