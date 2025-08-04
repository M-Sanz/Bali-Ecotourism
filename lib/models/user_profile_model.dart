import 'dart:convert';

UserProfileResponse userProfileResponseFromJson(String str) =>
    UserProfileResponse.fromJson(json.decode(str));

String userProfileResponseToJson(UserProfileResponse data) =>
    json.encode(data.toJson());

class UserProfileResponse {
  int? code;
  UserProfile? data;

  UserProfileResponse({
    this.code,
    this.data,
  });

  factory UserProfileResponse.fromJson(Map<String, dynamic> json) =>
      UserProfileResponse(
        code: json["code"],
        data: json["data"] != null ? UserProfile.fromJson(json["data"]) : null,
      );

  Map<String, dynamic> toJson() => {
    "code": code,
    "data": data?.toJson(),
  };
}

class UserProfile {
  int id;
  String displayName;
  String username;
  String email;
  String mobileNumber;
  String gender;
  String dob;
  String nationality;
  String description;
  String? profilePhotoUrl;

  UserProfile({
    required this.id,
    required this.displayName,
    required this.username,
    required this.email,
    required this.mobileNumber,
    required this.gender,
    required this.dob,
    required this.nationality,
    required this.description,
    this.profilePhotoUrl
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) => UserProfile(
    id: json["id"],
    displayName: json["display_name"],
    username: json["username"],
    email: json["email"],
    mobileNumber: json["mobile_number"],
    gender: json["gender"],
    dob: json["dob"],
    nationality: json["nationality"],
    description: json["description"],
    profilePhotoUrl: json["profile_photo"] is List && (json["profile_photo"] as List).isEmpty
        ? null
        : (json["profile_photo"] != null &&
        json["profile_photo"]["data"] != null &&
        (json["profile_photo"]["data"] as List).isNotEmpty
        ? json["profile_photo"]["data"][0]["url"]
        : null),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "display_name": displayName,
    "username": username,
    "email": email,
    "mobile_number": mobileNumber,
    "gender": gender,
    "dob": dob,
    "nationality": nationality,
    "description": description,
  };
}
