import 'dart:math';
import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/Models/httpdeleteerror.dart';
import '../Provider/auth.dart';
import '../Models/httpdeleteerror.dart';

enum AuthMode { Signup, Login }

class AuthScreen extends StatelessWidget {
  static const routeName = '/auth';

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    // final transformConfig = Matrix4.rotationZ(-8 * pi / 180);
    // transformConfig.translate(-10.0);
    return Scaffold(
      // resizeToAvoidBottomInset: false,
      body: Stack(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color.fromRGBO(215, 117, 255, 1).withOpacity(0.5),
                  Color.fromRGBO(255, 188, 117, 1).withOpacity(0.9),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                stops: [0, 1],
              ),
            ),
          ),
          SingleChildScrollView(
            child: Container(
              height: deviceSize.height,
              width: deviceSize.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Flexible(
                    child: Container(
                      margin: EdgeInsets.only(bottom: 15.0),
                      padding:
                          EdgeInsets.symmetric(vertical: 8.0, horizontal: 94.0),
                      transform: Matrix4.rotationZ(-10 * pi / 180)
                        ..translate(-10.0),
                      // ..translate(-10.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.deepOrange.shade900,
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 8,
                            color: Colors.black26,
                            offset: Offset(0, 2),
                          )
                        ],
                      ),
                      child: Text(
                        'MyShop',
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 50,
                          fontFamily: 'Anton',
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ),
                  ),
                  Flexible(
                    flex: deviceSize.width > 600 ? 2 : 1,
                    child: AuthCard(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class AuthCard extends StatefulWidget {
  const AuthCard({
    Key key,
  }) : super(key: key);
  @override
  _AuthCardState createState() => _AuthCardState();
}

class _AuthCardState extends State<AuthCard>
    with SingleTickerProviderStateMixin {
  GlobalKey<FormState> formkey = GlobalKey();
  AuthMode authMode = AuthMode.Login;
  Map<String, String> authData = {'email': '', 'password': ''};
  final confirmPasswordcontroller = TextEditingController();
  bool isLoading = false;
  AnimationController _controller;
  Animation<Size> _animation;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 300));
    _animation = Tween<Size>(
            begin: Size(double.infinity, 270), end: Size(double.infinity, 330))
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeInBack));
    _controller.addListener(() {setState(() {
      });});    
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _controller.dispose();
  }
  void showMyDialog(String message) {
    showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('Okay'))
              ],
              title: Text('Authentication Failed'),
              content: Text(message),
            ));
  }

  Future<void> submit() async {
    if (!formkey.currentState.validate()) {
      return;
    }
    formkey.currentState.save();
    setState(() {
      isLoading = true;
    });
    try {
      if (authMode == AuthMode.Login) {
        await Provider.of<Auth>(context, listen: false)
            .login(authData['email'], authData['password']);
      } else {
        //sign up user
        await Provider.of<Auth>(context, listen: false)
            .signup(authData['email'], authData['password']);
      }
    } on HttpDeleteException catch (error) {
      var errorMessage = 'Authentication failed';
      switch (error.toString()) {
        case 'EMAIL_EXISTS':
          errorMessage = 'EMAIL_EXISTS';
          break;
        case 'EMAIL_NOT_FOUND':
          errorMessage = 'EMAIL_NOT_FOUND';
          break;
        case 'INVALID_PASSWORD':
          errorMessage = 'INVALID_PASSWORD';
          break;
      }
      showMyDialog(errorMessage);
      // print(errorMessage);
    } catch (error) {
      var errorMessage = 'Authentication failed';
      showMyDialog(errorMessage);
    }
    setState(() {
      isLoading = false;
    });
  }

  void switchLoginType() {
    if (authMode == AuthMode.Login) {
      setState(() {
        authMode = AuthMode.Signup;
      });
       _controller.forward();
    } else {
      setState(() {
        authMode = AuthMode.Login;
      });
      _controller.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        elevation: 8.0,
        child: AnimatedBuilder(animation: _animation, builder: (ctx,ch)=>
        Container(
          // height: authMode == AuthMode.Login ? 290 : 350,
          height:_animation.value.height,
          width: 300,
          padding: EdgeInsets.all(5),
          child:ch),child:SingleChildScrollView(
            child: Form(
                key: formkey,
                child: Column(
                  children: [
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Email',
                      ),
                      validator: (value) {
                        if (!value.contains('@')) {
                          return 'Please enter valid email';
                        }
                        return null;
                      },
                      onSaved: (email) {
                        authData['email'] = email;
                      },
                    ),
                    TextFormField(
                        decoration: InputDecoration(labelText: 'Password'),
                        obscureText: true,
                        controller: confirmPasswordcontroller,
                        validator: (value) {
                          if (!(value.length > 5)) {
                            return 'Password be greater than 5 letters';
                          }
                          return null;
                        },
                        onSaved: (password) {
                          authData['password'] = password;
                        }),
                    if (authMode == AuthMode.Signup)
                      TextFormField(
                        decoration:
                            InputDecoration(labelText: 'Confirm Password'),
                        obscureText: true,
                        validator: (value) {
                          if (value != confirmPasswordcontroller.text) {
                            return 'Password do not match';
                          }
                          return null;
                        },
                      ),
                    SizedBox(
                      height: 20,
                    ),
                    if (isLoading == false)
                      ElevatedButton(
                        onPressed: () {
                          submit();
                        },
                        child: authMode == AuthMode.Login
                            ? Text('Login')
                            : Text('SignUp'),
                      )
                    else
                      CircularProgressIndicator(),
                    TextButton(
                        onPressed: () {
                          switchLoginType();
                        },
                        child: authMode == AuthMode.Login
                            ? Text('Signup Instead')
                            : Text('Login Instead'))
                  ],
                )),
          ),
        ));
  }
}
