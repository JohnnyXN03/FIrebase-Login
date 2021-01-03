import 'dart:ui';

import 'package:firebase/screens/welcome.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:google_fonts/google_fonts.dart';

class Signin extends StatefulWidget {
  @override
  _SigninState createState() => _SigninState();
}

enum FormType { login, register }

class _SigninState extends State<Signin> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = new GoogleSignIn();

  void signinwithemail() async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _textEditingController.text,
          password: _textEditingControlle.text);
      Navigator.push(context, MaterialPageRoute(builder: (ctx) => Welcome()));
    } catch (e) {
      print(e.toString());
    }
  }

  Future<FirebaseUser> currentuser() async {
    FirebaseUser user = await _auth.currentUser();
    return user;
  }

  Future<FirebaseUser> signInWithGoogle() async {
    FirebaseUser user;
    bool isSignedin = await googleSignIn.isSignedIn();

    if (isSignedin) {
      user = await _auth.currentUser();
    } else {
      final GoogleSignInAccount googleUser = await googleSignIn.signIn();
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.getCredential(
          idToken: googleAuth.idToken, accessToken: googleAuth.accessToken);
      user = (await _auth.signInWithCredential(credential)).user;
    }
    return user;
  }

  void onSigned(BuildContext context) async {
    FirebaseUser user = await signInWithGoogle();
    Navigator.push(context, MaterialPageRoute(builder: (ctx) => Welcome()));
  }

  final formkey = new GlobalKey<FormState>();
  String _email;
  String _password;
  FormType _form = FormType.login;
  bool _validate() {
    final form = formkey.currentState;
    form.save();
    if (form.validate()) {
      return true;
    }
    return false;
  }

  /*void _formchange() async {
    setState(() {
      if (_form == FormType.register) {
        // ignore: unnecessary_statements
        _form == FormType.login;
      } else {
        _form = FormType.register;
      }
    });
  } */

  TextEditingController _textEditingController = TextEditingController();
  TextEditingController _textEditingControlle = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
            child: Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: Column(
        children: [
          Container(
              width: MediaQuery.of(context).size.width,
              child: Image.asset(
                'assets/frame.png',
              )),
          SizedBox(
            height: 30,
          ),
          Container(
            margin: EdgeInsets.only(left: 20),
            alignment: Alignment.topLeft,
            child: Text("Login",
                style: GoogleFonts.poppins(
                    color: Colors.black,
                    fontSize: 30,
                    fontWeight: FontWeight.bold)),
          ),
          Center(
            child: _input(),
          )
        ],
      ),
    )));
  }

  Widget _input() {
    return Form(
      key: formkey,
      child: Container(
        /* padding: EdgeInsets.all(20), */
        width: MediaQuery.of(context).size.width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(20),
              child: TextFormField(
                controller: _textEditingController,
                autocorrect: true,
                maxLines: 1,
                keyboardType: TextInputType.emailAddress,
                autofocus: false,
                decoration: InputDecoration(
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.blue,
                      width: 1,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.yellow,
                      width: 1,
                    ),
                  ),
                  border: InputBorder.none,
                  floatingLabelBehavior: FloatingLabelBehavior.auto,
                  hintText: 'Email',
                  labelText: 'Email',
                ),
                validator: (value) =>
                    value.isEmpty ? 'Email can\'t be empty' : null,
                onChanged: (value) => _email = value,
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20),
              child: TextFormField(
                maxLines: 1,
                controller: _textEditingControlle,
                autofocus: true,
                obscureText: true,
                decoration: InputDecoration(
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.blue,
                      width: 1,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.yellow,
                      width: 1,
                    ),
                  ),
                  border: InputBorder.none,
                  floatingLabelBehavior: FloatingLabelBehavior.auto,
                  hintText: 'Password',
                  labelText: 'Password',
                ),
                validator: (value) => value.isEmpty ? 'Enter password' : null,
                onSaved: (value) => _password = value,
              ),
            ),
            _buttons(),
            Divider(),
            InkWell(
              onTap: () {
                onSigned(context);
              }, // google sign in
              child: Container(
                padding: EdgeInsets.all(10),
                width: MediaQuery.of(context).size.width,
                height: 90,
                child: Card(
                  color: Colors.white,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Image.asset(
                          'assets/google.png',
                        ),
                      ),
                      Center(
                        child: Text('Continue with Google',
                            style: GoogleFonts.poppins(
                                color: Colors.black, fontSize: 20)),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buttons() {
    return Column(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.all(10),
          child: RaisedButton(
            elevation: 3,
            color: Colors.blueAccent,
            child: Text(
              'Sign in',
              style: GoogleFonts.poppins(color: Colors.white, fontSize: 15),
            ),
            onPressed: () {
              signinwithemail();
            },
          ),
        ),
      ],
    );
    /* else {
      return Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(10),
            child: RaisedButton(
              elevation: 3,
              color: Colors.blue,
              child: Text(
                'Sign up',
                style: GoogleFonts.poppins(color: Colors.white, fontSize: 15),
              ),
              onPressed: () {
                signinwithemail();
              },
            ),
          ),
          FlatButton(
            child: Text(
              'Login',
              style: TextStyle(color: Colors.blue, fontSize: 15),
            ),
            onPressed: ,
          ),
        ],
      );
    } */
  }
}
