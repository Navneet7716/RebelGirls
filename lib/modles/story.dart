import 'package:cloud_firestore/cloud_firestore.dart';

class Story {
  final String description;
  final String title;
  final datePublished;
  final String uid;
  final String id;
  final String username;
  final String bannerImage;
  final String profImage;
  final bool approved;

  const Story(
      {required this.title,
      required this.description,
      required this.id,
      required this.username,
      required this.profImage,
      required this.bannerImage,
      required this.datePublished,
      required this.uid,
      this.approved = false});

  Map<String, dynamic> toJson() => {
        "description": description,
        "title": title,
        "uid": uid,
        "id": id,
        "username": username,
        "datePublished": datePublished,
        "profImage": profImage,
        "bannerImage": bannerImage,
        "approved": approved
      };

  static Story fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return Story(
        username: snapshot['username'],
        uid: snapshot['uid'],
        id: snapshot['id'],
        datePublished: snapshot['datePublished'],
        profImage: snapshot['profImage'],
        bannerImage: snapshot['bannerImage'],
        description: snapshot['description'],
        title: snapshot['title'],
        approved: snapshot['approved']);
  }
}
