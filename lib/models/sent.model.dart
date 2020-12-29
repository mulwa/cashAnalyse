class SentModel {
  bool success;
  List<Sends> sends;

  SentModel({this.success, this.sends});

  SentModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['sends'] != null) {
      sends = new List<Sends>();
      json['sends'].forEach((v) {
        sends.add(new Sends.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    if (this.sends != null) {
      data['sends'] = this.sends.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Sends {
  int id;
  String receiverName;
  String receiverMobile;
  dynamic amount;
  String transferDate;
  String transactionRef;
  int userId;
  String createdAt;
  String updatedAt;

  Sends(
      {this.id,
      this.receiverName,
      this.receiverMobile,
      this.amount,
      this.transferDate,
      this.transactionRef,
      this.userId,
      this.createdAt,
      this.updatedAt});

  @override
  String toString() {
    return '{ ${this.receiverName} ${this.amount}}';
  }

  Sends.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    receiverName = json['receiverName'];
    receiverMobile = json['receiverMobile'];
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
    data['receiverName'] = this.receiverName;
    data['receiverMobile'] = this.receiverMobile;
    data['amount'] = this.amount;
    data['transferDate'] = this.transferDate;
    data['transactionRef'] = this.transactionRef;
    data['userId'] = this.userId;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    return data;
  }
}
