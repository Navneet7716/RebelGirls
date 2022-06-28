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
      body: SafeArea(
        child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('posts')
              .orderBy("datePublished", descending: true)
              .limit(20)
              .snapshots(),
          builder: (context,
              AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if (snapshot.hasData) {
              return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      return StreamBuilder(
                        stream: FirebaseFirestore.instance
                            .collection('stories')
                            .orderBy("datePublished", descending: true)
                            .limit(5)
                            .snapshots(),
                        builder: (contextex,
                            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                                snapshot2) {
                          if (snapshot2.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }

                          if (snapshot2.hasData) {
                            return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    margin: const EdgeInsets.only(
                                        left: 20, top: 20),
                                    child: const Text(
                                      'Voices',
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontFamily: 'Poppins-Bold',
                                          fontSize: 22,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 270,
                                    child: ListView.builder(
                                      shrinkWrap: true,
                                      scrollDirection: Axis.horizontal,
                                      itemCount: snapshot2.data!.docs.length,
                                      itemBuilder: (contexter, indexer) {
                                        return StoryCard(
                                            snap: snapshot2.data!.docs[indexer]
                                                .data());
                                      },
                                    ),
                                  ),
                                  const Divider(),
                                  Container(
                                    margin: const EdgeInsets.only(
                                        left: 20, top: 20),
                                    child: const Text(
                                      'Events',
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontFamily: 'Poppins-Bold',
                                          fontSize: 22,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  PostCard(
                                    snap: snapshot.data!.docs[index].data(),
                                  )
                                ]);
                          }
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        },
                      );
                    } else {
                      return PostCard(
                        snap: snapshot.data!.docs[index].data(),
                      );
                    }
                  });
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
      ),
    );
  }
}
