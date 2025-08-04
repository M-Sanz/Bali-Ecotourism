import 'package:flutter/material.dart';
import 'package:bali_smart_ecotourism_app/utils/constants.dart';
import 'package:get/get.dart';

import '../api_service.dart';
import '../controller/posts_controller.dart';
import '../models/post.dart';

class CardItem extends StatefulWidget {
  const CardItem({super.key});

  @override
  _CardItemState createState() => _CardItemState();
}

class _CardItemState extends State<CardItem> {
  final PostsController _postsController =
      Get.put(PostsController(), tag: 'favourite-places');

  @override
  Widget build(BuildContext context) {
    _postsController.updateTerm("favourite-places");
    return SizedBox(
        height: 240,
        child: Obx(() {
          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Flexible(
                child: ListView.builder(
                  itemCount: _postsController.posts.length,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (BuildContext context, int index) {
                    final Post post = _postsController.posts[index];
                    return FavouritePlaceCard(post: post);
                  },
                ),
              ),
            ],
          );
        }));
  }
}

class FavouritePlaceCard extends StatefulWidget {
  final Post post;

  const FavouritePlaceCard({super.key, required this.post});

  @override
  State<FavouritePlaceCard> createState() => _FavouritePlaceCardState();
}

class _FavouritePlaceCardState extends State<FavouritePlaceCard> {
  bool _isBookmarkLoading = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: InkWell(
        onTap: () => Get.toNamed(
          '/detail-page',
          arguments: {'postId': widget.post.id},
        ),
        child: Container(
          width: 250,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: Colors.white,
            boxShadow: const [
              BoxShadow(
                color: Color.fromARGB(15, 0, 0, 0),
                spreadRadius: 5,
                blurRadius: 4,
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 250,
                height: 130,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  image: DecorationImage(
                      image: widget.post.featuredImageUrl != null
                          ? NetworkImage(widget.post.featuredImageUrl!)
                          : const AssetImage('assets/images/default_post.jpg')
                              as ImageProvider,
                      fit: BoxFit.cover),
                ),
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: GestureDetector(
                            onTap: _isBookmarkLoading ? null : _toggleBookmark,
                            child: Container(
                              height: 30,
                              width: 30,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white,
                              ),
                              child: Center(
                                child: _isBookmarkLoading
                                    ? SizedBox(
                                        width: 20,
                                        height: 20,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                                  Constants.darkPrimary),
                                        ),
                                      )
                                    : Icon(
                                        widget.post.isBookmarked
                                            ? Icons.bookmark
                                            : Icons.bookmark_outline,
                                        color: Constants.darkPrimary,
                                        size: 19,
                                      ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 10.0, horizontal: 15),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.post.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        softWrap: false,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Row(
                        children: [
                          Icon(
                            // Feather.map_pin,
                            Icons.location_on,
                            size: 15,
                            color: Constants.darkAccent,
                          ),
                          const SizedBox(width: 2),
                          Expanded(
                            child: Text(
                              widget.post.location,
                              overflow: TextOverflow.ellipsis,
                              softWrap: false,
                              maxLines: 1,
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                color: Constants.darkGrey,
                                fontSize: 12,
                              ),
                            ),
                          ),
                          const SizedBox(width: 5),
                          Icon(
                            Icons.star,
                            size: 15,
                            color: Constants.darkAccent,
                          ),
                          const SizedBox(width: 2),
                          Align(
                            alignment: Alignment.bottomRight,
                            child: Text(
                              (widget.post.reviewSummary?.averageRating
                                      .floor()
                                      .toString() ??
                                  "0"),
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                color: Constants.darkGrey,
                                fontSize: 12,
                                // color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _toggleBookmark() async {
    if (_isBookmarkLoading) return;

    setState(() {
      _isBookmarkLoading = true;
    });

    try {
      bool isBookmarked = await APIService.toggleBookmark(widget.post.id);

      if (mounted) {
        setState(() {
          widget.post.isBookmarked = isBookmarked;
          _isBookmarkLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isBookmarkLoading = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                'Failed to ${widget.post.isBookmarked ? 'remove from' : 'add to'} bookmarks'),
            duration: const Duration(seconds: 2),
          ),
        );
      }
    }
  }
}
