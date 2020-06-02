import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_youtube/flutter_youtube.dart';
import 'package:news/data/URL.dart';
import 'package:news/data/news/News.dart';
import 'package:news/data/news/NewsRepository.dart';

class NewsDetailsPage extends StatefulWidget {
  final News news;

  NewsDetailsPage(this.news);

  @override
  _NewsDetailsPageState createState() => _NewsDetailsPageState(news);
}

class _NewsDetailsPageState extends State<NewsDetailsPage> {
  NewsRepository _repository = NewsRepository.create();
  String _title;
  String _body;
  String _imgUrl;
  final FlutterYoutube youtube = FlutterYoutube();
  News _news;
  bool _isFavourite = false;

  _NewsDetailsPageState(News news) {
    _news = news;
    _title = news.title;
    _body = news.body;
    _imgUrl = URL.imageUrl(news.image);
  }

  @override
  void initState() {
    _repository.isFavouriteNews(_news.id).then((value) {
      setState(() {
        _isFavourite = value;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              expandedHeight: 200.0,
              floating: false,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                title: Padding(
                  padding: EdgeInsets.only(
                    top: 16.0,
                    left: 48.0,
                    right: 16.0,
                    bottom: 0.0,
                  ),
                  child: SizedBox.fromSize(
                    size: Size(
                      MediaQuery.of(context).size.width * 0.7,
                      20.0,
                    ),
                    child: Text(
                      _title,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.0,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.clip,
                    ),
                  ),
                ),
                background: Image.network(
                  _imgUrl,
                  fit: BoxFit.cover,
                ),
                // background: Image(image: CachedNetworkImageProvider(_imgUrl)),
              ),
            ),
          ];
        },
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(8.0),
            child: Html(
              data: _body,
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (!_isFavourite) {
            _repository.saveFavNews(_news);
            setState(() {
              _isFavourite = true;
            });
          } else {
            _repository.removeFavNews(_news);
            setState(() {
              _isFavourite = false;
            });
          }
        },
        elevation: 4.0,
        tooltip: 'Make Favourite',
        child: _isFavourite ? Icon(Icons.cancel) : Icon(Icons.favorite),
      ),
    );
  }
}
