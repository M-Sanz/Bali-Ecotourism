import 'dart:convert';
import 'dart:io';
import 'package:bali_smart_ecotourism_app/models/login_model.dart';
import 'package:bali_smart_ecotourism_app/models/user_profile_model.dart';
import 'package:bali_smart_ecotourism_app/services/shared_service.dart';
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'models/post.dart';
import 'models/review.dart';
import 'models/upload_profile_image.dart';
import 'models/user_model.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class APIService {
  static var client = http.Client();

  static String apiURL = "https://baliedutourism.digdaya.net";
  // static String apiURL = "http://192.168.1.10/baliecotourism";
  static final FlutterSecureStorage secureStorage = FlutterSecureStorage();

  static Future<UserResponseModel> registerUser(UserModel model) async {
    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
    };

    var response = await client.post(
        Uri.parse(apiURL + '/wp-json/wp/v2/users/register'),
        headers: requestHeaders,
        body: jsonEncode(model.toJson()));

    return userResponseFromJson(response.body);
  }

  static Future<bool> loginUser(String email, String password) async {
    Map<String, String> requestHeaders = {
      'Content-type': 'application/x-www-form-urlencoded',
    };

    var response = await client.post(
        Uri.parse(apiURL + '/wp-json/jwt-auth/v1/token'),
        headers: requestHeaders,
        body: {
          'username': email,
          'password': password,
        });

    if (response.statusCode == 200) {
      var jsonString = response.body;

      LoginResponseModel responseModel = loginResponseModelFromJson(jsonString);

      if (responseModel.statuscode == 200) {
        SharedService.setLoginDetails(responseModel);

        final setCookie = response.headers['set-cookie'];
        if (setCookie != null) {
          // Use a regex to capture the refresh token value.
          final regex = RegExp(r'refresh_token=([^;]+)');
          final match = regex.firstMatch(setCookie);
          if (match != null) {
            final refreshToken = match.group(1);
            // Store the refresh token securely.
            await secureStorage.write(
                key: 'refresh_token', value: refreshToken);
          } else {
            print("No refresh token found in the set-cookie header.");
          }
        } else {
          print("No set-cookie header found.");
        }
      }

      return responseModel.statuscode == 200 ? true : false;
    }

    return false;
  }

  static Future<UserProfileResponse> getUserProfile() async {
    // Get valid token first
    String? token = await getValidAccessToken();
    if (token == null) {
      throw Exception('No valid access token available');
    }

    final url = Uri.parse('$apiURL/wp-json/wp/v2/users/profile');
    final response = await client.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      UserProfileResponse userProfileResponse =
          userProfileResponseFromJson(response.body);
      return userProfileResponse;
    } else if (response.statusCode == 401) {
      throw Exception('User not logged in');
    } else {
      throw Exception('Failed to fetch profile: ${response.statusCode}');
    }
  }

  static Future<String?> getValidAccessToken() async {
    final prefs = await SharedPreferences.getInstance();
    final loginDetailsJson = prefs.getString("login_details");

    if (loginDetailsJson == null) {
      print("No login details found.");
      return null;
    }

    LoginResponseModel loginDetails;
    try {
      loginDetails = LoginResponseModel.fromJson(jsonDecode(loginDetailsJson));
    } catch (e) {
      print("Error parsing login details: $e");
      await prefs.remove("login_details");
      return null;
    }

    String? token = loginDetails.data?.token;
    if (token == null || JwtDecoder.isExpired(token)) {
      print("Token is null or expired. Attempting to refresh...");

      final refreshToken = await secureStorage.read(key: 'refresh_token');
      if (refreshToken == null) {
        print("No refresh token found.");
        await prefs.remove("login_details");
        return null;
      }

      try {
        final response = await http.post(
          Uri.parse('${apiURL}/wp-json/jwt-auth/v1/token'),
          headers: {'Cookie': 'refresh_token=$refreshToken'},
        );

        if (response.statusCode == 200) {
          final newData = jsonDecode(response.body);
          final newToken = newData['data']['token'];

          // Update token in local storage
          loginDetails.data!.token = newToken;
          await prefs.setString(
              "login_details", jsonEncode(loginDetails.toJson()));

          print("Token refreshed successfully.");
          return newToken;
        } else {
          print("Failed to refresh token: ${response.statusCode}");
          await prefs.remove("login_details");
          return null;
        }
      } catch (e) {
        print("Error during token refresh: $e");
        await prefs.remove("login_details");
        return null;
      }
    }

    return token;
  }

  static Future<bool> updateUserProfile(
      int userId, Map<String, dynamic> updatedData) async {
    String? token = await APIService.getValidAccessToken();
    if (token == null) {
      print("Error: No valid access token available.");
      return false;
    }

    final url = Uri.parse('$apiURL/wp-json/wp/v2/users/profile?id=$userId');
    final response = await http.patch(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(updatedData),
    );

    if (response.statusCode == 200) {
      print("Profile updated successfully.");
      return true;
    } else {
      print(
          "Failed to update profile: ${response.statusCode} - ${response.body}");
      return false;
    }
  }

  static Future<UploadProfileImageResponse> uploadProfileImage(
      int userId, File imageFile) async {
    try {
      String? token = await getValidAccessToken();
      if (token == null) {
        return UploadProfileImageResponse(
          success: false,
          error: 'No valid access token available',
        );
      }

      var request = http.MultipartRequest(
        'POST',
        Uri.parse('$apiURL/wp-json/myplugin/v1/profile-image'),
      );

      request.headers['Authorization'] = 'Bearer $token';
      request.fields['user_id'] = userId.toString();
      request.fields['timestamp'] =
          (DateTime.now().millisecondsSinceEpoch ~/ 1000).toString();

      var multipartFile = await http.MultipartFile.fromPath(
        'profile_photo',
        imageFile.path,
        filename: 'profile_${DateTime.now().millisecondsSinceEpoch}.jpg',
      );
      request.files.add(multipartFile);

      var response = await client.send(request);
      var responseBody = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(responseBody);
        return UploadProfileImageResponse(
          success: true,
          data: FileData(
            file: jsonResponse['data']['file'],
            url: jsonResponse['data']['url'],
            type: jsonResponse['data']['type'],
            fileInfo: FileInfo(
              basename: jsonResponse['data']['file_info']['basename'],
              name: jsonResponse['data']['file_info']['name'],
              originalName: jsonResponse['data']['file_info']['original_name'],
              ext: jsonResponse['data']['file_info']['ext'],
              type: jsonResponse['data']['file_info']['type'],
              size: jsonResponse['data']['file_info']['size'],
              sizeFormat: jsonResponse['data']['file_info']['size_format'],
            ),
          ),
        );
      } else {
        final errorData = jsonDecode(responseBody);
        return UploadProfileImageResponse(
          success: false,
          error: errorData['message'] ?? 'Failed to upload profile image',
        );
      }
    } catch (e) {
      return UploadProfileImageResponse(
        success: false,
        error: 'Exception occurred: $e',
      );
    }
  }

  static Future<ResizeImageResponse> resizeProfileImage({
    required int userId,
    required String imageUrl,
    required String coords,
  }) async {
    try {
      String? token = await getValidAccessToken();
      if (token == null) {
        return ResizeImageResponse(
          errorCode: 'no_token',
          errorMessage: 'No valid access token available',
          success: false,
        );
      }

      final response = await client.post(
        Uri.parse('$apiURL/wp-json/myplugin/v1/resize-image'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: {
          'src': imageUrl,
          'coord': coords,
          'user_id': userId.toString(),
        },
      );

      final jsonResponse = jsonDecode(response.body);
      print(jsonResponse);

      // Handle error responses from the API
      if (response.statusCode != 200) {
        return ResizeImageResponse(
          errorCode: jsonResponse['code'] ?? 'unknown_error',
          errorMessage: jsonResponse['message'] ?? 'Failed to resize image',
          statusCode: response.statusCode,
          success: false,
        );
      }

      // Handle success response
      return ResizeImageResponse.fromJson(jsonResponse);
    } catch (e) {
      return ResizeImageResponse(
        errorCode: 'exception',
        errorMessage: 'Exception occurred: $e',
        success: false,
      );
    }
  }

  static Future<List<Post>> fetchTrips({String? term}) async {
    try {
      String? token = await getValidAccessToken();

      Map<String, String> headers = {
        'Content-Type': 'application/json',
      };

      if (token != null) {
        headers['Authorization'] = 'Bearer $token';
      }

      String url = '$apiURL/wp-json/my-plugin/v1/trips';
      if (term != null && term.isNotEmpty) {
        url += '?term=$term';
      }

      print(url);
      final response = await client.get(
        Uri.parse(url),
        headers: headers,
      );

      print(response.body);

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        return jsonData.map((item) => Post.fromJson(item)).toList();
      } else {
        throw Exception('Failed to load posts: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching trip data: $e');
    }
  }

  static Future<Post> fetchPostById(int postId) async {
    try {
      final response = await client.get(
        Uri.parse('$apiURL/wp-json/my-plugin/v1/trips/$postId'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        return Post.fromJson(jsonData);
      } else {
        throw Exception('Failed to load post: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching post by ID: $e');
    }
  }

  static Future<CreateReviewResponse> createReview(Review review) async {
    try {
      // Get valid token
      String? token = await getValidAccessToken();
      if (token == null) {
        return CreateReviewResponse(
          success: false,
          message: 'No valid access token available',
        );
      }

      print(jsonEncode(review.toJson()));

      // Make the API request
      final response = await client.post(
        Uri.parse('$apiURL/wp-json/balieco/v1/reviews'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(review.toJson()),
      );

      // Parse the response
      final jsonResponse = jsonDecode(response.body);

      if (response.statusCode == 201) {
        // Successfully created
        return CreateReviewResponse.fromJson(jsonResponse);
      } else {
        // Handle error response
        return CreateReviewResponse(
          success: false,
          message: jsonResponse['message'] ?? 'Failed to create review',
        );
      }
    } catch (e) {
      return CreateReviewResponse(
        success: false,
        message: 'Exception occurred: $e',
      );
    }
  }

  static Future<bool> toggleBookmark(int tripId) async {
    try {
      // Get valid token
      String? token = await getValidAccessToken();
      if (token == null) {
        throw Exception('No valid access token available');
      }

      final response = await client.post(
        Uri.parse('$apiURL/wp-json/balieco/v1/bookmark'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'trip_id': tripId,
        }),
      );

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        return jsonResponse['is_bookmarked'] ?? false;
      } else {
        throw Exception('Failed to toggle bookmark: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error toggling bookmark: $e');
    }
  }

  static Future<List<Post>> getBookmarkedPostsByCategory({String? term}) async {
    String? token = await getValidAccessToken();
    if (token == null) {
      throw Exception('No valid access token available');
    }

    // Prepare the URL with the optional 'term' parameter
    String url = '$apiURL/wp-json/my-plugin/v1/bookmarked-trips';
    if (term != null && term.isNotEmpty) {
      url += '?term=$term'; // Append the term to the URL if provided
    }

    final response = await client.get(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    print(response.body);

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);

      // Handle both object and array responses
      if (jsonData is Map) {
        final List<dynamic> postsData = jsonData['data'] ?? [];
        return postsData.map((item) => Post.fromJson(item)).toList();
      } else if (jsonData is List) {
        return jsonData.map((item) => Post.fromJson(item)).toList();
      } else {
        throw Exception('Unexpected bookmarks response format');
      }
    } else if (response.statusCode == 401) {
      throw Exception('User not logged in');
    } else {
      throw Exception(
          'Failed to load bookmarked posts: ${response.statusCode}');
    }
  }
}
