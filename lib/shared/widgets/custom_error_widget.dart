import 'package:flutter/material.dart';

class CustomErrorWidget extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final Color? background;
  const CustomErrorWidget({super.key, required this.text, this.onPressed, this.background});

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Container(
      padding: EdgeInsets.symmetric(vertical: 16, horizontal: size.width * .1),
      color: background,
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.warning_amber_outlined,
            size: 100,
            color: Colors.red.shade400,
          ),
          const SizedBox(height: 12),
          Text(
            text,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 15),
          ),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: onPressed,
            child: const Text(
              'Try Again',
              style: TextStyle(color: Colors.black54),
            ),
          )
        ],
      ),
    );
  }
}
