import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:rebel_girls/screens/story_detail_screen.dart';

class StoryCard extends StatefulWidget {
  final dynamic snap;

  const StoryCard({Key? key, required this.snap}) : super(key: key);

  @override
  State<StoryCard> createState() => _StoryCardState();
}

class _StoryCardState extends State<StoryCard> {
  @override
  Widget build(BuildContext context) {
    return widget.snap != null
        ? GestureDetector(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => StoryDetails(storyData: widget.snap),
                ),
              );
            },
            child: Stack(
              children: [
                Container(
                  margin: const EdgeInsets.only(left: 7, right: 7, top: 10),
                  width: 200,
                  height: 270,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.white,
                    image: DecorationImage(
                        image: CachedNetworkImageProvider(
                            widget.snap['bannerImage']),
                        fit: BoxFit.cover),
                  ),
                ),
                Positioned(
                  bottom: 0.0,
                  left: 0.0,
                  right: 0.0,
                  child: Container(
                    width: 200,
                    margin: const EdgeInsets.only(left: 7, right: 7, top: 10),
                    padding: const EdgeInsets.symmetric(
                        vertical: 10.0, horizontal: 20.0),
                    child: Text(
                      widget.snap['title'],
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      gradient: const LinearGradient(
                        colors: [
                          Color.fromARGB(200, 0, 0, 0),
                          Color.fromARGB(0, 0, 0, 0)
                        ],
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )
        : Container();
  }
}
