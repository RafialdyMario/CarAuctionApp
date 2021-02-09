import 'package:auction_app/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

class SignIn extends StatefulWidget {
  final Function toggleView;
  SignIn({this.toggleView});
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();

  //text field state
  String email = '';
  String password = '';
  String error = '';
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: HexColor('#E9CBB0'),
        elevation: 0.0,
        title: Text(
          'Sign in',
          style: TextStyle(color: HexColor('#3F4D55')),
        ),
        centerTitle: true,
      ),
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 20, horizontal: 50),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              SizedBox(height: 20.0),
              _buildEmailTextField(),
              SizedBox(height: 20.0),
              _buildPasswordTextField(),
              SizedBox(height: 20.0),
              RaisedButton(
                color: HexColor('#406260'),
                child: Text(
                  'Sign in',
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () async {
                  if (_formKey.currentState.validate()) {
                    dynamic result =
                        await _auth.signInWithEmailAndPassword(email, password);
                    if (result == null) {
                      setState(() {
                        error = 'could not sign in with those credential';
                      });
                    }
                  }
                },
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      'Not a user yet?',
                      style: TextStyle(
                        color: HexColor('#E9CBB0'),
                      ),
                    ),
                    FlatButton(
                      child: Text(
                        'Create an Account',
                        style: TextStyle(
                          color: HexColor('#406260'),
                        ),
                      ),
                      onPressed: () async {
                        widget.toggleView();
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  TextFormField _buildEmailTextField() {
    return TextFormField(
      validator: (value) {
        Pattern pattern =
            r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
        RegExp regex = new RegExp(pattern);
        if (value.isEmpty) {
          return 'Email can\'t be empty!';
        } else if (!regex.hasMatch(value)) {
          return 'Enter valid email!';
        }
        return null;
      },
      decoration: InputDecoration(labelText: 'Email'),
      onChanged: (val) {
        setState(() {
          email = val;
        });
      },
    );
  }

  TextFormField _buildPasswordTextField() {
    return TextFormField(
      validator: (value) {
        if (value.isEmpty) {
          return 'Password can\'t be empty!';
        } else if (value.length < 8) {
          return 'Password can be fill at least 8 characters';
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: 'Password',
        suffixIcon: IconButton(
          iconSize: 20,
          onPressed: () {
            setState(() {
              _obscureText = !_obscureText;
            });
          },
          icon: Icon(Icons.remove_red_eye),
          color: Colors.grey,
        ),
      ),
      obscureText: _obscureText,
      onChanged: (val) {
        setState(() {
          password = val;
        });
      },
    );
  }
}
