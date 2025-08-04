import 'dart:math';

import 'package:flutter/material.dart';
import 'package:bali_smart_ecotourism_app/utils/constants.dart';
import 'package:bali_smart_ecotourism_app/widgets/carditem.dart';
import 'package:bali_smart_ecotourism_app/widgets/categories.dart';
import 'package:get/get.dart';

import '../controller/posts_controller.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final PostsController _postsController =
      Get.put(PostsController(), tag: 'hero-post');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              flexibleSpace: FlexibleSpaceBar(
                background: Container(
                  color: Colors.transparent,
                  child: Obx(() {
                    if (_postsController.posts.isEmpty) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    final random = Random();

                    final post = _postsController
                        .posts[random.nextInt(_postsController.posts.length)];

                    return Stack(
                      clipBehavior: Clip.none,
                      alignment: Alignment.topCenter,
                      children: [
                        Container(
                          height: 330,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              fit: BoxFit.cover,
                              image: _postsController.posts.isNotEmpty
                                  ? NetworkImage(post.featuredImageUrl!)
                                      as ImageProvider
                                  : AssetImage(
                                      'assets/images/default_post.jpg'),
                            ),
                            borderRadius: BorderRadius.only(
                                bottomRight: Radius.circular(30),
                                bottomLeft: Radius.circular(30)),
                          ),
                        ),
                        Positioned(
                          bottom: 10,
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.white,
                              boxShadow: const [
                                BoxShadow(
                                  color: Color.fromARGB(15, 0, 0, 0),
                                  spreadRadius: 5,
                                  blurRadius: 4,
                                ),
                              ],
                            ),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 23, vertical: 15),
                            width: MediaQuery.of(context).size.width - 30,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(
                                        post.title,
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.w700),
                                        textAlign: TextAlign.left,
                                      ),
                                      const SizedBox(
                                        height: 3,
                                      ),
                                      Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Icon(
                                              Icons.location_on,
                                              size: 18,
                                              color: Constants.darkAccent,
                                            ),
                                            Flexible(
                                              child: Text(
                                                post.location,
                                                style: TextStyle(
                                                    color: Constants.darkGrey),
                                              ),
                                            )
                                          ]),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                    ],
                                  ),
                                ),
                                FloatingActionButton(
                                  onPressed: () => Get.toNamed(
                                    '/detail-page',
                                    arguments: {'postId': post.id},
                                  ),
                                  child: const Icon(
                                    Icons.arrow_forward,
                                    color: Colors.white,
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    );
                  }),
                ),
              ),
              expandedHeight: 300,
              backgroundColor: Colors.transparent,
              actionsIconTheme: const IconThemeData.fallback(),
            ),
            SliverList(
              delegate: SliverChildListDelegate([
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 18.0, vertical: 10.0),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        const Text(
                          "Categories",
                          style: TextStyle(
                              fontWeight: FontWeight.w700, fontSize: 18),
                          textAlign: TextAlign.start,
                        ),
                        Categories(),
                        const Text(
                          "Favourite Place",
                          style: TextStyle(
                              fontWeight: FontWeight.w700, fontSize: 18),
                          textAlign: TextAlign.start,
                        ),
                        const CardItem(),
                      ]),
                )
              ]),
            )
          ],
        ),
      ),
    );
  }
}
