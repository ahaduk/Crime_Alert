import 'package:crime_alert/pages/leaflet/missing.dart';
import 'package:crime_alert/pages/leaflet/wanted.dart';
import 'package:flutter/material.dart';

import '../../components/user_profile_avatar.dart';
import '../../utility/dimensions.dart';
import '../../widget/big_text.dart';
import '../../widget/tab_button.dart';

class LeafletFeed extends StatefulWidget {
  const LeafletFeed({Key? key}) : super(key: key);

  @override
  _LeafletFeedState createState() => _LeafletFeedState();
}

class _LeafletFeedState extends State<LeafletFeed> {
  int _selectedPage = 0;
  late PageController _pageController;
  @override
  void initState() {
    _pageController = PageController();
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _changePage(int pageNum) {
    setState(() {
      _selectedPage = pageNum;
      _pageController.animateToPage(pageNum,
          duration: const Duration(milliseconds: 500),
          curve: Curves.fastLinearToSlowEaseIn);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(fit: StackFit.expand, children: [
      Column(children: [
        Container(
          margin: EdgeInsets.only(
              top: Dimensions.height45, bottom: Dimensions.width10),
          padding: EdgeInsets.only(right: Dimensions.width20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                height: 40,
                width: 100,
                decoration: const BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage('assets/screenlogo.png'),
                        fit: BoxFit.cover)),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  NavTabs(
                    text: "Wanted",
                    pageNumber: 0,
                    selectedPage: _selectedPage,
                    onPressed: () {
                      _changePage(0);
                    },
                  ),
                  BigText(
                    text: "|",
                    size: Dimensions.font14,
                  ),
                  NavTabs(
                    text: "Missing   ",
                    pageNumber: 1,
                    selectedPage: _selectedPage,
                    onPressed: () {
                      _changePage(1);
                    },
                  ),
                ],
              ),
              const Center(child: UserProfileAvatar())
            ],
          ),
        ),
        Expanded(
            child: PageView(
          onPageChanged: (int page) {
            setState(() {
              _selectedPage = page;
            });
          },
          controller: _pageController,
          children: const [Wanted(), Missing()],
        ))
      ]),
    ]);
  }
}
