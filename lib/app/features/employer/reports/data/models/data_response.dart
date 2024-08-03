class DateResponse {
  final DateTime date;
  final String day;

  DateResponse({
    required this.date,
    required this.day,
  });

  factory DateResponse.fromJson(DateTime date, String day) {
    return DateResponse(
      date: date,
      day: day,
    );
  }
}
