import 'package:get/get.dart';
import '../api_service.dart';
import '../models/post.dart';

class PostsController extends GetxController {
  final RxList<Post> posts = <Post>[].obs;
  final RxBool isLoading = true.obs;
  final RxString errorMessage = ''.obs;
  final RxString term = 'hutan-mangrove'.obs;
  final Rx<Post?> selectedPost = Rx<Post?>(null);

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments != null) {
      term.value = Get.arguments?['slug'] as String;
    }
    fetchPosts();
  }

  void selectPost(Post post) {
    selectedPost.value = post;
  }

  void clearSelectedPost() {
    selectedPost.value = null;
  }

  void updateTerm(String newTerm) {
    term.value = newTerm;
    fetchPosts();
  }

  Future<void> fetchPosts() async {
    try {
      isLoading(true);
      errorMessage('');

      final trips = await APIService.fetchTrips(term: term.value);
      posts.assignAll(trips);
    } catch (e) {
      errorMessage(e.toString());
      Get.snackbar('Error', 'Failed to load posts',
          snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading(false);
    }
  }
}
