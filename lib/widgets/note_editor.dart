// file: app/widgets/note_editor.dart
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;

class NoteEditor extends StatefulWidget {
  final Function(String) onNoteAdded;

  NoteEditor({required this.onNoteAdded});

  @override
  _NoteEditorState createState() => _NoteEditorState();
}

class _NoteEditorState extends State<NoteEditor> {
  late quill.QuillController _controller;
  final FocusNode _focusNode = FocusNode();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _controller = quill.QuillController.basic();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        quill.QuillToolbar.simple(
          configurations: quill.QuillSimpleToolbarConfigurations(
            controller: _controller,
            sharedConfigurations: const quill.QuillSharedConfigurations(
              locale: Locale('en'),
            ),
          ),
        ),
        Expanded(
          child: quill.QuillEditor(
            scrollController: _scrollController,
            focusNode: _focusNode,
            configurations: quill.QuillEditorConfigurations(
              controller: _controller,
              scrollable: true,
              autoFocus: false,
              expands: false,
              padding: EdgeInsets.zero,
              sharedConfigurations: const quill.QuillSharedConfigurations(
                locale: Locale('en'),
              ),
            ),
          ),
        ),
        ElevatedButton(
          onPressed: () {
            final noteContent = _controller.document.toPlainText();
            widget.onNoteAdded(noteContent);
            _controller.clear();
          },
          child: Text('Add Note'),
        ),
      ],
    );
  }
}