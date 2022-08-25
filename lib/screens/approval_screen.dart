import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:rebel_girls/utils/colors.dart';
import 'package:rebel_girls/widgets/approval_card.dart';

class ApprovalScreen extends StatefulWidget {
  const ApprovalScreen({Key? key}) : super(key: key);

  @override
  State<ApprovalScreen> createState() => _ApprovalScreenState();
}

class _ApprovalScreenState extends State<ApprovalScreen> {
  late dynamic data;

  @override
  void initState() {
    super.initState();
    getData();
  }

  getData() async {
    var a = FirebaseFirestore.instance
        .collection('stories')
        .where("approved", isEqualTo: false)
        .orderBy("datePublished", descending: true)
        .limit(20)
        .snapshots();

    setState(() {
      data = a;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: mobileBackgroundColor,
          title: const Text(
            'Approval',
            style: TextStyle(
                color: Colors.black,
                fontFamily: 'Poppins-Bold',
                fontSize: 25,
                fontWeight: FontWeight.bold),
          ),
        ),
        body: StreamBuilder(
          stream: data,
          builder: (context,
              AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snaps) {
            if (snaps.hasData) {
              return SizedBox(
                child: RefreshIndicator(
                  onRefresh: () async {
                    await getData();
                  },
                  child: snaps.data!.docs.isNotEmpty
                      ? ListView.builder(
                          shrinkWrap: true,
                          physics: const AlwaysScrollableScrollPhysics(),
                          itemCount: snaps.data!.docs.length,
                          itemBuilder: (context, indexer) {
                            return ApprovalCard(
                                snap: snaps.data!.docs[indexer].data());
                          },
                        )
                      : const Center(
                          child: Text('No data...'),
                        ),
                ),
              );
            }

            return const Center(
              child: CircularProgressIndicator(),
            );
          },
        ));
  }
}
