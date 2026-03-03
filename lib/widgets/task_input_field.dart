import 'package:flutter/material.dart';

class TaskInputField extends StatelessWidget {
  final TextEditingController controller;
  final Function(String task) onTaskAdded;

  const TaskInputField({
    super.key,
    required this.controller,
    required this.onTaskAdded,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: controller,
            decoration: const InputDecoration(
              hintText: 'Add a task...',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.add_task),
            ),
            onSubmitted: (value) {
              if (value.trim().isNotEmpty) {
                onTaskAdded(value.trim());
              }
            },
          ),
        ),
        const SizedBox(width: 8),
        IconButton(
          onPressed: () {
            if (controller.text.trim().isNotEmpty) {
              onTaskAdded(controller.text.trim());
            }
          },
          icon: const Icon(Icons.add_circle),
          style: IconButton.styleFrom(
            backgroundColor: Theme.of(context).colorScheme.primary,
            foregroundColor: Colors.white,
          ),
        ),
      ],
    );
  }
}