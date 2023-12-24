import 'package:flutter/material.dart';
import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart';
class PDFViewer extends StatefulWidget {
  final String pdfUrl;
  const PDFViewer({super.key,required this.pdfUrl});

  @override
  State<PDFViewer> createState() => _PDFViewerState();
}

class _PDFViewerState extends State<PDFViewer> {
  @override
  void initState() {


    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.transparent,
        leading: BackButton(color: Colors.black),
      ),
      body: PDF(
        swipeHorizontal: true,
        onError: (error) => Text('الملف غير صالج'),
        onPageError: (page, error) => Text('الملف غير صالج'),
      ).cachedFromUrl(widget.pdfUrl),
    );
  }
}
