import 'package:flutter/material.dart';

class authbutton extends StatelessWidget {
  const authbutton({Key? key, required this.icon, required this.text, this.ontap}) : super(key: key);
  final IconData icon;
  final String text;
  final Function()? ontap;
  @override
  Widget build(BuildContext context) {
    return  Padding(
      padding: const EdgeInsets.all(10.0),
      child: InkWell(
          onTap: ontap,
          child: Container(
            height: 40,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(20)
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon),
                Text(text),
              ],
            ),
          ),
      ),
    );
  }
}
