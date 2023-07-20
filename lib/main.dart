import 'dart:developer';

import 'package:chat_app/screens/auth_screen.dart';
import 'package:chat_app/screens/chat_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  final instance = FirebaseMessaging.instance;
  await instance.requestPermission();
  final token = await instance.getToken();
  log("token: $token");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Firebase.initializeApp(),
      builder: (ctx, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'FlutterChat',
          theme: ThemeData(
            colorScheme: const ColorScheme(
                brightness: Brightness.dark,
                primary: Colors.pink,
                onPrimary: Colors.pink,
                secondary: Colors.deepPurple,
                onSecondary: Colors.deepPurple,
                error: Colors.red,
                onError: Colors.red,
                background: Colors.pink,
                onBackground: Colors.pink,
                surface: Colors.pink,
                onSurface: Colors.pink),
            buttonTheme: ButtonTheme.of(context).copyWith(
              buttonColor: Colors.pink,
              textTheme: ButtonTextTheme.normal,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
          home: StreamBuilder(
            stream: FirebaseAuth.instance.authStateChanges(),
            // initialData: initialData,
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.hasData) {
                return const ChatScreen();
              }
              return const AuthScreen();
            },
          ),
        );
      },
    );
  }
}
