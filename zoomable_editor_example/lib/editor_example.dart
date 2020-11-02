import 'package:flutter/material.dart';
import 'package:zoomable_editor/zoomable_editor.dart';

import 'constants.dart';


class EditorExample extends StatelessWidget {

  AssetImage createAssetImage() {
    const assetImage = AssetImage('resource/kate-hliznitsova-lU_UuQ-6OVI-unsplash.jpg');
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
    zoomableController.updateScale(2);
    final editor = ZoomableEditor(
        zoomableController,
        editorSize: screenSize,
        contentSize: Size(sampleImageWidthInPoint, sampleImageHeightInPoint),
        displayWHRatio: 1,
        child: imgContent,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Editor'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: editor,
            ),
            Container(height: 50, width: 10,),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Finish'),
              ),
            ),
          ],
        ),
      )
    );
  }
}