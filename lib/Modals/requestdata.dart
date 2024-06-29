class Request {
  final int id;
  final String name;
  final String imageURL;
  final String blood;
  final String location;
  final String hospitaname;
  final String rating;
  final String time;
  final String date;
  final String note;
  final String email;
  final String number;

  Request(
      {required this.id,
      required this.name,
      required this.imageURL,
      required this.blood,
      required this.location,
      required this.hospitaname,
      required this.rating,
      required this.time,
      required this.date,
      required this.note,
      required this.email,
      required this.number});
}
