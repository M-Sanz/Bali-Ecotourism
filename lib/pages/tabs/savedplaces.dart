import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controller/bookmarked_posts_controller.dart';
import '../../widgets/post_card.dart';

class SavedPlaces extends StatefulWidget {
  final String term;
  const SavedPlaces({super.key, required this.term});

  @override
  _SavedPlacesState createState() => _SavedPlacesState();
}

class _SavedPlacesState extends State<SavedPlaces> {
  late final BookmarkedPostsController _controller;

  @override
  void initState() {
    super.initState();
    // Initialize controller with unique tag
    _controller = Get.put(
      BookmarkedPostsController(),
      tag: widget.term,
      permanent: false,
    );

    // Load data after first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _controller.loadBookmarkedPostsByCategory(term: widget.term);
    });
  }

  @override
  void dispose() {
    Get.delete<BookmarkedPostsController>(tag: widget.term);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (_controller.isLoading) {
        return const Center(child: CircularProgressIndicator());
      }

      if (_controller.error != null) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Error: ${_controller.error}'),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () => _controller.loadBookmarkedPostsByCategory(
                    term: widget.term),
                child: const Text('Retry'),
              ),
            ],
          ),
        );
      }

      return Padding(
        padding: const EdgeInsets.all(15.0),
        child: RefreshIndicator(
          onRefresh: () =>
              _controller.loadBookmarkedPostsByCategory(term: widget.term),
          child: _controller.bookmarkedPosts.isEmpty
              ? const Center(child: Text('No saved places found'))
              : ListView.separated(
                  itemCount: _controller.bookmarkedPosts.length,
                  padding:
                      const EdgeInsets.symmetric(vertical: 20, horizontal: 5),
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 24),
                  itemBuilder: (context, index) {
                    final post = _controller.bookmarkedPosts[index];
                    return PostCard(post: post);
                  },
                ),
        ),
      );
    });
  }
}
