import 'package:bali_smart_ecotourism_app/controller/posts_controller.dart';
import 'package:get/get.dart';
import '../api_service.dart'; // Updated import
import '../models/post.dart';

class PostController extends GetxController {
  final Rx<Post> post = Rx<Post>(Post(
      id: 0,
      type: '',
      title: '',
      location: '',
      description: '',
      reviews: [],
      reviewSummary: ReviewSummary(averageRating: 0.0, reviewCount: 0),
      isBookmarked: false,
      iframe: '',
      latitude: 0,
      longitude: 0));
  final RxBool isLoading = true.obs;
  final RxString errorMessage = ''.obs;
  final RxBool isBookmarkLoading = false.obs;

  Future<void> fetchPost(int postId) async {
    try {
      isLoading(true);
      errorMessage('');

      final fetchedPost = await APIService.fetchPostById(postId);
      post.value = fetchedPost;
    } catch (e) {
      errorMessage(e.toString());
      Get.snackbar('Error', 'Failed to load post data',
          snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading(false);
    }
  }

  Future<void> toggleBookmark() async {
    if (isBookmarkLoading.value) return;

    isBookmarkLoading.value = true;
    try {
      final newStatus = await APIService.toggleBookmark(post.value.id);
      post.update((post) {
        if (post != null) {
          post.isBookmarked = newStatus;
        }
      });

      if (Get.isRegistered<PostsController>()) {
        final postsController = Get.find<PostsController>();
        final index =
            postsController.posts.indexWhere((p) => p.id == post.value.id);
        if (index != -1) {
          postsController.posts[index] =
              postsController.posts[index].copyWith(isBookmarked: newStatus);
          postsController.posts.refresh();
        }
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to update bookmark: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isBookmarkLoading.value = false;
    }
  }
}
