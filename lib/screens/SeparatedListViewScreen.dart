import 'package:flutter/material.dart';

class SeparatedListViewScreen extends StatefulWidget {
  const SeparatedListViewScreen({super.key});

  @override
  State<SeparatedListViewScreen> createState() =>
      _SeparatedListViewScreenState();
}

class _SeparatedListViewScreenState extends State<SeparatedListViewScreen> {
  final List<String> subjects = ["PostgreSQL", "SQL Server", "MySQL"];
  final TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.separated(
        itemCount: subjects.length,
        itemBuilder: (context, index) => ListTile(
          title: Text(subjects[index]),
          trailing: IconButton(
            icon: const Icon(Icons.remove, color: Colors.grey),
            onPressed: () => setState(() => subjects.removeAt(index)),
          ),
        ),
        separatorBuilder: (context, index) => const Divider(),
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
