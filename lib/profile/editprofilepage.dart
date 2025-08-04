import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../api_service.dart';
import '../controller/profile_controller.dart';
import '../models/user_profile_model.dart';

class EditProfilePage extends StatefulWidget {
  final UserProfile profile;
  const EditProfilePage({Key? key, required this.profile}) : super(key: key);

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();
  final List<String> _genderOptions = ['Male', 'Female'];
  final ImagePicker _picker = ImagePicker();
  bool _isUploading = false; // Track upload state

  late TextEditingController _displayNameController;
  late TextEditingController _emailController;
  late TextEditingController _mobileController;
  late TextEditingController _dobController;
  late TextEditingController _nationalityController;
  late TextEditingController _descriptionController;
  String? _selectedGender;
  File? _image;

  final ProfileController userProfileController = Get.find<ProfileController>();

  @override
  void initState() {
    super.initState();
    _initializeControllers();
    _selectedGender =
        widget.profile.gender.isNotEmpty ? widget.profile.gender : 'Male';
  }

  void _initializeControllers() {
    _displayNameController =
        TextEditingController(text: widget.profile.displayName);
    _emailController = TextEditingController(text: widget.profile.email);
    _mobileController =
        TextEditingController(text: widget.profile.mobileNumber);
    _dobController = TextEditingController(text: widget.profile.dob);
    _nationalityController =
        TextEditingController(text: widget.profile.nationality);
    _descriptionController =
        TextEditingController(text: widget.profile.description);
  }

  @override
  void dispose() {
    _displayNameController.dispose();
    _emailController.dispose();
    _mobileController.dispose();
    _dobController.dispose();
    _nationalityController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
      await _uploadImage();
    }
  }

  Future<void> _uploadImage() async {
    if (_image == null) return;

    setState(() => _isUploading = true); // Start loading

    try {
      // Get image dimensions
      final imageData = await _image!.readAsBytes();
      final decodedImage = await decodeImageFromList(imageData);
      final imageWidth = decodedImage.width;
      final imageHeight = decodedImage.height;

      // Create coordinates for full image
      final fullImageCoords = "0,0,$imageWidth,$imageHeight";

      final uploadResponse = await APIService.uploadProfileImage(
        widget.profile.id,
        _image!,
      );

      if (uploadResponse.success && uploadResponse.data != null) {
        // Call resize API with temporary image URL
        final resizeResponse = await APIService.resizeProfileImage(
          userId: widget.profile.id,
          imageUrl: uploadResponse.data!.url,
          coords: fullImageCoords,
        );

        if (resizeResponse.success) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Profile photo uploaded and resized successfully'),
              duration: Duration(seconds: 3),
            ),
          );
          userProfileController.loadProfile();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                  'Uploaded but resize failed: ${resizeResponse.errorMessage}'),
              duration: Duration(seconds: 3),
            ),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(uploadResponse.error ?? 'Failed to upload image'),
            duration: Duration(seconds: 3),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${e.toString()}'),
          duration: Duration(seconds: 3),
        ),
      );
    } finally {
      setState(
          () => _isUploading = false); // Stop loading regardless of outcome
    }
  }

  void _saveProfile() async {
    if (_formKey.currentState!.validate()) {
      final updatedProfile = UserProfile(
        id: widget.profile.id,
        displayName: _displayNameController.text,
        username: widget.profile.username,
        email: _emailController.text,
        mobileNumber: _mobileController.text,
        gender: _selectedGender ?? '',
        dob: _dobController.text,
        nationality: _nationalityController.text,
        description: _descriptionController.text,
        profilePhotoUrl: widget.profile.profilePhotoUrl,
      );

      final success = await APIService.updateUserProfile(
        widget.profile.id,
        updatedProfile.toJson(),
      );

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile updated successfully')),
        );
        Navigator.pop(context, updatedProfile);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to update profile')),
        );
      }
    }
  }

  InputDecoration _buildInputDecoration(String labelText, IconData icon) {
    return InputDecoration(
      labelText: labelText,
      prefixIcon: Icon(icon),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      filled: true,
      fillColor: Colors.grey[200],
    );
  }

  String? _validateField(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return "$fieldName is required";
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Profile"),
      ),
      body: Stack(
        children: [
          // Main content
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: ListView(
                children: [
                  Center(
                    child: Stack(
                      children: [
                        Obx(() {
                          String? profilePhotoUrl = userProfileController
                              .userProfile.value!.profilePhotoUrl;

                          return ClipOval(
                            child: _image != null
                                ? Image.file(
                                    _image!,
                                    width: 100,
                                    height: 100,
                                    fit: BoxFit.cover,
                                  )
                                : profilePhotoUrl != null
                                    ? Image.network(
                                        profilePhotoUrl,
                                        width: 100,
                                        height: 100,
                                        fit: BoxFit.cover,
                                        loadingBuilder:
                                            (context, child, progress) {
                                          return progress == null
                                              ? child
                                              : Container(
                                                  width: 100,
                                                  height: 100,
                                                  color: Colors.grey[300],
                                                  child: const Center(
                                                    child:
                                                        CircularProgressIndicator(),
                                                  ),
                                                );
                                        },
                                      )
                                    : Image.asset(
                                        "assets/images/default_profile.jpg",
                                        width: 100,
                                        height: 100,
                                        fit: BoxFit.cover,
                                      ),
                          );
                        }),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: InkWell(
                            onTap: () => showModalBottomSheet(
                              context: context,
                              builder: (context) => Wrap(
                                children: [
                                  ListTile(
                                    leading: const Icon(Icons.photo_library),
                                    title: const Text("Choose from Gallery"),
                                    onTap: () {
                                      Navigator.pop(context);
                                      _pickImage(ImageSource.gallery);
                                    },
                                  ),
                                  ListTile(
                                    leading: const Icon(Icons.camera_alt),
                                    title: const Text("Take a Photo"),
                                    onTap: () {
                                      Navigator.pop(context);
                                      _pickImage(ImageSource.camera);
                                    },
                                  ),
                                ],
                              ),
                            ),
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.blue,
                                shape: BoxShape.circle,
                                border:
                                    Border.all(color: Colors.white, width: 2),
                              ),
                              child: const Icon(Icons.camera_alt,
                                  color: Colors.white, size: 20),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _displayNameController,
                    decoration:
                        _buildInputDecoration("Display Name", Icons.person),
                    validator: (value) => _validateField(value, "Display Name"),
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _emailController,
                    decoration: _buildInputDecoration("Email", Icons.email),
                    readOnly: true,
                    validator: (value) => _validateField(value, "Email"),
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _mobileController,
                    decoration:
                        _buildInputDecoration("Mobile Number", Icons.phone),
                    keyboardType: TextInputType.phone,
                    validator: (value) =>
                        _validateField(value, "Mobile Number"),
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _dobController,
                    decoration: _buildInputDecoration(
                        "Date of Birth", Icons.calendar_today),
                    onTap: () async {
                      final date = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(1900),
                        lastDate: DateTime.now(),
                      );
                      if (date != null) {
                        _dobController.text =
                            "${date.day}/${date.month}/${date.year}";
                      }
                    },
                  ),
                  const SizedBox(height: 20),
                  DropdownButtonFormField<String>(
                    value: _selectedGender,
                    decoration: _buildInputDecoration("Gender", Icons.wc),
                    items: _genderOptions.map((String gender) {
                      return DropdownMenuItem<String>(
                        value: gender,
                        child: Text(gender),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() => _selectedGender = newValue);
                    },
                    validator: (value) => _validateField(value, "Gender"),
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _nationalityController,
                    decoration:
                        _buildInputDecoration("Nationality", Icons.flag),
                    validator: (value) => _validateField(value, "Nationality"),
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _descriptionController,
                    decoration:
                        _buildInputDecoration("Description", Icons.description),
                    maxLines: 3,
                    validator: (value) => _validateField(value, "Description"),
                  ),
                  const SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: _saveProfile,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      "Save Changes",
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Full-screen loading overlay
          if (_isUploading)
            Container(
              color:
                  Colors.black.withOpacity(0.5), // Semi-transparent background
              child: const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      strokeWidth: 5.0,
                    ),
                    SizedBox(height: 20),
                    Text(
                      "Uploading image...",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
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
}
