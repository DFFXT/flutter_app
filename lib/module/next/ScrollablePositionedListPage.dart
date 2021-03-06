import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_widgets/flutter_widgets.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

const numberOfItems = 5001;
const minItemHeight = 20.0;
const maxItemHeight = 150.0;
const scrollDuration = Duration(seconds: 2);


class ScrollablePositionedListPage extends StatefulWidget {
  const ScrollablePositionedListPage({Key key}) : super(key: key);

  @override
  _ScrollablePositionedListPageState createState() =>
      _ScrollablePositionedListPageState();
}

class _ScrollablePositionedListPageState
    extends State<ScrollablePositionedListPage> {
  /// Controller to scroll or jump to a particular item.
  final ItemScrollController itemScrollController = ItemScrollController();

  /// Listener that reports the position of items when the list is scrolled.
  final ItemPositionsListener itemPositionsListener =
  ItemPositionsListener.create();
  List<double> itemHeights;
  List<Color> itemColors;
  bool reversed = false;

  /// The alignment to be used next time the user scrolls or jumps to an item.
  double alignment = 0;

  @override
  void initState() {
    super.initState();
    final heightGenerator = Random(328902348);
    final colorGenerator = Random(42490823);
    itemHeights = List<double>.generate(
        numberOfItems,
            (int _) =>
        heightGenerator.nextDouble() * (maxItemHeight - minItemHeight) +
            minItemHeight);
    itemColors = List<Color>.generate(
        numberOfItems,
            (int _) =>
            Color(colorGenerator.nextInt(pow(2, 32) - 1)).withOpacity(1));
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: OrientationBuilder(
        builder: (context, orientation) => Column(
          children: <Widget>[
            Expanded(
              child: SmartRefresher(

                controller: RefreshController(),
                header: ClassicHeader(
                  height: 45.0,
                  releaseText: '松开手刷新',
                  refreshingText: '刷新中',
                  completeText: '刷新完成',
                  failedText: '刷新失败',
                  idleText: '下拉刷新',
                ),
                footer: ClassicFooter(),
                enablePullUp: true,
                enablePullDown: true,
                child: list(orientation),
              ),
            ),
            positionsView,
            Row(
              children: <Widget>[
                Column(
                  children: <Widget>[
                    scrollControlButtons,
                    jumpControlButtons,
                    alignmentControl,
                  ],
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget get alignmentControl => Row(
    mainAxisSize: MainAxisSize.max,
    children: <Widget>[
      const Text('Alignment: '),
      SizedBox(
        width: 200,
        child: Slider(
          value: alignment,
          onChanged: (double value) => setState(() => alignment = value),
        ),
      ),
    ],
  );

  Widget list(Orientation orientation) =>
      ListView.builder(
        itemCount: numberOfItems,
        itemBuilder: (context, index) => item(index, orientation),
        controller: ScrollController(),
        //itemPositionsListener: itemPositionsListener,
        reverse: reversed,
        scrollDirection: orientation == Orientation.portrait
            ? Axis.vertical
            : Axis.horizontal,
      )
      ;

  Widget get positionsView => ValueListenableBuilder<Iterable<ItemPosition>>(
    valueListenable: itemPositionsListener.itemPositions,
    builder: (context, positions, child) {
      int min;
      int max;
      if (positions.isNotEmpty) {
        // Determine the first visible item by finding the item with the
        // smallest trailing edge that is greater than 0.  i.e. the first
        // item whose trailing edge in visible in the viewport.
        min = positions
            .where((ItemPosition position) => position.itemTrailingEdge > 0)
            .reduce((ItemPosition min, ItemPosition position) =>
        position.itemTrailingEdge < min.itemTrailingEdge
            ? position
            : min)
            .index;
        // Determine the last visible item by finding the item with the
        // greatest leading edge that is less than 1.  i.e. the last
        // item whose leading edge in visible in the viewport.
        max = positions
            .where((ItemPosition position) => position.itemLeadingEdge < 1)
            .reduce((ItemPosition max, ItemPosition position) =>
        position.itemLeadingEdge > max.itemLeadingEdge
            ? position
            : max)
            .index;
      }
      return Row(
        children: <Widget>[
          Expanded(child: Text('First Item: ${min ?? ''}')),
          Expanded(child: Text('Last Item: ${max ?? ''}')),
          const Text('Reversed: '),
          Checkbox(
              value: reversed,
              onChanged: (bool value) => setState(() {
                reversed = value;
              }))
        ],
      );
    },
  );

  Widget get scrollControlButtons => Row(
    children: <Widget>[
      const Text('scroll to'),
      scrollButton(0),
      scrollButton(5),
      scrollButton(10),
      scrollButton(100),
      scrollButton(1000),
      scrollButton(5000),
    ],
  );

  Widget get jumpControlButtons => Row(
    children: <Widget>[
      const Text('jump to'),
      jumpButton(0),
      jumpButton(5),
      jumpButton(10),
      jumpButton(100),
      jumpButton(1000),
      jumpButton(5000),
    ],
  );

  Widget scrollButton(int value) => GestureDetector(
    key: ValueKey<String>('Scroll$value'),
    onTap: () => scrollTo(value),
    child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Text('$value')),
  );

  Widget jumpButton(int value) => GestureDetector(
    key: ValueKey<String>('Jump$value'),
    onTap: () => jumpTo(value),
    child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Text('$value')),
  );

  void scrollTo(int index) => itemScrollController.scrollTo(
      index: index,
      duration: scrollDuration,
      curve: Curves.easeInOutCubic,
      alignment: alignment);

  void jumpTo(int index) =>
      itemScrollController.jumpTo(index: index, alignment: alignment);

  /// Generate item number [i].
  Widget item(int i, Orientation orientation) {
    return SizedBox(
      height: orientation == Orientation.portrait ? itemHeights[i] : null,
      width: orientation == Orientation.landscape ? itemHeights[i] : null,
      child: Container(
        color: itemColors[i],
        child: Center(
          child: Text('Item $i'),
        ),
      ),
    );
  }
}