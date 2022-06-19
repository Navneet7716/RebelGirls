import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:rebel_girls/modles/user.dart' as model;
import 'package:rebel_girls/providers/user_provider.dart';
import 'package:rebel_girls/resources/firestore_methods.dart';
import 'package:rebel_girls/utils/colors.dart';
import 'package:rebel_girls/utils/utils.dart';

class AddPostScreen extends StatefulWidget {
  const AddPostScreen({Key? key}) : super(key: key);

  @override
  _AddPostScreenState createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  Uint8List? _file;
  bool _isLoading = false;

  DateTime eventDate = DateTime.now();
  TimeOfDay eventStartTime = TimeOfDay.now();
  TimeOfDay eventEndTime = TimeOfDay.now();
  String venue = "online";

  var venueList = <String>["online", "offline"];

  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _linkController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  void postImage(
    String uid,
    String username,
    String profImage,
  ) async {
    setState(() {
      _isLoading = true;
    });
    try {
      if (_file == null) {
        showSnackBar('Image is Required!', context);
        setState(() {
          _isLoading = false;
        });
        return;
      }

      String res = await FireStoreMethods().uploadPost(
          _titleController.text,
          _descriptionController.text,
          _file!,
          uid,
          username,
          profImage,
          '${eventStartTime.hourOfPeriod} : ${eventStartTime.minute} ${eventStartTime.period.name}',
          '${eventEndTime.hourOfPeriod} : ${eventEndTime.minute} ${eventEndTime.period.name}',
          eventDate,
          venue,
          _linkController.text,
          _addressController.text);

      if (res == "success") {
        setState(() {
          _isLoading = false;
        });
        showSnackBar(
          "Posted!",
          context,
        );
        clearImage();
      } else {
        setState(() {
          _isLoading = false;
        });
        showSnackBar(res, context);
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      showSnackBar(e.toString(), context);
    }
  }

  _selectImage(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            title: const Text("Upload a photo"),
            children: [
              SimpleDialogOption(
                padding: const EdgeInsets.all(20),
                child: const Text('Take a photo'),
                onPressed: () async {
                  Navigator.of(context).pop();
                  Uint8List file = await pickImage(ImageSource.camera);
                  setState(() {
                    _file = file;
                  });
                },
              ),
              SimpleDialogOption(
                padding: const EdgeInsets.all(20),
                child: const Text('Choose from gallery'),
                onPressed: () async {
                  Navigator.of(context).pop();
                  Uint8List file = await pickImage(ImageSource.gallery);
                  setState(() {
                    _file = file;
                  });
                },
              ),
              SimpleDialogOption(
                padding: const EdgeInsets.all(20),
                child: const Text('Cancel'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }

  @override
  void dispose() {
    super.dispose();
    _descriptionController.dispose();
    _titleController.dispose();
    _addressController.dispose();
    _linkController.dispose();
  }

  void clearImage() {
    setState(() {
      _file = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final model.User user = Provider.of<UserProvider>(context).getUser;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        title: const Text(
          "Create an event",
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: false,
        actions: [
          TextButton(
            onPressed: () => postImage(user.uid, user.username, user.photoUrl),
            child: const Text(
              'Create',
              style: TextStyle(
                color: Colors.blueAccent,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _isLoading
                ? const LinearProgressIndicator()
                : const Padding(padding: EdgeInsets.only(top: 0)),
            const Divider(),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _file != null
                    ? Stack(alignment: Alignment.center, children: [
                        SizedBox(
                          width: double.infinity,
                          child: AspectRatio(
                            aspectRatio: 16 / 10,
                            child: Container(
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  colorFilter:
                                      const ColorFilter.linearToSrgbGamma(),
                                  image: MemoryImage(_file!),
                                  fit: BoxFit.fill,
                                  alignment: FractionalOffset.topCenter,
                                ),
                              ),
                            ),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.edit_outlined,
                            size: 35,
                          ),
                          onPressed: () => _selectImage(context),
                        ),
                      ])
                    : Container(
                        color: const Color.fromARGB(255, 216, 216, 216),
                        height: 150,
                        child: Center(
                          child: IconButton(
                            icon: const Icon(
                              Icons.upload,
                            ),
                            onPressed: () => _selectImage(context),
                          ),
                        ),
                      ),
                const Divider(),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      TextField(
                        controller: _titleController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Write a Title',
                        ),
                        maxLines: 1,
                      ),
                      const Divider(),
                      TextField(
                        controller: _descriptionController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Write a description',
                        ),
                        maxLines: 10,
                      ),
                      const Divider(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Text(
                            'Venue',
                            style: TextStyle(fontSize: 20),
                          ),
                          DropdownButton<String>(
                            value: venue,
                            elevation: 16,
                            items: venueList.map<DropdownMenuItem<String>>(
                              (String e) {
                                return DropdownMenuItem(
                                  value: e,
                                  child: Text(e.toUpperCase()),
                                );
                              },
                            ).toList(),
                            onChanged: (String? newValue) {
                              if (newValue == null) return;
                              setState(() {
                                venue = newValue;
                              });
                            },
                          ),
                        ],
                      ),
                      const Divider(),
                      venue == "offline"
                          ? TextField(
                              controller: _addressController,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                hintText: 'Write venue address',
                              ),
                              maxLines: 3,
                            )
                          : TextField(
                              controller: _linkController,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                hintText: 'Give link',
                              ),
                              maxLines: 1,
                            ),
                      const Divider(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 8, horizontal: 20),
                            decoration: BoxDecoration(
                              border: Border.all(),
                            ),
                            child: Text(
                              '${eventDate.day}/${eventDate.month}/${eventDate.year}',
                              style: const TextStyle(fontSize: 20),
                            ),
                          ),
                          OutlinedButton(
                            onPressed: () async {
                              DateTime? newDate = await showDatePicker(
                                context: context,
                                initialDate: eventDate,
                                firstDate: eventDate,
                                lastDate: DateTime(2080),
                              );
                              if (newDate == null) return;
                              setState(() {
                                eventDate = newDate;
                              });
                            },
                            child: const Text('Select event date'),
                          ),
                        ],
                      ),
                      const Divider(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 8, horizontal: 39),
                            decoration: BoxDecoration(
                              border: Border.all(),
                            ),
                            child: Text(
                              '${eventStartTime.hourOfPeriod}:${eventStartTime.minute} ${eventStartTime.period.name}',
                              style: const TextStyle(fontSize: 20),
                            ),
                          ),
                          OutlinedButton(
                            onPressed: () async {
                              TimeOfDay? newTime = await showTimePicker(
                                  context: context,
                                  initialTime: TimeOfDay.now());
                              if (newTime == null) return;
                              setState(() {
                                eventStartTime = newTime;
                              });
                            },
                            child: const Text('Event start time'),
                          ),
                        ],
                      ),
                      const Divider(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 8, horizontal: 39),
                            decoration: BoxDecoration(
                              border: Border.all(),
                            ),
                            child: Text(
                              '${eventEndTime.hourOfPeriod}:${eventEndTime.minute} ${eventEndTime.period.name}',
                              style: const TextStyle(fontSize: 20),
                            ),
                          ),
                          OutlinedButton(
                            onPressed: () async {
                              TimeOfDay? newTime = await showTimePicker(
                                  context: context,
                                  initialTime: TimeOfDay.now());
                              if (newTime == null) return;
                              setState(() {
                                eventEndTime = newTime;
                              });
                            },
                            child: const Text('Event end time'),
                          ),
                        ],
                      ),
                      const Divider(),
                      const SizedBox(
                        height: 20,
                      )
                    ],
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
