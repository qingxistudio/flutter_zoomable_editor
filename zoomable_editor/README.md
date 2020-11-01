# zoomable_editor

Zoomable editor to control child widget's position, scale, rotation

Features:

- Support scale and offset to edit a widget's transform matrix.
- Auto bounce back if the offset exceed the rect.
- Support double tap to reset scale and offset.




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
## Example Screenshot

![alt Sample Screenshot](https://raw.githubusercontent.com/qingxistudio/flutter_zoomable_editor/master/sample.jpg)
