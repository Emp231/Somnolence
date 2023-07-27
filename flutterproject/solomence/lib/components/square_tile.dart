import 'package:flutter/material.dart';

class SquareTile extends StatelessWidget {
  final String text;
  final String title;
  const SquareTile({super.key, required this.title, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 400,
      padding: const EdgeInsets.symmetric(horizontal: 5.0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white),
        borderRadius: BorderRadius.circular(16),
        color: Colors.white,
        ),
        child: Column(
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Colors.black87
              ),
            ),

            SizedBox(height: 10,),

            Text(
              this.text,
              style: TextStyle(
                fontSize: 15,
                color: Colors.black87
              )

            )
          ],
        ),

      
    );
  }
}