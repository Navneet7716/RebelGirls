import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rebel_girls/resources/firestore_methods.dart';
import 'package:rebel_girls/utils/colors.dart';
import 'package:rebel_girls/widgets/profile_image.dart';

class ApprovalCard extends StatefulWidget {
  final dynamic snap;

  const ApprovalCard({Key? key, required this.snap}) : super(key: key);

  @override
  State<ApprovalCard> createState() => _ApprovalCardState();
}

class _ApprovalCardState extends State<ApprovalCard> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
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
                            Text(
                              widget.snap['title'],
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: double.infinity,
                height: 270,
                decoration: BoxDecoration(
                  color: Colors.white,
                  image: DecorationImage(
                    fit: BoxFit.contain,
                    image:
                        CachedNetworkImageProvider(widget.snap['bannerImage']),
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
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
                                    ' ${(widget.snap['description'] as String)}',
                                style: const TextStyle(
                                  color: Colors.black,
                                )),
                          ],
                        ),
                      ),
                    ),
                    Text(
                      DateFormat.yMMMd()
                          .format(widget.snap['datePublished'].toDate()),
                      style:
                          const TextStyle(fontSize: 13, color: secondaryColor),
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  Expanded(
                      child: ElevatedButton(
                    child: const Text('Approve'),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => Dialog(
                          child: ListView(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shrinkWrap: true,
                            children: [
                              'Approve',
                            ]
                                .map(
                                  (e) => InkWell(
                                    onTap: () async {
                                      if (kDebugMode) {
                                        print(widget.snap);
                                      }

                                      await FireStoreMethods()
                                          .approveStory(widget.snap['id']);

                                      Navigator.of(context).pop();
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 12, horizontal: 16),
                                      child: Text(e),
                                    ),
                                  ),
                                )
                                .toList(),
                          ),
                        ),
                      );
                    },
                  )),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                      child: ElevatedButton(
                    child: const Text('Reject'),
                    style: ElevatedButton.styleFrom(
                      primary: const Color.fromARGB(255, 188, 69, 0),
                    ),
                    onPressed: () async {
                      showDialog(
                        context: context,
                        builder: (context) => Dialog(
                          child: ListView(
                            padding: const EdgeInsets.symmetric(vertical: 16),
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
                                          .deleteStory(widget.snap['id']);

                                      Navigator.of(context).pop();
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 12, horizontal: 16),
                                      child: Text(e),
                                    ),
                                  ),
                                )
                                .toList(),
                          ),
                        ),
                      );
                    },
                  ))
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
