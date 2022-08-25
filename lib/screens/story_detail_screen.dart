import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:rebel_girls/modles/user.dart';
import 'package:rebel_girls/providers/user_provider.dart';
import 'package:rebel_girls/resources/firestore_methods.dart';
import 'package:rebel_girls/screens/story_comment_screen.dart';
import 'package:rebel_girls/utils/colors.dart';

class StoryDetails extends StatefulWidget {
  final dynamic storyData;

  const StoryDetails({Key? key, required this.storyData}) : super(key: key);

  @override
  State<StoryDetails> createState() => _StoryDetailsState();
}

class _StoryDetailsState extends State<StoryDetails> {
  @override
  Widget build(BuildContext context) {
    final User? user = Provider.of<UserProvider>(context).getUser;

    return user != null
        ? Scaffold(
            body: SafeArea(
              child: CustomScrollView(
                slivers: [
                  SliverAppBar(
                    actions: [
                      user.uid == widget.storyData['uid'] || user.isAdmin
                          ? IconButton(
                              onPressed: () async {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: const Text('Deleting this story'),
                                      content: const Text('Are you sure?'),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: const Text('CANCEL'),
                                        ),
                                        TextButton(
                                          style: ButtonStyle(
                                              overlayColor:
                                                  MaterialStateProperty.all(
                                                      const Color.fromARGB(
                                                          57, 244, 67, 54))),
                                          onPressed: () async {
                                            await FireStoreMethods()
                                                .deleteStory(
                                                    widget.storyData['id']);
                                            Navigator.of(context).pop();
                                            Navigator.of(context).pop();
                                          },
                                          child: const Text(
                                            'DELETE',
                                            style: TextStyle(color: Colors.red),
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                              icon: const Icon(Icons.delete_outline_rounded),
                            )
                          : Container()
                    ],
                    pinned: true,
                    floating: true,
                    expandedHeight: 350,
                    flexibleSpace: FlexibleSpaceBar(
                      collapseMode: CollapseMode.parallax,
                      titlePadding: const EdgeInsets.all(10),
                      centerTitle: true,
                      title: Text(
                        '${widget.storyData['title']}',
                        style: const TextStyle(
                          fontFamily: 'Pacifico',
                          fontWeight: FontWeight.w400,
                          letterSpacing: 1.2,
                        ),
                      ),
                      background: CachedNetworkImage(
                        imageUrl: widget.storyData['bannerImage'],
                        fit: BoxFit.fill,
                        placeholder: (context, url) =>
                            const CircularProgressIndicator(),
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.error),
                      ),
                    ),
                  ),
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: double.maxFinite,
                                child: Card(
                                  child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: RichText(
                                      textAlign: TextAlign.justify,
                                      text: TextSpan(
                                        children: [
                                          TextSpan(
                                            text:
                                                widget.storyData['description'],
                                            style: const TextStyle(
                                              fontSize: 16,
                                              color: Color.fromARGB(
                                                  255, 107, 107, 107),
                                            ),
                                          ),
                                          TextSpan(
                                            text:
                                                '\n\nAuthored by - ${widget.storyData['username']}',
                                            style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: Color.fromARGB(
                                                  255, 36, 36, 36),
                                            ),
                                          ),
                                          TextSpan(
                                            text: '\n' +
                                                DateFormat.yMMMd().format(
                                                  widget.storyData[
                                                          'datePublished']
                                                      .toDate(),
                                                ),
                                            style: const TextStyle(
                                              fontSize: 16,
                                              color: secondaryColor,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 10),
                              SizedBox(
                                width: double.maxFinite,
                                child: ElevatedButton(
                                  onPressed: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            StoryCommentScreen(
                                                snap: widget.storyData),
                                      ),
                                    );
                                  },
                                  child: const Text('Comments'),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                      childCount: 1,
                    ),
                  ),
                ],
              ),
            ),
          )
        : const Center(
            child: CircularProgressIndicator(),
          );
  }
}
