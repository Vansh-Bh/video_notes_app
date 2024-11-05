import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'dart:convert';

class RichTextViewer extends StatelessWidget {
  final String content;

  RichTextViewer({required this.content});

  @override
  Widget build(BuildContext context) {
    // Decode JSON content into a quill document
    final document = quill.Document.fromJson(jsonDecode(content));
    return quill.QuillEditor(
      controller: quill.QuillController(
        readOnly: true,
        document: document,
        selection: const TextSelection.collapsed(offset: 0),
      ),
      scrollController: ScrollController(),
      focusNode: FocusNode(),
      configurations: const quill.QuillEditorConfigurations(
        scrollable: true,
        autoFocus: false,
        expands: false,
        padding: EdgeInsets.zero,
        sharedConfigurations: quill.QuillSharedConfigurations(
          locale: Locale('en'),
        ),
      ),
    );
  }
}
