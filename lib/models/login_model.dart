
import 'dart:convert';

LoginResponseModel loginResponseModelFromJson(String str) => LoginResponseModel.fromJson(json.decode(str));

class LoginResponseModel {
  bool? success;
  int? statuscode;
  String? code;
  String? message;
  Data? data;

  LoginResponseModel({this.success, this.statuscode, this.code, this.message, this.data});

  LoginResponseModel.fromJson(Map<String, dynamic> json){
    success = json["success"];
    statuscode = json["statusCode"];
    code = json["code"];
    message = json["message"];
    data = json["data"].length > 0 ? new Data.fromJson(json["data"]) : null;
  }

  Map<String, dynamic> toJson(){
    final Map<String, dynamic> data = <String, dynamic>{};
    data["success"] = this.success;
    data["statuscode"] = this.statuscode;
    data["code"] = this.code;
    data["message"] = this.message;
    if(this.data != null){
      data["data"] = this.data!.toJson();
    }

    return data;
  }
}

class Data {
  String? token;
  int? id;
  String? email;
  String? nicename;
  String? firstname;
  String? lastname;
  String? displayname;

  Data({
    required this.token,
    required this.id,
    required this.email,
    required this.nicename,
  });

  Data.fromJson(Map<String, dynamic> json){
    token = json["token"];
    id = json["id"];
    email = json["email"];
    nicename = json["nicename"];
    firstname = json["firstname"];
    lastname = json["lastname"];
    displayname = json["displayname"];
  }

  Map<String, dynamic> toJson(){
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["token"] = this.token;
    data["id"] = this.id;
    data["email"] = this.email;
    data["nicename"] = this.nicename;
    data["firstname"] = this.firstname;
    data["lastname"] = this.lastname;
    data["displayname"] = this.displayname;
    return data;
  }
}