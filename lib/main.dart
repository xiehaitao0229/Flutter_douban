import 'package:flutter/material.dart';
import 'package:douban/entity/movie.dart';
import 'package:douban/page/bookPage.dart';
import 'package:douban/page/moviePage.dart';
import 'package:douban/page/musicPage.dart';
import 'package:douban/idea/donate.dart';
import 'value.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: Value.appName,
      theme: ThemeData(
        primarySwatch: Colors.yellow,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  // This widget is home page
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int index = 0; //  默认为首页

  //  切换tabBottom
  _selectPosition(int index) {
    if (this.index == index) return;
    setState(() {
      this.index = index;
    });
  }

  final List<MovieTab> movieTabs = <MovieTab>[
    MovieTab(Icons.whatshot, Value.justHot, Value.justHotPath),
    MovieTab(Icons.compare, Value.willUp, Value.willUpPath),
    MovieTab(Icons.vertical_align_top, Value.top250, Value.top250Path),
  ];

  var moviePage; //  电影页

  var bookPage; //  图书页

  var musicPage; //  音乐页

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: movieTabs.length,
      child: Scaffold(
        appBar: AppBar(
          title: _getTitle(),
          bottom: index == 0 ? _movieTab() : null,
        ),
        body: _getBody(),
        drawer: Drawer(
          elevation: 8.0,
          semanticLabel: Value.drawerLabel,
          child: DrawerLayout(),
        ),
        bottomNavigationBar: _getBottomNavigationBar(),
      ),
    );
  }

  //  底部文案
  _getTitle() {
    switch (index) {
      case 0:
        return _forMatchTitle(Value.movie);
      case 1:
        return _forMatchTitle(Value.book);
      case 2:
        return _forMatchTitle(Value.music);
    }
  }

  _forMatchTitle(String data) {
    return Text(data);
  }

  //  电影页滑动切换
  _movieTab() {
    return TabBar(
        isScrollable: false,
        tabs: movieTabs.map((MovieTab tab) {
          return Tab(
            text: tab.title,
            icon: Icon(tab.iconData),
          );
        }).toList());
  }

  //  显示主体内容
  _getBody() {
    switch (index) {
      case 0:
        if (moviePage == null) {
          moviePage = TabBarView(
              children: movieTabs.map((MovieTab tab) {
            if (tab.page == null) {
              tab.offset = 0.0;
              tab.page = MoviePage( tab.address, tab.offset );
            }
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: tab.page,
            );
          }).toList());
        }
        return moviePage;
      case 1:
        if (bookPage == null) {
          double offset = 0.0;
          bookPage = BookPage(offset);
        }
        return bookPage;
      case 2:
        if (musicPage == null) {
          double offset = 0.0; //save the offset from scrollView
          musicPage = MusicPage(/* offset */);
        }
        return musicPage;
    }
  }

  _getBottomNavigationBar() {
    return BottomNavigationBar(
        onTap: _selectPosition,
        currentIndex: index,
        type: BottomNavigationBarType.fixed,
        iconSize: 24.0,
        items: List<BottomNavigationBarItem>.generate(3, (index) {
          switch (index) {
            case 0:
              return BottomNavigationBarItem(
                  icon: this.index == 0
                      ? Icon(Icons.movie_filter)
                      : Icon(Icons.movie),
                  title: Text(Value.movie));
            case 1:
              return BottomNavigationBarItem(
                  icon:
                      this.index == 1 ? Icon(Icons.book) : Icon(Icons.bookmark),
                  title: Text(Value.book));
            case 2:
              return BottomNavigationBarItem(
                  icon: this.index == 2
                      ? Icon(Icons.music_video)
                      : Icon(Icons.music_note),
                  title: Text(Value.music));
          }
        }));
  }
}

//  左上角的按钮弹窗
class DrawerLayout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        _getHeader(context),
        _getDonateItem(),
        _getAboutItem(),
      ],
    );
  }

  _getHeader(BuildContext context) {
    return DrawerHeader();
  }

  _getDonateItem() {
    return DonateListTile(
        icon: Icon(Icons.supervisor_account),
        child: Text(Value.support),
        authorDes: Value.supportTip,
        title: Value.supportTitle);
  }

  _getAboutItem() {
    return AboutListTile(
      icon: Icon(Icons.person),
      child: Text(Value.about),
      applicationName: Value.appName,
      applicationVersion: 'version:${Value.appVersion}',
    );
  }
}
