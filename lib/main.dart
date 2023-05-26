import 'package:firebase_core/firebase_core.dart';
import "package:flutter/material.dart";
import 'package:provider/provider.dart';
import 'package:tmdb/providers.dart';
import 'package:tmdb/screens/authscreen.dart';
import 'package:tmdb/screens/bottom_navigation.dart';
import 'package:tmdb/screens/description.dart';
import 'package:tmdb/screens/home.dart';
import './screens/authscreen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider.value(value: Auth())],
      child: Consumer<Auth>(
          builder: ((context, auth, child) => MaterialApp(
                debugShowCheckedModeBanner: false,

                theme: ThemeData(
                    backgroundColor: Colors.white,
                    textTheme: GoogleFonts.oswaldTextTheme(
                        Theme.of(context).textTheme),
                    brightness: Brightness.dark,
                    primaryColor: Colors.white),
                home: //BottomNavigation(),
                    auth.isAuth ? BottomNavigation() : AuthScreen(), //Login(),
                routes: {
                  "/description": (_) => Description(
                      "name",
                      "description",
                      "posterurl",
                      "rating",
                      "release",
                      "bannerurl",
                      "id",
                      "key"),
                  BottomNavigation.routename: (context) => BottomNavigation()
                },
              ))),
    );
  }
}
