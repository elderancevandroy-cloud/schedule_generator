import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/schedule_request.dart';
import '../providers/schedule_provider.dart';
import '../widgets/task_input_field.dart';

class ScheduleInputScreen extends StatefulWidget {
  const ScheduleInputScreen({super.key});

  @override
  State<ScheduleInputScreen> createState() => _ScheduleInputScreenState();
}

class _ScheduleInputScreenState extends State<ScheduleInputScreen> {
  final _formKey = GlobalKey<FormState>();
  final _tasksController = TextEditingController();
  final _notesController = TextEditingController();
  final _workHoursController = TextEditingController(text: '9:00 AM - 5:00 PM');
  
  DateTime _selectedDate = DateTime.now();
  List<String> _tasks = [];
  List<String> _priorities = ['medium'];
  int _breakDuration = 15;
  List<String> _selectedCategories = ['Work', 'Personal'];

  final List<String> _availablePriorities = ['high', 'medium', 'low'];
  final List<String> _availableCategories = [
    'Work',
    'Personal',
    'Health',
    'Education',
    'Social',
    'Creative',
  ];

  @override
  void dispose() {
    _tasksController.dispose();
    _notesController.dispose();
    _workHoursController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Generate Schedule'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _buildDateSelector(),
            const SizedBox(height: 24),
            _buildWorkHoursField(),
            const SizedBox(height: 24),
            _buildTasksSection(),
            const SizedBox(height: 24),
            _buildPrioritiesSection(),
            const SizedBox(height: 24),
            _buildCategoriesSection(),
            const SizedBox(height: 24),
            _buildBreakDurationSection(),
            const SizedBox(height: 24),
            _buildNotesSection(),
            const SizedBox(height: 32),
            _buildGenerateButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildDateSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Select Date',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 12),
        InkWell(
          onTap: () => _selectDate(context),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey[300]!),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _formatDate(_selectedDate),
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const Icon(Icons.calendar_today),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildWorkHoursField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Working Hours',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: _workHoursController,
          decoration: const InputDecoration(
            hintText: 'e.g., 9:00 AM - 5:00 PM',
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.access_time),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter working hours';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildTasksSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Tasks',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 12),
        TaskInputField(
          controller: _tasksController,
          onTaskAdded: (task) {
            setState(() {
              _tasks.add(task);
              _tasksController.clear();
            });
          },
        ),
        const SizedBox(height: 12),
        if (_tasks.isNotEmpty) ...[
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _tasks.map((task) {
              return Chip(
                label: Text(task),
                onDeleted: () {
                  setState(() {
                    _tasks.remove(task);
                  });
                },
              );
            }).toList(),
          ),
        ],
      ],
    );
  }

  Widget _buildPrioritiesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Priority Level',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          children: _availablePriorities.map((priority) {
            final isSelected = _priorities.contains(priority);
            return FilterChip(
              label: Text(priority.toUpperCase()),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  if (selected) {
                    _priorities = [priority];
                  }
                });
              },
              selectedColor: _getPriorityColor(priority),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildCategoriesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Categories',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _availableCategories.map((category) {
            final isSelected = _selectedCategories.contains(category);
            return FilterChip(
              label: Text(category),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  if (selected) {
                    _selectedCategories.add(category);
                  } else {
                    _selectedCategories.remove(category);
                  }
                });
              },
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildBreakDurationSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Break Duration: $_breakDuration minutes',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 12),
        Slider(
          value: _breakDuration.toDouble(),
          min: 5,
          max: 60,
          divisions: 11,
          label: '$_breakDuration min',
          onChanged: (value) {
            setState(() {
              _breakDuration = value.round();
            });
          },
        ),
      ],
    );
  }

  Widget _buildNotesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Additional Notes (Optional)',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: _notesController,
          maxLines: 3,
          decoration: const InputDecoration(
            hintText: 'Any additional preferences or constraints...',
            border: OutlineInputBorder(),
          ),
        ),
      ],
    );
  }

  Widget _buildGenerateButton() {
    return Consumer<ScheduleProvider>(
      builder: (context, scheduleProvider, child) {
        return SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton(
            onPressed: scheduleProvider.isLoading
                ? null
                : () => _generateSchedule(scheduleProvider),
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: scheduleProvider.isLoading
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.auto_awesome),
                      SizedBox(width: 8),
                      Text('Generate Schedule'),
                    ],
                  ),
          ),
        );
      },
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _generateSchedule(ScheduleProvider scheduleProvider) {
    if (_formKey.currentState!.validate() && _tasks.isNotEmpty) {
      final request = ScheduleRequest(
        date: _selectedDate,
        workHours: _workHoursController.text,
        tasks: _tasks,
        priorities: _priorities,
        additionalNotes: _notesController.text.isNotEmpty
            ? _notesController.text
            : null,
        breakDuration: _breakDuration,
        preferredCategories: _selectedCategories,
      );

      scheduleProvider.generateSchedule(request).then((_) {
        if (scheduleProvider.errorMessage == null) {
          Navigator.pop(context);
        }
      });
    } else if (_tasks.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please add at least one task')),
      );
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  Color _getPriorityColor(String priority) {
    switch (priority) {
      case 'high':
        return Colors.red.withOpacity(0.3);
      case 'medium':
        return Colors.orange.withOpacity(0.3);
      case 'low':
        return Colors.green.withOpacity(0.3);
      default:
        return Colors.grey.withOpacity(0.3);
    }
  }
}