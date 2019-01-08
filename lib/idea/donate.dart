import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart' hide Flow;
import 'package:douban/utils/Utils.dart';
import 'package:douban/value.dart';

//  首页左上角的选框
class DonateListTile extends StatelessWidget{
  final Widget icon;
  final Widget child;
  final String authorDes;
  final String title;

  //  构造函数
  const DonateListTile({
    Key key,
    this.icon:const Icon(null),
    this.child,
    this.authorDes,
    this.title,
  }):super(key:key);


  @override
  Widget build(BuildContext context){
 //   assert(debugCheckHasMaterial(context));
    return new ListTile(
      leading:icon,
      title:child,
      onTap:(){  //  点击弹出框显示
        showDonateDialog(
          context:context,
          authorDes:authorDes,
          title:title
        );
      }
    );
  }
}

void showDonateDialog({
   @required BuildContext context,
   String authorDes,
  String title,
}){
  assert(context != null);
  showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return new DonateDialog(
          authorDes: authorDes,
          title: title,
        );
      });
}

class DonateDialog extends StatelessWidget{
  final String authorDes;
  final String title;

  //  构造函数
  const DonateDialog({
    Key key,
    this.authorDes,
    this.title
  });

  @override
  Widget build(BuildContext context){
   List<Widget> body = <Widget>[];
    body.add(new Expanded(
        child: new Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: new ListBody(children: <Widget>[
              new Text(title ?? '',style: Theme.of(context).textTheme.title),
              new Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: new Text(authorDes ?? '',
                    style: Theme.of(context).textTheme.caption),
              )
            ]))));
    body = <Widget>[
      new Row(crossAxisAlignment: CrossAxisAlignment.start, children: body),
    ];
    return new AlertDialog(
        content: new SingleChildScrollView(
          child: new ListBody(children: body),
        ),
        actions: <Widget>[
          new DonateFlatButton(ercode: Value.supportErCode,text: Value.supportTipCommit,),],);

  }
}






