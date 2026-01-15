

import 'package:hive/hive.dart';
import 'task_repository.dart';
import '../models/task.dart';

class LocalTaskRepository implements TaskRepository {
  late Box<Task> _taskBox;

  LocalTaskRepository() {
    _init();
  }

  Future<void> _init() async {
    _taskBox = await Hive.openBox<Task>('tasks_box');
  }

  @override
  Future<List<Task>> getAllTasks() async {
    await _ensureBoxOpen();
    return _taskBox.values.toList();
  }

  @override
  Future<Task> getTaskById(String id) async {
    await _ensureBoxOpen();
    final task = _taskBox.get(id);
    if (task == null) {
      throw Exception('Task with id $id not found');
    }
    return task;
  }

  @override
  Future<void> addTask(Task task) async {
    await _ensureBoxOpen();
    await _taskBox.put(task.id, task);
  }

  @override
  Future<void> updateTask(Task task) async {
    await _ensureBoxOpen();
    await _taskBox.put(task.id, task);
  }

  @override
  Future<void> deleteTask(String id) async {
    await _ensureBoxOpen();
    await _taskBox.delete(id);
  }

  @override
  Future<void> clearAll() async {
    await _ensureBoxOpen();
    await _taskBox.clear();
  }

  Future<void> _ensureBoxOpen() async {
    if (!_taskBox.isOpen) {
      _taskBox = await Hive.openBox<Task>('tasks_box');
    }
  }
}