import 'package:chart/SfChart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_examples/model/model.dart';
import 'package:flutter_examples/widgets/flutter_backdrop.dart';
import 'package:scoped_model/scoped_model.dart';

class StepLineDefault extends StatefulWidget {
  final SubItemList sample;
  const StepLineDefault(this.sample, {Key key}) : super(key: key);

  @override
  _StepLineDefaultState createState() => _StepLineDefaultState(sample);
}

class _StepLineDefaultState extends State<StepLineDefault> {
  final SubItemList sample;

  _StepLineDefaultState(this.sample);

  bool panelOpen;
  final frontPanelVisible = ValueNotifier<bool>(true);

  @override
  void initState() {
    panelOpen = frontPanelVisible.value;
    frontPanelVisible.addListener(_subscribeToValueNotifier);
    super.initState();
  }

  void _subscribeToValueNotifier() => panelOpen = frontPanelVisible.value;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void didUpdateWidget(StepLineDefault oldWidget) {
    super.didUpdateWidget(oldWidget);
    frontPanelVisible.removeListener(_subscribeToValueNotifier);
    frontPanelVisible.addListener(_subscribeToValueNotifier);
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<SampleListModel>(
        builder: (context, _, model) => SafeArea(
              child: Backdrop(
                needCloseButton: false,
                panelVisible: frontPanelVisible,
                sampleListModel: model,
                frontPanelOpenPercentage: 0.28,
                toggleFrontLayer: false,
                appBarAnimatedLeadingMenuIcon: AnimatedIcons.close_menu,
                appBarActions: <Widget>[
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                    child: Container(
                      height: 40,
                      width: 40,
                      child: IconButton(
                        icon: Image.asset(model.codeViewerIcon,
                            color: Colors.white),
                        onPressed: () {},
                      ),
                    ),
                  ),
                  
                ],
                appBarTitle: AnimatedSwitcher(
                    duration: Duration(milliseconds: 1000),
                    child: Text(sample.title.toString())),
                backLayer: BackPanel(sample),
                frontLayer: FrontPanel(sample),
                sideDrawer: null,
                headerClosingHeight: 350,
                titleVisibleOnPanelClosed: true,
                borderRadius: BorderRadius.vertical(
                    top: Radius.circular(12), bottom: Radius.circular(0)),
              ),
            ));
  }
}

class FrontPanel extends StatefulWidget {
  final SubItemList subItemList;
  FrontPanel(this.subItemList);

  @override
  _FrontPanelState createState() => _FrontPanelState(this.subItemList);
}

class _FrontPanelState extends State<FrontPanel> {
  final SubItemList sample;
  _FrontPanelState(this.sample);

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<SampleListModel>(
        rebuildOnChange: true,
        builder: (context, _, model) {
          return Scaffold(
              body: Padding(
            padding: const EdgeInsets.fromLTRB(5, 0, 5, 50),
            child: Container(child: getDefaultStepLineChart(false)),
          ));
        });
  }
}

class BackPanel extends StatefulWidget {
  final SubItemList sample;

  BackPanel(this.sample);

  @override
  _BackPanelState createState() => _BackPanelState(sample);
}

class _BackPanelState extends State<BackPanel> {
  final SubItemList sample;
  GlobalKey _globalKey = GlobalKey();
  _BackPanelState(this.sample);

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback(_afterLayout);
    super.initState();
  }

  _afterLayout(_) {
    _getSizesAndPosition();
  }

  _getSizesAndPosition() {
    final RenderBox renderBoxRed = _globalKey.currentContext.findRenderObject();
    final size = renderBoxRed.size;
    final position = renderBoxRed.localToGlobal(Offset.zero);
    double appbarHeight = 60;
    BackdropState.frontPanelHeight =
        position.dy + (size.height - appbarHeight) + 20;
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<SampleListModel>(
      rebuildOnChange: true,
      builder: (context, _, model) {
        return Container(
          color: model.backgroundColor,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  sample.title,
                  textAlign: TextAlign.left,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 28.0,
                      color: Colors.white,
                      letterSpacing: 0.53),
                ),
                Padding(
                  key: _globalKey,
                  padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                  child: Text(
                    sample.description,
                    style: const TextStyle(
                        fontWeight: FontWeight.normal,
                        fontSize: 15.0,
                        color: Colors.white,
                        letterSpacing: 0.3,
                        height: 1.5),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

SfCartesianChart getDefaultStepLineChart(bool isTileView) {
  return SfCartesianChart(
    plotAreaBorderWidth: 0,
    title: ChartTitle(text: isTileView ? '' : 'Electricity-Production'),
    primaryXAxis: NumericAxis(majorGridLines: MajorGridLines(width: 0)),
    primaryYAxis: NumericAxis(
        axisLine: AxisLine(width: 0),
        majorTickLines: MajorTickLines(size: 0),
        title: AxisTitle(text: isTileView ? '' : 'Production (kWh)'),
        labelFormat: '{value}B'),
    legend: Legend(isVisible: isTileView ? false : true),
    tooltipBehavior: TooltipBehavior(enable: true),
    series: getStepLineSeries(isTileView),
  );
}

List<StepLineSeries<_StepLineData, num>> getStepLineSeries(bool isTileView) {
  final List<_StepLineData> chartData = <_StepLineData>[
    _StepLineData(2000, 416, 180),
    _StepLineData(2001, 490, 240),
    _StepLineData(2002, 470, 370),
    _StepLineData(2003, 500, 200),
    _StepLineData(2004, 449, 229),
    _StepLineData(2005, 470, 210),
    _StepLineData(2006, 437, 337),
    _StepLineData(2007, 458, 258),
    _StepLineData(2008, 500, 300),
    _StepLineData(2009, 473, 173),
    _StepLineData(2010, 520, 220),
    _StepLineData(2011, 509, 309)
  ];
  return <StepLineSeries<_StepLineData, num>>[
    StepLineSeries<_StepLineData, num>(
        dataSource: chartData,
        xValueMapper: (_StepLineData sales, _) => sales.xData,
        yValueMapper: (_StepLineData sales, _) => sales.yData,
        name: 'Renewable'),
    StepLineSeries<_StepLineData, num>(
        dataSource: chartData,
        xValueMapper: (_StepLineData sales, _) => sales.xData,
        yValueMapper: (_StepLineData sales, _) => sales.yData2,
        name: 'Non-Renewable')
  ];
}

class _StepLineData {
  _StepLineData(this.xData, this.yData, this.yData2);
  final double xData;
  final double yData;
  final double yData2;
}
