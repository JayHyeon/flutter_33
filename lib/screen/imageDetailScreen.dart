import 'package:flutter/material.dart';
import 'package:flutter_33/models/searchDataModel.dart';

class ImageDetailScreen extends StatefulWidget {
  const ImageDetailScreen(SearchData this.data, {Key? key}) : super(key: key);
  final data;

  @override
  ImageDetailScreenState createState() => ImageDetailScreenState();
}

class ImageDetailScreenState extends State<ImageDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.data.displaySitename)),
      body: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Image.network(widget.data.imageUrl, fit: BoxFit.contain)),
    );
  }
}
