import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../api_service.dart';
import '../controller/post_controller.dart';
import '../models/review.dart';
import '../utils/constants.dart';

class ReviewSubmissionDialog extends StatefulWidget {
  final int postId;

  const ReviewSubmissionDialog({super.key, required this.postId});

  @override
  _ReviewSubmissionDialogState createState() => _ReviewSubmissionDialogState();
}

class _ReviewSubmissionDialogState extends State<ReviewSubmissionDialog> {
  final _formKey = GlobalKey<FormState>();
  String? _title, _comment;
  int _rating = 1;
  bool _isSubmitting = false;

  // Method to submit the review
  void _submitReview() async {
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState?.save();

      setState(() {
        _isSubmitting = true;
      });

      try {
        // Create a Review object
        final review = Review(
            username: "", // This will be set by the backend using current user
            rating: _rating,
            comment: _comment!,
            date: DateTime.now().toIso8601String(),
            assignedPosts: [widget.postId], // Assign to current post
            title: _title);

        // Submit the review using APIService
        final response = await APIService.createReview(review);

        if (response.success) {
          Get.back(); // Close the dialog
          Get.snackbar(
            'Success',
            'Review submitted successfully!',
            backgroundColor: Colors.green[100],
            colorText: Colors.green[800],
          );

          // Refresh the reviews list
          final PostController postController = Get.find<PostController>();
          await postController.fetchPost(widget.postId);
        } else {
          Get.snackbar(
            'Error',
            response.message,
            backgroundColor: Colors.red[100],
            colorText: Colors.red[800],
          );
        }
      } catch (e) {
        Get.snackbar(
          'Error',
          'Failed to submit review: ${e.toString()}',
          backgroundColor: Colors.red[100],
          colorText: Colors.red[800],
        );
      } finally {
        if (mounted) {
          setState(() {
            _isSubmitting = false;
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      elevation: 5,
      backgroundColor: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Write a Review',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 16),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  // Review Title Input
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Review Title',
                      hintText: 'Enter a catchy title',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      filled: true,
                      fillColor: Colors.grey[200],
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a title';
                      }
                      return null;
                    },
                    onSaved: (value) => _title = value,
                  ),
                  SizedBox(height: 12),

                  // Review Content Input
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Your Review',
                      hintText: 'What did you like or dislike?',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      filled: true,
                      fillColor: Colors.grey[200],
                    ),
                    maxLines: 3,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your review';
                      }
                      return null;
                    },
                    onSaved: (value) => _comment = value,
                  ),
                  SizedBox(height: 16),

                  // Rating Section with Stars
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(5, (index) {
                      return IconButton(
                        icon: Icon(
                          Icons.star,
                          color: _rating > index ? Colors.orange : Colors.grey,
                          size: 30,
                        ),
                        onPressed: () {
                          setState(() {
                            _rating = index + 1;
                          });
                        },
                      );
                    }),
                  ),
                  SizedBox(height: 16),

                  // Submit Button
                  ElevatedButton(
                    onPressed: _submitReview,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Constants
                          .darkPrimary, // Use backgroundColor instead of primary
                      foregroundColor: Colors.white,
                      padding:
                          EdgeInsets.symmetric(vertical: 6.0, horizontal: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                    ),
                    child: _isSubmitting
                        ? SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                        : Text(
                            'Submit Review',
                            style: TextStyle(fontSize: 11, color: Colors.white),
                          ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
