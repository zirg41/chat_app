// ignore_for_file: deprecated_member_use

import 'dart:io';

import 'package:chat_app/widgets/pickers/user_image_picker.dart';
import 'package:flutter/material.dart';

class AuthForm extends StatefulWidget {
  const AuthForm(this.submitFn, this.isLoading, {Key? key}) : super(key: key);
  final bool isLoading;
  final void Function(
    String? email,
    String? username,
    String? password,
    File? image,
    bool? isLogin,
    BuildContext context,
  ) submitFn;

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>();
  bool _isLogin = true;

  String? _userEmail = '';
  String? _userName = '';
  String? _userPassword = '';
  File? _userAvatarFile;

  void _pickedImage(File image) {
    _userAvatarFile = image;
  }

  void _trySubmit() {
    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();

    if (_userAvatarFile == null && !_isLogin) {
      Scaffold.of(context).showSnackBar(const SnackBar(
        content: Text("Please pick image"),
      ));

      return;
    }

    if (isValid) {
      _formKey.currentState!.save();
      widget.submitFn(
        _userEmail!.trim(),
        _userName!.trim(),
        _userPassword!.trim(),
        _userAvatarFile,
        _isLogin,
        context,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        margin: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (!_isLogin) UserImagePicker(_pickedImage),
                  TextFormField(
                    key: const ValueKey('email'),
                    // E-MAIL
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      labelText: "Email address",
                    ),
                    validator: (value) {
                      if (value!.isEmpty || !value.contains("@")) {
                        return "Pleasse enter a valid email address";
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _userEmail = value;
                    },
                  ),
                  if (!_isLogin)
                    TextFormField(
                      // USER NAME
                      key: const ValueKey('username'),
                      validator: (value) {
                        if (value!.isEmpty || value.length < 4) {
                          return "Please enter at least 4 characters";
                        }
                        return null;
                      },
                      decoration: const InputDecoration(labelText: "Username"),
                      onSaved: (value) {
                        _userName = value;
                      },
                    ),
                  TextFormField(
                    // PASSWORD
                    key: const ValueKey('password'),
                    validator: (value) {
                      if (value!.isEmpty || value.length < 4) {
                        return "Password must be at least 4 characters long";
                      }
                      return null;
                    },
                    decoration: const InputDecoration(labelText: "Password"),
                    obscureText: true,
                    onSaved: (value) {
                      _userPassword = value;
                    },
                  ),
                  const SizedBox(height: 12),
                  widget.isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : RaisedButton(
                          onPressed: _trySubmit,
                          child: Text(_isLogin ? "Login" : "Signup"),
                        ),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        _isLogin = !_isLogin;
                      });
                    },
                    child: Text(_isLogin
                        ? "Create new account"
                        : "I already have an account"),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
