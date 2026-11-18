import 'package:flutter/material.dart';

import '../models/task.dart';
import 'add_task_screen.dart';

class TaskListScreen extends StatefulWidget {
  const TaskListScreen({super.key});

  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  final List<Task> _tasks = [];

  int get _completedCount => _tasks.where((t) => t.completed).length;

  Future<void> _addTask() async {
    final task = await Navigator.push<Task>(
      context,
      MaterialPageRoute(builder: (_) => const AddTaskScreen()),
    );
    if (task == null || !mounted) return; // rinuncia: nessun cambiamento
    setState(() => _tasks.add(task));
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(const SnackBar(content: Text('Attività aggiunta')));
  }

  Future<void> _deleteTask(Task task) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Eliminare attività?'),
        content: Text('"${task.title}" verrà rimossa.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Annulla'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Elimina'),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      setState(() => _tasks.remove(task));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Le mie attività'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(28),
          child: Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text(
              'Completate: $_completedCount / ${_tasks.length}',
              style: Theme.of(context).textTheme.titleSmall,
            ),
          ),
        ),
      ),
      body: _tasks.isEmpty
          ? const Center(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: Text(
                  'Nessuna attività.\nPremi + per aggiungerne una.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16),
                ),
              ),
            )
          : ListView.builder(
              itemCount: _tasks.length,
              itemBuilder: (context, i) => _buildTile(_tasks[i]),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addTask,
        tooltip: 'Nuova attività',
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildTile(Task task) {
    final scheme = Theme.of(context).colorScheme;
    return ListTile(
      leading: Checkbox(
        value: task.completed,
        onChanged: (v) => setState(() => task.completed = v ?? false),
      ),
      title: Text(
        task.title,
        style: TextStyle(
          decoration: task.completed ? TextDecoration.lineThrough : null,
          color: task.completed ? Colors.grey : null,
          fontWeight: task.important ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      subtitle: Text(task.completed ? 'Completata' : 'Da fare'),
      onTap: () => setState(() => task.completed = !task.completed),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (task.important)
            Icon(Icons.star,
                color: Colors.amber.shade700, semanticLabel: 'Importante'),
          IconButton(
            icon: Icon(Icons.delete_outline, color: scheme.error),
            tooltip: 'Elimina',
            onPressed: () => _deleteTask(task),
          ),
        ],
      ),
    );
  }
}
