import 'package:flutter/material.dart';
import 'package:douban/entity/movie.dart';
import 'package:douban/http/HttpManagert.dart' as HttpManager;
import 'dart:convert';
import 'package:douban/entity/movie_info.dart';
import 'package:douban/utils/Utils.dart';
import 'package:douban/value.dart';

class MovieInfoPage extends StatefulWidget {
  final Movie movie;

  //  构造函数
  MovieInfoPage({this.movie});

  @override
  _MovieInfoPageState createState() => _MovieInfoPageState();
}

class _MovieInfoPageState extends State<MovieInfoPage> {
  MovieInfo info;
  bool isSuccess = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  //  加载数据
  _loadData() async {
    String url = '${Value.moviePath}${widget.movie.id}';
    // print(url);
    HttpManager.get(
        url: url,
        onSend: () {
          setState(() {
            isSuccess = true;
          });
        },
        onSuccess: (String body) {
          setState(() {
            info = MovieInfo.forJson(json.decode(body));
          });
        },
        onError: (Object e) {
          setState(() {
            info = null;
            isSuccess = false;
          });
        });
  }

  //  格式化制作国家字段
  String _formatString(List<String> strings) {
    String sb = '';
    for (String item in strings) {
      sb = sb + '$item,';
    }
    return sb.length > 1 ? sb.substring(0, sb.length - 1) : sb;
  }

  _getLoading() {
    if (isSuccess) {
      return LoadingProgress();
    } else {
      return LoadingError(
        voidCallback: _loadData(),
      );
    }
  }

  //  获取顶部action,两个按钮
  _getAction() {
    return info == null
        ? null
        : <Widget>[
            WebIconButton(url: info.mobileUrl),
            ShareIconButton(
              title: info.title,
              url: info.mobileUrl,
              summary: info.summary,
            )
          ];
  }

  //  导演组件
  _getDirectors() {
    return List<Widget>.generate(info.directors.length, (index) {
      DirectorsBean directorsBean = info.directors[index];
      return Expanded(
        child: Column(
          children: <Widget>[
            Image.network(
              directorsBean.avatars == null ? "" : directorsBean.avatars.medium,
              width: 100.0,
              height: 100.0,
            ),
            Text(
              directorsBean.name,
              maxLines: 1,
            ),
          ],
        ),
      );
    });
  }

  //  演员组件
  _getCastList() {
    return List<Widget>.generate(info.casts.length, (index) {
      CastsBean castsBean = info.casts[index];
      return Expanded(
        child: Column(
          children: <Widget>[
            Image.network(
              castsBean.avatars == null ? "" : castsBean.avatars.medium,
              width: 100.0,
              height: 100.0,
            ),
            Text(
              castsBean.name,
              maxLines: 1,
            ),
          ],
        ),
      );
    });
  }

  _getBody() {
    //  获取主页面
    return ListView(
      children: <Widget>[
        Container(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: <Widget>[
              Image.network(info.images.medium, width: 150.0, height: 200.0),
              Expanded(
                child: Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        '原名:${info.originalTitle}',
                        style: Theme.of(context).textTheme.title,
                      ),
                      Text('年代:${info.year}'),
                      Text('影评数:${info.reviewsCount}'),
                      Text('评分人数:${info.ratingsCount}'),
                      Text('类型:${_formatString(info.genres)}'),
                      Text('制片国家/地区:${_formatString(info.countries)}'),
                      Text(
                        '${info.wishCount}人想看',
                        style: Theme.of(context)
                            .textTheme
                            .body1
                            .copyWith(color: Colors.red),
                      ),
                      Text(
                        '${info.collectCount}人看过',
                        style: Theme.of(context)
                            .textTheme
                            .body1
                            .copyWith(color: Colors.red),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
        Align(
          alignment: Alignment.topLeft,
          child: Container(
            padding: const EdgeInsets.all(4.0),
            child: Text(
              '导演',
              style: Theme.of(context)
                  .textTheme
                  .title
                  .copyWith(color: Colors.blue),
            ),
          ),
        ),
        Row(
          children: _getDirectors(),
        ),
        Align(
          alignment: Alignment.topLeft,
          child: Container(
              padding: const EdgeInsets.all(4.0),
              child: Text(
                '主演:',
                style: Theme.of(context)
                    .textTheme
                    .title
                    .copyWith(color: Colors.blue),
              )),
        ),
        Row(
          children: _getCastList(),
        ),
        Align(
          alignment: Alignment.topLeft,
          child: Container(
              padding: const EdgeInsets.all(4.0),
              child: Text(
                '介绍:',
                style: Theme.of(context)
                    .textTheme
                    .title
                    .copyWith(color: Colors.blue),
              )),
        ),
        Container(
            padding: const EdgeInsets.all(4.0), child: Text(info.summary)),
        Divider(
          height: 1.0,
          color: Colors.red,
        ),
        Align(
          alignment: Alignment.topLeft,
          child: Container(
              padding: const EdgeInsets.all(4.0),
              child: Text(
                '影评:(豆瓣api无权限,所以没有)',
                style: Theme.of(context)
                    .textTheme
                    .title
                    .copyWith(color: Colors.blue),
              )),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.movie.title),
          actions: _getAction(),
        ),
        body: info == null ? _getLoading() : _getBody());
  }
}
