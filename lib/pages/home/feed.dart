import 'package:flutter/material.dart';
import '../../components/postcard.dart';

class Feed extends StatefulWidget {
  const Feed({Key? key}) : super(key: key);

  @override
  State<Feed> createState() => _FeedState();
}

class _FeedState extends State<Feed> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(children: [
        Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: 10,
                  itemBuilder: (context, index) {
                    return PostCard(
                      id: index.toString() + "feed",
                      picUrl: "assets/avatar2.png",
                      //Photo can be null
                      postDescription:
                          "Lorem, ipsum dolor sit amet consectetur adipisicing elit. Omnis ipsum dolor sit amet consectetur adipisicing elit. Omnis illum aperiam quam aut nihil ipsa aspernatur porro inventore at expedita?",
                    );
                  },
                ),
              ),
            )
          ],
        ),
      ]),
    );
  }
}
