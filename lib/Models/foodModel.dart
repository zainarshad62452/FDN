import 'package:cloud_firestore/cloud_firestore.dart';

class FoodModel {
  String? name;
  String? category;
  Timestamp? registeredOn;
  String? profileImageUrl;
  String? quantity;
  String? description;
  String? itemId;
  String? location;
  String? phone;
  DateTime? date;
  double? latitude;
  double? longitude;
  double? reservedLatitude;
  double? reservedLongitude;
  String? postBy;
  bool? resurved;
  String? reservedStatus;
  String? requestedVolunteer;
  String? deliveredBy;
  Timestamp? deliveredOn;
  Timestamp? requestedOn;
  bool? isAccepted;
  String? resurvedBy;
  String? resurvedByUid;

  FoodModel(
      {this.name,
      this.category,
      this.registeredOn,
      this.profileImageUrl,
      this.quantity,
      this.description,
      this.date,
      this.itemId,
      this.location,
      this.phone,
      this.longitude,
      this.latitude,
        this.reservedLongitude,
        this.reservedLatitude,
      this.postBy,
      this.resurved,
      this.resurvedBy,
        this.reservedStatus,
        this.requestedVolunteer,
        this.requestedOn,
        this.deliveredBy,
        this.deliveredOn,
        this.isAccepted,this.resurvedByUid});

  FoodModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    category = json['category'];
    registeredOn = json['registeredOn'];
    profileImageUrl = json['profileImageUrl'];
    quantity = json['quantity'];
    description = json['description'];
    date = json['date'].toDate();
    itemId = json['itemId'];
    phone = json['phone'];
    location = json['location'];
    longitude = json['longitude'];
    latitude = json['latitude'];
    reservedLongitude = json['reservedLongitude'];
    reservedLatitude = json['reservedLatitude'];
    postBy = json['postBy'];
    resurved = json['resurved'];
    resurvedBy = json['resurvedBy'];
    reservedStatus = json['reservedStatus'];
    requestedVolunteer = json['requestedVolunteer'];
    requestedOn = json['requestedOn'];
    deliveredBy = json['deliveredBy'];
    deliveredOn = json['deliveredOn'];
    isAccepted = json['isAccepted'];
    resurvedByUid = json['resurvedByUid'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['category'] = this.category;
    data['registeredOn'] = this.registeredOn;
    data['profileImageUrl'] = this.profileImageUrl;
    data['quantity'] = this.quantity;
    data['description'] = this.description;
    data['date'] = date;
    data['itemId'] = itemId;
    data['phone'] = this.phone;
    data['location'] = this.location;
    data['longitude'] = this.longitude;
    data['latitude'] = this.latitude;
    data['reservedLongitude'] = this.reservedLongitude;
    data['reservedLatitude'] = this.reservedLatitude;
    data['postBy'] = this.postBy;
    data['resurved'] = this.resurved;
    data['resurvedBy'] = this.resurvedBy;
    data['reservedStatus'] = this.reservedStatus;
    data['requestedVolunteer'] = this.requestedVolunteer;
    data['requestedOn'] = this.requestedOn;
    data['deliveredBy'] = this.deliveredBy;
    data['deliveredOn'] = this.deliveredOn;
    data['isAccepted'] = this.isAccepted;
    data['resurvedByUid'] = this.resurvedByUid;
    return data;
  }
}
