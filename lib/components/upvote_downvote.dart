import 'package:crime_alert/resources/firestore_methods.dart';
import 'package:crime_alert/utility/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UpvoteDownvote extends StatefulWidget {
  final String postId;
  // ignore: prefer_typing_uninitialized_variables
  final snap;
  const UpvoteDownvote({Key? key, required this.postId, required this.snap})
      : super(key: key);

  @override
  State<UpvoteDownvote> createState() => _UpvoteDownvoteState();
}

class _UpvoteDownvoteState extends State<UpvoteDownvote> {
  Future<void> _toggleUpVote() async {
    //Allow vote if not own post
    if (widget.snap['uid'] != FirebaseAuth.instance.currentUser!.uid) {
      String? res = await FireStoreMethods().upvote(
          //to tell if it is from followers, feed, missing wanted as the IDs need to be unique
          //Removing last two characters as the id comes appended from post
          widget.postId.substring(0, widget.postId.length - 2),
          FirebaseAuth.instance.currentUser!.uid,
          widget.snap['uid'],
          widget.snap['upvotes'],
          widget.snap['downvotes']);
      if (res != null) {
        Utils.showSnackbar(res, context);
      }
    } else {
      Utils.showSnackbar('You can not vote on your own post', context);
    }
  }

  void _toggleDownvote() async {
    if (widget.snap['uid'] != FirebaseAuth.instance.currentUser!.uid) {
      String? res = await FireStoreMethods().downvote(
          widget.postId.substring(0, widget.postId.length - 2),
          FirebaseAuth.instance.currentUser!.uid,
          widget.snap['uid'],
          widget.snap['upvotes'],
          widget.snap['downvotes']);
      if (res != null) {
        Utils.showSnackbar(res, context);
      }
    } else {
      Utils.showSnackbar('You can not vote on your own post', context);
    }
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
                    onPressed: _toggleDownvote,
                    icon: Icon(
                      widget.snap.containsKey('downvotes') &&
                              widget.snap['downvotes'].contains(
                                  FirebaseAuth.instance.currentUser!.uid)
                          ? Icons.thumb_down_alt_rounded
                          : Icons.thumb_down_off_alt_outlined,
                      //Icons.thumb_down_off_alt_outlined,  when downvoted
                      color: widget.snap.containsKey('downvotes') &&
                              widget.snap['downvotes'].contains(
                                  FirebaseAuth.instance.currentUser!.uid)
                          ? Colors.red
                          : Colors.black,
                      size: 20,
                    ),
                  ),
                  Text(
                    widget.snap.containsKey('downvotes')
                        ? '${widget.snap['downvotes'].length}'
                        : '0',
                  )
                ],
              ),
              Column(
                children: [
                  IconButton(
                    onPressed: _toggleUpVote,
                    icon: Icon(
                      widget.snap.containsKey('upvotes') &&
                              widget.snap['upvotes'].contains(
                                  FirebaseAuth.instance.currentUser!.uid)
                          ? Icons.thumb_up_off_alt_rounded
                          : Icons.thumb_up_off_alt_outlined,
                      color: widget.snap.containsKey('upvotes') &&
                              widget.snap['upvotes'].contains(
                                  FirebaseAuth.instance.currentUser!.uid)
                          ? const Color.fromARGB(255, 246, 189, 0)
                          : Colors.black,
                      size: 20,
                    ),
                  ),
                  Text(
                    widget.snap.containsKey('upvotes')
                        ? '${widget.snap['upvotes'].length}'
                        : '0',
                  )
                ],
              )
            ],
          )
        : Container();
  }
}
