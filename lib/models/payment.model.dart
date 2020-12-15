class PaymentModel {
  bool success;
  List<Payments> payments;

  PaymentModel({this.success, this.payments});

  PaymentModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['payments'] != null) {
      payments = new List<Payments>();
      json['payments'].forEach((v) {
        payments.add(new Payments.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    if (this.payments != null) {
      data['payments'] = this.payments.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Payments {
  int id;
  String receiverName;
  dynamic amount;
  String transferDate;
  String transactionRef;
  int userId;
  String createdAt;
  String updatedAt;

  Payments(
      {this.id,
      this.receiverName,
      this.amount,
      this.transferDate,
      this.transactionRef,
      this.userId,
      this.createdAt,
      this.updatedAt});

  Payments.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    receiverName = json['receiverName'];
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
    data['amount'] = this.amount;
    data['transferDate'] = this.transferDate;
    data['transactionRef'] = this.transactionRef;
    data['userId'] = this.userId;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    return data;
  }
}
