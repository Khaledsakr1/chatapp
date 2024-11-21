import 'package:chatapp/constants/constants.dart';
import 'package:chatapp/helper/show_snackbar.dart';
import 'package:chatapp/widgets/Textfield.dart';
import 'package:chatapp/widgets/button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

// ignore: must_be_immutable
class RegisterPage extends StatefulWidget {
  RegisterPage({super.key});

  static String id = 'registerpage';

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  String? Email;

  String? Password;

  GlobalKey<FormState> formKey = GlobalKey();

  bool isloading = false;

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: isloading,
      child: Scaffold(
        backgroundColor: kPrimaryColor,
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 13),
            child: Form(
              key: formKey,
              child: Column(
                children: [
                  const SizedBox(height: 70),
                  Image.asset(kmain , width: 200, height: 200,),
                  const Text(
                    'Scholar Chat',
                    style: TextStyle(
                        fontSize: 30,
                        fontFamily: 'pacifico',
                        color: Colors.white),
                  ),
                  const SizedBox(height: 60),
                  const Row(
                    children: [
                      Text(
                        'REGISTER',
                        style: TextStyle(
                          fontSize: 25,
                          color: Color(0xffC7EDE6),
                          fontWeight: FontWeight.bold,
                          fontStyle: FontStyle.italic,
                          shadows: [
                            Shadow(
                              color: Colors.black45,
                              blurRadius: 4,
                              offset: Offset(2, 2), // Text shadow offset
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Textfield(
                    onchanged: (data) {
                      Email = data;
                    },
                    headtextfield: 'Create New Email',
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Textfield(
                    obscuretext: true,
                    onchanged: (data) {
                      Password = data;
                    },
                    headtextfield: 'Create New Password',
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Button(
                    ontap: () async {
                      if (formKey.currentState!.validate()) {
                        isloading = true;
                        setState(() {});
                        try {
                          await UserRegister();
                          ShowSnackBar(
                              context, 'Registering Successfully Go And Login');
                          Navigator.pop(context);
                        } on FirebaseAuthException catch (ex) {
                          if (ex.code == 'weak-password') {
                            ShowSnackBar(context, 'Weak Password');
                          } else if (ex.code == 'email-already-in-use') {
                            ShowSnackBar(context, 'Email already exist');
                          } else {
                            ShowSnackBar(context, 'There was an Error');
                          }
                        }

                        isloading = false;
                        setState(() {});
                      } else {}
                    },
                    title: 'Register',
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Already have an account?',
                        style: TextStyle(color: Colors.white),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: const Text(
                          '  Login',
                          style: TextStyle(
                            color: Color(0xffC7EDE6),
                            fontWeight: FontWeight.bold,
                            shadows: [
                              Shadow(
                                color: Colors.black45,
                                blurRadius: 4,
                                offset: Offset(2, 2), // Text shadow offset
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> UserRegister() async {
    // ignore: unused_local_variable
    UserCredential user = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: Email!, password: Password!);
  }
}
