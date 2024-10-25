import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:file_picker/file_picker.dart';
import 'package:video_notes_app/api_service.dart';
import 'package:video_notes_app/models/video_data.dart';

class AddVideoView extends StatefulWidget {
  const AddVideoView({super.key});

  @override
  _AddVideoViewState createState() => _AddVideoViewState();
}

class _AddVideoViewState extends State<AddVideoView> {
  final _formKey = GlobalKey<FormState>();
  String _title = '';
  String _path = '';
  bool _isLocal = false;
  String _thumbnailUrl = '';

  void _selectFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.video,
    );

    if (result != null) {
      setState(() {
        _path = result.files.single.path!;
        _isLocal = true;
      });
    }
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      try {
        await ApiService.addVideo(VideoData(
          id: '',
          title: _title,
          path: _path,
          isLocal: _isLocal,
          thumbnailUrl: _thumbnailUrl,
          lastWatched: DateTime.now(),
        ));
        Get.back(result: true);
      } catch (e) {
        Get.snackbar('Error', 'Failed to add video: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Video')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: 'Title'),
                validator: (value) => value!.isEmpty ? 'Please enter a title' : null,
                onSaved: (value) => _title = value!,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      decoration: const InputDecoration(labelText: 'Video Path/URL'),
                      validator: (value) => value!.isEmpty ? 'Please enter a path or URL' : null,
                      onSaved: (value) => _path = value!,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.file_upload),
                    onPressed: _selectFile,
                  ),
                ],
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Thumbnail URL'),
                validator: (value) => value!.isEmpty ? 'Please enter a thumbnail URL' : null,
                onSaved: (value) => _thumbnailUrl = value!,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _submitForm,
                child: const Text('Add Video'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}