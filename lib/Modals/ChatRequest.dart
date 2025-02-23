class ChatRequest {
  final String receiver_id;
  final String sender_id;
  final String sendername;
  final String receivername;
  final String receiverimage;
  final String senderimage;
  final String senderemail;
  final String receiveremail;
  final String sendernumber;
  final String time;
  final String status;
  final String receipient_number;

  ChatRequest(
      {required this.receiver_id,
      required this.sender_id,
      required this.sendername,
      required this.receivername,
      required this.receiverimage,
      required this.senderimage,
      required this.senderemail,
      required this.sendernumber,
      required this.receiveremail,
      required this.status,
      required this.time,
      required this.receipient_number});
}
