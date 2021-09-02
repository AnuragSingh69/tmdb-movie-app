import "package:flutter/material.dart";
import './screens/home_screen.dart';

void main(){
  runApp(MyApp());


}

class MyApp extends StatelessWidget{
  Widget build(BuildContext context){
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme:ThemeData.dark(
        
        ),
      home: Home(),
    );
  }
}
