import 'dart:async';
import 'package:flutter/material.dart';

Future<Widget> getImage() async {
  final Completer<Widget> completer = Completer();

  final url = 'https://picsum.photos/200/300';
  final image = NetworkImage(url);
  final config = await image.obtainKey(const ImageConfiguration());
  final load = image.load(config);

  final listener = new ImageStreamListener((ImageInfo info, isSync) async {
    print(info.image.width);
    print(info.image.height);

    if (info.image.width == 80 && info.image.height == 160) {
      completer.complete(Container(child: Text('AZAZA')));
    } else {
      completer.complete(Container(child: Image(image: image)));
    }
  });

  load.addListener(listener);
  return completer.future;
}
