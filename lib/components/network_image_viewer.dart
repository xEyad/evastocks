import 'package:flutter/material.dart';
import 'package:nosooh/utils/colors.dart';

class NetworkPictureViewer extends StatefulWidget {
  final String imagePath;
  const NetworkPictureViewer({super.key,required this.imagePath});

  @override
  _NetworkPictureViewerState createState() => _NetworkPictureViewerState();
}

class _NetworkPictureViewerState extends State<NetworkPictureViewer> {
  double _scale = 1.0;
  double _previousScale = 1.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: BackButton(color: Colors.black),
      ),
      body: Center(
        child: GestureDetector(
          onScaleStart: (details) {
            _previousScale = _scale;
          },
          onScaleUpdate: (details) {
            setState(() {
              _scale = _previousScale * details.scale;
            });
          },
          child: Transform.scale(
            scale: _scale,
            child: Image.network(
              widget.imagePath,
              width: 500, // Adjust the initial width as needed
              height: 500, // Adjust the initial height as needed
            ),
          ),
        ),
      ),
    );
  }
}