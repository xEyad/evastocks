import 'package:flutter/material.dart';
import 'package:nosooh/utils/colors.dart';
import 'package:webview_flutter/webview_flutter.dart';

class BillWebView extends StatefulWidget {
  final String hyperLink;
  const BillWebView({Key? key,required this.hyperLink}) : super(key: key);

  @override
  State<BillWebView> createState() => _BillWebViewState();
}

class _BillWebViewState extends State<BillWebView> {
  var controller;

  @override
  void initState() {
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..addJavaScriptChannel('getBack', onMessageReceived: (p0) {
        if(p0.message == '1'){
          Navigator.of(context).pop();
        }
      },)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {},
          onPageStarted: (String url) {},
          onPageFinished: (String url) {},
          onWebResourceError: (WebResourceError error) {},
          onNavigationRequest: (NavigationRequest request) {
            if (request.url.startsWith('https://www.youtube.com/')) {
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(
          widget.hyperLink));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
       // title: const Text('Payment'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: BackButton(color: Colors.black),
      ),
      body: WebViewWidget(
        controller: controller,
      ),
    );
  }
}
