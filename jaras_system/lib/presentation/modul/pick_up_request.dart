class PickUpRequest {
  final String id;
  final String studentName;
  final String time;
  final String date;
   String status;

  PickUpRequest({
    required this.id,
    required this.studentName,
    required this.time,
    required this.date,
    required this.status,
  });
}
