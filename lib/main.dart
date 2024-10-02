import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
        fontFamily: 'Roboto',
      ),
      home: FadingTextScreen(),
    );
  }
}

class FadingTextScreen extends StatefulWidget {
  @override
  _FadingTextScreenState createState() => _FadingTextScreenState();
}

class _FadingTextScreenState extends State<FadingTextScreen>
    with SingleTickerProviderStateMixin {
  bool _isVisible = true;
  double _opacityDuration = 2.0;
  String _text = 'Welcome to Flutter Animations!';
  String _imageAsset =
      'flutter.png'; // Update image path accordingly

  late AnimationController _controller;
  late Animation<Color?> _backgroundAnimation;

  @override
  void initState() {
    super.initState();

    // Animation controller for background color transition
    _controller = AnimationController(
      duration: const Duration(seconds: 6),
      vsync: this,
    )..repeat(reverse: true);

    _backgroundAnimation = ColorTween(
      begin: Colors.blueGrey[900],
      end: Colors.teal[200],
    ).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void toggleVisibility() {
    setState(() {
      _isVisible = !_isVisible;
    });
  }

  void changeText() {
    setState(() {
      if (_text == 'Welcome to Flutter Animations!') {
        _text = 'Master Flutter Animations!';
        _imageAsset =
            'bird.png'; // Update image path accordingly
      } else {
        _text = 'Welcome to Flutter Animations!';
        _imageAsset =
            'flutter.png'; // Update back to initial image path
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text('Fading Text Animation'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: GestureDetector(
        onTap: toggleVisibility,
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Animated Image with FadeTransition
            AnimatedOpacity(
              opacity: _isVisible ? 1.0 : 0.0,
              duration: Duration(seconds: _opacityDuration.toInt()),
              curve: Curves.easeInOut,
              child: Image.asset(
                _imageAsset,
                fit: BoxFit.cover,
              ),
            ),
            // Animated Overlay
            AnimatedBuilder(
              animation: _backgroundAnimation,
              builder: (context, child) {
                return Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        _backgroundAnimation.value!,
                        Colors.black54,
                      ],
                    ),
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Text with FadeTransition
                        AnimatedOpacity(
                          opacity: _isVisible ? 1.0 : 0.0,
                          duration: Duration(seconds: _opacityDuration.toInt()),
                          curve: Curves.easeInOut,
                          child: Text(
                            _text,
                            style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                              letterSpacing: 1.2,
                              shadows: [
                                Shadow(
                                  blurRadius: 10.0,
                                  color: Colors.black38,
                                  offset: Offset(3.0, 3.0),
                                ),
                              ],
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        const SizedBox(height: 30),

                        // Outlined Button for toggling text
                        OutlinedButton(
                          onPressed: changeText,
                          style: OutlinedButton.styleFrom(
                            padding: EdgeInsets.symmetric(
                                horizontal: 25, vertical: 15),
                            side: BorderSide(color: Colors.tealAccent),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          child: Text(
                            'Change Text',
                            style: TextStyle(
                                fontSize: 18, color: Colors.tealAccent),
                          ),
                        ),

                        // Slider for animation duration
                        const SizedBox(height: 40),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              'Animation Duration:',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 16),
                            ),
                            const SizedBox(width: 10),
                            Slider(
                              value: _opacityDuration,
                              min: 1,
                              max: 5,
                              divisions: 4,
                              activeColor: Colors.tealAccent,
                              label: "${_opacityDuration.toInt()} sec",
                              onChanged: (value) {
                                setState(() {
                                  _opacityDuration = value;
                                });
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: toggleVisibility,
        label: Text(_isVisible ? 'Fade Out' : 'Fade In'),
        icon: Icon(Icons.visibility),
        backgroundColor: Colors.tealAccent,
      ),
    );
  }
}
