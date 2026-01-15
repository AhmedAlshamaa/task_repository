import 'dart:developer';
import 'task_repository.dart';
import 'local_task_repository.dart';
import 'api_task_repository.dart';
import '../models/task.dart';

class TaskSyncRepository implements TaskRepository {
  final LocalTaskRepository _localRepo = LocalTaskRepository();
  final ApiTaskRepository _apiRepo = ApiTaskRepository();

  @override
  Future<List<Task>> getAllTasks() async {
    return await _localRepo.getAllTasks();
  }

  @override
  Future<Task> getTaskById(String id) async {
    return await _localRepo.getTaskById(id);
  }

  @override
  Future<void> addTask(Task task) async {
    await _localRepo.addTask(task);
  }

  @override
  Future<void> updateTask(Task task) async {
    await _localRepo.updateTask(task);
  }

  @override
  Future<void> deleteTask(String id) async {
    await _localRepo.deleteTask(id);
  }

  @override
  Future<void> clearAll() async {
    await _localRepo.clearAll();
  }

  Future<List<Task>> syncFromApi({int limit = 30}) async {
    try {
      // استخدام getAllTasks من ApiTaskRepository بدلاً من fetchTodos
      final apiTasks = await _apiRepo.getAllTasks();

      // تخزينها محلياً
      for (var task in apiTasks) {
        await _localRepo.addTask(task);
      }

      return apiTasks;
    } catch (e) {
      // استخدام log بدلاً من print
      log('Failed to sync from API: $e');
      throw Exception('Failed to sync tasks from API: $e');
    }
  }

  Future<List<Task>> syncUsersTasks(int userId) async {
    try {
      // نستخدم getAllTasks ثم نفلتر حسب المستخدم
      final allTasks = await _apiRepo.getAllTasks();
      final userTasks = allTasks.where((task) {
        // نفترض أن Task لديها حقل userId
        // إذا لم يكن لديها، يمكنك إضافته أو استخدام طريقة أخرى
        return true; // تعديل هذا الشرط بناءً على هيكل Task لديك
      }).toList();

      // تخزينها محلياً
      for (var task in userTasks) {
        await _localRepo.addTask(task);
      }

      return userTasks;
    } catch (e) {
      log('Failed to sync user tasks from API: $e');
      throw Exception('Failed to sync user tasks from API: $e');
    }
  }

  // دالة إضافية للمزامنة ثنائية الاتجاه
  Future<void> syncAllTasks() async {
    try {
      // 1. جلب المهام من API
      final apiTasks = await _apiRepo.getAllTasks();
      
      // 2. جلب المهام المحلية
      final localTasks = await _localRepo.getAllTasks();
      
      // 3. دمج المهام (مثال بسيط)
      final localTaskIds = localTasks.map((t) => t.id).toSet();
      
      for (final apiTask in apiTasks) {
        if (!localTaskIds.contains(apiTask.id)) {
          await _localRepo.addTask(apiTask);
        } else {
          // إذا كانت موجودة محلياً، يمكن تحديثها
          await _localRepo.updateTask(apiTask);
        }
      }
      
      // 4. إرسال المهام المحلية التي ليست على API
      for (final localTask in localTasks) {
        try {
          // يمكنك إضافة منطق للتحقق إذا كانت المهمة موجودة على API
          await _apiRepo.addTask(localTask);
        } catch (e) {
          log('Failed to push task ${localTask.id} to API: $e');
        }
      }
      
      log('Sync completed successfully');
    } catch (e) {
      log('Failed to sync all tasks: $e');
      throw Exception('Sync failed: $e');
    }
  }
}