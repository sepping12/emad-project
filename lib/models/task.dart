/// Un'attività della to-do list.
class Task {
  Task({required this.title, this.important = false, this.completed = false});

  final String title;
  final bool important;
  bool completed;
}
