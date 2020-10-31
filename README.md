# zoomable_editor

Zoomable editor to control child widget's position, scale, rotation



## Getting Started

Example

```


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
        editorWidth: 250,
        editorHeight: 250,
        contentHeight: contentH,
        contentWidth: contentW,
        displayWHRatio: 1,
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


```



## Assets
flutter_zoomable_editor/zoomable_editor_example/resource/kate-hliznitsova-lU_UuQ-6OVI-unsplash.jpg
<span>Photo by <a href="https://unsplash.com/@kate_gliz?utm_source=unsplash&amp;utm_medium=referral&amp;utm_content=creditCopyText">Kate Hliznitsova</a> on <a href="https://unsplash.com/?utm_source=unsplash&amp;utm_medium=referral&amp;utm_content=creditCopyText">Unsplash</a></span>
