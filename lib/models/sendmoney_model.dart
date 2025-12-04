class SendMoneyModel {
  final String id; // unique transaction id
  final String mobilenumber; // stored as string
  final double amount; // numeric amount
  final String remarks;

  SendMoneyModel({
    required this.id,
    required this.mobilenumber,
    required this.amount,
    required this.remarks,
  });
}
