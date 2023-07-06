class UserType {
  bool user = false;
  bool donor = false;
  bool none = false;
  bool volunteer = false;

  UserType(
      {this.user = false,
        this.donor = false,
        this.none = false,
  this.volunteer = false});

  UserType.fromJson(Map<String, dynamic> json) {
    user = json['user'];
    donor = json['donor'];
    none = json['none'];
    volunteer = json['volunteer'];

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user'] = this.user;
    data['donor'] = this.donor;
    data['none'] = this.none;
    data['volunteer'] = this.volunteer;
    return data;
  }

  UserType instance(String type) {
    if (type == "user")
      return UserType(user: true);
    else if (type == "donor")
      return UserType(donor: true);
    else if (type == "volunteer")
      return UserType(volunteer: true);
    else
      return UserType(none: true);
  }
}
