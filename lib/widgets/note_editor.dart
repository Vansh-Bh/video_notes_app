import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'dart:convert';

class NoteEditor extends StatefulWidget {
  final Function(String, String) onNoteAdded; // Callback function to pass note data back.

  NoteEditor({required this.onNoteAdded});

  @override
  _NoteEditorState createState() => _NoteEditorState();
}

class _NoteEditorState extends State<NoteEditor> {
  late quill.QuillController _controller;
  final FocusNode _focusNode = FocusNode();
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _titleController = TextEditingController();

  @override
  void initState() {
    super.initState();
     // Initialize Quill controller with a basic document setup
    _controller = quill.QuillController.basic();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _scrollController.dispose();
    _titleController.dispose();
    super.dispose();
  }

  // Show an error dialog if the title is empty.
  void _showErrorDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Error'),
        content: const Text('Please enter a title for the note.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Title input field for the note.
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            controller: _titleController,
            decoration: const InputDecoration(
              labelText: 'Title',
              border: OutlineInputBorder(),
            ),
          ),
        ),
        // Simple toolbar for text formatting in the Quill editor.
        quill.QuillToolbar.simple(
          controller: _controller,
          configurations: const quill.QuillSimpleToolbarConfigurations(
            sharedConfigurations: quill.QuillSharedConfigurations(
              locale: Locale('en'),
            ),
          ),
        ),
        // Main Quill editor for note content
        Expanded(
          child: quill.QuillEditor(
            controller: _controller,
            scrollController: _scrollController,
            focusNode: _focusNode,
            configurations: const quill.QuillEditorConfigurations(
              scrollable: true,
              autoFocus: false,
              expands: false,
              padding: EdgeInsets.zero,
              sharedConfigurations: quill.QuillSharedConfigurations(
                locale: Locale('en'),
              ),
            ),
          ),
        ),
        // Button to add the note. If title is empty show error dialog.
        Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: ElevatedButton(
            onPressed: () {
              final noteTitle = _titleController.text.trim();
              final noteContent =
                  jsonEncode(_controller.document.toDelta().toJson());
              if (noteTitle.isEmpty) {
                _showErrorDialog();
              } else if (noteContent.isNotEmpty) {
                widget.onNoteAdded(noteTitle, noteContent);
                _titleController.clear();
                _controller.clear();
              }
            },
            child: const Text('Add Note'),
          ),
        ),
      ],
    );
  }
}
