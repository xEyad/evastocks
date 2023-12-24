import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart' as html_parser;
import 'package:url_launcher/url_launcher.dart';

showMessage(
    {required BuildContext ctx,
    required String message,
    required String title,
    Color backgroundColor = Colors.red}) {
  Flushbar(
    backgroundColor: backgroundColor,
    flushbarPosition: FlushbarPosition.TOP,
    title: title,
    message: message,
    duration: const Duration(seconds: 3),
  ).show(ctx);
}

Future<void> launchUrl(_url) async {
  await launchUrl(_url);
}

whatsapp(context) async {
  print('called');
  var whatsappUrl = "https://wsend.co/966505839717";
  try {
    launch(whatsappUrl);
  } catch (e) {
    //To handle error and display error message
    showMessage(ctx: context, message: "لم نستطع فتح واتساب", title: 'خطأ');
  }
}

String removeHtmlTags(String htmlText) {
  // Parse the HTML text into a Document object
  final document = html_parser.parse(htmlText);

  // Extract text content from the Document
  final text = parseNode(document.body!);

  // Join the text and remove extra whitespace
  return text.join(' ').trim();
}

List<String> parseNode(dom.Node node) {
  final result = <String>[];

  if (node.nodeType == dom.Node.TEXT_NODE) {
    result.add(node.text!);
  } else if (node.nodeType == dom.Node.ELEMENT_NODE) {
    for (var child in node.nodes) {
      result.addAll(parseNode(child));
    }
  }

  return result;
}
