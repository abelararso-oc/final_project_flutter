import '../model/task.dart';

abstract class Storage {
  Future<List<Task>> getTasks();

  Future<Task> insertTask(Task task);

  Future<void> removeTask(Task task);
}
