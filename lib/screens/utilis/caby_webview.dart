import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'colors.dart';
import 'config/app_startup.dart';
import 'navigation/navigation_service.dart';

class CabyWebView extends StatefulWidget {
  final String? url;
  final String? title;

  const CabyWebView({Key? key, this.url, this.title}) : super(key: key);

  @override
  _CabyWebViewState createState() => _CabyWebViewState();
}

class _CabyWebViewState extends State<CabyWebView> {
  late final WebViewController controller;
  int position = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: AppColors.darkBlue,
          ),
          onPressed: () => getIt<NavigationService>().back(),
        ),
        title: Text(
          widget.title ?? "",
          // "About Us",
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: IndexedStack(
            index: position,
            children: [
              WebView(
                  javascriptMode: JavascriptMode.unrestricted,
                  onWebViewCreated: (controller) {
                    this.controller = controller;
                  },
                  onProgress: (int progress) {},
                  javascriptChannels: <JavascriptChannel>{
                    _toasterJavascriptChannel(context),
                  },
                  onPageFinished: doneLoading,
                  onPageStarted: startLoading,
                  initialUrl: Uri.parse(widget.url!).toString()),
              Container(
                color: Colors.white,
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  JavascriptChannel _toasterJavascriptChannel(BuildContext context) {
    return JavascriptChannel(
        name: 'Toaster',
        onMessageReceived: (JavascriptMessage message) {
          // ignore: deprecated_member_use
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(message.message)),
          );
        });
  }

  doneLoading(String A) {
    setState(() {
      position = 0;
    });
  }

  startLoading(String A) {
    setState(() {
      position = 1;
    });
  }
}
