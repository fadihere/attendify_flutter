import 'package:flutter/material.dart';

class LeaveTagButton extends StatelessWidget {
  final String title;

  const LeaveTagButton({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
      decoration: BoxDecoration(
          color: const Color(0xff35D388).withOpacity(0.1),
          borderRadius: BorderRadius.circular(10)),
      child: Text(
        title,
        style: const TextStyle(
            fontSize: 10,
            color: Color(0xff35D388),
            fontWeight: FontWeight.bold),
      ),
    );
  }
}
