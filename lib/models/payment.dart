class Payment {
  final String paymentId;
  final String uid; // id of user creating this receipt
  final String receiptId;
  final double amount; // amount to pay
  final String currency; // [usd, nzd, aud etc]
  final int quantity; // number of units ordered
  final String status; // [Pending, Success, Fail]
  final String buyerUid; // id of the user creating the payment
  final String buyerServiceId; // id of the service creating the payment
  final String buyerEmail;
  final String sellerUid; // id of the user receiving the payment
  final String sellerServiceId; // id of the service receiving the payment
  final String sellerEmail;
  final String paymentIntentId;
  final DateTime lastUpdateDate;
  final DateTime creationDate;
  Payment({
    required this.paymentId,
    required this.uid,
    required this.receiptId,
    required this.amount,
    required this.currency,
    required this.quantity,
    required this.status,
    required this.buyerUid,
    required this.buyerServiceId,
    required this.buyerEmail,
    required this.sellerUid,
    required this.sellerServiceId,
    required this.sellerEmail,
    required this.paymentIntentId,
    required this.lastUpdateDate,
    required this.creationDate,
  });

  Payment copyWith({
    String? paymentId,
    String? uid,
    String? receiptId,
    double? amount,
    String? currency,
    int? quantity,
    String? status,
    String? buyerUid,
    String? buyerServiceId,
    String? buyerEmail,
    String? sellerUid,
    String? sellerServiceId,
    String? sellerEmail,
    String? paymentIntentId,
    DateTime? lastUpdateDate,
    DateTime? creationDate,
  }) {
    return Payment(
      paymentId: paymentId ?? this.paymentId,
      uid: uid ?? this.uid,
      receiptId: receiptId ?? this.receiptId,
      amount: amount ?? this.amount,
      currency: currency ?? this.currency,
      quantity: quantity ?? this.quantity,
      status: status ?? this.status,
      buyerUid: buyerUid ?? this.buyerUid,
      buyerServiceId: buyerServiceId ?? this.buyerServiceId,
      buyerEmail: buyerEmail ?? this.buyerEmail,
      sellerUid: sellerUid ?? this.sellerUid,
      sellerServiceId: sellerServiceId ?? this.sellerServiceId,
      sellerEmail: sellerEmail ?? this.sellerEmail,
      paymentIntentId: paymentIntentId ?? this.paymentIntentId,
      lastUpdateDate: lastUpdateDate ?? this.lastUpdateDate,
      creationDate: creationDate ?? this.creationDate,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'paymentId': paymentId,
      'uid': uid,
      'receiptId': receiptId,
      'amount': amount,
      'currency': currency,
      'quantity': quantity,
      'status': status,
      'buyerUid': buyerUid,
      'buyerServiceId': buyerServiceId,
      'buyerEmail': buyerEmail,
      'sellerUid': sellerUid,
      'sellerServiceId': sellerServiceId,
      'sellerEmail': sellerEmail,
      'paymentIntentId': paymentIntentId,
      'lastUpdateDate': lastUpdateDate.millisecondsSinceEpoch,
      'creationDate': creationDate.millisecondsSinceEpoch,
    };
  }

  factory Payment.fromMap(Map<String, dynamic> map) {
    return Payment(
      paymentId: map['paymentId'] as String,
      uid: map['uid'] as String,
      receiptId: map['receiptId'] as String,
      amount: map['amount'] as double,
      currency: map['currency'] as String,
      quantity: map['quantity'] as int,
      status: map['status'] as String,
      buyerUid: map['buyerUid'] as String,
      buyerServiceId: map['buyerServiceId'] as String,
      buyerEmail: map['buyerEmail'] as String,
      sellerUid: map['sellerUid'] as String,
      sellerServiceId: map['sellerServiceId'] as String,
      sellerEmail: map['sellerEmail'] as String,
      paymentIntentId: map['paymentIntentId'] as String,
      lastUpdateDate:
          DateTime.fromMillisecondsSinceEpoch(map['lastUpdateDate'] as int),
      creationDate:
          DateTime.fromMillisecondsSinceEpoch(map['creationDate'] as int),
    );
  }

  @override
  String toString() {
    return 'Payment(paymentId: $paymentId, uid: $uid, receiptId: $receiptId, amount: $amount, currency: $currency, quantity: $quantity, status: $status, buyerUid: $buyerUid, buyerServiceId: $buyerServiceId, buyerEmail: $buyerEmail, sellerUid: $sellerUid, sellerServiceId: $sellerServiceId, sellerEmail: $sellerEmail, paymentIntentId: $paymentIntentId, lastUpdateDate: $lastUpdateDate, creationDate: $creationDate)';
  }

  @override
  bool operator ==(covariant Payment other) {
    if (identical(this, other)) return true;

    return other.paymentId == paymentId &&
        other.uid == uid &&
        other.receiptId == receiptId &&
        other.amount == amount &&
        other.currency == currency &&
        other.quantity == quantity &&
        other.status == status &&
        other.buyerUid == buyerUid &&
        other.buyerServiceId == buyerServiceId &&
        other.buyerEmail == buyerEmail &&
        other.sellerUid == sellerUid &&
        other.sellerServiceId == sellerServiceId &&
        other.sellerEmail == sellerEmail &&
        other.paymentIntentId == paymentIntentId &&
        other.lastUpdateDate == lastUpdateDate &&
        other.creationDate == creationDate;
  }

  @override
  int get hashCode {
    return paymentId.hashCode ^
        uid.hashCode ^
        receiptId.hashCode ^
        amount.hashCode ^
        currency.hashCode ^
        quantity.hashCode ^
        status.hashCode ^
        buyerUid.hashCode ^
        buyerServiceId.hashCode ^
        buyerEmail.hashCode ^
        sellerUid.hashCode ^
        sellerServiceId.hashCode ^
        sellerEmail.hashCode ^
        paymentIntentId.hashCode ^
        lastUpdateDate.hashCode ^
        creationDate.hashCode;
  }
}
