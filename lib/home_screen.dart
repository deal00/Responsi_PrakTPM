import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<dynamic> agents = [];
  bool isLoggedIn = false;

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
    _fetchAgents();
  }

  Future<void> _checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final username = prefs.getString('username');
    setState(() {
      isLoggedIn = username != null;
    });
  }

  Future<void> _fetchAgents() async {
    final response = await http.get(Uri.parse('https://valorant-api.com/v1/agents'));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        agents = data['data'];
      });
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Error'),
          content: Text('Failed to fetch agents.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  Future<void> _logout() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('username');
    setState(() {
      isLoggedIn = false;
    });
    Navigator.pushReplacementNamed(context, '/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
        actions: [
          Visibility(
            visible: isLoggedIn,
            child: IconButton(
              icon: Icon(Icons.logout),
              onPressed: _logout,
            ),
          ),
        ],
      ),
      body: agents.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: agents.length,
        itemBuilder: (context, index) {
          final agent = agents[index];
          return ListTile(
            leading: Image.network(agent['displayIcon']),
            title: Text(agent['displayName']),
            onTap: () {
              Navigator.pushNamed(context, '/detail', arguments: agent['uuid']);
            },
          );
        },
      ),
    );
  }
}