// *************************************************
// *************************************************
// *************************************************
// KEEP SKYPE PAYMENT & RECEIPT
// ADD ORDERS + ORDER ITEMS
// ADD BILLING ADDRESS, SHIPPING ADDRESS
// https://appmaster.io/blog/how-to-design-a-shopping-cart-database
// *************************************************
// *************************************************
// *************************************************

class StripePayment {
  final String stripePaymentId;
  final String uid; // id of user creating this receipt
  final String receiptId;
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
  StripePayment({
    required this.stripePaymentId,
    required this.uid,
    required this.receiptId,
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

  StripePayment copyWith({
    String? stripePaymentId,
    String? uid,
    String? receiptId,
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
    return StripePayment(
      stripePaymentId: stripePaymentId ?? this.stripePaymentId,
      uid: uid ?? this.uid,
      receiptId: receiptId ?? this.receiptId,
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
      'stripePaymentId': stripePaymentId,
      'uid': uid,
      'receiptId': receiptId,
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

  factory StripePayment.fromMap(Map<String, dynamic> map) {
    return StripePayment(
      stripePaymentId: map['stripePaymentId'] as String,
      uid: map['uid'] as String,
      receiptId: map['receiptId'] as String,
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
    return 'StripePayment(stripePaymentId: $stripePaymentId, uid: $uid, receiptId: $receiptId, amount: $amount, currency: $currency, status: $status, buyerUid: $buyerUid, buyerEmail: $buyerEmail, sellerUid: $sellerUid, sellerEmail: $sellerEmail, paymentIntentId: $paymentIntentId, lastUpdateDate: $lastUpdateDate, creationDate: $creationDate)';
  }

  @override
  bool operator ==(covariant StripePayment other) {
    if (identical(this, other)) return true;

    return other.stripePaymentId == stripePaymentId &&
        other.uid == uid &&
        other.receiptId == receiptId &&
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
    return stripePaymentId.hashCode ^
        uid.hashCode ^
        receiptId.hashCode ^
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
