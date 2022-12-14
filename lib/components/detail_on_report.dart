import 'package:crime_alert/components/post_card_from_object.dart';
import 'package:crime_alert/model/post_model.dart';
import 'package:crime_alert/utility/colors.dart';
import 'package:flutter/material.dart';

class MoreDetailOnReport extends StatelessWidget {
  final List<Post> posts;
  const MoreDetailOnReport({Key? key, required this.posts}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.mainColor,
        title: const Text('Alerts In Location', style: TextStyle(fontSize: 15)),
        foregroundColor: Colors.black,
      ),
      body: ListView.builder(
          itemCount: posts.length,
          itemBuilder: (BuildContext context, int index) {
            return PostCardFromList(post: posts[index]);
          }),
    );
  }
}
