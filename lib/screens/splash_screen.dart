import 'package:baniadam/screens/dashboard.dart';
import 'package:baniadam/screens/logIn.dart';
import 'package:baniadam/screens/register.dart';
import 'package:baniadam/widgets/base_state.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';


class SplashScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _SplashScreenState();
  }
}

class _SplashScreenState extends BaseState<SplashScreen> {
  var token;
  var cID;

  _getUserInfo() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString('curr-user');
    cID = prefs.getString('curr-cid');
  }
  @override
  void initState() {
    _getUserInfo();
    super.initState();
    Future.delayed(Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) =>
              cID != null ?
                token != null ?
                DashboardPage():LogInPage()
              :RegisterPage(),
        ),
      );
    },
    );
  }

  @override
  Widget build(BuildContext context) {
    return
      Material(
        color: Colors.white,
        child: Center(
          child: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  flex: 2,
                  child:Container(
                    padding: EdgeInsets.only(top:100.0),
                      child:Image(
                        width: 200.0,
                        image: AssetImage('assets/icons/BaniAdam-Logo_Final.png', ),
                      ),
                  ),

                ),
                Expanded(
                  flex: 1,
                  child:Container(
                    padding: EdgeInsets.only(top:100.0),
                    child:Text('version 1.0', style: TextStyle(color: Colors.black38),),
                  ),

                )


              ],
            ),
          ),
        ),
      );
  }
}
//class MyCustomRoute<T> extends MaterialPageRoute<T> {
//  MyCustomRoute({ WidgetBuilder builder, RouteSettings settings })
//      : super(builder: builder, settings: settings);
//
//  @override
//  Widget buildTransitions(BuildContext context,
//      Animation<double> animation,
//      Animation<double> secondaryAnimation,
//      Widget child) {
//    if (settings.isInitialRoute)
//      return child;
//    // Fades between routes. (If you don't want any animation,
//    // just return child.)
//    Animation<Offset> leftToRight = Tween(begin: Offset(1.0, 0.0), end: Offset(0.0, 0.0)).animate(animation);
//
//    return new SlideTransition(position: leftToRight,child: child,);
//  }
//}


