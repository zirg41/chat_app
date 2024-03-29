import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import 'package:chat_app/widgets/auth/auth_form.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _auth = FirebaseAuth.instance;
  bool _isLoading = false;

  void _submitAuthForm(
    String? email,
    String? username,
    String? password,
    File? image,
    bool? isLogin,
    BuildContext context,
  ) async {
    try {
      setState(() {
        _isLoading = true;
      });
      UserCredential authResult;
      if (isLogin!) {
        authResult = await _auth.signInWithEmailAndPassword(
            email: email!, password: password!);
      } else {
        authResult = await _auth.createUserWithEmailAndPassword(
            email: email!, password: password!);
      }

      final ref = FirebaseStorage.instance
          .ref()
          .child('user_images')
          .child('${authResult.user!.uid}.jpg');

      ref.putFile(image!);

      final url = await ref.getDownloadURL();

      await FirebaseFirestore.instance
          .collection('users')
          .doc(authResult.user!.uid)
          .set({
        'username': username,
        'email': email,
        'image_url': url,
      });
    } on FirebaseException catch (err) {
      var message = "An error occured, please check your credentials";
      if (err.message != null) {
        message = err.message!;
      }
      // ignore: deprecated_member_use
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(message),
        backgroundColor: Theme.of(context).errorColor,
      ));
      setState(() {
        _isLoading = false;
      });
    } catch (err) {
      debugPrint(err.toString());
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: ,
      backgroundColor: Theme.of(context).primaryColor,
      body: AuthForm(
        _submitAuthForm,
        _isLoading,
      ),
    );
  }
}
