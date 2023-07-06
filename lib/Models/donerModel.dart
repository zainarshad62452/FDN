import 'package:cloud_firestore/cloud_firestore.dart';

import 'UserType.dart';

class DonorModel {
  String? uid;
  String? name;
  String? email;
  Timestamp? registeredOn;
  String? profileImageUrl;
  String? contactNo;
  String? type;
  String? address;
  UserType? userType;
  String? token;

  DonorModel(
      {this.name,
        this.email,
        this.registeredOn,
        this.profileImageUrl,
        this.contactNo,
        this.type,
        this.uid,
        this.address,
        this.userType,
        this.token
      });

  DonorModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    email = json['email'];
    registeredOn = json['registeredOn'];
    profileImageUrl = json['profileImageUrl'];
    contactNo = json['contactNo'];
    type = json['userType'];
    uid = json['uid'];
    address =json['address'];
    token = json['token'];
    userType = UserType().instance(json['userType']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['email'] = this.email;
    data['registeredOn'] = this.registeredOn;
    data['profileImageUrl'] = this.profileImageUrl;
    data['contactNo'] = this.contactNo;
    data['userType'] = this.type;
    data['uid'] = this.uid;
    data['token'] = this.token;
    data['address'] = this.address;
    return data;
  }
}
