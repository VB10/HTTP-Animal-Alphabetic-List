import 'package:alphabeticlist/core/base/base_model.dart';
import 'package:alphabeticlist/core/base/base_state.dart';
import 'package:alphabeticlist/core/components/space/empty_widget.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class AlphabeticListView<T extends BaseModel> extends StatefulWidget {
  final int itemCount;
  final List<String> headers;
  final ScrollPhysics physics;
  final List<T> list;
  final String listKey;
  final Widget Function(Map data, int index) item;
  final EdgeInsets padding;
  final bool shrinWrap;
  final Widget child;

  AlphabeticListView(
      {Key key,
      @required this.headers,
      @required this.itemCount,
      this.physics,
      this.padding,
      this.shrinWrap,
      @required this.list,
      @required this.listKey,
      this.item,
      this.child})
      : super(key: key);

  @override
  _AlphabeticListViewState createState() => _AlphabeticListViewState();
}

class _AlphabeticListViewState extends BaseState<AlphabeticListView> {
  List<String> _headList = [];
  List<Map<String, dynamic>> _mapList = [];
  List<Map<String, dynamic>> _mapListSerach = [];
  int selectedValue = 0;

  final Map<int, String> firstValueMap = {0: "-"};

  @override
  void initState() {
    super.initState();
    headListCreate(widget.headers);
    _mapList = widget.list.map((e) => e.toJson()).toList();
    _mapListSerach = widget.list.map((e) => e.toJson()).toList();
  }

  @override
  void didUpdateWidget(oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.listKey != widget.listKey) {
      headListCreate(widget.headers);
      setState(() {});
    }
  }

  void headListCreate(List<String> headers) {
    _headList = _headersCharacter(headers);
    _headList.insert(firstValueMap.keys.first, firstValueMap.values.first);
  }

  List<String> _headersCharacter(List<String> headers) {
    final firstCharacterArray =
        headers.map((e) => e.trim()[0]).toSet().toList();
    firstCharacterArray.sort();
    return firstCharacterArray;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [buildExpandedListView(), buildExpandedRightBody()],
    );
  }

  Expanded buildExpandedRightBody() {
    return Expanded(
      child: Column(
        children: <Widget>[Spacer(), buildExpandedRight(), Spacer()],
      ),
    );
  }

  Expanded buildExpandedRight() {
    return Expanded(
      flex: 2,
      child: PageView.builder(
        physics: PageScrollPhysics(),
        onPageChanged: (value) {
          listMapParse(value);
        },
        controller: PageController(viewportFraction: 0.1),
        scrollDirection: Axis.vertical,
        itemCount: _headList.length,
        itemBuilder: (context, index) {
          if (index == 0) {
            return buildIconButtonAll(index);
          } else {
            return Center(child: buildText(index));
          }
        },
      ),
    );
  }

  Expanded buildExpandedListView() {
    return Expanded(flex: 9, child: buildListView());
  }

  ListView buildListView() {
    return ListView(
      shrinkWrap: widget.shrinWrap ?? false,
      padding: widget.padding ?? EdgeInsets.zero,
      physics: widget.physics ?? NeverScrollableScrollPhysics(),
      children: [
        _customChild,
        ...List.generate(_mapListSerach.length,
            (index) => widget.item(_mapListSerach[index], index))
        // ..._mapListSerach.map((e) => widget.item(e)).toList()
      ],
    );
  }

  Widget get _customChild =>
      widget.child ??
      EmptyWidget.height(
        value: 0.01,
      );

  IconButton buildIconButtonAll(int index) {
    return IconButton(
        icon: Icon(
          Icons.search,
          color: selectedValue == index ? currentTheme.accentColor : null,
          size: selectedValue == index
              ? dynamicHeight(0.025)
              : dynamicHeight(0.015),
        ),
        onPressed: () => listMapParse(index));
  }

  Widget buildText(int index) => Container(
          child: InkWell(
        onTap: () {
          listMapParse(index);
        },
        child: AutoSizeText(
          _headList[index],
          style: selectedValue == index ? boldStyle : normalStyle,
        ),
      ));

  TextStyle get boldStyle => currentTheme.textTheme.headline1
      .copyWith(color: currentTheme.accentColor);

  TextStyle get normalStyle => currentTheme.textTheme.headline6;

  void listMapParse(int index) {
    if (index == 0) {
      _mapListSerach = _mapList;
    } else {
      _mapListSerach = _mapList.where((element) {
        if (element is Map) {
          return element.keys.where((subElement) {
            final _valueFirst = element[subElement].toString();
            return subElement == widget.listKey &&
                _valueFirst[0] == _headList[index];
          }).isNotEmpty;
        }
        return false;
      }).toList();
    }

    setState(() {
      selectedValue = index;
    });
  }
}
