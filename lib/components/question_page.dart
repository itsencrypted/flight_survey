import 'package:flight_survey/components/answers.dart';
import 'package:flight_survey/components/arrow_icons.dart';
import 'package:flight_survey/components/dot.dart';
import 'package:flight_survey/components/plane.dart';
import 'package:flight_survey/components/question.dart';
import 'package:flight_survey/components/question_number.dart';
import 'package:flutter/material.dart';
import '../constants.dart';
import 'line.dart';

class FlightsStepper extends StatefulWidget {
  @override
  _FlightsStepperState createState() => _FlightsStepperState();
}

class _FlightsStepperState extends State<FlightsStepper> {
  int pageNumber = 1;

  @override
  Widget build(BuildContext context) {
    Widget page = pageNumber == 1
        ? Page(
      key: Key('page1'),
      onOptionSelected: () => setState(() => pageNumber = 2),
      question:
      'Do you typically fly for business, personal reasons, or some other reason?',
      answers: <String>['Business', 'Personal', 'Others'],
      number: 1,
    )
        : Page(
      key: Key('page2'),
      onOptionSelected: () => setState(() => pageNumber = 1),
      question: 'How many hours is your average flight?',
      answers: <String>[
        'Less than two hours',
        'More than two but less than five hours',
        'Others'
      ],
      number: 2,
    );
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: backgroundDecoration,
        child: SafeArea(
          child: Stack(
            children: <Widget>[
              ArrowIcons(),
              Plane(),
              Line(),
              Positioned.fill(
                left: 32.0 + 8,
                child: AnimatedSwitcher(
                  child: page,
                  duration: Duration(milliseconds: 250),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}






class Page extends StatefulWidget {
  final int number;
  final String question;
  final List<String> answers;
  final VoidCallback onOptionSelected;

  const Page(
      {Key key,
        @required this.onOptionSelected,
        @required this.number,
        @required this.question,
        @required this.answers})
      : super(key: key);

  @override
  _PageState createState() => _PageState();
}

class _PageState extends State<Page> with SingleTickerProviderStateMixin {
  List<GlobalKey<_ItemFaderState>> keys;
  int selectedOptionKeyIndex;
  AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    keys = List.generate(
      2 + widget.answers.length,
          (_) => GlobalKey<_ItemFaderState>(),
    );
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );
    onInit();
  }

  Future<void> animateDot(Offset startOffset) async {
    OverlayEntry entry = OverlayEntry(
      builder: (context) {
        double minTop = MediaQuery.of(context).padding.top + 52;
        return AnimatedBuilder(
          animation: _animationController,
          builder: (context, child) {
            return Positioned(
              left: 26.0 + 32 + 8,
              top: minTop +
                  (startOffset.dy - minTop) * (1 - _animationController.value),
              child: child,
            );
          },
          child: Dot(),
        );
      },
    );
    Overlay.of(context).insert(entry);
    await _animationController.forward(from: 0);
    entry.remove();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(height: 32),
        ItemFader(key: keys[0], child: StepNumber(number: widget.number)),
        ItemFader(
          key: keys[1],
          child: StepQuestion(question: widget.question),
        ),
        Spacer(),
        ...widget.answers.map((String answer) {
          int answerIndex = widget.answers.indexOf(answer);
          int keyIndex = answerIndex + 2;
          return ItemFader(
            key: keys[keyIndex],
            child: OptionItem(
              name: answer,
              onTap: (offset) => onTap(keyIndex, offset),
              showDot: selectedOptionKeyIndex != keyIndex,
            ),
          );
        }),
        SizedBox(height: 64),
      ],
    );
  }

  void onTap(int keyIndex, Offset offset) async {
    for (GlobalKey<_ItemFaderState> key in keys) {
      await Future.delayed(Duration(milliseconds: 40));
      key.currentState.hide();
      if (keys.indexOf(key) == keyIndex) {
        setState(() => selectedOptionKeyIndex = keyIndex);
        animateDot(offset).then((_) => widget.onOptionSelected());
      }
    }
  }

  void onInit() async {
    for (GlobalKey<_ItemFaderState> key in keys) {
      await Future.delayed(Duration(milliseconds: 40));
      key.currentState.show();
    }
  }
}

class ItemFader extends StatefulWidget {
  final Widget child;

  const ItemFader({Key key, @required this.child}) : super(key: key);

  @override
  _ItemFaderState createState() => _ItemFaderState();
}

class _ItemFaderState extends State<ItemFader>
    with SingleTickerProviderStateMixin {
  //1 means its below, -1 means its above
  int position = 1;
  AnimationController _animationController;
  Animation _animation;

  void show() {
    setState(() => position = 1);
    _animationController.forward();
  }

  void hide() {
    setState(() => position = -1);
    _animationController.reverse();
  }

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 600),
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, 64 * position * (1 - _animation.value)),
          child: Opacity(
            opacity: _animation.value,
            child: child,
          ),
        );
      },
      child: widget.child,
    );
  }
}