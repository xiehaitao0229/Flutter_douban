import 'package:flutter/material.dart';
import 'package:douban/entity/book.dart';
import 'package:douban/http/HttpManagert.dart' as HttpManager;
import 'package:douban/utils/Utils.dart';
import 'package:douban/value.dart';

class BookPage extends StatefulWidget {
  double offset;
  bool isLoad = false;
  List<BookTitleList> bookTitleList;
  ScrollController controller;

  BookPage(this.offset);

  @override
  _BookPageState createState() {
    return _BookPageState();
  }
}

class _BookPageState extends State<BookPage> {
  bool isSuccess = true;

  //save the listView offset
  void _initController() {
    widget.controller = ScrollController(initialScrollOffset: widget.offset);
    widget.controller.addListener(() {
      widget.offset = widget.controller.offset;
    });
  }

  @override
  void initState() {
    super.initState();
    if (!widget.isLoad) {
      _loadData();
    }
  }

  //  请求数据
  _loadData() {
    HttpManager.get(
        url: Value.bookRootPath,
        onSend: () {
          setState(() {
            isSuccess = true;
          });
        },
        onSuccess: (String body) {
          List<BookTitleList> temp = BookTitleList.getFromHtml(body);
          print(temp);
          setState(() {
            List<BookTitleList> temp = BookTitleList.getFromHtml(body);
            widget.isLoad = true;
            widget.bookTitleList = temp;
          });
        },
        onError: (Object e) {
          setState(() {
            widget.bookTitleList = null;
            isSuccess = false;
          });
        });
  }

  //  显示loading
  _getLoading() {
    if (isSuccess) {
      return LoadingProgress();
    } else {
      return LoadingError(
        voidCallback: _loadData(),
      );
    }
  }

  _getBody() {
    _initController();
    List<Widget> bookList = [];
    widget.bookTitleList.forEach((list) {
      bookList.add(
        SliverPersistentHeader(
          delegate: BookTitle(
            title: list.title,
          ),
        ),
      );
      bookList.add(SliverGrid(
          delegate: SliverChildBuilderDelegate(
            (
              BuildContext context,
              index,
            ) {
              return BookItem(
                book: list.bookList[index],
              );
            },
            childCount: list.bookList.length,
          ),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 5.0,
            mainAxisSpacing: 5.0,
            childAspectRatio: 0.7,
          )));
    });

    return CustomScrollView(
      controller: widget.controller,
      slivers: bookList,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: widget.bookTitleList == null ? _getLoading() : _getBody(),
    );
  }
}

//  图书标题
class BookTitle extends SliverPersistentHeaderDelegate {
  final String title;
  final double height;
  BuildContext context;

  BookTitle({@required this.title, this.height});

  @override
  double get maxExtent => height ?? 60.0;

  @override
  double get minExtent => height ?? Theme.of(context).textTheme.title.fontSize;

  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) {
    // TODO: implement shouldRebuild
    return true;
  }

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    // TODO: implement build
    this.context = context;
    return Container(
        child: Center(
            child: Text(
      title ?? '标题',
      style: Theme.of(context).textTheme.title,
    )));
  }
}

//  图片item
class BookItem extends StatelessWidget {
  final Book book;

  BookItem({this.book}) : super(key: ObjectKey(book));

  //  评分组件
  _getRatings() {
    int starCount = (book.ratingsValue ~/ 2).toInt();
    var starWidget = new List<Widget>.generate(starCount, (index) {
      return new Icon(
        Icons.star,
        color: Colors.yellow,
        size: 15.0,
      );
    });
    var noStarWidget = new List<Widget>.generate(5 - starCount, (index) {
      return new Icon(
        Icons.star,
        color: Colors.grey,
        size: 15.0,
      );
    });
    starWidget.addAll(noStarWidget);
    starWidget.add(new Text(
      '${book.ratingsValue}',
      style: new TextStyle(color: Colors.white),
    ));
    return starWidget;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // _onclick(context);
      },
      child: Card(
        child: Stack(
          children: <Widget>[
            Image.network(book.imageAddress),
            DecoratedBox(
              decoration: BoxDecoration(
                  gradient: RadialGradient(
                center: const Alignment(0.0, -0.5),
                colors: <Color>[
                  const Color(0x00000000),
                  const Color(0x70000000),
                ],
                radius: 0.60,
                stops: <double>[0.3, 1.0],
              )),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Center(
                    child: Text(book.name,
                        style: Theme.of(context)
                            .textTheme
                            .title
                            .copyWith(color: Colors.white)),
                  ),
                  Center(
                    child: Text(
                      book.author,
                      style: Theme.of(context)
                          .textTheme
                          .subhead
                          .copyWith(color: Colors.white, fontSize: 12.0),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: _getRatings(),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
