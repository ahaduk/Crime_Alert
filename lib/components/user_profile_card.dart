import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../utility/colors.dart';
import '../utility/dimensions.dart';
import '../widget/big_text.dart';
import '../widget/small_text.dart';

class UserProfileCard extends StatelessWidget {
  final bool ownProfile;
  const UserProfileCard({Key? key, required this.ownProfile}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            BigText(
              text: "John Milkis",
              size: Dimensions.font26,
              color: AppColors.textColor,
              overflow: TextOverflow.fade,
            ),
            const CircleAvatar(
              backgroundColor: Colors.grey,
              backgroundImage: AssetImage("assets/user1.jpg"),
              radius: 50,
            ),
          ],
        ),
        ownProfile
            ? Row(
                children: [
                  const Text("Phone Number: "),
                  Text(
                    FirebaseAuth.instance.currentUser!.phoneNumber
                        .toString()
                        .replaceRange(8, 11, "***"),
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              )
            : Container(),
        SizedBox(
          height: Dimensions.height15,
        ),
        Container(
          padding: EdgeInsets.only(left: Dimensions.width10),
          child: SmallText(
            text:
                "Lorem,  dolor sit sit amet consecteturdolor sit sit amet consectetur",
            size: Dimensions.font16,
            color: AppColors.paraColor,
          ),
        ),
        const SizedBox(height: 10),
        // Post, follower, follwing
        Container(
          height: 90,
          padding: EdgeInsets.only(
              left: Dimensions.width20, right: Dimensions.width20),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.4),
                offset: const Offset(0, 10),
                blurRadius: 10,
              ),
            ],
            borderRadius: BorderRadius.all(
              Radius.circular(Dimensions.radius10),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  TextButton(
                    onPressed: () {},
                    child: const BigText(
                      text: "0",
                    ),
                  ),
                  SmallText(
                    text: "Posts",
                    size: Dimensions.font15,
                    color: AppColors.paraColor,
                  ),
                ],
              ),
              const BigText(
                text: "|",
                size: 18,
                color: AppColors.iconColor2,
              ),
              // Following Colum
              Column(
                children: [
                  TextButton(
                    onPressed: () {},
                    child: const BigText(
                      text: "150",
                    ),
                  ),
                  SmallText(
                    text: "Followers",
                    size: Dimensions.font15,
                    color: AppColors.paraColor,
                  ),
                ],
              ),
              const BigText(
                text: "|",
                size: 18,
                color: AppColors.iconColor2,
              ),
              // Follower Colum
              Column(
                children: [
                  TextButton(
                    onPressed: () {},
                    child: const BigText(
                      text: "100",
                    ),
                  ),
                  SmallText(
                    text: "Following",
                    size: Dimensions.font15,
                    color: AppColors.paraColor,
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
