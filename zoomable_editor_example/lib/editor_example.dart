import 'package:flutter/material.dart';
import 'package:zoomable_editor/zoomable_editor.dart';

import 'constants.dart';


class EditorExample extends StatelessWidget {

  AssetImage createAssetImage() {
    final assetImage = AssetImage("resource/kate-hliznitsova-lU_UuQ-6OVI-unsplash.jpg");
    return assetImage;
  }

  @override
  Widget build(BuildContext context) {

    final devicePixelRatio = MediaQuery.of(context).devicePixelRatio;
    final sampleImageWidthInPoint = sampleImageWidth / devicePixelRatio;
    final sampleImageHeightInPoint = sampleImageHeight / devicePixelRatio;
    final screenSize = MediaQuery.of(context).size;

    final imgContent = Image(width: sampleImageWidthInPoint, height: sampleImageHeightInPoint, image: createAssetImage());
    final zoomableController = ZoomableController(
        transitionEnabled: true,
        scaleEnabled: true,
        minScale: 1,
        maxScale: 3
    );
    zoomableController.scale = 1;
    final editor = ZoomableEditor(
        imgContent,
        zoomableController,
        editorWidth: screenSize.width,
        editorHeight: screenSize.width,
        contentHeight: sampleImageHeightInPoint,
        contentWidth: sampleImageWidthInPoint,
        displayWHRatio: 1,
    );

    return Scaffold(
      appBar: AppBar(
        title: Text("Editor"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: editor,
            ),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('Finish'),
              ),
            ),
          ],
        ),
      )
    );
  }
}