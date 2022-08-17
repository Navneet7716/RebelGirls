import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  final String description;
  final String title;
  final eventStartTime;
  final eventEndTime;
  final eventDate;

  final String venue;
  final String uid;
  final String username;
  final String postId;
  final datePublished;
  final String profImage;
  final String postUrl;
  final String? eventLink;
  final String? eventAddress;
  final likes;
  final volunteers;

  const Post({
    this.eventLink,
    this.eventAddress,
    required this.eventDate,
    required this.title,
    required this.eventStartTime,
    required this.eventEndTime,
    required this.venue,
    required this.description,
    required this.uid,
    required this.postId,
    required this.username,
    required this.datePublished,
    required this.profImage,
    required this.postUrl,
    required this.likes,
    required this.volunteers,
  });

  Map<String, dynamic> toJson() => {
        "description": description,
        "title": title,
        "eventStartTime": eventStartTime,
        "eventEndTime": eventEndTime,
        "venue": venue,
        "eventDate": eventDate,
        "eventLink": eventLink,
        "eventAddress": eventAddress,
        "uid": uid,
        "postId": postId,
        "username": username,
        "datePublished": datePublished,
        "profImage": profImage,
        "postUrl": postUrl,
        "likes": likes,
        "volunteers": volunteers
      };

  static Post fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return Post(
        username: snapshot['username'],
        uid: snapshot['uid'],
        postId: snapshot['postId'],
        datePublished: snapshot['datePublished'],
        profImage: snapshot['profImage'],
        postUrl: snapshot['postUrl'],
        likes: snapshot['likes'],
        volunteers: snapshot['volunteers'],
        description: snapshot['description'],
        eventDate: snapshot['eventDate'],
        eventEndTime: snapshot['eventEndTime'],
        eventStartTime: snapshot['eventStartTime'],
        title: snapshot['title'],
        venue: snapshot['venue'],
        eventAddress: snapshot['eventAddress'],
        eventLink: snapshot['eventLink']);
  }
}
