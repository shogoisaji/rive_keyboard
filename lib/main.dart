import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.red[200],
        body: const Center(
          child: MyAnimation(),
        ),
      ),
    );
  }
}

class MyAnimation extends StatefulWidget {
  const MyAnimation({Key? key}) : super(key: key);

  @override
  _MyAnimationState createState() => _MyAnimationState();
}

class _MyAnimationState extends State<MyAnimation> {
  String _text = '';
  bool _isVisibility = false;
  SMITrigger? _appear;
  SMITrigger? _hide;

  void _onRiveInit(Artboard artboard) {
    final controller = StateMachineController.fromArtboard(
      artboard,
      'State Machine',
      onStateChange: _onStateChange,
    );
    artboard.addController(controller!);
    _appear = controller.findInput<bool>('appear') as SMITrigger;
    _hide = controller.findInput<bool>('hide') as SMITrigger;
  }

  void _hitAppear() => _appear?.fire();
  void _hitHide() => _hide?.fire();

  void _onStateChange(
    String stateMachineName,
    String stateName,
  ) {
    // stateName -> "A_W" -> text -> "W"
    final List<String> splitString = stateName.split("_");
    if (splitString[0] == "A") {
      if (splitString[1] == "space") {
        setState(() {
          _text += " ";
        });
      } else if (splitString[1] == "backspace") {
        setState(() {
          _text = _text.substring(0, _text.length - 1);
        });
      } else {
        setState(() {
          _text += splitString[1];
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red[200],
      body: Column(
        children: [
          Expanded(
              child: Center(
            child: Container(
              width: MediaQuery.of(context).size.width * 0.8,
              height: 100,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.red[100],
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: Text(
                  _text,
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.black.withOpacity(0.7),
                  ),
                ),
              ),
            ),
          )),
          SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.width * 356 / 1080, // rive size 1080x356
            child: GestureDetector(
                child: RiveAnimation.asset(
              'assets/rive/keyboard.riv',
              fit: BoxFit.contain,
              onInit: _onRiveInit,
            )),
          ),
          Container(
            color: Color(0xFFBBC7E2),
            width: MediaQuery.of(context).size.width,
            height: 55,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: IconButton(
                onPressed: () {
                  if (_isVisibility) {
                    _hitHide();
                    setState(() {
                      _isVisibility = false;
                    });
                  } else {
                    _hitAppear();
                    setState(() {
                      _isVisibility = true;
                    });
                  }
                },
                icon: Icon(Icons.keyboard, color: Colors.black54, size: 30),
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
