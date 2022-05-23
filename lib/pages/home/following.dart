import 'package:crime_alert/components/postcard.dart';
import 'package:flutter/material.dart';

class Following extends StatefulWidget {
  const Following({Key? key}) : super(key: key);

  @override
  State<Following> createState() => _FollowingState();
}

class _FollowingState extends State<Following> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(children: [
        Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: 10,
                  itemBuilder: (context, index) {
                    return PostCard(
                      id: index.toString(),
                      picUrl: "assets/avatar5.png",
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
