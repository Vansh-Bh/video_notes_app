import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;

class NoteEditor extends StatefulWidget {
  final Function(String, String) onNoteAdded;

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
    _controller = quill.QuillController.basic();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _scrollController.dispose();
    _titleController.dispose();
    super.dispose();
  }

  void _showErrorDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Error'),
        content: Text('Please enter a title for the note.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            controller: _titleController,
            decoration: InputDecoration(
              labelText: 'Title',
              border: OutlineInputBorder(),
            ),
          ),
        ),
        quill.QuillToolbar.simple(
          controller: _controller,
          configurations: const quill.QuillSimpleToolbarConfigurations(
            sharedConfigurations: quill.QuillSharedConfigurations(
              locale: Locale('en'),
            ),
          ),
        ),
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
        ElevatedButton(
          onPressed: () {
            final noteTitle = _titleController.text.trim();
            final noteContent = _controller.document.toPlainText().trim();
            if (noteTitle.isEmpty) {
              _showErrorDialog();
            } else if (noteContent.isNotEmpty) {
              widget.onNoteAdded(noteTitle, noteContent);
              _titleController.clear();
              _controller.clear();
            }
          },
          child: Text('Add Note'),
        ),
      ],
    );
  }
}