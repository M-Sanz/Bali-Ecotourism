import 'package:bali_smart_ecotourism_app/widgets/app_text.dart';
import 'package:flutter/material.dart';
import '../api_service.dart';
import '../models/post.dart';
import '../utils/constants.dart';
import 'package:get/get.dart';

class PostCard extends StatefulWidget {
  final Post post;

  const PostCard({super.key, required this.post});

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  bool _isBookmarkLoading = false;

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(15),
      elevation: 4,
      child: InkWell(
        borderRadius: BorderRadius.circular(15),
        onTap: () => Get.toNamed(
          '/detail-page',
          arguments: {'postId': widget.post.id},
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withAlpha(20),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              _buildImageSection(),
              _buildCardFooter(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImageSection() {
    return Hero(
      tag: 'place-image-${widget.post.id}',
      child: Stack(
        children: [
          Container(
            height: 150,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(15)),
              image: DecorationImage(
                image: widget.post.featuredImageUrl != null
                    ? NetworkImage(widget.post.featuredImageUrl!)
                    : const AssetImage('assets/images/default_post.jpg')
                        as ImageProvider,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(15)),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withAlpha(150),
                  ],
                  stops: const [0.6, 1.0],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 12,
            right: 12,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.black54,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.location_on_outlined,
                    size: 16,
                    color: Colors.white,
                  ),
                  const SizedBox(width: 4),
                  ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * 0.5,
                    ),
                    child: Text(
                      widget.post.location,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                        fontFamily: 'Ubuntu',
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCardFooter() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.post.title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[800],
                    fontFamily: 'Ubuntu',
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    AppText(
                      text:
                          "${widget.post.reviewSummary?.averageRating.toStringAsFixed(1)}",
                      size: 14,
                      color: Constants.darkAccent,
                      fontWeight: FontWeight.w600,
                    ),
                    const SizedBox(width: 8),
                    Wrap(
                      spacing: 2,
                      children: List.generate(
                        5,
                        (index) => Icon(
                          Icons.star_rounded,
                          size: 18,
                          color: index <
                                  (widget.post.reviewSummary?.averageRating
                                          .floor() ??
                                      0)
                              ? Constants.darkAccent
                              : Colors.grey[400],
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    AppText(
                      text:
                          "(${widget.post.reviewSummary?.reviewCount} reviews)",
                      size: 12,
                      color: Colors.grey[600],
                    ),
                  ],
                ),
              ],
            ),
          ),
          IconButton(
            icon: _isBookmarkLoading
                ? SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor:
                          AlwaysStoppedAnimation<Color>(Constants.darkPrimary),
                    ),
                  )
                : Icon(
                    widget.post.isBookmarked
                        ? Icons.bookmark
                        : Icons.bookmark_outline,
                    color: Constants.darkPrimary,
                    size: 25,
                  ),
            onPressed: _isBookmarkLoading ? null : _toggleBookmark,
          ),
        ],
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
