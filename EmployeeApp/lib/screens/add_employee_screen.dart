import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';

class AddEmployeeScreen extends StatefulWidget {
  @override
  _AddEmployeeScreenState createState() => _AddEmployeeScreenState();
}

class _AddEmployeeScreenState extends State<AddEmployeeScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _genderController = TextEditingController();
  final TextEditingController _salaryController = TextEditingController();
  final FlutterSecureStorage _storage = FlutterSecureStorage();

  final _formKey = GlobalKey<FormState>(); // Key for form validation

  Future<void> _addEmployee() async {
    if (_formKey.currentState?.validate() ?? false) {
      final token = await _storage.read(key: 'auth_token');
      final response = await http.post(
        Uri.parse('http://localhost:8000/api/employees'),
        headers: <String, String>{
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'name': _nameController.text,
          'age': _ageController.text,
          'gender': _genderController.text,
          'salary': _salaryController.text,
        }),
      );

      if (response.statusCode == 201) {
        // Assuming 201 is the success code for creation
        Navigator.pop(context, true); // Pass true to indicate success
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to add employee')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Employee'),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey, // Attach the key to the form
          child: Column(
            children: [
              SizedBox(
                width: 250, // Adjust the width of the input fields
                child: TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: 'Name',
                    contentPadding: EdgeInsets.symmetric(
                        vertical: 8.0, horizontal: 12.0), // Adjust padding
                  ),
                  style: TextStyle(fontSize: 14), // Adjust text size
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the name';
                    }
                    return null;
                  },
                ),
              ),
              SizedBox(height: 10),
              SizedBox(
                width: 250, // Adjust the width of the input fields
                child: TextFormField(
                  controller: _ageController,
                  decoration: InputDecoration(
                    labelText: 'Age',
                    contentPadding: EdgeInsets.symmetric(
                        vertical: 8.0, horizontal: 12.0), // Adjust padding
                  ),
                  keyboardType: TextInputType.number,
                  style: TextStyle(fontSize: 14), // Adjust text size
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the age';
                    }
                    final age = int.tryParse(value);
                    if (age == null || age <= 0) {
                      return 'Please enter a valid positive integer for age';
                    }
                    return null;
                  },
                ),
              ),
              SizedBox(height: 10),
              SizedBox(
                width: 250, // Adjust the width of the input fields
                child: TextFormField(
                  controller: _genderController,
                  decoration: InputDecoration(
                    labelText: 'Gender',
                    contentPadding: EdgeInsets.symmetric(
                        vertical: 8.0, horizontal: 12.0), // Adjust padding
                  ),
                  style: TextStyle(fontSize: 14), // Adjust text size
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the gender';
                    }
                    return null;
                  },
                ),
              ),
              SizedBox(height: 10),
              SizedBox(
                width: 250, // Adjust the width of the input fields
                child: TextFormField(
                  controller: _salaryController,
                  decoration: InputDecoration(
                    labelText: 'Salary',
                    contentPadding: EdgeInsets.symmetric(
                        vertical: 8.0, horizontal: 12.0), // Adjust padding
                  ),
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  style: TextStyle(fontSize: 14), // Adjust text size
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the salary';
                    }
                    final salary = double.tryParse(value);
                    if (salary == null || salary <= 0) {
                      return 'Please enter a valid positive number for salary';
                    }
                    return null;
                  },
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _addEmployee,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  textStyle: TextStyle(fontSize: 16),
                ),
                child: Text('Add Employee'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
