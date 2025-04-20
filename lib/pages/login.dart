import 'package:chatapp/constants/constants.dart';
import 'package:chatapp/helper/show_snackbar.dart';
import 'package:chatapp/pages/chatpage.dart';
import 'package:chatapp/pages/register.dart';
import 'package:chatapp/widgets/Textfield.dart';
import 'package:chatapp/widgets/button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

// ignore: must_be_immutable
class LoginPage extends StatefulWidget {
  LoginPage({super.key});

  static String id = 'loginpage';
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
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
                  Image.asset(
                    kmain,
                    width: 200,
                    height: 200,
                  ),
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
                        'LOGIN',
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
                    headtextfield: 'Enter Your Email',
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Textfield(
                    obscuretext: true,
                    onchanged: (data) {
                      Password = data;
                    },
                    //hint: 'Password',
                    headtextfield: 'Enter Your Password',
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Button(
                    ontap: () async {
                      if (formKey.currentState!.validate()) {
                        FocusScope.of(context).unfocus();
                        isloading = true;
                        setState(() {});
                        try {
                          await UserLogin();
                          ShowSnackBar(context, 'Login Successful! Welcome');
                          Navigator.pushNamed(context, Chatpage.id,
                              arguments: Email);
                        } on FirebaseAuthException {
                          ShowSnackBar(context,
                              'There was an error in your email or password');
                        }

                        isloading = false;
                        setState(() {});
                      } else {}
                    },
                    title: 'Login',
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Create an account?',
                        style: TextStyle(color: Colors.white),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, RegisterPage.id);
                        },
                        child: const Text(
                          '  Register',
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

                  //google sign button
                  GestureDetector(
                    onTap: () {
                      signInWithGoogle();
                    },
                    child: Container(
                      width: double.infinity,
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 4,
                            offset: Offset(2, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                          Icons.face
                          ),
                          SizedBox(width: 12),
                          Text(
                            'Sign in with Google',
                            style: TextStyle(
                              color: Colors.black87,
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> UserLogin() async {
    // ignore: unused_local_variable
    UserCredential user = await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: Email!, password: Password!);
  }

  Future<void> signInWithGoogle() async {
    try {
      // Step 1: Trigger the Google authentication flow
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      if (googleUser == null) {
        ShowSnackBar(context, 'Login cancelled');
        return;
      }

      // Step 2: Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // Step 3: Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Step 4: Sign in to Firebase with the credential
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);

      // Step 5: Navigate to chat page on success
      ShowSnackBar(context, 'Login with Google Successful!');
      Navigator.pushNamed(context, Chatpage.id,
          arguments: userCredential.user!.email);
    } catch (e) {
      ShowSnackBar(context, 'Google sign-in failed: $e');
    }
  }
}