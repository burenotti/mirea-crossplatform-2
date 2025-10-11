import 'package:flutter/material.dart';

class ColumnScreen extends StatefulWidget {
  const ColumnScreen({super.key});

  @override
  State<ColumnScreen> createState() => _ColumnScreenState();
}

class _ColumnScreenState extends State<ColumnScreen> {
  final List<String> subjects = ["Python", "Goland", "C++"];
  final TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            for (int i = 0; i < subjects.length; i++)
              ListTile(
                title: Text(subjects[i]),
                trailing: IconButton(
                  icon: const Icon(Icons.remove, color: Colors.grey),
                  onPressed: () => setState(() => subjects.removeAt(i)),
                ),
              ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _addSubjectDialog(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _addSubjectDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Добавить предмет'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(hintText: 'Введите название'),
        ),
        actions: [
          TextButton(
            onPressed: () {
              setState(() {
                if (controller.text.isNotEmpty) {
                  subjects.add(controller.text);
                }
                controller.clear();
              });
              Navigator.pop(context);
            },
            child: const Text('Добавить'),
          ),
        ],
      ),
    );
  }
}
