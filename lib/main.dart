import 'package:flutter/material.dart';

void main(){
  runApp(const DriveXApp());
}
class DriveXApp extends StatelessWidget {
  const DriveXApp({super.key});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus!.unfocus();
      },
      child:
      MaterialApp(
        debugShowCheckedModeBanner: false,
        home:  Container(),
      ),
    );
  }
}
