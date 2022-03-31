import 'package:flutter/material.dart';

class AuthForm extends StatefulWidget {
  const AuthForm(this.submitFn, {Key? key}) : super(key: key);

  final void Function(
    String? email,
    String? username,
    String? password,
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

  void _trySubmit() {
    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();
    if (isValid) {
      _formKey.currentState!.save();
      widget.submitFn(
        _userEmail!.trim(),
        _userName!.trim(),
        _userPassword!.trim(),
        _isLogin,
        context,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        margin: EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
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
                  RaisedButton(
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
