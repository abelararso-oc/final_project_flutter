class Task {
  final String id;
  bool isCompleted;
  final String description;
  DateTime? dueDate;

  Task({this.description = '', this.dueDate, required this.id}) : isCompleted = false;

  Map<String, dynamic> toMap() => { 'id' : id, 'description' : description, 'dueDate' : dueDate, 'isCompleted' : isCompleted};

  Task.fromJson(Map<String, Object?> json)
      : this(
    id : json['id']! as String,
    description: json['description']! as String,
  );

  Map<String, Object?> toJson() {
    return {
      'id' : id,
      'description' : description,
      'dueDate' : dueDate
    };
  }
  @override
  String toString() => 'Task{id : $id, dueDate: $dueDate, description : $description, isCompleted : $isCompleted}';
}