//
// Created by iMahfuzurX on 2/15/2023.
//
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/models/http_exception.dart';
import 'package:shop_app/providers/auth.dart';

enum AuthMode { Login, Signup }

class AuthScreen extends StatelessWidget {
  static const String routeName = '/auth-screen';

  // const AuthScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: [
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
                children: [
                  Flexible(
                    child: Container(
                      margin: EdgeInsets.only(bottom: 20),
                      padding:
                          EdgeInsets.symmetric(vertical: 8, horizontal: 94),
                      transform: Matrix4.rotationZ(-8 * pi / 180)
                        ..translate(-10.0),
                      child: Text(
                        'MyShop',
                        style: TextStyle(
                          fontSize: 50,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.deepOrange.shade900,
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 8,
                            color: Colors.black26,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Flexible(
                    flex: deviceSize.width > 600 ? 2 : 1,
                    // flex: 1,
                    child: AuthCard(),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

class AuthCard extends StatefulWidget {
  const AuthCard({Key? key}) : super(key: key);

  @override
  State<AuthCard> createState() => _AuthCardState();
}

class _AuthCardState extends State<AuthCard> {
  final _formKey = GlobalKey<FormState>();
  AuthMode _authMode = AuthMode.Login;
  final Map<String, String?> _authData = {'email': null, 'password': null};
  final _passwordController = TextEditingController();
  var _isLoading = false;

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('An Error Occured'),
        content: Text(message),
        actions: [
          TextButton(
              onPressed: () => Navigator.of(ctx).pop(), child: Text('Okay'))
        ],
      ),
    );
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState?.validate() as bool) {
      _formKey.currentState?.save();
      setState(() {
        _isLoading = true;
      });
      try {
        if (_authMode == AuthMode.Login) {
          await Provider.of<Auth>(context, listen: false)
              .signIn(_authData['email'], _authData['password']);
        } else {
          await Provider.of<Auth>(context, listen: false)
              .signUp(_authData['email'], _authData['password']);
          // signup the user
        }
      } on HttpException catch (error) {
        var errorMessage = 'An Error Occured';
        if (error.toString().contains('EMAIL_EXISTS')) {
          errorMessage = 'Email already exists';
        } else if (error.toString().contains('OPERATION_NOT_ALLOWED')) {
          errorMessage = 'Password sign-in disabled';
        } else if (error.toString().contains('TOO_MANY_ATTEMPTS_TRY_LATER')) {
          errorMessage = 'Server Busy! Try again later';
        } else if (error.toString().contains('EMAIL_NOT_FOUND')) {
          errorMessage = 'Email not found! Check again';
        } else if (error.toString().contains('INVALID_PASSWORD')) {
          errorMessage = 'Wrong Password! Try again';
        } else if (error.toString().contains('USER_DISABLED')) {
          errorMessage = 'Login failed! User disabled';
        }
        _showErrorDialog(errorMessage);
      } catch (error) {
        const errorMessage = 'Couldn\'t authenticate! Try again';
        _showErrorDialog(errorMessage);
        //error return
      }
      setState(() {
        _isLoading = false;
      });
    }
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
    final deviceSize = MediaQuery.of(context).size;
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 8,
      child: Container(
        height: _authMode == AuthMode.Signup ? deviceSize.height * 0.5 : 320,
        constraints:
            BoxConstraints(minHeight: _authMode == AuthMode.Login ? 260 : 320),
        width: deviceSize.width * 0.75,
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  decoration: InputDecoration(labelText: 'Email'),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null ||
                        value.isEmpty ||
                        !value.contains('@')) {
                      return 'Please enter a valid email.';
                    }
                  },
                  onSaved: (value) {
                    _authData['email'] = value;
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Password'),
                  obscureText: true,
                  controller: _passwordController,
                  validator: (value) {
                    if (value == null || value.isEmpty || value.length < 6) {
                      return 'Please enter a valid password.';
                    }
                  },
                  onSaved: (value) {
                    _authData['password'] = value;
                  },
                ),
                if (_authMode == AuthMode.Signup)
                  TextFormField(
                    decoration: InputDecoration(labelText: 'Confirm Password'),
                    obscureText: true,
                    enabled: _authMode == AuthMode.Signup,
                    validator: (_authMode == AuthMode.Signup)
                        ? (value) {
                            if (value != _passwordController.text) {
                              return 'Passwords does not match.';
                            }
                          }
                        : null,
                    // onSaved: (value) {
                    //   _authData['password'] = value;
                    // },
                  ),
                SizedBox(
                  height: 20,
                ),
                if (_isLoading)
                  CircularProgressIndicator()
                else
                  MaterialButton(
                    onPressed: _submitForm,
                    child:
                        Text(_authMode == AuthMode.Login ? 'Login' : 'Signup'),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30)),
                    padding: EdgeInsets.symmetric(vertical: 8, horizontal: 30),
                    color: Theme.of(context).primaryColor,
                    textColor: Theme.of(context).primaryTextTheme.button?.color,
                  ),
                OutlinedButton(
                  onPressed: _switchAuthMode,
                  child: Text(
                      'Switch to ${_authMode == AuthMode.Login ? 'Signup' : 'Login'}'),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
