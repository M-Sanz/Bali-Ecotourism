import 'package:bali_smart_ecotourism_app/widgets/post_card.dart';
import 'package:flutter/material.dart';
import 'package:bali_smart_ecotourism_app/utils/constants.dart';
import 'package:get/get.dart';
import 'package:bali_smart_ecotourism_app/controller/posts_controller.dart';
import 'package:bali_smart_ecotourism_app/models/post.dart'; // Add this import

class PostList extends StatelessWidget {
  PostList({super.key});

  final PostsController controller = Get.put(PostsController());

  @override
  Widget build(BuildContext context) {
    final arguments = Get.arguments as Map<String, dynamic>?;
    return Scaffold(
      appBar: AppBar(
        title: Text("${arguments?['name'] as String} in Bali"),
        backgroundColor: Constants.darkPrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Obx(() {
          if (controller.posts.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          return ListView.separated(
            itemCount: controller.posts.length,
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 5),
            separatorBuilder: (context, index) => const SizedBox(height: 24),
            itemBuilder: (BuildContext context, int index) {
              final Post post = controller.posts[index];
              return PostCard(
                post: post,
              );
            },
          );
        }),
      ),
    );
  }
}
