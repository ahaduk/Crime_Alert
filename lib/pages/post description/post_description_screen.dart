import 'package:flutter/material.dart';

import '../../utility/dimensions.dart';
import '../../widget/big_text.dart';

class PostDescriptionScreen extends StatefulWidget {
  final String postDescription;
  final String id;
  const PostDescriptionScreen(
      {Key? key, required this.postDescription, required this.id})
      : super(key: key);

  @override
  State<PostDescriptionScreen> createState() => _PostDescriptionScreenState();
}

class _PostDescriptionScreenState extends State<PostDescriptionScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          "Post Description",
          style: TextStyle(
            color: Colors.grey,
            fontSize: Dimensions.font16,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18),
            child: Hero(
              tag: widget.id,
              child: BigText(
                text: widget.postDescription,
                size: Dimensions.screenHeight <= 825 ? 12 : Dimensions.font14,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
