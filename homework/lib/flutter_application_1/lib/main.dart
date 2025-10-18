// main.dart
import 'package:flutter/material.dart';
import 'components/customW.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Custom Widget'),
        ),
        body: Center(
          child: ProfileCard(
            name: 'Nutthapoom Neunget',
            position: 'Programmer',
            email: 'Nutthapoom.nt@gmail.com',
            phoneNumber: '0892259857',
            imageUrl: 'https://static.wikia.nocookie.net/shingekinokyojin/images/9/94/Levi_Ackerman_character_image.png/revision/latest/scale-to-width/360?cb=20210410135001', 
          ),
        ),
      ),
    );
  }
}