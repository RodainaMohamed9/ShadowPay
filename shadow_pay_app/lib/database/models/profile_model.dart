class ProfileModel {
  String fullName;
  String cardNumberHash;
  String cardHolderName;
  DateTime exprDate;
  String email;
  String phoneNumber;
  bool isFrozen; 
  double balance; 
  String cardType;


  ProfileModel({
    required this.fullName,
    required this.cardNumberHash,
    required this.cardHolderName,
    required this.exprDate,
    required this.email,
    required this.phoneNumber,
    required this.isFrozen,
    required this.balance,
    required this.cardType,
  });

  String get formattedExpiry {
    final month = exprDate.month.toString().padLeft(2, '0');
    final year = exprDate.year.toString().substring(2);
    return "$month/$year";
  }

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      fullName: json['fullName'] ?? '',
      cardNumberHash: json['cardNumberHash'] ?? '',
      cardHolderName: json['cardHolderName'] ?? '',
      exprDate: json['exprDate'] != null
          ? DateTime.parse(json['exprDate'])
          : DateTime.now(),
      email: json['email'] ?? '',
      phoneNumber: json['phoneNumber'] ?? '',
      isFrozen: json['isFrozen'] ?? false,
      balance: (json['balance'] ?? 0.0).toDouble(),
      cardType: json['cardType'] ?? 'VISA',
    );
  }

  Map<String, dynamic> toJson() => {
        "fullName": fullName,
        "cardNumberHash": cardNumberHash,
        "cardHolderName": cardHolderName,
        "exprDate": exprDate.toIso8601String(),
        "email": email,
        "phoneNumber": phoneNumber,
        "isFrozen": isFrozen,
        "balance": balance,
        "cardType": cardType,
      };
}
