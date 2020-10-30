import 'package:flutter/material.dart';

class SampleImage1 extends StatelessWidget {

  AssetImage createAssetImage() {
    final assetImage = AssetImage("resource/kate-hliznitsova-lU_UuQ-6OVI-unsplash.jpg");
    return assetImage;
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text("Second Route"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              color: Colors.black26,
              child: Transform(
                alignment: Alignment.center,
                transform: Matrix4.identity(),
                child: Image(width: 100, height: 100, image: createAssetImage(),fit: BoxFit.cover,),
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
              color: Colors.black26,
              child: Transform(
                alignment: Alignment.center,
                transform: Matrix4.identity()..scale(2.0, 2.0),
                child: Image(width: 100, height: 100, image: createAssetImage(),fit: BoxFit.cover,),
              ),
            ),
            Container(
              color: Colors.black26,
              child: Transform(
                alignment: Alignment.center,
                transform: Matrix4.identity()..scale(2.0, 2.0)..translate(10.0, 10.0),
                child: Image(width: 100, height: 100, image: createAssetImage(),fit: BoxFit.cover,),
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