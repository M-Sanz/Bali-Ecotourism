import 'package:flutter/material.dart';

import '../models/review.dart';
import '../utils/constants.dart';

Widget ReviewCard({required Review review}) {
  return Card(
    color: Constants.lightPrimary,
    margin: EdgeInsets.symmetric(vertical: 8, horizontal: 4),
    elevation: 1,
    child: Padding(
      padding: EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundImage:
                    AssetImage("assets/images/default_profile.jpg"),
              ),
              SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(review.username,
                      style: TextStyle(fontWeight: FontWeight.w600)),
                  Row(
                    children: [
                      Wrap(
                        children: List.generate(5, (starIndex) {
                          return Icon(
                            Icons.star,
                            size: 16,
                            color: starIndex < review.rating
                                ? Constants.darkAccent
                                : Colors.grey,
                          );
                        }),
                      ),
                      SizedBox(width: 8),
                      Text(review.date,
                          style: TextStyle(color: Colors.grey, fontSize: 12)),
                    ],
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 10),
          Text(review.comment, style: TextStyle(fontWeight: FontWeight.w300)),
          SizedBox(height: 8),
        ],
      ),
    ),
  );
}
