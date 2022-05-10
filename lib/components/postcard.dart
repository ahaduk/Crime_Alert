import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../utility/dimensions.dart';
import '../widget/big_text.dart';
import '../widget/small_text.dart';

class PostCard extends StatelessWidget {
  final String? picUrl;
  final String postDescription;
  const PostCard({Key? key, this.picUrl, required this.postDescription})
      : super(key: key);
  //Also pass a user object or user id to identify profile of poster

  @override
  Widget build(BuildContext context) {
    double screenHeight = Get.context!.height;
    //double screenWidth = Get.context!.width;
    return Container(
      margin: EdgeInsets.only(
          left: Dimensions.width20,
          right: Dimensions.width20,
          bottom: Dimensions.height20),
      decoration: BoxDecoration(boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.4),
          offset: const Offset(10, 10),
          blurRadius: 10,
        )
      ]),
      child: Row(
        children: [
          picUrl != null
              ? Container(
                  width: Dimensions.listViewImgSize,
                  height: Dimensions.listViewImgSize,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(Dimensions.radius10),
                        bottomLeft: Radius.circular(Dimensions.radius10),
                      ),
                      color: const Color.fromRGBO(255, 255, 255, 0.384),
                      image: picUrl != null
                          ? DecorationImage(
                              fit: BoxFit.cover, image: AssetImage(picUrl!))
                          : null),
                )
              : Container(),
          // text section
          Expanded(
            child: Container(
              height: Dimensions.listViewImgSize,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(Dimensions.radius10),
                  bottomRight: Radius.circular(Dimensions.radius10),
                ),
                color: Colors.white,
              ),
              child: Padding(
                padding: EdgeInsets.only(
                    top: Dimensions.width10,
                    left: Dimensions.width10,
                    right: Dimensions.width10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    BigText(
                      text: postDescription,
                      size: screenHeight <= 825 ? 12 : Dimensions.font14,
                    ),
                    SizedBox(
                      height: Dimensions.height7,
                    ),
                    SizedBox(
                      height: screenHeight <= 825 ? 8 : 8,
                    ),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: Dimensions.height20,
                                height: Dimensions.height20,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(
                                      Dimensions.radius30),
                                  color: Colors.black,
                                  image: const DecorationImage(
                                      image: AssetImage("assets/user3.jpg"),
                                      fit: BoxFit.fill),
                                ),
                              ),
                              SizedBox(
                                width: Dimensions.width5,
                              ),
                              SmallText(
                                text: "johonnes milke",
                                color: const Color.fromARGB(255, 75, 60, 60),
                                size: screenHeight <= 825
                                    ? 11
                                    : Dimensions.font13,
                              ),
                            ],
                          ),
                          Container(
                            padding: EdgeInsets.only(right: Dimensions.width15),
                            child: SmallText(
                              text: "1h ago",
                              color: const Color.fromARGB(255, 129, 127, 127),
                              size:
                                  screenHeight <= 825 ? 11 : Dimensions.font13,
                            ),
                          )
                        ]),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
