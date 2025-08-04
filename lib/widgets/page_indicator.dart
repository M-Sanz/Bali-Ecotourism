import 'package:flutter/material.dart';

class PageIndicator extends StatelessWidget {
  final int currentPage;
  final int totalPages;

  const PageIndicator(
      {super.key, required this.currentPage, required this.totalPages});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 10, // Adjust the position of the indicator
      left: 10, // Adjust the left margin
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.7),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Text(
              '$currentPage/$totalPages',
              style: const TextStyle(
                color: Colors.black,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(width: 6),
            Icon(
              Icons.chevron_right,
              color: Colors.black,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }
}
