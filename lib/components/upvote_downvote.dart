import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UpvoteDownvote extends StatefulWidget {
  const UpvoteDownvote({Key? key}) : super(key: key);

  @override
  State<UpvoteDownvote> createState() => _UpvoteDownvoteState();
}

class _UpvoteDownvoteState extends State<UpvoteDownvote> {
  bool upvoted = false;
  bool downvoted = false;
  int upvotes = 0;
  int downvotes = 0;
  void toggleUpVote() {
    setState(() {
      upvoted = !upvoted;
      downvoted = false;
      upvoted ? upvotes = 1 : upvotes = 0;
      downvotes = 0;
    });
  }

  void toggleDownvote() {
    setState(() {
      downvoted = !downvoted;
      upvoted = false;
      downvoted ? downvotes = 1 : downvotes = 0;
      upvotes = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    //User only upvotes and downvotes if signed in
    return FirebaseAuth.instance.currentUser != null
        ? Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Column(
                children: [
                  IconButton(
                    onPressed: () {
                      toggleDownvote();
                    },
                    icon: Icon(
                      downvoted
                          ? Icons.thumb_down_alt_rounded
                          : Icons.thumb_down_off_alt_outlined,
                      //Icons.thumb_down_off_alt_outlined,  when downvoted
                      color: Colors.red,
                    ),
                  ),
                  Text(downvotes.toString())
                ],
              ),
              Column(
                children: [
                  IconButton(
                    onPressed: () {
                      toggleUpVote();
                    },
                    icon: Icon(
                      upvoted
                          ? Icons.thumb_up_off_alt_rounded
                          : Icons.thumb_up_off_alt_outlined,
                      color: Colors.blue,
                    ),
                  ),
                  Text(upvotes.toString())
                ],
              )
            ],
          )
        : Container();
  }
}
