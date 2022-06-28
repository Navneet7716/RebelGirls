import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:rebel_girls/utils/colors.dart';
import 'package:url_launcher/url_launcher.dart';

class PostDetails extends StatefulWidget {
  final postData;

  const PostDetails({Key? key, required this.postData}) : super(key: key);

  @override
  State<PostDetails> createState() => _PostDetailsState();
}

class _PostDetailsState extends State<PostDetails> {
  Future<void>? _launched;

  Future<void> _launchInBrowser(Uri url) async {
    if (!await launchUrl(
      url,
      mode: LaunchMode.externalApplication,
    )) {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    final Uri? toLaunch = widget.postData['eventLink'] != ""
        ? Uri(
            scheme: "https",
            host: (widget.postData['eventLink'] as String)
                .split("//")[1]
                .split("/")[0],
          )
        : Uri();

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: whiteColor,
        iconTheme: const IconThemeData(color: Colors.black),
        title: const Text(
          'Details',
          style: TextStyle(
              color: Colors.black,
              fontFamily: 'Poppins-Bold',
              fontSize: 25,
              fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: Stack(
                alignment: Alignment.bottomRight,
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: AspectRatio(
                      aspectRatio: 1 / 1,
                      child: Container(
                          decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25),
                        image: DecorationImage(
                          image: NetworkImage(
                            '${widget.postData['postUrl']}',
                          ),
                          fit: BoxFit.fill,
                          // alignment: FractionalOffset.topCenter,
                        ),
                      )),
                    ),
                  ),
                  Container(
                    height: 100,
                    alignment: Alignment.bottomCenter,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25),
                        gradient: const LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          colors: [
                            Color.fromARGB(255, 13, 13, 13),
                            Color.fromARGB(0, 48, 48, 48),
                          ],
                        )),
                    width: double.infinity,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Text(
                        '${widget.postData['title']}',
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.white,
                          fontFamily: 'Pacifico',
                          fontSize: 30,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                elevation: 2,
                child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Text(
                      '${widget.postData['description']}',
                      style: const TextStyle(fontSize: 16),
                    )),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //date
                      Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Text(
                              "Event Date:",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            Text(
                              '${(widget.postData['eventDate'] as Timestamp).toDate().day}-${(widget.postData['eventDate'] as Timestamp).toDate().month}-${(widget.postData['eventDate'] as Timestamp).toDate().year}',
                              style: const TextStyle(
                                fontSize: 16,
                              ),
                            )
                          ],
                        ),
                      ),
                      // time

                      Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Text(
                              "Event Time:",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            Text(
                              '${widget.postData['eventStartTime']} to ${widget.postData['eventEndTime']}',
                              style: const TextStyle(
                                fontSize: 16,
                              ),
                            )
                          ],
                        ),
                      ),

                      // cost

                      Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: const [
                            Text(
                              "Cost:",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            Text(
                              'Free',
                              style: TextStyle(
                                fontSize: 16,
                              ),
                            )
                          ],
                        ),
                      ),

                      // venue

                      Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Text(
                              "Venue:",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            Text(
                              '${widget.postData['venue']}',
                              style: const TextStyle(
                                fontSize: 16,
                              ),
                            )
                          ],
                        ),
                      ),

                      widget.postData['venue'] == "offline"
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Address:",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                SizedBox(
                                  width: 200,
                                  child: Text(
                                    '${widget.postData['eventAddress']}',
                                    style: const TextStyle(
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              ],
                            )
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const Text(
                                  "Link:",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    setState(() {
                                      _launched = _launchInBrowser(toLaunch!);
                                    });
                                  },
                                  style: const ButtonStyle(
                                      visualDensity: VisualDensity.compact),
                                  child: const Text(
                                    'Join',
                                  ),
                                )
                              ],
                            ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
