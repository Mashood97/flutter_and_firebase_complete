import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import './mytask_screen.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.purple,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();

  Future<FirebaseUser> _signInwithGoogle() async {
    GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
    GoogleSignInAuthentication auth = await googleSignInAccount.authentication;

    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: auth.accessToken,
      idToken: auth.idToken,
    );

    final AuthResult authResult =
        await firebaseAuth.signInWithCredential(credential);
    final FirebaseUser user = authResult.user;

    Navigator.of(context).push(MaterialPageRoute(
      builder: (ctx) => MyTask(
        user: user,
        googleSignIn: googleSignIn,
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Login with google'),
            SizedBox(
              height: 10,
            ),
            FlatButton(
              color: Theme.of(context).primaryColor,

              child: Text('Google Sign-in',style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),),
              onPressed: () {
                _signInwithGoogle();
              },
            ),
          ],
        ),
      )),
    );
  }
}
