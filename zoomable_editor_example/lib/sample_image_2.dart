import 'package:flutter/material.dart';

import 'constants.dart';

class SampleImage2 extends StatelessWidget {

  AssetImage createAssetImage() {
    final assetImage = AssetImage("resource/kate-hliznitsova-lU_UuQ-6OVI-unsplash.jpg");
    return assetImage;
  }

  @override
  Widget build(BuildContext context) {

    final devicePixelRatio = MediaQuery.of(context).devicePixelRatio;
    final sampleImageWidthInPoint = sampleImageWidth / devicePixelRatio;
    final sampleImageHeightInPoint = sampleImageHeight / devicePixelRatio;


    return Scaffold(
      appBar: AppBar(
        title: Text("Second Route"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              clipBehavior: Clip.antiAlias,
              decoration: new BoxDecoration(
                  border: new Border.all(color: Colors.transparent, width: 0)
              ),
              width: 200,
              height: 200,
              child: FittedBox(
                fit: BoxFit.cover,
                child: Container(
                  color: Colors.black26,
                  child: Transform(
                    alignment: Alignment.center,
                    transform: Matrix4.identity(),
                    child: Image(width: sampleImageWidthInPoint, height: sampleImageHeightInPoint, image: createAssetImage(),fit: BoxFit.cover,),
                  ),
                ),
              ),
            ),

            Container(
              color: Colors.black26,
              child: Transform(
                alignment: Alignment.center,
                transform: Matrix4.identity()..scale(1.0, 1.0)..translate(10.0, 10.0),
                child: Image(width: 100, height: 100, image: createAssetImage(),fit: BoxFit.cover,),
              ),
            ),
            Container(
              clipBehavior: Clip.antiAlias,
              decoration: new BoxDecoration(
                  border: new Border.all(color: Colors.transparent, width: 0)
              ),
              width: 200,
              height: 200,
              child: FittedBox(
                fit: BoxFit.cover,
                child: Container(
                  color: Colors.black26,
                  child: Transform(
                    alignment: Alignment.center,
                    transform: Matrix4.identity()..scale(0.1, 0.1)..translate(500.0, 500.0),
                    child: Image(width: sampleImageWidthInPoint, height: sampleImageHeightInPoint, image: createAssetImage(),fit: BoxFit.cover,),
                  ),
                ),
              ),
            ),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('Go back!'),
              ),
            ),
          ],
        ),
      )
    );
  }
}