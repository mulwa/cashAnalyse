class ReceivedRespond {
  bool success;
  List<Received> received;

  ReceivedRespond({this.success, this.received});

  ReceivedRespond.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['received'] != null) {
      received = new List<Received>();
      json['received'].forEach((v) {
        received.add(new Received.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    if (this.received != null) {
      data['received'] = this.received.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Received {
  int id;
  String senderName;
  String senderMobile;
  dynamic amount;
  String transferDate;
  String transactionRef;
  int userId;
  String createdAt;
  String updatedAt;

  Received(
      {this.id,
      this.senderName,
      this.senderMobile,
      this.amount,
      this.transferDate,
      this.transactionRef,
      this.userId,
      this.createdAt,
      this.updatedAt});

  Received.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    senderName = json['senderName'];
    senderMobile = json['senderMobile'];
    amount = json['amount'];
    transferDate = json['transferDate'];
    transactionRef = json['transactionRef'];
    userId = json['userId'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['senderName'] = this.senderName;
    data['senderMobile'] = this.senderMobile;
    data['amount'] = this.amount;
    data['transferDate'] = this.transferDate;
    data['transactionRef'] = this.transactionRef;
    data['userId'] = this.userId;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    return data;
  }
}
