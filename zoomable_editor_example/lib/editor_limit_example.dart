import 'package:flutter/material.dart';
import 'package:zoomable_editor/zoomable_editor.dart';


class EditorLimitExample extends StatelessWidget {


  AssetImage createAssetImage() {
    const assetImage = AssetImage('resource/kate-hliznitsova-lU_UuQ-6OVI-unsplash.jpg');
    return assetImage;
  }

  @override
  Widget build(BuildContext context) {

    final zoomableController = ZoomableController(
        transitionEnabled: true,
        scaleEnabled: true,
        minScale: 1,
        maxScale: 3
    );
    zoomableController.updateScale(2);
    const contentW = 400.0;
    const contentH = 600.0;
    final imgContent = Image(image: createAssetImage());
    final editor = ZoomableEditor(
        Container(
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
              border: Border.all(color: Colors.transparent, width: 0)
          ),
          width: contentW,
          height: contentH,
          child: imgContent,
        ),
        zoomableController,
        editorSize: const Size(250, 250),
        contentSize: const Size(contentW, contentH),
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