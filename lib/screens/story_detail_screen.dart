import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rebel_girls/modles/user.dart';
import 'package:rebel_girls/providers/user_provider.dart';
import 'package:rebel_girls/resources/firestore_methods.dart';

class StoryDetails extends StatefulWidget {
  final storyData;

  const StoryDetails({Key? key, required this.storyData}) : super(key: key);

  @override
  State<StoryDetails> createState() => _StoryDetailsState();
}

class _StoryDetailsState extends State<StoryDetails> {
  @override
  Widget build(BuildContext context) {
    final User user = Provider.of<UserProvider>(context).getUser;

    return Scaffold(
      body: SizedBox(
        width: double.maxFinite,
        height: double.maxFinite,
        child: Stack(
          children: [
            Positioned(
              left: 0,
              right: 0,
              child: Container(
                width: double.maxFinite,
                height: 350,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(widget.storyData['bannerImage']),
                    fit: BoxFit.fill,
                  ),
                ),
              ),
            ),
            Positioned(
              left: 20,
              top: 70,
              child: Row(
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    icon: const Icon(
                      Icons.arrow_circle_left_outlined,
                      color: Colors.white,
                      size: 30,
                      shadows: [
                        Shadow(
                            color: Colors.black,
                            blurRadius: 50,
                            offset: Offset(0, 0))
                      ],
                    ),
                  ),
                ],
              ),
            ),
            user.uid == widget.storyData['uid']
                ? Positioned(
                    right: 20,
                    top: 70,
                    child: Row(
                      children: [
                        IconButton(
                          onPressed: () async {
                            await FireStoreMethods()
                                .deleteStory(widget.storyData['id']);
                            Navigator.of(context).pop();
                          },
                          icon: const Icon(
                            Icons.delete_outline_rounded,
                            color: Colors.white,
                            size: 30,
                            shadows: [
                              Shadow(
                                  color: Colors.black,
                                  blurRadius: 50,
                                  offset: Offset(0, 0))
                            ],
                          ),
                        ),
                      ],
                    ),
                  )
                : Container(),
            Positioned(
              top: 320,
              child: Container(
                padding: const EdgeInsets.only(left: 20, right: 20, top: 30),
                width: MediaQuery.of(context).size.width,
                height: 500,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      flex: 0,
                      child: Text(
                        '${widget.storyData['title']}',
                        style: const TextStyle(
                          fontFamily: 'Pacifico',
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 7,
                    ),
                    Expanded(
                      flex: 0,
                      child: Text(
                        'By ${widget.storyData['username']}',
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w100,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        child: SizedBox(
                          height: 500,
                          child: Text(
                            widget.storyData['description'],
                            style: const TextStyle(
                                fontSize: 16,
                                color: Color.fromARGB(255, 107, 107, 107)),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    SizedBox(
                      width: double.maxFinite,
                      child: ElevatedButton(
                        onPressed: () {},
                        child: Text('Comments'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
