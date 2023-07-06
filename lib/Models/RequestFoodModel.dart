import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fdn/Models/foodModel.dart';

class RequestFoodModel {
  String? requestedFood;
  Timestamp? requestedOn;
  String? requestedBy;
  String? requestedUid;
  String? requestedTo;
  String? quantity;
  double? reservedLatitude;
  double? reservedLongitude;
  int? index;
  bool? resurved;
  String? uid;
  String? reservedStatus;
  String? requestedVolunteer;
  String? deliveredBy;
  Timestamp? deliveredOn;
  Timestamp? requestedOnForRequest;
  bool? isAccepted;
  String? resurvedBy;

  RequestFoodModel(
      {
        this.requestedOn,
        this.quantity,
        this.requestedBy,
        this.resurved,
        this.requestedFood,
        this.requestedTo,
        this.index,
      this.uid,
        this.reservedLongitude,
        this.reservedLatitude,
        this.requestedUid,
        this.reservedStatus,
        this.requestedVolunteer,
        this.requestedOnForRequest,
        this.deliveredBy,
        this.deliveredOn,
        this.isAccepted
      });

  RequestFoodModel.fromJson(Map<String, dynamic> json) {

    requestedOn = json['requestedOn'];
    quantity = json['quantity'];
    requestedBy = json['requestedBy'];
    resurved= json['resurved'];
    requestedTo = json['requestedTo'];
    requestedFood = json['requestedFood'];
    uid = json['uid'];
    index = json['index'];
    reservedLongitude = json['reservedLongitude'];
    reservedLatitude = json['reservedLatitude'];
    requestedUid = json['requestedUid'];
    reservedStatus = json['reservedStatus'];
    requestedVolunteer = json['requestedVolunteer'];
    requestedOnForRequest = json['requestedOnForRequest'];
    deliveredBy = json['deliveredBy'];
    deliveredOn = json['deliveredOn'];
    isAccepted = json['isAccepted'];

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();

    data['requestedOn'] = this.requestedOn;
    data['quantity'] = this.quantity;
    data['requestedBy'] = this.requestedBy;
    data['resurved'] = this.resurved;
    data['requestedFood'] = this.requestedFood;
    data['requestedTo'] = this.requestedTo;
    data['uid'] = this.uid;
    data['index'] = this.index;
    data['requestedUid'] = this.requestedUid;
    data['reservedStatus'] = this.reservedStatus;
    data['requestedVolunteer'] = this.requestedVolunteer;
    data['reservedLongitude'] = this.reservedLongitude;
    data['reservedLatitude'] = this.reservedLatitude;
    data['requestedOn'] = this.requestedOn;
    data['deliveredBy'] = this.deliveredBy;
    data['requestedOnForRequest'] = this.requestedOnForRequest;
    data['isAccepted'] = this.isAccepted;
    return data;
  }
 
}
