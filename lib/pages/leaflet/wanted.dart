import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../components/postcard.dart';

class Wanted extends StatefulWidget {
  const Wanted({Key? key}) : super(key: key);

  @override
  State<Wanted> createState() => _WantedState();
}

class _WantedState extends State<Wanted> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(children: [
        Column(
          children: [
            Expanded(
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('posts')
                    .orderBy('datePublished', descending: true)
                    .snapshots(),
                builder: (context,
                    AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                        snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  if (snapshot.data!.docs.isEmpty) {
                    return const Center(
                      child: Text(
                        "No Feeds Available\nStart following someone to see posts",
                        textAlign: TextAlign.center,
                      ),
                    );
                  }
                  return ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    physics: const BouncingScrollPhysics(),
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return PostCard(
                          snap: snapshot.data!.docs[index].data(),
                          docId:
                              snapshot.data!.docs[index].reference.id + "wa");
                    },
                  );
                },
              ),
            )
          ],
        ),
      ]),
    );
  }
}
