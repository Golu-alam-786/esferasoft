import 'package:flutter/material.dart';

class GetContentAndTitleWidget extends StatelessWidget {
  final String title;
  final String data;
  const GetContentAndTitleWidget({super.key, required this.title,required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
          color: const Color(0xFF515156).withOpacity(0.3),
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: Colors.white.withOpacity(0.5))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
           Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const Divider(color: Colors.white,),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              data ?? "Untitled",
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );

  }

}
