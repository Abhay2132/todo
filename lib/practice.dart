import 'package:flutter/material.dart';

void main(){
  runApp(const App());
}

class App extends StatelessWidget{
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(
        body: Center(child: Text("ABHAY BISHT")),
      ),
    );
    // throw UnimplementedError();
  }

}