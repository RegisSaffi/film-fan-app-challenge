import 'package:flutter/material.dart';

class AccountPage extends StatelessWidget{
  @override
  Widget build(BuildContext context) {

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.person,size: 70,),
        SizedBox(height: 15,),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text("Sign in or create an account to get exclusive contents"),
        ),

        SizedBox(height: 20,),
        OutlinedButton(onPressed: (){},child: Text("Sign in"),)
      ],
    );
  }


}