import 'package:flutter/material.dart';

import '../utils/constants.dart';

class RatingStar extends StatelessWidget {
  final num totalStar;
  final double starSize;
  final int reviewCount;
  final double reviewTextSize;

  const RatingStar({
    super.key,
    required this.totalStar,
    required this.starSize,
    required this.reviewCount,
    required this.reviewTextSize,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Wrap(
          children: List.generate(
            5,
            (index) => Icon(
              Icons.star,
              size: starSize,
              color: index < totalStar ? Constants.darkAccent : Colors.grey,
            ),
          ),
        ),
        Text(
          "  (${reviewCount} reviews)",
          style: TextStyle(color: Colors.grey, fontSize: reviewTextSize),
        ),
      ],
    );
  }
}
