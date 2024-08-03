// ignore_for_file: public_member_api_docs, sort_constructors_first
class IntervalModel {
  int interval;
  String title;
  IntervalModel({
    required this.interval,
    required this.title,
  });
}

List<IntervalModel> getIntervalsList() {
  return [
    IntervalModel(interval: 0, title: 'None'),
    IntervalModel(interval: 1, title: 'Once'),
    IntervalModel(interval: 2, title: 'Twice'),
    IntervalModel(interval: 3, title: 'Thrice'),
  ];
}
