import 'package:flutter/material.dart';

class AddEditNoteDialog extends StatefulWidget {
  final String? initialText;

  const AddEditNoteDialog({super.key, this.initialText});

  @override
  State<AddEditNoteDialog> createState() => _AddEditNoteDialogState();
}

class _AddEditNoteDialogState extends State<AddEditNoteDialog> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialText ?? '');
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.initialText != null;

    return AlertDialog(
      title: Text(isEditing ? 'Edit Note' : 'Add Note'),
      content: TextField(
        controller: _controller,
        decoration: const InputDecoration(
          hintText: 'Enter your note here...',
          border: OutlineInputBorder(),
        ),
        maxLines: 5,
        autofocus: true,
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            final text = _controller.text.trim();
            if (text.isNotEmpty) {
              Navigator.of(context).pop(text);
            }
          },
          child: Text(isEditing ? 'Update' : 'Add'),
        ),
      ],
    );
  }
}
