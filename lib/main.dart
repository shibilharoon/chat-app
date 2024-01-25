import 'package:chathub/controller/auth_provider.dart';
import 'package:chathub/controller/otp_provider.dart';
import 'package:chathub/controller/firebase_provider.dart';
import 'package:chathub/view/pages/auth_gate.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: 'AIzaSyCBTW-ZMqw6edRcTdzHIeavNEcFH754u0w',
          appId: '1:23560088534:android:80965053e1072ab4bd5277',
          messagingSenderId: '23560088534',
          projectId: 'chitchat-39461',
          storageBucket: "chitchat-39461.appspot.com"));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => OtpProvider()),
        ChangeNotifierProvider(create: (context) => FirebaseProvider()),
        ChangeNotifierProvider(create: (context) => AuthProviders())
      ],
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: AuthGate(),
      ),
    );
  }
}
