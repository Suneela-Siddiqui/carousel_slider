import 'package:flutter/cupertino.dart';

class ImagePlaceHolder extends StatelessWidget {
  final String? path;
  final double? imageHeight;
  final double? imageWidth;

  const ImagePlaceHolder(String s, double height, double width, 
    {
      Key? key,
      this.imageHeight,
      this.path,
      this.imageWidth
    }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Image.asset(path!, height: imageHeight, width:imageWidth, fit: BoxFit.fill);
  }
}
