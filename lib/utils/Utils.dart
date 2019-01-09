import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:douban/value.dart';
import 'package:share/share.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

const utils_platform = const MethodChannel('samples.flutter.io/utils');

_showDialog({@required BuildContext context, String content}) {
  assert(context != null);
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(Value.tip),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text(content),
            ],
          ),
        ),
        actions: <Widget>[
          FlatButton(
            child: Text(Value.sure),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

//捐献按钮
class DonateFlatButton extends StatelessWidget {
  DonateFlatButton({@required this.ercode, this.text});

  final String ercode;
  final String text;

  _donateAndroid(BuildContext context) async {
    bool isSuccess =
        await utils_platform.invokeMethod(Value.ZhiFuMethodValue, [ercode]);
    if (!isSuccess) {
      _showDialog(context: context, content: Value.noSupportZhiFu);
    }
  }

  @override
  Widget build(BuildContext context) {
    return FlatButton(
        onPressed: () {
          _donateAndroid(context);
        },
        child: Text(text));
  }
}

//  分享按钮
class ShareIconButton extends StatelessWidget {
  final String title;
  final String url;
  final String summary;

  ShareIconButton({this.title, this.url, this.summary});

  @override
  Widget build(BuildContext context) {
    return IconButton(
        icon: Icon(Icons.share),
        onPressed: () => Share.share(
            "$title\n介绍:\n$summary\n详情请看:\n$url\n来自flutter_douban应用"));
  }
}

//  加载网页按钮
class WebIconButton extends StatelessWidget {
  final String url;
  final String errorTip;

  WebIconButton({@required this.url, this.errorTip});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return IconButton(
        icon: Icon(Icons.web),
        onPressed: () {
          openByWeb(context, url, errorTip, true);
        });
  }
}

openByWeb(BuildContext context, String url, String errorTip,
    bool forceWebView) async {
  if (await canLaunch(url)) {
    await launch(url, forceWebView: forceWebView);
  } else {
    _showDialog(
        context: context, content: errorTip ?? Value.loadingWebErrorTip);
  }
}

//加载网页按钮
class WebButton extends StatelessWidget {
  WebButton({@required this.text, @required this.url, this.errorTip});

  final String text;
  final String url;
  final String errorTip;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return RaisedButton(
      child: Text(text),
      onPressed: () {
        openByWeb(context, url, errorTip, false);
      },
    );
  }
}

class WebText extends StatelessWidget {
  WebText({@required this.text, @required this.url, this.errorTip});

  final String text;
  final String url;
  final String errorTip;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return GestureDetector(
      child: Text(
        text,
        style: Theme.of(context).textTheme.title.copyWith(color: Colors.blue),
      ),
      onTap: () {
        openByWeb(context, url, errorTip, true);
      },
    );
  }
}

//  显示加载转圈组件
class LoadingProgress extends StatelessWidget {
  getProgressDialog() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return getProgressDialog();
  }
}

//  显示加载失败组件
class LoadingError extends StatelessWidget {
  final VoidCallback voidCallback;

  //  构造函数
  LoadingError({@required this.voidCallback});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: RaisedButton(
        textColor: Colors.yellow,
        child: Text(Value.loadingErrorTip),
        onPressed: voidCallback,
      ),
    );
  }
}
