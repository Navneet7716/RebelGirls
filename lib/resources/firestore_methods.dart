import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:rebel_girls/modles/story.dart';
import 'package:uuid/uuid.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rebel_girls/modles/post.dart';
import 'package:rebel_girls/resources/storage_methods.dart';

class FireStoreMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String> uploadPost(
      String title,
      String description,
      Uint8List file,
      String uid,
      String username,
      String profImage,
      eventStartTime,
      eventEndTime,
      DateTime eventDate,
      String venue,
      String? eventLink,
      String? eventAddress) async {
    String res = "Some error occurred";
    try {
      String photoUrl =
          await StorageMethods().uploadImageToStorage('posts', file, true);

      String postId = const Uuid().v1();

      Post post = Post(
          eventDate: eventDate,
          eventEndTime: eventEndTime,
          eventStartTime: eventStartTime,
          eventAddress: eventAddress,
          venue: venue,
          eventLink: eventLink,
          description: description,
          title: title,
          uid: uid,
          postId: postId,
          username: username,
          datePublished: DateTime.now(),
          profImage: profImage,
          postUrl: photoUrl,
          likes: [],
          volunteers: []);

      _firestore.collection('posts').doc(postId).set(post.toJson());

      res = "success";
    } catch (e) {
      res = e.toString();
    }

    return res;
  }

  Future<String> uploadStory(
    String title,
    String description,
    Uint8List file,
    String uid,
    String username,
    String profImage,
  ) async {
    String res = "Some error occurred";

    try {
      String bannerImage =
          await StorageMethods().uploadImageToStorage('storys', file, true);

      String id = const Uuid().v1();

      Story story = Story(
        title: title,
        description: description,
        id: id,
        username: username,
        profImage: profImage,
        bannerImage: bannerImage,
        datePublished: DateTime.now(),
        uid: uid,
      );

      _firestore.collection('stories').doc(id).set(story.toJson());

      res = "success";
    } catch (e) {
      res = e.toString();
    }
    return res;
  }

  Future<void> likePost(String postId, String uid, List likes) async {
    try {
      if (likes.contains(uid)) {
        await _firestore.collection('posts').doc(postId).update({
          'likes': FieldValue.arrayRemove([uid])
        });
      } else {
        await _firestore.collection('posts').doc(postId).update({
          'likes': FieldValue.arrayUnion([uid])
        });
      }
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
    }
  }

  Future<void> postComment(String postId, String text, String uid, String name,
      String profilePic) async {
    try {
      if (text.isNotEmpty) {
        String commentId = const Uuid().v1();

        await _firestore
            .collection('posts')
            .doc(postId)
            .collection('comments')
            .doc(commentId)
            .set({
          'profilePic': profilePic,
          'name': name,
          'uid': uid,
          'text': text,
          'commentId': commentId,
          'datePublished': DateTime.now(),
        });
      } else {
        print('Text is Empty!');
      }
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
    }
  }

  Future<void> addStoryComment(String storyId, String text, String uid,
      String name, String profilePic) async {
    try {
      if (text.isNotEmpty) {
        String commentId = const Uuid().v1();

        await _firestore
            .collection('stories')
            .doc(storyId)
            .collection('comments')
            .doc(commentId)
            .set({
          'profilePic': profilePic,
          'name': name,
          'uid': uid,
          'text': text,
          'commentId': commentId,
          'datePublished': DateTime.now(),
        });
      } else {
        if (kDebugMode) {
          print('Text is Empty!');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
    }
  }

  Future<void> addVolunteer(String postId, String uid, List volunteers) async {
    try {
      if (volunteers.contains(uid)) {
        await _firestore.collection('posts').doc(postId).update({
          'volunteers': FieldValue.arrayRemove([uid])
        });
      } else {
        await _firestore.collection('posts').doc(postId).update({
          'volunteers': FieldValue.arrayUnion([uid])
        });
      }
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
    }
  }

  // deleating post

  Future<void> deletePost(String postId) async {
    try {
      await _firestore.collection('posts').doc(postId).delete();
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
    }
  }

  Future<void> deleteStory(String storyId) async {
    try {
      await _firestore.collection('stories').doc(storyId).delete();
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
    }
  }

  Future<void> approveStory(String storyId) async {
    try {
      await _firestore.collection('stories').doc(storyId).update({
        'approved': true,
      });
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
    }
  }

}
