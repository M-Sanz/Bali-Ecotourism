import 'package:get/get.dart';
import 'package:bali_smart_ecotourism_app/models/user_profile_model.dart';
import 'package:bali_smart_ecotourism_app/api_service.dart';
import 'package:bali_smart_ecotourism_app/services/shared_service.dart';

class ProfileController extends GetxController {
  // Using Rxn because the profile might be null initially.
  Rxn<UserProfile> userProfile = Rxn<UserProfile>();

  @override
  void onInit() {
    super.onInit();
    loadProfile();
  }

  Future<void> loadProfile() async {
    print("Load Profile");
    final loginDetails = await SharedService.loginDetails();
    if (loginDetails != null && loginDetails.data != null) {
      print("User ID from login details: ${loginDetails.data!.id}");
      try {
        final response = await APIService.getUserProfile();
        userProfile.value = response.data;
      } catch (e) {
        Get.snackbar('Error', 'Failed to load profile');
      }
    } else {
      Get.snackbar('Error', 'No login details found');
    }
  }

  void updateProfile(UserProfile updatedProfile) {
    userProfile.value = updatedProfile;
  }
}
