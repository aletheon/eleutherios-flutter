class StripeReceipt {
  final String stripeReceiptId;
  final String uid; // id of user creating this receipt
  final String paymentId;
  final double amount; // amount to pay
  final String currency; // [usd, nzd, aud etc]
  final String status; // [Pending, Success, Fail]
  final String buyerUid; // id of the user creating the payment
  final String buyerEmail;
  final String sellerUid; // id of the user receiving the payment
  final String sellerEmail;
  final String paymentIntentId;
  final DateTime lastUpdateDate;
  final DateTime creationDate;
  StripeReceipt({
    required this.stripeReceiptId,
    required this.uid,
    required this.paymentId,
    required this.amount,
    required this.currency,
    required this.status,
    required this.buyerUid,
    required this.buyerEmail,
    required this.sellerUid,
    required this.sellerEmail,
    required this.paymentIntentId,
    required this.lastUpdateDate,
    required this.creationDate,
  });

  StripeReceipt copyWith({
    String? stripeReceiptId,
    String? uid,
    String? paymentId,
    double? amount,
    String? currency,
    String? status,
    String? buyerUid,
    String? buyerEmail,
    String? sellerUid,
    String? sellerEmail,
    String? paymentIntentId,
    DateTime? lastUpdateDate,
    DateTime? creationDate,
  }) {
    return StripeReceipt(
      stripeReceiptId: stripeReceiptId ?? this.stripeReceiptId,
      uid: uid ?? this.uid,
      paymentId: paymentId ?? this.paymentId,
      amount: amount ?? this.amount,
      currency: currency ?? this.currency,
      status: status ?? this.status,
      buyerUid: buyerUid ?? this.buyerUid,
      buyerEmail: buyerEmail ?? this.buyerEmail,
      sellerUid: sellerUid ?? this.sellerUid,
      sellerEmail: sellerEmail ?? this.sellerEmail,
      paymentIntentId: paymentIntentId ?? this.paymentIntentId,
      lastUpdateDate: lastUpdateDate ?? this.lastUpdateDate,
      creationDate: creationDate ?? this.creationDate,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'stripeReceiptId': stripeReceiptId,
      'uid': uid,
      'paymentId': paymentId,
      'amount': amount,
      'currency': currency,
      'status': status,
      'buyerUid': buyerUid,
      'buyerEmail': buyerEmail,
      'sellerUid': sellerUid,
      'sellerEmail': sellerEmail,
      'paymentIntentId': paymentIntentId,
      'lastUpdateDate': lastUpdateDate.millisecondsSinceEpoch,
      'creationDate': creationDate.millisecondsSinceEpoch,
    };
  }

  factory StripeReceipt.fromMap(Map<String, dynamic> map) {
    return StripeReceipt(
      stripeReceiptId: map['stripeReceiptId'] as String,
      uid: map['uid'] as String,
      paymentId: map['paymentId'] as String,
      amount: map['amount'] as double,
      currency: map['currency'] as String,
      status: map['status'] as String,
      buyerUid: map['buyerUid'] as String,
      buyerEmail: map['buyerEmail'] as String,
      sellerUid: map['sellerUid'] as String,
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
    return 'StripeReceipt(stripeReceiptId: $stripeReceiptId, uid: $uid, paymentId: $paymentId, amount: $amount, currency: $currency, status: $status, buyerUid: $buyerUid, buyerEmail: $buyerEmail, sellerUid: $sellerUid, sellerEmail: $sellerEmail, paymentIntentId: $paymentIntentId, lastUpdateDate: $lastUpdateDate, creationDate: $creationDate)';
  }

  @override
  bool operator ==(covariant StripeReceipt other) {
    if (identical(this, other)) return true;

    return other.stripeReceiptId == stripeReceiptId &&
        other.uid == uid &&
        other.paymentId == paymentId &&
        other.amount == amount &&
        other.currency == currency &&
        other.status == status &&
        other.buyerUid == buyerUid &&
        other.buyerEmail == buyerEmail &&
        other.sellerUid == sellerUid &&
        other.sellerEmail == sellerEmail &&
        other.paymentIntentId == paymentIntentId &&
        other.lastUpdateDate == lastUpdateDate &&
        other.creationDate == creationDate;
  }

  @override
  int get hashCode {
    return stripeReceiptId.hashCode ^
        uid.hashCode ^
        paymentId.hashCode ^
        amount.hashCode ^
        currency.hashCode ^
        status.hashCode ^
        buyerUid.hashCode ^
        buyerEmail.hashCode ^
        sellerUid.hashCode ^
        sellerEmail.hashCode ^
        paymentIntentId.hashCode ^
        lastUpdateDate.hashCode ^
        creationDate.hashCode;
  }
}
