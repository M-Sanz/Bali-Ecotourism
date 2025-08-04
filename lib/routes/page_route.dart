import 'package:bali_smart_ecotourism_app/pages/categories/post_list.dart';
import 'package:bali_smart_ecotourism_app/pages/detail_page.dart';
import 'package:get/get.dart';

import '../controller/posts_controller.dart';
import '../pages/auth/login_or_register.dart';
import '../screens/homescreen.dart';

class ApplicationPage {
  static final pages = [
    GetPage(name: '/', page: () => LoginOrRegister()),
    GetPage(name: '/home', page: () => HomeScreen()),
    GetPage(
      name: '/detail-page',
      page: () => DetailPage(postId: Get.arguments['postId']),
    ),
    GetPage(
      name: '/post-list',
      page: () => PostList(),
      binding: BindingsBuilder(() {
        Get.put(PostsController());
      }),
    ),
  ];
}
