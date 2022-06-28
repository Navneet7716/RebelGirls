import 'package:flutter/material.dart';
import 'package:rebel_girls/utils/colors.dart';

class StoryDetails extends StatefulWidget {
  final storyData;

  const StoryDetails({Key? key, required this.storyData}) : super(key: key);

  @override
  State<StoryDetails> createState() => _StoryDetailsState();
}

class _StoryDetailsState extends State<StoryDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: whiteColor,
        iconTheme: const IconThemeData(color: Colors.black),
        title: const Text(
          'Details',
          style: TextStyle(
              color: Colors.black,
              fontFamily: 'Poppins-Bold',
              fontSize: 25,
              fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
          child: Column(
        children: const [Text('This is detail')],
      )),
    );
  }
}
