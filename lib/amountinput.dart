import 'package:flutter/material.dart';

class AmountInputField extends StatelessWidget {
  final TextEditingController controller;
  final Function onChanged;

  const AmountInputField({
    required this.controller,
    required this.onChanged,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: TextField(
        controller: controller,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          labelText: 'Amount',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        onChanged: (value) {
          if (value.isNotEmpty) {
            onChanged();
          }
        },
      ),
    );
  }
}
