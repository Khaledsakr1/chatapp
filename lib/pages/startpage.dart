import 'package:chatapp/constants/constants.dart';
import 'package:chatapp/pages/login.dart';
import 'package:chatapp/widgets/button.dart';
import 'package:flutter/material.dart';

class Startpage extends StatelessWidget {
  const Startpage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
    backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: kPrimaryColor,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              klogo,
              height: 50,
            ),
            const Text(
              'Chat',
              style: TextStyle(
                  fontSize: 25, fontFamily: 'pacifico', color: Colors.white),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 130),
              child: Image.asset('assets/images/chat.gif'),
            ),

            SizedBox(height: 70,),
            Button(
                ontap: () {
                  Navigator.pushNamed(context, LoginPage.id);
                },
                title: 'Let\'s Chat....'),
          ],
        ),
      ),
    );
  }
}
