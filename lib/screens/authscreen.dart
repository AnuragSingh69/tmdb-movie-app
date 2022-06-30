import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:tmdb/providers.dart';
import '../providers.dart';

enum AuthMode { Signup, Login }

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final GlobalKey<FormState> _formkey = GlobalKey();

  AuthMode _authMode = AuthMode.Login;
  Map<String, String> _authData = {"email": "", "password": ""};

  final _passwordController = TextEditingController();

  var _isLoading = false;
  Future<void> _submit() async {
    if (!_formkey.currentState!.validate()) {
      return;
    }
    _formkey.currentState!.save();
    setState(() {
      _isLoading = true;
    });
    if (_authData == AuthMode.Login) {
    } else {
      await Provider.of<Auth>(context, listen: false)
          .Signup(_authData["email"]!, _authData["password"]!);
    }
    setState(() {
      _isLoading = false;
    });
  }

  void _switchAuthMode() {
    if (_authMode == AuthMode.Login) {
      setState(() {
        _authMode = AuthMode.Signup;
      });
    } else {
      setState(() {
        _authMode = AuthMode.Login;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // final deviceSize = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(
              child: Container(
                width: 500,
                height: 500,

                //shape: RoundedRectangleBorder(
                // borderRadius: BorderRadius.circular(10.0)),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        child: Center(
                          child: Column(
                            children: [
                              Text(
                                "Welcome to TMDB",
                                style: TextStyle(fontSize: 25),
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              Text(
                                "Login to continue",
                                style: TextStyle(fontSize: 18),
                              ),
                              Form(
                                key: _formkey,
                                child: SingleChildScrollView(
                                  child: Column(
                                    children: <Widget>[
                                      TextFormField(
                                        decoration: InputDecoration(
                                            labelText: 'E-Mail'),
                                        keyboardType:
                                            TextInputType.emailAddress,
                                        validator: (value) {
                                          if (value!.isEmpty ||
                                              !value.contains('@')) {
                                            return 'Invalid email!';
                                          }
                                          return null;
                                        },
                                        onSaved: (value) {
                                          _authData['email'] = value!;
                                        },
                                      ),
                                      TextFormField(
                                        decoration: InputDecoration(
                                            labelText: 'Password'),
                                        obscureText: true,
                                        controller: _passwordController,
                                        validator: (value) {
                                          if (value!.isEmpty ||
                                              value.length < 5) {
                                            return 'Password is too short!';
                                          }
                                          return null;
                                        },
                                        onSaved: (value) {
                                          _authData['password'] = value!;
                                        },
                                      ),
                                      if (_authMode == AuthMode.Signup)
                                        TextFormField(
                                          enabled: _authMode == AuthMode.Signup,
                                          decoration: InputDecoration(
                                              labelText: 'Confirm Password'),
                                          obscureText: true,
                                          validator:
                                              _authMode == AuthMode.Signup
                                                  ? (value) {
                                                      if (value !=
                                                          _passwordController
                                                              .text) {
                                                        return 'Passwords do not match!';
                                                      }
                                                    }
                                                  : null,
                                        ),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      if (_isLoading)
                                        CircularProgressIndicator()
                                      else
                                        RaisedButton(
                                          child: Text(
                                              _authMode == AuthMode.Login
                                                  ? 'LOGIN'
                                                  : 'SIGN UP'),
                                          onPressed: _submit,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(30),
                                          ),
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 30.0, vertical: 8.0),
                                          color: Theme.of(context).primaryColor,
                                          textColor: Theme.of(context)
                                              .primaryTextTheme
                                              .button!
                                              .color,
                                        ),
                                      FlatButton(
                                        child: Text(
                                            '${_authMode == AuthMode.Login ? 'SIGNUP' : 'LOGIN'} INSTEAD'),
                                        onPressed: _switchAuthMode,
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 30.0, vertical: 4),
                                        materialTapTargetSize:
                                            MaterialTapTargetSize.shrinkWrap,
                                        textColor:
                                            Theme.of(context).primaryColor,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ]),
      ),
    );
  }
}
