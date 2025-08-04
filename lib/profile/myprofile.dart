import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:bali_smart_ecotourism_app/models/user_profile_model.dart';
import 'package:bali_smart_ecotourism_app/profile/editprofilepage.dart';
import 'package:bali_smart_ecotourism_app/services/shared_service.dart';

import '../controller/profile_controller.dart';

class MyProfile extends StatelessWidget {
  MyProfile({Key? key}) : super(key: key);

  final ProfileController profileController = Get.put(ProfileController());

  Future<void> _confirmLogout(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Log Out?'),
        content: const Text('Are you sure you want to log out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text(
              'Yes',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      Get.delete<ProfileController>();
      // Call your logout service
      SharedService.logout(context);
    }
  }

  void _showFullImageDialog(BuildContext context, String imageUrl) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: GestureDetector(
            onTap: () => Navigator.pop(context), // Close dialog on tap
            child: InteractiveViewer(
              child: ClipRRect(
                // borderRadius: BorderRadius.circular(1),
                child: Image.network(imageUrl, fit: BoxFit.contain),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    print("build");
    profileController.loadProfile();
    return Obx(() {
      if (profileController.userProfile.value == null) {
        return const Center(child: CircularProgressIndicator());
      }

      final profile = profileController.userProfile.value!;
      final displayName =
          profile.displayName.isNotEmpty ? profile.displayName : "Your Name";
      final email = profile.email.isNotEmpty ? profile.email : "Not provided";
      final mobileNumber = profile.mobileNumber.isNotEmpty
          ? profile.mobileNumber
          : "Not provided";
      final dob = profile.dob.isNotEmpty ? profile.dob : "Not provided";
      final gender =
          profile.gender.isNotEmpty ? profile.gender : "Not provided";
      final nationality =
          profile.nationality.isNotEmpty ? profile.nationality : "Not provided";
      final description =
          profile.description.isNotEmpty ? profile.description : "Not provided";
      final profilePhotoUrl = profile.profilePhotoUrl;

      return ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        children: [
          // Profile header
          SizedBox(
            height: 250,
            child: Stack(
              children: [
                Container(
                  height: 150,
                  width: MediaQuery.of(context).size.width - 40,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    image: const DecorationImage(
                      image: AssetImage('assets/images/saved/saved1.jpg'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Positioned(
                  top: 110,
                  left: MediaQuery.of(context).size.width / 8,
                  child: InkWell(
                    onTap: () {
                      if (profilePhotoUrl != null) {
                        _showFullImageDialog(context, profilePhotoUrl);
                      }
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.transparent),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.3),
                            offset: const Offset(0.0, 0.0),
                            blurRadius: 2.0,
                            spreadRadius: 0.0,
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(1.0),
                        child: CircleAvatar(
                          radius: 35,
                          backgroundImage: profilePhotoUrl != null
                              ? NetworkImage(
                                  profilePhotoUrl) // Load from server
                              : AssetImage('assets/images/default_profile.jpg')
                                  as ImageProvider,
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 155,
                  right: 10,
                  child: InkWell(
                    onTap: () async {
                      // Navigate to the EditProfilePage using GetX
                      final updatedProfile =
                          await Get.to(() => EditProfilePage(profile: profile));
                      if (updatedProfile != null &&
                          updatedProfile is UserProfile) {
                        // Update the profile controller with the new data.
                        profileController.updateProfile(updatedProfile);
                      }
                    },
                    child: Container(
                      height: 30,
                      width: 30,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        shape: BoxShape.circle,
                      ),
                      child: const Center(
                        child: Icon(Icons.edit, size: 15),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 185,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: Text(
                      displayName,
                      style: const TextStyle(
                        fontFamily: 'Ubuntu-Regular',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 205,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 40.0),
                      child: Text(
                        description,
                        textAlign: TextAlign.center,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontFamily: 'Ubuntu-Regular',
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Profile details
          ListTile(
            visualDensity: const VisualDensity(vertical: -4),
            title: const Text(
              'Email',
              style: TextStyle(
                fontSize: 18,
                fontFamily: 'Ubuntu-Regular',
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Text(
              email,
              style: const TextStyle(
                fontFamily: 'Ubuntu-Regular',
                fontWeight: FontWeight.bold,
              ),
            ),
            trailing: const Icon(Icons.mail, size: 20),
          ),
          ListTile(
            title: const Text(
              'Mobile Number',
              style: TextStyle(
                fontSize: 18,
                fontFamily: 'Ubuntu-Regular',
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Text(
              mobileNumber,
              style: const TextStyle(
                fontFamily: 'Ubuntu-Regular',
                fontWeight: FontWeight.bold,
              ),
            ),
            trailing: const Icon(Icons.phone, size: 20),
          ),
          ListTile(
            title: const Text(
              'D.O.B',
              style: TextStyle(
                fontSize: 18,
                fontFamily: 'Ubuntu-Regular',
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Text(
              dob,
              style: const TextStyle(
                fontFamily: 'Ubuntu-Regular',
                fontWeight: FontWeight.bold,
              ),
            ),
            trailing: const Icon(Icons.cake, size: 20),
          ),
          ListTile(
            title: const Text(
              'Gender',
              style: TextStyle(
                fontSize: 18,
                fontFamily: 'Ubuntu-Regular',
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Text(
              gender,
              style: const TextStyle(
                fontFamily: 'Ubuntu-Regular',
                fontWeight: FontWeight.bold,
              ),
            ),
            trailing: const Icon(Icons.people, size: 20),
          ),
          ListTile(
            title: const Text(
              'Nationality',
              style: TextStyle(
                fontSize: 18,
                fontFamily: 'Ubuntu-Regular',
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Text(
              nationality,
              style: const TextStyle(
                fontFamily: 'Ubuntu-Regular',
                fontWeight: FontWeight.bold,
              ),
            ),
            trailing: const Icon(Icons.flag_rounded, size: 20),
          ),
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 80.0, vertical: 20.0),
            child: ElevatedButton(
              onPressed: () {
                _confirmLogout(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                padding: const EdgeInsets.symmetric(vertical: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.logout, color: Colors.white, size: 20),
                  SizedBox(width: 10),
                  Text(
                    'Sign Out',
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'Ubuntu-Regular',
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      );
    });
  }
}
