import 'package:ai_first_flutter_starter/app/theme/app_spacing.dart';
import 'package:ai_first_flutter_starter/features/tasks/domain/entities/task.dart';
import 'package:ai_first_flutter_starter/features/tasks/presentation/forms/task_form_value.dart';
import 'package:ai_first_flutter_starter/shared/widgets/app_button.dart';
import 'package:flutter/material.dart';

Future<TaskFormValue?> showTaskFormSheet(
  BuildContext context, {
  Task? initialTask,
}) {
  return showModalBottomSheet<TaskFormValue>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    builder: (context) => TaskFormSheet(initialTask: initialTask),
  );
}

final class TaskFormSheet extends StatefulWidget {
  const TaskFormSheet({this.initialTask, super.key});

  final Task? initialTask;

  @override
  State<TaskFormSheet> createState() => _TaskFormSheetState();
}

final class _TaskFormSheetState extends State<TaskFormSheet> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleController;
  late final TextEditingController _descriptionController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.initialTask?.title);
    _descriptionController = TextEditingController(
      text: widget.initialTask?.description,
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.viewInsetsOf(context).bottom;
    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(
        AppSpacing.lg,
        AppSpacing.lg,
        AppSpacing.lg,
        AppSpacing.lg + bottomInset,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 640),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        widget.initialTask == null
                            ? 'Create task'
                            : 'Edit task',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                    ),
                    IconButton(
                      tooltip: 'Close task form',
                      onPressed: Navigator.of(context).pop,
                      icon: const Icon(Icons.close_rounded),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.lg),
                TextFormField(
                  key: const Key('task-title-field'),
                  controller: _titleController,
                  autofocus: true,
                  maxLength: Task.maxTitleLength,
                  textInputAction: TextInputAction.next,
                  decoration: const InputDecoration(
                    labelText: 'Task title',
                    hintText: 'What needs to be done?',
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Enter a task title.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: AppSpacing.sm),
                TextFormField(
                  key: const Key('task-description-field'),
                  controller: _descriptionController,
                  maxLength: Task.maxDescriptionLength,
                  minLines: 3,
                  maxLines: 6,
                  textInputAction: TextInputAction.newline,
                  decoration: const InputDecoration(
                    labelText: 'Description',
                    hintText: 'Add useful context (optional)',
                    alignLabelWithHint: true,
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                AppButton(label: 'Save task', onPressed: _submit),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    Navigator.of(context).pop(
      TaskFormValue(
        title: _titleController.text,
        description: _descriptionController.text,
      ),
    );
  }
}
