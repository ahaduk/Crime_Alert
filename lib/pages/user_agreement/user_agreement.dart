import 'package:crime_alert/utility/colors.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class UserAgreement extends StatelessWidget {
  const UserAgreement({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.mainColor,
      ),
      body: const WebView(
        javascriptMode: JavascriptMode.unrestricted,
        initialUrl:
            'https://www.termsfeed.com/live/fa6146f9-2812-4cb8-8ea3-0da424751e2c',
      ),
    );
  }
}
