import 'package:flutter/material.dart';
import 'package:news/data/URL.dart';
import 'package:news/data/category/Category.dart';
import 'package:transparent_image/transparent_image.dart';

typedef CategoryCallback = void Function(Category category);

class CategoryItemWidget extends StatelessWidget {
  final Category category;
  final Color color;
  final CategoryCallback callback;

  const CategoryItemWidget(
    this.category,
    this.color,
    this.callback, {
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      child: InkWell(
        onTap: () {
          callback(category);
        },
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(
                top: 8.0,
                left: 8.0,
                right: 8.0,
              ),
              child: FadeInImage.memoryNetwork(
                placeholder: kTransparentImage,
                image: URL.imageUrl(category.imageUrl),
                fit: BoxFit.contain,
                height: 120,
                width: 120,
              ),
            ),
            Padding(
              padding: EdgeInsets.all(4.0),
              child: Text(
                category.name,
                style: buildHeadline(context),
              ),
            )
          ],
        ),
      ),
    );
  }

  TextStyle buildHeadline(BuildContext context) {
    return TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.bold,
      color: Colors.black87,
    );
  }
}
