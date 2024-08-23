import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class EditEmployeeScreen extends StatefulWidget {
  final Map<String, dynamic> employee;

  EditEmployeeScreen({required this.employee});

  @override
  _EditEmployeeScreenState createState() => _EditEmployeeScreenState();
}

class _EditEmployeeScreenState extends State<EditEmployeeScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _genderController = TextEditingController();
  final TextEditingController _salaryController = TextEditingController();
  final FlutterSecureStorage _storage = FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.employee['name'];
    _ageController.text = widget.employee['age'].toString();
    _genderController.text = widget.employee['gender'];
    _salaryController.text = widget.employee['salary'].toString();
  }

  Future<void> _updateEmployee() async {
    final token = await _storage.read(key: 'auth_token');
    final response = await http.put(
      Uri.parse('http://localhost:8000/api/employees/${widget.employee['id']}'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'name': _nameController.text,
        'age': _ageController.text,
        'gender': _genderController.text,
        'salary': _salaryController.text,
      }),
    );

    if (response.statusCode == 200) {
      // Assuming 200 is the success code for update
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update employee')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Employee'),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 250, // Adjust the width of the input fields
              child: TextField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Name'),
              ),
            ),
            SizedBox(height: 10),
            SizedBox(
              width: 250, // Adjust the width of the input fields
              child: TextField(
                controller: _ageController,
                decoration: InputDecoration(labelText: 'Age'),
                keyboardType: TextInputType.number,
              ),
            ),
            SizedBox(height: 10),
            SizedBox(
              width: 250, // Adjust the width of the input fields
              child: TextField(
                controller: _genderController,
                decoration: InputDecoration(labelText: 'Gender'),
              ),
            ),
            SizedBox(height: 10),
            SizedBox(
              width: 250, // Adjust the width of the input fields
              child: TextField(
                controller: _salaryController,
                decoration: InputDecoration(labelText: 'Salary'),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _updateEmployee,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
                padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                textStyle: TextStyle(fontSize: 16),
              ),
              child: Text('Update Employee'),
            ),
          ],
        ),
      ),
    );
  }
}
