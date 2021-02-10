import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tic_tac_toe/home.dart';
import 'package:tic_tac_toe/theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(ChangeNotifierProvider(
    child: new MyApp(),
    create: (BuildContext context) =>
        ThemeProvider(isDarkMode: prefs.getBool('isDarkTheme') ?? true),
  ));
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with SingleTickerProviderStateMixin {
  final navigatorkey = GlobalKey<NavigatorState>();
  AnimationController _controller;
  Animation<Offset> _offsetAnimation;
  Animation<double> _fadeAnimation;
  @override
  void initState() {
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1700),
      vsync: this,
    )..forward();
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    ));
    _offsetAnimation = Tween<Offset>(
      begin: const Offset(0.0, -50.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.bounceOut,
    ));
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(builder: (context, themeProvider, child) {
      return GetMaterialApp(
        navigatorKey: navigatorkey,
        title: 'Tic Tac Toe',
        theme: themeProvider.getTheme,
        debugShowCheckedModeBanner: false,
        home: Align(
          alignment: Alignment.topCenter,
          child: AnimatedSplashScreen(
            duration: 3,
            backgroundColor: themeProvider.getTheme.backgroundColor,
            nextScreen: Home(),
            splashTransition: SplashTransition.scaleTransition,
            splash: Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Lottie.asset(
                      'images/ttt_ss.json',
                    ),
                  ),
                  SlideTransition(
                    position: _offsetAnimation,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 4.0),
                      child: Text(
                        'HI THERE, I\'M',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                  FadeTransition(
                    opacity: _fadeAnimation,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        TypewriterAnimatedTextKit(
                          text: ['Abrar', 'Altaf'],
                          totalRepeatCount: 1,
                          speed: Duration(milliseconds: 350),
                          textStyle: TextStyle(
                            color: Theme.of(context).accentColor,
                            fontSize: 20,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 4.0),
                          child: Text(
                            'developer of the app',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            splashIconSize: 300,
          ),
        ),
      );
    });
  }
}
