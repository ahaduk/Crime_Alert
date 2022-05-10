import 'package:flutter/material.dart';
import '../../components/postcard.dart';

class Missing extends StatefulWidget {
  const Missing({Key? key}) : super(key: key);

  @override
  State<Missing> createState() => _MissingState();
}

class _MissingState extends State<Missing> {
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
                    return const PostCard(
                      // picUrl: "assets/avatar5.png",
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
