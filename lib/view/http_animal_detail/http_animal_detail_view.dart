import 'package:flutter/material.dart';

class HttpDetailView extends StatelessWidget {
  final String tag;
  final String imageUrl;

  const HttpDetailView({Key key, this.tag, this.imageUrl}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Hero(
          tag: tag,
          child: Image.network(imageUrl),
        ),
      ),
    );
  }
}
