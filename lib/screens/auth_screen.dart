import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:chat_app/widgets/auth/auth_form.dart';
import 'package:flutter/services.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _auth = FirebaseAuth.instance;

  void _submitAuthForm(
    String? email,
    String? username,
    String? password,
    bool? isLogin,
    BuildContext context,
  ) async {
    try {
      if (isLogin!) {
        final authResult = await _auth.signInWithEmailAndPassword(
            email: email!, password: password!);
      } else {
        final authResult = await _auth.createUserWithEmailAndPassword(
            email: email!, password: password!);
      }
    } on FirebaseException catch (err) {
      var message = "An error occured, please check your credentials";
      if (err.message != null) {
        message = err.message!;
      }
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text(message),
        backgroundColor: Theme.of(context).errorColor,
      ));
    } catch (err) {
      debugPrint(err.toString());
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text(err.toString()),
        backgroundColor: Theme.of(context).errorColor,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: ,
      backgroundColor: Theme.of(context).primaryColor,
      body: AuthForm(_submitAuthForm),
    );
  }
}
