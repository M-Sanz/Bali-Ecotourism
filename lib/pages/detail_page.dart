import 'package:bali_smart_ecotourism_app/widgets/rating_star.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:bali_smart_ecotourism_app/utils/constants.dart';
import 'package:bali_smart_ecotourism_app/widgets/app_text.dart';
import '../controller/post_controller.dart';
import '../widgets/review_card.dart';
import '../widgets/review_submission_dialog.dart';

class DetailPage extends StatefulWidget {
  final int postId;

  const DetailPage({super.key, required this.postId});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late PageController _pageController;
  late int _currentPage;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _pageController = PageController(viewportFraction: 1);
    _currentPage = 0;

    final PostController postController = Get.put(PostController());
    postController.fetchPost(widget.postId);

    _pageController.addListener(() {
      setState(() {
        _currentPage = _pageController.page?.round() ?? 0;
      });
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetX<PostController>(
        builder: (controller) {
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }
          if (controller.errorMessage.value.isNotEmpty) {
            return Center(child: Text(controller.errorMessage.value));
          }

          final post = controller.post.value;
          int totalImages = post.galleryImages?.length ?? 1;

          return SizedBox(
            width: double.maxFinite,
            height: double.maxFinite,
            child: Stack(
              children: [
                Positioned(
                  left: 0,
                  right: 0,
                  child: SizedBox(
                    height: 260,
                    child: Stack(
                      children: [
                        PageView.builder(
                          controller: _pageController,
                          itemCount: totalImages,
                          itemBuilder: (context, index) {
                            final imageUrl =
                                post.galleryImages?.isNotEmpty == true
                                    ? post.galleryImages![index]
                                    : post.featuredImageUrl;

                            return Image.network(
                              imageUrl ?? 'assets/images/default_post.jpg',
                              fit: BoxFit.cover,
                              width: double.infinity,
                              errorBuilder: (_, __, ___) => Image.asset(
                                'assets/images/default_post.jpg',
                                fit: BoxFit.cover,
                              ),
                            );
                          },
                        ),
                        Positioned(
                          bottom: 45,
                          left: 40,
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 4, horizontal: 10),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.7),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Text(
                                  '${_currentPage + 1}/$totalImages',
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 11,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Positioned(
                          top: MediaQuery.of(context).padding.top,
                          left: 20,
                          child: IconButton(
                            icon: const Icon(Icons.arrow_back,
                                color: Colors.white),
                            onPressed: () => Navigator.pop(context),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  top: 240,
                  bottom: 0,
                  child: Container(
                    padding:
                        const EdgeInsets.only(left: 30, right: 30, top: 10),
                    width: MediaQuery.of(context).size.width,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(15),
                        topRight: Radius.circular(15),
                      ),
                    ),
                    child: LayoutBuilder(builder: (context, constraints) {
                      return ConstrainedBox(
                        constraints: BoxConstraints(
                          minHeight: constraints.maxHeight,
                          maxHeight: double.infinity,
                        ),
                        child: IntrinsicHeight(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Flexible(
                                    child: AppText(
                                      text: post.title,
                                      size: 18,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  Obx(() {
                                    final controller =
                                        Get.find<PostController>();
                                    final isBookmarked =
                                        controller.post.value.isBookmarked;
                                    final isBookmarkLoading =
                                        controller.isBookmarkLoading.value;

                                    return GestureDetector(
                                      onTap: isBookmarkLoading
                                          ? null
                                          : controller.toggleBookmark,
                                      child: CircleAvatar(
                                        backgroundColor: Constants.darkAccent,
                                        radius: 18,
                                        child: isBookmarkLoading
                                            ? const SizedBox(
                                                width: 10,
                                                height: 10,
                                                child:
                                                    CircularProgressIndicator(
                                                  strokeWidth: 2,
                                                  color: Colors.white,
                                                ),
                                              )
                                            : Icon(
                                                isBookmarked
                                                    ? Icons.bookmark
                                                    : Icons.bookmark_border,
                                                size: 20,
                                                color: Colors.white,
                                              ),
                                      ),
                                    );
                                  }),
                                ],
                              ),
                              Row(
                                children: [
                                  Icon(
                                    Icons.location_on_outlined,
                                    color: Constants.darkAccent,
                                    size: 15,
                                  ),
                                  Expanded(
                                    child: Text(
                                      post.location,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                          color: Color(0xFFA0A0A0)),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 5),
                              // <--- Rating Star -->
                              RatingStar(
                                  totalStar: (post.reviewSummary?.averageRating
                                          .floor() ??
                                      0),
                                  starSize: 16,
                                  reviewCount:
                                      post.reviewSummary?.reviewCount ?? 0,
                                  reviewTextSize: 10),
                              const SizedBox(height: 10),
                              // <--- Rating Star --->
                              TabBar(
                                labelColor: Constants.darkPrimary,
                                indicatorColor: Constants.darkPrimary,
                                indicatorPadding:
                                    const EdgeInsets.only(bottom: 6.0),
                                indicator: const UnderlineTabIndicator(
                                  borderSide: BorderSide(
                                    color: Constants.darkPrimary,
                                    width: 1.0,
                                  ),
                                  insets:
                                      EdgeInsets.symmetric(horizontal: 50.0),
                                ),
                                controller: _tabController,
                                tabs: const [
                                  Tab(child: Text("About")),
                                  Tab(child: Text("Reviews")),
                                  Tab(child: Text("Map")),
                                ],
                              ),
                              Expanded(
                                child: TabBarView(
                                  physics: const NeverScrollableScrollPhysics(),
                                  controller: _tabController,
                                  children: [
                                    // About Tab
                                    SingleChildScrollView(
                                      padding: const EdgeInsets.only(top: 10),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const AppText(
                                            text: "About",
                                            size: 15,
                                            color: Colors.black,
                                            fontWeight: FontWeight.w600,
                                          ),
                                          const SizedBox(height: 5),
                                          Text(
                                            post.description,
                                            style: const TextStyle(
                                                fontWeight: FontWeight.w300),
                                          ),
                                        ],
                                      ),
                                    ),
                                    // Reviews Tab
                                    Column(
                                      children: [
                                        Expanded(
                                          child: post.reviews?.isNotEmpty ==
                                                  true
                                              ? ListView.builder(
                                                  padding:
                                                      const EdgeInsets.only(
                                                    top: 5,
                                                  ),
                                                  itemCount:
                                                      post.reviews!.length,
                                                  itemBuilder:
                                                      (context, index) {
                                                    final review =
                                                        post.reviews![index];
                                                    return ReviewCard(
                                                        review: review);
                                                  },
                                                )
                                              : const Center(
                                                  child: Text(
                                                    "No reviews available yet.",
                                                    style: TextStyle(
                                                      color: Colors.grey,
                                                      fontStyle:
                                                          FontStyle.italic,
                                                    ),
                                                  ),
                                                ),
                                        ),
                                        SafeArea(
                                          top: false,
                                          minimum: const EdgeInsets.only(
                                              top: 10, bottom: 26),
                                          child: ElevatedButton.icon(
                                            icon: const Icon(Icons.edit,
                                                size: 18),
                                            label: const Text("Write a Review"),
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor:
                                                  Constants.darkPrimary,
                                              foregroundColor: Colors.white,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                              ),
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                vertical: 12,
                                                horizontal: 24,
                                              ),
                                            ),
                                            onPressed: () {
                                              showDialog(
                                                context: context,
                                                builder: (_) =>
                                                    ReviewSubmissionDialog(
                                                        postId: widget.postId),
                                              );
                                            },
                                          ),
                                        ),
                                      ],
                                    ),

                                    // Map Tab
                                    post.iframe != ""
                                        ? Container(
                                            margin:
                                                const EdgeInsets.only(top: 10),
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height -
                                                400,
                                            child:
                                                MapWebView(iframe: post.iframe),
                                          )
                                        : Center(
                                            child: Text(
                                              "No map available",
                                              style:
                                                  TextStyle(color: Colors.grey),
                                            ),
                                          ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class MapWebView extends StatefulWidget {
  final String iframe;

  const MapWebView({super.key, required this.iframe});

  @override
  State<MapWebView> createState() => _MapWebViewState();
}

class _MapWebViewState extends State<MapWebView>
    with AutomaticKeepAliveClientMixin {
  late final WebViewController controller;

  @override
  void initState() {
    super.initState();
    _initializeController();
  }

  void _initializeController() {
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.transparent)
      ..setNavigationDelegate(
        NavigationDelegate(
          onNavigationRequest: (request) {
            if (request.isMainFrame) {
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadHtmlString('''
        <html style="height: 100%">
          <head>
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <style>
              body, html, iframe { 
                height: 100%; 
                width: 100%; 
                margin: 0; 
                border: none;
              }
            </style>
          </head>
          <body>
            ${widget.iframe}
          </body>
        </html>
      ''');
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return WebViewWidget(controller: controller);
  }

  @override
  bool get wantKeepAlive => true;
}
