import 'package:bali_smart_ecotourism_app/controller/map_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:bali_smart_ecotourism_app/utils/constants.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../api_service.dart';
import '../controller/posts_controller.dart';
import '../models/post.dart';
import 'package:url_launcher/url_launcher.dart';

class Explore extends StatelessWidget {
  const Explore({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<PostsController>(
      init: PostsController(),
      builder: (controller) {
        controller.posts.refresh();
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            toolbarHeight: 60,
            flexibleSpace: SafeArea(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 25.0),
                child: Column(
                  children: [
                    _buildLocationHeader(),
                  ],
                ),
              ),
            ),
          ),
          body: _buildMapContent(controller),
        );
      },
    );
  }

  Widget _buildMapContent(PostsController controller) {
    final mapController = Get.find<MyMapController>();
    return Stack(
      children: [
        Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 20),
              child: Row(
                children: [
                  _buildCategoryDropdown(controller),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: _buildFlutterMap(controller),
                ),
              ),
            ),
          ],
        ),
        Positioned(
          bottom: 50,
          right: 30,
          child: Obx(() => FloatingActionButton(
                mini: true,
                backgroundColor: Colors.white,
                onPressed: mapController.getCurrentLocation,
                child: Icon(
                  Icons.my_location,
                  color: mapController.currentPosition.value != null
                      ? Constants.darkAccent
                      : Colors.grey,
                  size: 25,
                ),
              )),
        ),
        Obx(() => controller.isLoading.value
            ? Positioned.fill(
                child: Container(
                  color: Colors.black.withOpacity(0.2),
                  child: Center(
                    child: CircularProgressIndicator(
                      color: Constants.darkAccent,
                    ),
                  ),
                ),
              )
            : const SizedBox.shrink()),
        // Display card when a post is selected
        Obx(() => controller.selectedPost.value != null
            ? Positioned(
                left: 20,
                right: 20,
                bottom: 20,
                child: _LocationCard(post: controller.selectedPost.value!),
              )
            : const SizedBox.shrink()),
      ],
    );
  }

  Widget _buildCategoryDropdown(PostsController controller) {
    return Obx(() => DropdownButton<String>(
          value: controller.term.value.isEmpty
              ? 'hutan-mangrove'
              : controller.term.value,
          icon: const Icon(Icons.arrow_drop_down),
          elevation: 16,
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 17,
          ),
          underline: Container(),
          onChanged: (String? newValue) {
            if (newValue != null) {
              controller.updateTerm(newValue);
            }
          },
          items:
              Constants.categoryList.map<DropdownMenuItem<String>>((category) {
            return DropdownMenuItem<String>(
              value: category['slug'] as String,
              child: Text('${category['icon']} ${category['name']}'),
            );
          }).toList(),
        ));
  }

  Widget _buildFlutterMap(PostsController controller) {
    final mapController = Get.find<MyMapController>();
    return Obx(() => FlutterMap(
          mapController: mapController.mapController,
          options: MapOptions(
            initialCenter: const LatLng(-8.409518, 115.188919),
            initialZoom: 9.2,
            onTap: (_, __) => controller.clearSelectedPost(),
          ),
          children: [
            TileLayer(
              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              userAgentPackageName: 'com.bali.smart.ecotourism',
            ),
            MarkerLayer(
              markers: [
                ...controller.posts
                    .where((post) =>
                        post.latitude != null && post.longitude != null)
                    .map((post) => Marker(
                          width: 40,
                          height: 40,
                          point: LatLng(post.latitude!, post.longitude!),
                          child: GestureDetector(
                            onTap: () => controller.selectPost(post),
                            child: Icon(
                              Icons.location_pin,
                              color: Constants.darkAccent,
                              size: 40,
                            ),
                          ),
                        )),
                if (mapController.currentPosition.value != null)
                  Marker(
                    width: 40,
                    height: 40,
                    point: mapController.currentPosition.value!,
                    child: const Icon(
                      Icons.my_location,
                      color: Colors.blue,
                      size: 30,
                    ),
                  ),
              ],
            ),
          ],
        ));
  }

  Widget _buildLocationHeader() {
    return Container(
      child: Flexible(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Mau ke mana?",
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: Constants.darkGrey,
                fontSize: 14,
              ),
            ),
            Row(
              children: [
                Icon(
                  Icons.location_on,
                  size: 15,
                  color: Constants.darkAccent,
                ),
                const SizedBox(width: 2),
                const Expanded(
                  child: Text(
                    "Bali",
                    overflow: TextOverflow.ellipsis,
                    softWrap: false,
                    maxLines: 1,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                      fontSize: 17,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _LocationCard extends StatefulWidget {
  final Post post;

  const _LocationCard({required this.post});

  @override
  State<_LocationCard> createState() => _LocationCardState();
}

class _LocationCardState extends State<_LocationCard> {
  bool _isBookmarkLoading = false;
  Future<void> _launchMaps() async {
    if (widget.post.latitude == null || widget.post.longitude == null) return;

    final url =
        'https://www.google.com/maps/search/?api=1&query=${widget.post.latitude},${widget.post.longitude}';
    try {
      await launchUrl(Uri.parse(url));
    } catch (e) {
      ScaffoldMessenger.of(Get.context!).showSnackBar(
        const SnackBar(content: Text('Failed to open maps')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Get.toNamed(
        '/detail-page',
        arguments: {'postId': widget.post.id},
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 8,
                spreadRadius: 1,
              )
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(18),
            child: Stack(
              children: [
                SizedBox(
                  height: 160,
                  width: double.infinity,
                  child: ShaderMask(
                    shaderCallback: (rect) {
                      return LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withOpacity(0.6)
                        ],
                      ).createShader(rect);
                    },
                    blendMode: BlendMode.darken,
                    child: Image.network(
                      widget.post.featuredImageUrl ??
                          'https://via.placeholder.com/400',
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        color: Colors.grey[200],
                        child: const Icon(Icons.image_not_supported, size: 36),
                      ),
                    ),
                  ),
                ),
                Positioned.fill(
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.amber[700],
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                children: [
                                  const Icon(Icons.star_rate_rounded,
                                      color: Colors.white, size: 16),
                                  const SizedBox(width: 3),
                                  Text(
                                    "${widget.post.reviewSummary?.averageRating.toStringAsFixed(1) ?? '0.0'}",
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            InkWell(
                              onTap:
                                  _isBookmarkLoading ? null : _toggleBookmark,
                              child: CircleAvatar(
                                radius: 16,
                                backgroundColor: Colors.white.withOpacity(0.9),
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
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.post.title,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                shadows: [
                                  Shadow(
                                      color: Colors.black45,
                                      blurRadius: 6,
                                      offset: Offset(1, 1))
                                ],
                              ),
                            ),
                            const SizedBox(height: 6),
                            Row(
                              children: [
                                const Icon(Icons.location_on,
                                    color: Colors.white, size: 14),
                                const SizedBox(width: 4),
                                Expanded(
                                  // Add this
                                  child: Text(
                                    widget.post.location,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      height: 1.2,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                if (widget.post.galleryImages != null &&
                                    widget.post.galleryImages!.isNotEmpty)
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: Colors.greenAccent[700],
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const Icon(Icons.photo_library,
                                            color: Colors.white, size: 14),
                                        const SizedBox(width: 4),
                                        Text(
                                          "${widget.post.galleryImages!.length}+",
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                GestureDetector(
                                  onTap: _launchMaps,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: Colors.blue[700],
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: const Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(Icons.map,
                                            color: Colors.white, size: 14),
                                        SizedBox(width: 4),
                                        Text(
                                          "Open Google Maps",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
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
