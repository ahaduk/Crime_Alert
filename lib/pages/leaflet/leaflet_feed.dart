import 'package:crime_alert/pages/leaflet/missing.dart';
import 'package:crime_alert/pages/leaflet/wanted.dart';
import 'package:flutter/material.dart';

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
    return Stack(children: [
      Column(children: [
        Container(
          margin: EdgeInsets.only(
              top: Dimensions.height45, bottom: Dimensions.width10),
          padding: EdgeInsets.only(
              left: Dimensions.width20, right: Dimensions.width20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const BigText(
                text: "Logo",
                color: Color.fromARGB(255, 178, 180, 178),
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
                    text: "Missing",
                    pageNumber: 1,
                    selectedPage: _selectedPage,
                    onPressed: () {
                      _changePage(1);
                    },
                  ),
                ],
              ),
              Center(
                child: Container(
                  width: Dimensions.height40,
                  height: Dimensions.height40,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(Dimensions.radius30),
                    color: Colors.black,
                    image: const DecorationImage(
                        image: AssetImage("assets/user1.jpg"),
                        fit: BoxFit.fill),
                  ),
                ),
              )
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
