import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class Edit extends StatefulWidget {
  final String label;
  final bool Function(String data) onChanged;
  final Function() onTap;
  final String errorText;
  final TextInputType keyboardType;
  final bool readOnly;
  final TextEditingController controller;
  String text;

  Edit({
    Key key,
    this.label,
    this.onChanged,
    this.errorText,
    this.keyboardType,
    this.readOnly,
    this.controller,
    this.onTap,
    String text,
  }) : super(key: key) {
    this.text = text;
  }

  @override
  State<StatefulWidget> createState() {
    return EditState();
  }
}

class EditState extends State<Edit> {
  String text = '';

  @override
  Widget build(BuildContext context) {
    return (defaultTargetPlatform == TargetPlatform.android)
        ? TextField(
            decoration: InputDecoration(
              errorText: widget.errorText,
              border: OutlineInputBorder(),
              labelText: widget.label,
            ),
            controller: widget.controller,
            readOnly: widget.readOnly ?? false,
            keyboardType: TextInputType.number,
            onChanged: (text) => widget.onChanged(text),
          )
        : Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                text.isEmpty ? '' : widget.label,
              ),
              CupertinoTextField(
                placeholder: widget.label,
                keyboardType: widget.keyboardType,
                onChanged: (text) {
                  this.text = text;
                  return widget.onChanged(text);
                },
                readOnly: widget.readOnly ?? false,
                onTap: widget.onTap,
                controller: widget.controller,
              ),
              Text(
                widget.errorText ?? '',
                style: TextStyle(color: Colors.red),
              ),
            ],
          );
  }
}

/**
 *
 * */

Widget TitleBar(BuildContext context, {String title, List<SanAction> rigth}) {
  if (isAndroid()) {
    return AppBar(
      title: Text(title),
      actions: rigth != null && rigth.first != null
          ? rigth.map((item) {
              return InkWell(
                onTap: () {
                  try {
                    item.onTap.call();
                  } catch (e) {}
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: buildBellow(item, context),
                  ),
                ),
              );
            }).toList()
          : [Empty()],
    );
  } else {
    return CupertinoNavigationBar(
      actionsForegroundColor: Theme.of(context).primaryColor,
      middle: Text(title),
      trailing: rigth != null
          ? Row(
              mainAxisSize: MainAxisSize.min,
              children: rigth
                  .map((item) => item == null
                      ? Empty()
                      : InkWell(
                          onTap: () {
                            try {
                              item.onTap.call();
                            } catch (e) {}
                          },
                          child: rigth.last == item
                              ? Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    item.text != null
                                        ? Text(
                                            item.text,
                                            style: TextStyle(
                                                color: Theme.of(context)
                                                    .primaryColor),
                                          )
                                        : Icon(item.icon) ?? Empty(),
                                  ],
                                )
                              : Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Padding(
                                          padding:
                                              const EdgeInsets.only(right: 8),
                                          child: item.icon != null
                                              ? Icon(item.icon)
                                              : Text(
                                                  item.text,
                                                  style: TextStyle(
                                                      color: Theme.of(context)
                                                          .primaryColor),
                                                ),
                                        ) ??
                                        Empty(),
                                  ],
                                ),
                        ))
                  .toList())
          : null,
    );
  }
}

/**
 *
 * */

Widget CollapsingTitleBar(BuildContext context,
    {String title, List<SanAction> rigth}) {
  if (isAndroid()) {
    return SliverAppBar(
      expandedHeight: 120,
      floating: false,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: false,
        title: Text(
          title,
        ),
        background: Container(
          color: Theme.of(context).primaryColor,
        ),
      ),
      actions: rigth != null && rigth.first != null
          ? rigth.map((item) {
              return InkWell(
                onTap: () {
                  try {
                    item.onTap.call();
                  } catch (e) {}
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: buildBellow(item, context),
                  ),
                ),
              );
            }).toList()
          : [Empty()],
    );
  } else {
    return CupertinoSliverNavigationBar(
      largeTitle: Text(title),
      actionsForegroundColor: Theme.of(context).primaryColor,
      trailing: rigth != null
          ? Row(
              mainAxisSize: MainAxisSize.min,
              children: rigth
                  .map((item) => item == null
                      ? Empty()
                      : InkWell(
                          onTap: () {
                            try {
                              item.onTap.call();
                            } catch (e) {}
                          },
                          child: rigth.last == item
                              ? Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    item.text != null
                                        ? Text(
                                            item.text,
                                            style: TextStyle(
                                                color: Theme.of(context)
                                                    .primaryColor),
                                          )
                                        : Icon(item.icon) ?? Empty(),
                                  ],
                                )
                              : Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Padding(
                                          padding:
                                              const EdgeInsets.only(right: 8),
                                          child: item.icon != null
                                              ? Icon(item.icon)
                                              : Text(
                                                  item.text,
                                                  style: TextStyle(
                                                      color: Theme.of(context)
                                                          .primaryColor),
                                                ),
                                        ) ??
                                        Empty(),
                                  ],
                                ),
                        ))
                  .toList())
          : null,
    );
  }
}

List<Widget> buildBellow(SanAction item, BuildContext context) {
  List<Widget> list = List<Widget>();
  item.icon != null
      ? list.add(Icon(item.icon))
      : list.add(Text(
          item.text,
          style: TextStyle(
              color: Theme.of(context).primaryTextTheme.headline6.color),
        ));
  return list;
}

class Empty extends SizedBox {
  Empty() : super(height: 0, width: 0);
}

bool isAndroid() {
  return (defaultTargetPlatform == TargetPlatform.android);
}

class CollapsingPagefold extends Pagefold {
  CollapsingPagefold(
    BuildContext context, {
    String title,
    SanAction defaultAction,
    List<SanAction> rigth,
    Widget center,
  }) : super(
          context,
          title: title,
          defaultAction: defaultAction,
          rigth: rigth,
          center: center,
          collapsing: true,
        );
}

class Pagefold extends Scaffold {
  final String title;
  final SanAction defaultAction;
  final List<SanAction> rigth;
  final Widget center;
  final bool collapsing;

  Pagefold(
    BuildContext context, {
    this.title,
    this.defaultAction,
    this.rigth,
    this.center,
    this.collapsing = false,
  }) : super(
          appBar: collapsing
              ? null
              : TitleBar(
                  context,
                  title: title ?? '',
                  rigth: isAndroid()
                      ? rigth
                      : (defaultAction == null
                          ? rigth
                          : (rigth ?? []) + [defaultAction]),
                ),
          floatingActionButton: isAndroid()
              ? (defaultAction.icon == null
                  ? FloatingActionButton(
                      onPressed: defaultAction.onTap,
                      child: Text(defaultAction.text),
                    )
                  : FloatingActionButton.extended(
                      onPressed: defaultAction.onTap,
                      label: Text(defaultAction.text),
                      icon: Icon(defaultAction.icon),
                    ))
              : null,
          body: collapsing
              ? CustomScrollView(
                  slivers: <Widget>[
                    CollapsingTitleBar(context,
                        title: title ?? '',
                        rigth: isAndroid()
                            ? rigth
                            : (defaultAction == null
                                ? rigth
                                : (rigth ?? []) + [defaultAction])),
                    SliverFillRemaining(child: center),
                  ],
                )
              : NestedScrollView(
                  headerSliverBuilder:
                      (BuildContext context, bool innerBoxIsScrolled) {
                    return !collapsing
                        ? []
                        : <Widget>[
                            CollapsingTitleBar(context,
                                title: title ?? '',
                                rigth: isAndroid()
                                    ? rigth
                                    : (defaultAction == null
                                        ? rigth
                                        : (rigth ?? []) + [defaultAction])),
                          ];
                  },
                  body: center,
                ),
        );

  @override
  _PagefoldState createState() => _PagefoldState();
}

class _PagefoldState extends ScaffoldState {
  @override
  Widget build(BuildContext context) => super.build(context);
}

class SanAction {
  final String text;
  final IconData icon;
  final Function() onTap;

  SanAction(this.icon, {this.text, this.onTap});
}

class CmdButton extends StatefulWidget {
  final String text;
  final Function() onTap;
  final Color accentColor;
  final Color backColor;
  final IconData icon;

  const CmdButton(
      {Key key,
      this.text,
      this.onTap,
      this.accentColor,
      this.backColor,
      this.icon})
      : super(key: key);

  @override
  _CmdButtonState createState() => _CmdButtonState();
}

class _CmdButtonState extends State<CmdButton> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: InkWell(
        child: Container(
          color: widget.backColor,
          child: Row(
            children: [
              SizedBox(
                width: 5,
              ),
              Icon(
                widget.icon,
                color: widget.accentColor,
              ),
              Padding(
                padding: const EdgeInsets.all(15),
                child: Text(
                  widget.text ?? '',
                  textAlign: TextAlign.left,
                  style: TextStyle(color: widget.accentColor, fontSize: 17),
                ),
              ),
            ],
          ),
        ),
        onTap: widget.onTap,
      ),
    );
  }
}
