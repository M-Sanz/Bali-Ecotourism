import 'package:get/get.dart';
import '../api_service.dart';
import '../models/post.dart';

class BookmarkedPostsController extends GetxController {
  final RxList<Post> _bookmarkedPosts = <Post>[].obs;
  final RxBool _isLoading = false.obs;
  final Rxn<String> _error = Rxn<String>();
  var _currentTerm = '';

  List<Post> get bookmarkedPosts => _bookmarkedPosts.toList();
  bool get isLoading => _isLoading.value;
  String? get error => _error.value;

  Future<void> loadBookmarkedPostsByCategory({String? term}) async {
    try {
      // Cancel previous request if term changed
      if (term != _currentTerm) {
        _bookmarkedPosts.clear();
        _currentTerm = term ?? '';
      }

      _isLoading.value = true;
      _error.value = null;

      final posts = await APIService.getBookmarkedPostsByCategory(term: term);
      _bookmarkedPosts.assignAll(posts);
    } catch (e) {
      _error.value = e.toString();
      _bookmarkedPosts.clear();
    } finally {
      _isLoading.value = false;
    }
  }

  void clearBookmarkedPosts() {
    _bookmarkedPosts.clear();
    _error.value = null;
    _currentTerm = '';
  }

  @override
  void onClose() {
    clearBookmarkedPosts();
    super.onClose();
  }
}
