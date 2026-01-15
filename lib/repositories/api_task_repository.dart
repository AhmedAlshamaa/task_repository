

import 'task_repository.dart';
import '../models/task.dart';
import '../services/api/todo_api.dart';

class ApiTaskRepository implements TaskRepository {
  final TodoApi _api = TodoApi();

  @override
  Future<List<Task>> getAllTasks() async {
    // استدعاء الدالة الصحيحة بناءً على TodoApi
    return await _api.fetchTodos(limit: 30);
  }

  @override
  Future<Task> getTaskById(String id) async {
    // لنفس الوظيفة، نحتاج لجلب كل المهام ثم البحث عن المهمة المطلوبة
    // لأن TodoApi لا يحتوي على دالة getTaskById
    final tasks = await getAllTasks();
    final task = tasks.firstWhere((task) => task.id == id, 
      orElse: () => throw Exception('Task not found with id: $id'));
    return task;
  }

  @override
  Future<void> addTask(Task task) async {
    // addTask في TodoApi ترجع Task، لكننا لا نحتاج إلى القيمة المرجعة
    await _api.addTask(task);
  }

  @override
  Future<void> updateTask(Task task) async {
    await _api.updateTask(task);
  }

  @override
  Future<void> deleteTask(String id) async {
    await _api.deleteTask(id);
  }

  @override
  Future<void> clearAll() async {
    // نفترض أن API لا يدعم حذف الكل مباشرة
    // لذا نحذف المهام واحدة تلو الأخرى
    final tasks = await getAllTasks();
    for (final task in tasks) {
      await deleteTask(task.id);
    }
  }
}