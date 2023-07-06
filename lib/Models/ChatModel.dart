
class ChatModel {
  String? idFrom;
  String? idTo;
  String? timestamp;
  String? content;

  ChatModel(
      {required this.idFrom,
        required this.idTo,
        required this.timestamp,
        required this.content,});

  ChatModel.fromJson(Map<String, dynamic> json) {
    idFrom = json['idFrom'];
    idTo = json['idTo'];
    timestamp = json['timestamp'];
    content = json['content'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['idFrom'] = this.idFrom;
    data['idTo'] = this.idTo;
    data['timestamp'] = this.timestamp;
    data['content'] = this.content;
    return data;
  }
}

