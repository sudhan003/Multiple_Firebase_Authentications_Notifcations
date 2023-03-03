import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({Key? key, required this.hinttext, required this.controller, required this.prefixicon, }) : super(key: key);
  final String hinttext;
  final TextEditingController controller;
  final IconData prefixicon;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Container(
        height: 40,
        decoration:  BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(20),
        ),
        child: TextField(
          controller: controller,
          decoration:  InputDecoration(
            border: InputBorder.none,
            hintText: hinttext,
            prefixIcon: Icon(prefixicon),
          ),
        ),
      ),
    );
  }
}
