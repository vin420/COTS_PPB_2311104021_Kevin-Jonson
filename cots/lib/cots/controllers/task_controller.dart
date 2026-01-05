import '../models/task_model.dart';
import '../services/task_service.dart';

class TaskController {
  final TaskService _service = TaskService();

  Future<List<Task>> fetchAll() {
    return _service.getTasks();
  }

  Future<void> add(Map<String, dynamic> data) {
    return _service.addTask(data);
  }

  Future<void> updateTask(int id, Map<String, dynamic> data) {
    return _service.updateTask(id, data);
  }

  Future<void> toggleDone(Task task) {
    return _service.updateTask(task.id, {
      'is_done': !task.isDone,
      'status': task.isDone ? 'BERJALAN' : 'SELESAI',
    });
  }
}
