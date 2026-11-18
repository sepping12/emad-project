import 'package:flutter/material.dart';

import '../models/task.dart';

/// Schermata di creazione. Restituisce con Navigator.pop la nuova [Task];
/// se l'utente rinuncia (es. tasto indietro) restituisce null.
class AddTaskScreen extends StatefulWidget {
  const AddTaskScreen({super.key});

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final _controller = TextEditingController();
  bool _important = false;
  String? _error;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _confirm() {
    final title = _controller.text.trim();
    if (title.isEmpty) {
      setState(() => _error = 'Il titolo è obbligatorio');
      return;
    }
    Navigator.pop(context, Task(title: title, important: _important));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Nuova attività')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              autofocus: true,
              textCapitalization: TextCapitalization.sentences,
              decoration: InputDecoration(
                labelText: 'Titolo',
                border: const OutlineInputBorder(),
                errorText: _error,
              ),
              // L'errore scompare appena il titolo viene corretto.
              onChanged: (value) {
                if (_error != null && value.trim().isNotEmpty) {
                  setState(() => _error = null);
                }
              },
              onSubmitted: (_) => _confirm(),
            ),
            const SizedBox(height: 8),
            SwitchListTile(
              title: const Text('Importante'),
              value: _important,
              onChanged: (v) => setState(() => _important = v),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: _confirm,
                child: const Text('Conferma'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
