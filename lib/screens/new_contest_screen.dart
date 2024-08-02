import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:images_picker/images_picker.dart';
import 'package:larva/controllers/contestController.dart';
import 'package:larva/widgets/customWidget.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class CreateContestScreen extends StatefulWidget {
  @override
  _CreateContestScreenState createState() => _CreateContestScreenState();
}

class _CreateContestScreenState extends State<CreateContestScreen> {
  final ContestController _contestController = ContestController();
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _rulesController = TextEditingController();
  final _prizesController = TextEditingController();
  DateTime? _startDate;
  DateTime? _endDate;
  File? _mediaFile;

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _rulesController.dispose();
    _prizesController.dispose();
    super.dispose();
  }

  void _pickDate(BuildContext context, bool isStart) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now().subtract(Duration(days: 1)),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        if (isStart) {
          _startDate = picked;
        } else {
          _endDate = picked;
        }
      });
    }
  }

  void _pickMediaFile() async {
    List<Media>? res = await ImagesPicker.pick(
      count: 1,
      pickType: PickType.all,
      quality: 0.8,
      maxSize: 500,
    );
    if (res != null && res.isNotEmpty) {
      setState(() {
        _mediaFile = File(res.first.path);
      });
    }
  }

  void _createContest(BuildContext context) async {
    if (_formKey.currentState!.validate() &&
        _startDate != null &&
        _endDate != null) {
      EasyLoading.show(status: 'Creating contest...');
      await _contestController.createContest(
        context,
        _nameController.text,
        _descriptionController.text,
        _startDate!.toIso8601String(),
        _endDate!.toIso8601String(),
        _rulesController.text,
        _prizesController.text,
        _mediaFile,
      );
      EasyLoading.dismiss();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill all the fields')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create New Contest'),
        centerTitle: true,
        systemOverlayStyle: SystemUiOverlayStyle.light,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Contest Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter contest name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(labelText: 'Description'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter description';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _rulesController,
                decoration: InputDecoration(labelText: 'Rules'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter rules';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _prizesController,
                decoration: InputDecoration(labelText: 'Prizes'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter prizes';
                  }
                  return null;
                },
              ),
              ListTile(
                title: Text(_startDate == null
                    ? 'Pick Start Date'
                    : 'Start Date: ${_startDate!.toLocal()}'.split(' ')[0]),
                trailing: Icon(Icons.calendar_today),
                onTap: () => _pickDate(context, true),
              ),
              ListTile(
                title: Text(_endDate == null
                    ? 'Pick End Date'
                    : 'End Date: ${_endDate!.toLocal()}'.split(' ')[0]),
                trailing: Icon(Icons.calendar_today),
                onTap: () => _pickDate(context, false),
              ),
              SizedBox(height: 10),
              _mediaFile == null
                  ? TextButton.icon(
                      onPressed: _pickMediaFile,
                      icon: Icon(Icons.add_photo_alternate),
                      label: Text('Upload Media'),
                    )
                  : Image.file(_mediaFile!,
                      height: 200, width: 200, fit: BoxFit.cover),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => _createContest(context),
                child: Text('Create Contest'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
