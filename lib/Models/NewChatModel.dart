
class NewChatModel {
  String? groupID;
  String? user1;
  String? user2;

  NewChatModel(
      {required this.groupID,this.user1,this.user2});

  NewChatModel.fromJson(Map<String, dynamic> json) {
    groupID = json['groupID'];
    user1 = json['user1'];
    user2 = json['user2'];

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['groupID'] = this.groupID;
    data['user1'] = this.user1;
    data['user2'] = this.user2;
    return data;
  }
}

