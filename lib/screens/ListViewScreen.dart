import 'package:flutter/material.dart';

class ListViewScreen extends StatefulWidget {
  const ListViewScreen({super.key});

  @override
  State<ListViewScreen> createState() => _ListViewScreenState();
}

class _ListViewScreenState extends State<ListViewScreen> {
  final List<String> subjects = ["Loki", "Prometheus", "Grafana"];
  final TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: subjects.length,
        itemBuilder: (context, index) => ListTile(
          title: Text(subjects[index]),
          trailing: IconButton(
            icon: const Icon(Icons.remove, color: Colors.grey),
            onPressed: () => setState(() => subjects.removeAt(index)),
          ),
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
