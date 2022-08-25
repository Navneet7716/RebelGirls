import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:rebel_girls/modles/user.dart';
import 'package:rebel_girls/providers/user_provider.dart';

import 'package:rebel_girls/resources/firestore_methods.dart';
import 'package:rebel_girls/screens/comments_screen.dart';
import 'package:rebel_girls/screens/post_detail_screen.dart';
import 'package:rebel_girls/utils/colors.dart';
import 'package:rebel_girls/utils/utils.dart';
import 'package:rebel_girls/widgets/like_animation.dart';
import 'package:rebel_girls/widgets/profile_image.dart';

class PostCard extends StatefulWidget {
  // ignore: prefer_typing_uninitialized_variables
  final dynamic snap;

  const PostCard({Key? key, required this.snap}) : super(key: key);

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  bool isLikeAnimating = false;
  int commentLen = 0;

  bool loadingVolunteer = false;

  @override
  void initState() {
    super.initState();
    getComments();
  }

  void getComments() async {
    try {
      QuerySnapshot snap = await FirebaseFirestore.instance
          .collection('posts')
          .doc(widget.snap['postId'])
          .collection('comments')
          .get();

      var commentLen2 = snap.docs.length;
      setState(() {
        commentLen = commentLen2;
      });
    } catch (e) {
      showSnackBar(e.toString(), context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final User? user = Provider.of<UserProvider>(context).getUser;

    return user != null
        ? Padding(
            padding: const EdgeInsets.all(5.0),
            child: Card(
              elevation: 5,
              color: mobileBackgroundColor,
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 4,
                      horizontal: 16,
                    ).copyWith(right: 0),
                    child: Row(
                      children: [
                        ProfileImage(imageUrl: widget.snap['profImage']),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(
                              left: 8,
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                GestureDetector(
                                  onTap: () => {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            PostDetails(postData: widget.snap),
                                      ),
                                    )
                                  },
                                  child: Text(
                                    widget.snap['title'],
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                        user.uid == widget.snap['uid'] || user.isAdmin
                            ? IconButton(
                                onPressed: () {
                                  showDialog(
                                      context: context,
                                      builder: (context) => Dialog(
                                              child: ListView(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 16),
                                            shrinkWrap: true,
                                            children: [
                                              'Delete',
                                            ]
                                                .map(
                                                  (e) => InkWell(
                                                    onTap: () async {
                                                      if (kDebugMode) {
                                                        print(widget.snap);
                                                      }

                                                      await FireStoreMethods()
                                                          .deletePost(widget
                                                              .snap['postId']);

                                                      Navigator.of(context)
                                                          .pop();
                                                    },
                                                    child: Container(
                                                      padding: const EdgeInsets
                                                              .symmetric(
                                                          vertical: 12,
                                                          horizontal: 16),
                                                      child: Text(e),
                                                    ),
                                                  ),
                                                )
                                                .toList(),
                                          )));
                                },
                                icon: const Icon(
                                  Icons.more_vert,
                                  color: Colors.black,
                                ),
                              )
                            : IconButton(
                                onPressed: () {},
                                icon: const Icon(Icons.more_vert)),
                      ],
                    ),
                  ),

                  GestureDetector(
                    onDoubleTap: () async {
                      await FireStoreMethods().likePost(widget.snap['postId'],
                          user.uid, widget.snap['likes']);
                      setState(() {
                        isLikeAnimating = true;
                      });
                    },
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.35,
                          width: double.infinity,
                          child: CachedNetworkImage(
                            imageUrl: widget.snap['postUrl'],
                            fit: BoxFit.cover,
                            placeholder: (context, url) => const Center(
                                child: CircularProgressIndicator()),
                          ),
                        ),
                        AnimatedOpacity(
                          duration: const Duration(milliseconds: 200),
                          opacity: isLikeAnimating ? 1 : 0,
                          child: LikeAnimation(
                            child: const Icon(
                              Icons.favorite,
                              color: Colors.white,
                              size: 120,
                            ),
                            isAnimating: isLikeAnimating,
                            duration: const Duration(
                              milliseconds: 400,
                            ),
                            onEnd: () {
                              setState(() {
                                isLikeAnimating = false;
                              });
                            },
                          ),
                        )
                      ],
                    ),
                  ),

                  Row(
                    children: [
                      LikeAnimation(
                        child: IconButton(
                          onPressed: () async {
                            await FireStoreMethods().likePost(
                                widget.snap['postId'],
                                user.uid,
                                widget.snap['likes']);
                          },
                          icon: widget.snap['likes'].contains(user.uid)
                              ? const Icon(
                                  Icons.favorite,
                                  color: Colors.red,
                                )
                              : const Icon(
                                  Icons.favorite_border,
                                  color: Colors.black,
                                ),
                        ),
                        isAnimating: widget.snap['likes'].contains(user.uid),
                        smallLike: true,
                      ),
                      IconButton(
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) =>
                                  CommentsScreen(snap: widget.snap),
                            ),
                          );
                        },
                        icon: const Icon(
                          Icons.comment_outlined,
                          color: Colors.black,
                        ),
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.send,
                        ),
                      ),
                      Expanded(
                          child: Align(
                        alignment: Alignment.bottomRight,
                        child: IconButton(
                          icon: const Icon(
                            Icons.bookmark_border_rounded,
                            color: Colors.black,
                          ),
                          onPressed: () {},
                        ),
                      ))
                    ],
                  ),
                  // DESCRIPTION AND NUMBER OF COMMENTS

                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        DefaultTextStyle(
                          style: Theme.of(context)
                              .textTheme
                              .subtitle2!
                              .copyWith(fontWeight: FontWeight.w800),
                          child: Text(
                            '${widget.snap['likes'].length} likes',
                            style: Theme.of(context).textTheme.bodyText2,
                          ),
                        ),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.only(
                            top: 8,
                          ),
                          child: RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: '${widget.snap['username']}:',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                                TextSpan(
                                    text:
                                        ' ${(widget.snap['description'] as String).substring(0, (widget.snap['description'] as String).length > 50 ? 50 : (widget.snap['description'] as String).length)} ${(widget.snap['description'] as String).length > 50 ? '- Read More...' : ''}',
                                    style: const TextStyle(
                                      color: Colors.black,
                                    )),
                              ],
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) =>
                                    CommentsScreen(snap: widget.snap),
                              ),
                            );
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 4),
                            child: Text(
                              'View all $commentLen comments',
                              style: const TextStyle(
                                  fontSize: 16, color: secondaryColor),
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: Text(
                            DateFormat.yMMMd()
                                .format(widget.snap['datePublished'].toDate()),
                            style: const TextStyle(
                                fontSize: 16, color: secondaryColor),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: ElevatedButton(
                          style: widget.snap['volunteers'].contains(user.uid)
                              ? ElevatedButton.styleFrom(
                                  primary:
                                      const Color.fromARGB(255, 188, 69, 0),
                                )
                              : ElevatedButton.styleFrom(
                                  primary: primaryButtonColor,
                                ),
                          onPressed: () async {
                            setState(() {
                              loadingVolunteer = true;
                            });
                            await FireStoreMethods().addVolunteer(
                                widget.snap['postId'],
                                user.uid,
                                widget.snap['volunteers']);
                            setState(() {
                              loadingVolunteer = false;
                            });
                          },
                          child: loadingVolunteer
                              ? const SizedBox(
                                  height: 25,
                                  width: 25,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                  ),
                                )
                              : !widget.snap['volunteers'].contains(user.uid)
                                  ? Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: const [
                                        Icon(Icons.add),
                                        Text('Want to be a volunteer?')
                                      ],
                                    )
                                  : Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: const [
                                        Icon(
                                            Icons.check_circle_outline_rounded),
                                        Text('You are already a volunteer 🥳')
                                      ],
                                    ),
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                ],
              ),
            ),
          )
        : Container();
  }
}
