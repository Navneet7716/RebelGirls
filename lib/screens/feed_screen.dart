import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:rebel_girls/resources/auth_methods.dart';
import 'package:rebel_girls/screens/login_screen.dart';
import 'package:rebel_girls/utils/colors.dart';
import 'package:rebel_girls/widgets/post_card.dart';
import 'package:rebel_girls/widgets/story_card.dart';

class FeedScreen extends StatelessWidget {
  const FeedScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: mobileBackgroundColor,
          actions: [
            PopupMenuButton(
                icon: const Icon(
                  Icons.ac_unit,
                  color: Colors.black,
                ),
                itemBuilder: (context) {
                  return [
                    const PopupMenuItem<int>(
                      value: 0,
                      child: Text("Logout"),
                    ),
                  ];
                },
                onSelected: (value) async {
                  if (value == 0) {
                    await AuthMethods().signOut();
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (context) => const LoginScreen(),
                      ),
                    );
                  }
                }),
          ],
          title: const Text(
            'Discover',
            style: TextStyle(
                color: Colors.black,
                fontFamily: 'Poppins-Bold',
                fontSize: 25,
                fontWeight: FontWeight.bold),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: const EdgeInsets.only(left: 20, top: 20),
                child: const Text(
                  'Voices',
                  style: TextStyle(
                      color: Colors.black,
                      fontFamily: 'Poppins-Bold',
                      fontSize: 22,
                      fontWeight: FontWeight.bold),
                ),
              ),
              StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('stories')
                    .where('approved', isEqualTo: true)
                    .orderBy("datePublished", descending: true)
                    .limit(5)
                    .snapshots(),
                builder: (context,
                    AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snaps) {
                  if (snaps.hasData) {
                    return SizedBox(
                      height: 270,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: snaps.data!.docs.length,
                        itemBuilder: (context, indexer) {
                          return StoryCard(
                              snap: snaps.data!.docs[indexer].data());
                        },
                      ),
                    );
                  }

                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                },
              ),
              Container(
                margin: const EdgeInsets.only(left: 20, top: 20),
                child: const Text(
                  'Events',
                  style: TextStyle(
                      color: Colors.black,
                      fontFamily: 'Poppins-Bold',
                      fontSize: 22,
                      fontWeight: FontWeight.bold),
                ),
              ),
              Flexible(
                child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('posts')
                      .orderBy("datePublished", descending: true)
                      .limit(20)
                      .snapshots(),
                  builder: (context,
                      AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                          snaps) {
                    if (snaps.hasData) {
                      return ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: snaps.data!.docs.length,
                          itemBuilder: (context, index) {
                            return PostCard(
                              snap: snaps.data!.docs[index].data(),
                            );
                          });
                    }
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  },
                ),
              )
            ],
          ),
        ));
  }
}
