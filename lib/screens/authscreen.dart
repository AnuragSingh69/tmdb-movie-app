import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tmdb/helper/httpexception.dart';
import 'package:tmdb/providers.dart';

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
  final _emailController = TextEditingController();

  var _isLoading = false;

  // Future<void> sendOTP(String email) async {
  //   FirebaseAuth auth = FirebaseAuth.instance;

  //   try {
  //     await auth.sendPasswordResetEmail(email: "_email_controller");
  //     print('OTP sent to $email');
  //   } catch (e) {
  //     print('Failed to send OTP: $e');
  //   }
  // }

  void _showDialog(String message) {
    showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
              title: Text("An Error Occured!"),
              content: Text(message),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text("Okay"))
              ],
            ));
  }

  Future<void> _submit() async {
    if (!_formkey.currentState!.validate()) {
      return;
    }
    _formkey.currentState!.save();
    setState(() {
      _isLoading = true;
    });

    try {
      if (_authMode == AuthMode.Login) {
        await Provider.of<Auth>(context, listen: false)
            .login(_authData["email"]!, _authData["password"]!);
        // Navigator.of(context).pushNamed("/bottomNavigation");
      } else {
        await Provider.of<Auth>(context, listen: false)
            .signup(_authData["email"]!, _authData["password"]!);
      }
    } on httpException catch (error) {
      var errorMessage = "Authentication Failed"; //default message

      if (error.toString().contains("EMAIL_EXISTS")) {
        errorMessage = "This Email is already in use";
      }
      if (error.toString().contains("INVALID_EMAIL")) {
        errorMessage = "This Email is invalid";
      }
      if (error.toString().contains("WEAK_PASSWORD")) {
        errorMessage = "Try a Stronger Password";
      }
      if (error.toString().contains("EMAIL_NOT_FOUND")) {
        errorMessage = "Can't find a user with this email";
      }
      if (error.toString().contains("INVALID_PASSWORD")) {
        errorMessage = "This password is not valid";
      }
      _showDialog(errorMessage);
    } catch (error) {
      var errorMessage = "Could Not Authenticate.Please Try Again Later";
      _showDialog(errorMessage);
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
      body: SingleChildScrollView(
        child: Padding(
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
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 25),
                                ),
                                SizedBox(
                                  height: 15,
                                ),
                                Text(
                                  "Login to continue",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 18),
                                ),
                                SizedBox(
                                  height: 15,
                                ),
                                Form(
                                  key: _formkey,
                                  child: SingleChildScrollView(
                                    child: Column(
                                      children: <Widget>[
                                        TextFormField(
                                          style: TextStyle(color: Colors.white),
                                          decoration: InputDecoration(
                                              border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(5)),
                                              focusedBorder: OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: Colors.white),
                                                  borderRadius:
                                                      BorderRadius.circular(5)),
                                              enabledBorder: OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: Colors.white),
                                                  borderRadius:
                                                      BorderRadius.circular(5)),
                                              labelText: 'Email'),
                                          textInputAction: TextInputAction.next,
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
                                        SizedBox(
                                          height: 15,
                                        ),
                                        TextFormField(
                                          style: TextStyle(color: Colors.white),
                                          decoration: InputDecoration(
                                              border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(5)),
                                              focusedBorder: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                  borderSide: BorderSide(
                                                      color: Colors.white)),
                                              enabledBorder: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                  borderSide: BorderSide(
                                                      color: Colors.white)),
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
                                        SizedBox(
                                          height: 15,
                                        ),
                                        if (_authMode == AuthMode.Signup)
                                          // SizedBox(
                                          // height: 15,
                                          //),
                                          TextFormField(
                                            style:
                                                TextStyle(color: Colors.white),
                                            enabled:
                                                _authMode == AuthMode.Signup,
                                            decoration: InputDecoration(
                                                border: OutlineInputBorder(
                                                    borderRadius: BorderRadius
                                                        .circular(5)),
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(5),
                                                        borderSide: BorderSide(
                                                            color: Colors
                                                                .white)),
                                                enabledBorder:
                                                    OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(5),
                                                        borderSide: BorderSide(
                                                            color:
                                                                Colors.white)),
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
                                          ElevatedButton(
                                            child: Text(
                                                _authMode == AuthMode.Login
                                                    ? 'LOGIN'
                                                    : 'SIGN UP'),
                                            onPressed: _submit,
                                          ),
                                        SizedBox(
                                          height: 20,
                                        ),
                                        TextButton(
                                          child: Text(
                                              '${_authMode == AuthMode.Login ? 'New User ? Signup' : 'Already a User ? Login'} '),
                                          onPressed: _switchAuthMode,

                                          //Theme.of(context).primaryColor,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 15,
                                ),
                                ElevatedButton(
                                    onPressed: () {
                                      // sendOTP(_emailController.toString());
                                    },
                                    child: Text("Send OTP"))
                              ],
                            ),
                          ),
                        ),
                        //SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
