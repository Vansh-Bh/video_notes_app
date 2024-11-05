import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:video_notes_app/models/note.dart';

class EditNoteDialog extends StatefulWidget {
  final Note note;
  final Function(String, String) onSave;

  const EditNoteDialog({super.key, required this.note, required this.onSave});

  @override
  _EditNoteDialogState createState() => _EditNoteDialogState();
}

class _EditNoteDialogState extends State<EditNoteDialog> {
  late TextEditingController _titleController;
  late quill.QuillController _contentController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.note.title);
    _contentController = quill.QuillController(
      document: quill.Document.fromJson(jsonDecode(widget.note.content)),
      selection: const TextSelection.collapsed(offset: 0),
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return AlertDialog(
          title: const Text('Edit Note'),
          content: SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: constraints.maxWidth * 0.8,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: _titleController,
                    maxLines: null,
                    decoration: const InputDecoration(labelText: 'Title'),
                  ),
                  const SizedBox(height: 16),
                  quill.QuillToolbar.simple(
                    controller: _contentController,
                    configurations:
                        const quill.QuillSimpleToolbarConfigurations(
                      sharedConfigurations: quill.QuillSharedConfigurations(
                        locale: Locale('en'),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 200,
                    child: quill.QuillEditor(
                      controller: _contentController,
                      scrollController: ScrollController(),
                      focusNode: FocusNode(),
                      configurations: const quill.QuillEditorConfigurations(
                        autoFocus: false,
                        expands: false,
                        padding: EdgeInsets.zero,
                        sharedConfigurations: quill.QuillSharedConfigurations(
                          locale: Locale('en'),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              style: ButtonStyle(
                overlayColor:
                    WidgetStateProperty.all(Colors.red.withOpacity(0.1)),
              ),
              onPressed: () => Navigator.of(context).pop(),
              child: const Text(
                'Cancel',
                style: TextStyle(color: Colors.red),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                final newTitle = _titleController.text;
                final newContent =
                    jsonEncode(_contentController.document.toDelta().toJson());
                widget.onSave(newTitle, newContent);
                Navigator.of(context).pop();
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }
}
