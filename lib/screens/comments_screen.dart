import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rebel_girls/modles/user.dart';
import 'package:rebel_girls/providers/user_provider.dart';
import 'package:rebel_girls/resources/firestore_methods.dart';
import 'package:rebel_girls/utils/colors.dart';
import 'package:rebel_girls/widgets/comment_card.dart';

class CommentsScreen extends StatefulWidget {
  final dynamic snap;

  const CommentsScreen({Key? key, required this.snap}) : super(key: key);

  @override
  _CommentsScreenState createState() => _CommentsScreenState();
}

class _CommentsScreenState extends State<CommentsScreen> {
  final TextEditingController _commentController = TextEditingController();

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final User? user = Provider.of<UserProvider>(context).getUser;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: whiteColor,
        iconTheme: const IconThemeData(color: Colors.black),
        title: const Text(
          'Comments',
          style: TextStyle(
              color: Colors.black,
              fontFamily: 'Poppins-Bold',
              fontSize: 25,
              fontWeight: FontWeight.bold),
        ),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('posts')
            .doc(widget.snap['postId'])
            .collection('comments')
            .orderBy('datePublished', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if ((snapshot.data! as dynamic).docs.length == 0) {
            return const Center(
              child: Text('No Comments yet!'),
            );
          } else {
            return ListView.builder(
              itemCount: (snapshot.data! as dynamic).docs.length,
              itemBuilder: (context, index) => CommentCard(
                  snap: (snapshot.data! as dynamic).docs[index].data()),
            );
          }
        },
      ),
      bottomNavigationBar: user != null
          ? SafeArea(
              child: Container(
                height: kToolbarHeight,
                margin: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom,
                ),
                padding: const EdgeInsets.only(left: 16, right: 8),
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundImage: NetworkImage(user.photoUrl),
                      radius: 18,
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      flex: 1,
                      child: TextField(
                        controller: _commentController,
                        decoration: InputDecoration(
                            hintText: ' Comment as ${user.username}',
                            border: InputBorder.none),
                      ),
                    ),
                    InkWell(
                      onTap: () async {
                        await FireStoreMethods().postComment(
                            widget.snap['postId'],
                            _commentController.text,
                            user.uid,
                            user.username,
                            user.photoUrl);

                        setState(() {
                          _commentController.text = "";
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 8),
                        child: const Text(
                          'Post',
                          style: TextStyle(
                            color: Colors.blueAccent,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          : const Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}
