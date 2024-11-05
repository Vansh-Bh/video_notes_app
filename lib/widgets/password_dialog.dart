import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PasswordDialog extends StatefulWidget {
  @override
  State<PasswordDialog> createState() => _PasswordDialogState();
}

class _PasswordDialogState extends State<PasswordDialog> {
  final TextEditingController _passwordController = TextEditingController();
  bool _isObscured = true;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Enter Password'),
      content: TextField(
        controller: _passwordController,
        obscureText: _isObscured,
        decoration: InputDecoration(
          hintText: 'Password',
          suffixIcon: IconButton(
          icon: Icon(
            _isObscured ? Icons.visibility : Icons.visibility_off,
            color: Colors.grey,
          ),
          onPressed: () {
            setState(() {
              _isObscured = !_isObscured;
            });
          },
        ),
        ),
      ),
      actions: [
        TextButton(
          child: const Text('Cancel'),
          onPressed: () => Get.back(result: null),
        ),
        ElevatedButton(
          child: const Text('Submit'),
          onPressed: () => Get.back(result: _passwordController.text),
        ),
      ],
    );
  }
}