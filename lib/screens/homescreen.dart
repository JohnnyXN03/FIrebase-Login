import 'package:firebase/screens/welcome.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

enum FormType { login, register }

class _HomePageState extends State<HomePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = new GoogleSignIn();

  final FirebaseAuth eauth = FirebaseAuth.instance;
  Future<FirebaseUser> emaillogin(String email, String password) async {
    final AuthResult result = await eauth.signInWithEmailAndPassword(
        email: email, password: password);
    final FirebaseUser user = result.user;
    assert(user != null);
    assert(await user.getIdToken() != null);
    final FirebaseUser currentuser = await eauth.currentUser();
    assert(user.uid == currentuser.uid); // assertion made
    print('login done');
    return user;
  }

  Future<FirebaseUser> signup(email, password) async {
    AuthResult result = await eauth.createUserWithEmailAndPassword(
        email: email, password: password);
    final FirebaseUser user = result.user;
    assert(user != null);
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

  void _formchange() async {
    setState(() {
      if (_form == FormType.register) {
        // ignore: unnecessary_statements
        _form == FormType.login;
      }
      if (_form == FormType.login) {
        _form = FormType.register;
      }
    });
  }

  TextEditingController _textEditingController = TextEditingController();
  TextEditingController _textEditingControlle = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        title: Text(
          'Firebase Login',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(20),
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Center(child: _input()),
        ),
      ),
    );
  }

  Widget _input() {
    return Form(
      key: formkey,
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
                    color: Colors.black,
                    width: 1,
                  ),
                ),
                border: InputBorder.none,
                floatingLabelBehavior: FloatingLabelBehavior.auto,
                hintText: 'Email',
                labelText: 'Email',
                icon: Icon(
                  Icons.markunread,
                  color: Colors.black,
                  size: 20,
                ),
              ),
              validator: (value) =>
                  value.isEmpty ? 'Email can\'t be empty' : null,
              onSaved: (value) => _email = value,
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
                      color: Colors.black,
                      width: 1,
                    ),
                  ),
                  border: InputBorder.none,
                  floatingLabelBehavior: FloatingLabelBehavior.auto,
                  hintText: 'Password',
                  labelText: 'Password',
                  icon: Icon(
                    Icons.lock_outline,
                    color: Colors.black,
                    size: 20,
                  )),
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
              height: 80,
              child: Card(
                color: Colors.black,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Icon(
                      Icons.markunread,
                      color: Colors.blue,
                    ),
                    Container(
                      padding: EdgeInsets.all(5),
                      alignment: Alignment.center,
                      child: Text(
                        'Continue with Google',
                        style: TextStyle(
                          color: Colors.blue,
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buttons() {
    if (_form == FormType.login) {
      return Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(10),
            child: RaisedButton(
              elevation: 3,
              color: Colors.black,
              child: Text(
                'Sign in',
                style: TextStyle(color: Colors.white, fontSize: 15),
              ),
              onPressed: () {
                emaillogin(_email, _password).then((FirebaseUser user) {
                  Navigator.push(
                      context, MaterialPageRoute(builder: (ctx) => Welcome()));
                });
              },
            ),
          ),
          FlatButton(
            child: Text(
              'Create account',
              style: TextStyle(color: Colors.black, fontSize: 15),
            ),
            onPressed: _formchange,
          )
        ],
      );
    } else {
      return Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(10),
            child: RaisedButton(
              elevation: 3,
              color: Colors.black,
              child: Text(
                'Sign up',
                style: TextStyle(color: Colors.white, fontSize: 15),
              ),
              onPressed: () {
                signup(_email, _password).then((FirebaseUser user) {
                  Navigator.push(
                      context, MaterialPageRoute(builder: (ctx) => Welcome()));
                });
              },
            ),
          ),
          FlatButton(
            child: Text(
              'already a user ? Login',
              style: TextStyle(color: Colors.black, fontSize: 15),
            ),
            onPressed: _formchange,
          ),
        ],
      );
    }
  }
}
