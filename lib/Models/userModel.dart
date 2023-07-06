import 'package:cloud_firestore/cloud_firestore.dart';

import 'UserType.dart';

class UserModel {
  String? uid;
  String? name;
  String? email;
  Timestamp? registeredOn;
  String? profileImageUrl;
  String? contactNo;
  String? type;
  String? address;

  UserModel(
      {this.name,
        this.email,
        this.registeredOn,
        this.profileImageUrl,
        this.contactNo,
        this.type,
        this.uid,
        this.address,
      });

  UserModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    email = json['email'];
    registeredOn = json['registeredOn'];
    profileImageUrl = json['profileImageUrl'];
    contactNo = json['contactNo'];
    type = json['userType'];
    uid = json['uid'];
    address =json['address'];
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
    data['address'] = this.address;
    return data;
  }
}
