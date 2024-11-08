import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_notes_app/models/note.dart';
import 'package:video_notes_app/modules/video_player/video_player_controller.dart';
import 'package:video_notes_app/widgets/edit_note_dialog.dart';
import 'package:video_notes_app/widgets/password_dialog.dart';
import 'package:video_notes_app/widgets/rich_text_viewer.dart';

class NotesListView extends StatefulWidget {
  final VideoPlayerController controller;

  NotesListView({required this.controller});

  @override
  _NotesListViewState createState() => _NotesListViewState();
}

class _NotesListViewState extends State<NotesListView> {
  Set<int> expandedNotes = {};
  Set<int> unlockedNotes = {};

  // Function to show the edit note dialog
  Future<void> _showEditNoteDialog(Note note, int index) async {
    // Check if note has a password
    if (note.password != null &&
        note.password!.isNotEmpty &&
        !unlockedNotes.contains(index)) {
      final enteredPassword = await Get.dialog<String>(PasswordDialog());
      if (enteredPassword != note.password) {
        Get.snackbar('Error', 'Incorrect password');
        return; 
      }
      unlockedNotes.add(index);
    }
    // Show edit dialog if password is correct or if there's no password
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return EditNoteDialog(
          note: note,
          onSave: (String newTitle, String newContent) {
            widget.controller.updateNote(note.id!, newTitle, newContent);
          },
        );
      },
    );
  }

  // Check for correct password
  Future<bool> _checkPassword(String? notePassword, int index) async {
    if (notePassword == null || notePassword.isEmpty) return true;

    final enteredPassword = await Get.dialog<String>(PasswordDialog());
    if (enteredPassword == notePassword) {
      unlockedNotes.add(index);
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final notes = widget.controller.notes;

      // Displays a message if there are no notes
      if (notes.isEmpty) {
        return const Center(
          child: Text(
            "No Notes, Start noting smth :)",
            style: TextStyle(fontSize: 18, color: Colors.grey),
          ),
        );
      }

      return ListView.builder(
        itemCount: notes.length,
        itemBuilder: (context, index) {
          final note = notes[index];
          final timestamp = note.timestamp;
          final formattedTime =
              "${timestamp.inHours.toString().padLeft(2, '0')}:${(timestamp.inMinutes % 60).toString().padLeft(2, '0')}:${(timestamp.inSeconds % 60).toString().padLeft(2, '0')}";
          bool isExpanded = expandedNotes.contains(index);
          bool isUnlocked = unlockedNotes.contains(index);

          return Column(
            children: [
              // List tile for each note entry
              ListTile(
                title: Text(note.title),
                subtitle: Text(formattedTime),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (note.password != null && note.password!.isNotEmpty)
                      Icon(
                        isUnlocked ? Icons.lock_open : Icons.lock,
                      ),
                    // Button to edit the note
                    IconButton(
                      onPressed: () => _showEditNoteDialog(note, index),
                      icon: const Icon(Icons.edit),
                    ),
                    // Button to delete the note
                    IconButton(
                      onPressed: () async {
                        await widget.controller.deleteNote(note.id);
                        setState(() {
                          expandedNotes.remove(index);
                          unlockedNotes.remove(index);
                        });
                      },
                      icon: const Icon(Icons.delete),
                    ),
                    // Button to expand or collapse the note content
                    IconButton(
                      icon: Icon(
                        isExpanded ? Icons.expand_less : Icons.expand_more,
                      ),
                      onPressed: () async {
                        if (isExpanded) {
                          setState(() {
                            expandedNotes.remove(index);
                          });
                        } else {
                          if (isUnlocked ||
                              await _checkPassword(note.password, index)) {
                            setState(() {
                              expandedNotes.add(index);
                            });
                          } else {
                            Get.snackbar('Error', 'Incorrect password');
                          }
                        }
                      },
                    ),
                  ],
                ),
                // Tap to seek video to the note's timestamp
                onTap: () {
                  widget.controller.seekTo(note.timestamp);
                  Navigator.pop(context);
                },
              ),
              // Display content of the note if expanded.
              if (isExpanded)
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 8.0,
                  ),
                  child: RichTextViewer(
                      content:
                          note.content.isEmpty ? 'No content' : note.content),
                ),
              const Divider(),
            ],
          );
        },
      );
    });
  }
}
