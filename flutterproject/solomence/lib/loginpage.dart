import 'package:Somnolence/components/my_button.dart';
import 'package:Somnolence/homepage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:Somnolence/components/register_page.dart';
import 'components/my_button.dart';

import 'components/my_textfield.dart';
import 'forgot_password_page.dart';

class LoginPage extends StatefulWidget {
  final Function()? onTap;
  const LoginPage({super.key, required this.onTap});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  // sign user in method
  void signUserIn() async {
       // show loading circle
    showDialog(
      context: context,
      builder: (context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );

    // try sign in
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: usernameController.text,
        password: passwordController.text,
      );
      // pop the loading circle
      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      // pop the loading circle
      Navigator.pop(context);
      
      //not right message
      showErrorMessage("Wrong Email or Password");
      
    }
  }

  // wrong email message popup
  void showErrorMessage(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Color.fromARGB(255, 252, 203, 203),
          title: Center(
            child: Text(
              message,
              style: TextStyle(color: Colors.white),
            ),
          ),
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 230, 179, 178),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 50),
                //logo
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset('assets/image_png.png', height: 100,),
              
                  ],
                ),
              ),
              const SizedBox(height: 50,),
            //message
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Text(
                'Let\'s be more safe with Somnolence!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,)
                          ),
              ),
            const SizedBox(height: 25,),
          
            //username
            MyTextField(
              controller: usernameController,
              hintText: "Email",
              obscureText: false,
            ), 
          
            const SizedBox(height: 10),
            //password
            MyTextField(
              controller: passwordController,
              hintText: "Password",
              obscureText: true,
            ),
            const SizedBox(height: 10),
          
            //forgot password?
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GestureDetector(
                    onTap:() {
                      Navigator.push(context, MaterialPageRoute(builder: (context) {
                        return ForgotPasswordPage(
                          onTap: widget.onTap,
                        );
                      }));
                    },
                    child: Text(
                      'Forgot Password?',
                      style: TextStyle(color: Colors.pink),
                      ),
                  ),
                ],
              ),
            ),
          
            const SizedBox(height: 10),
          
            //sign in button
            MyButton(
              text: 'Sign In',
              onTap: signUserIn,
            ),
          
            SizedBox(height: 30,),
            //regester now
            Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Not a member?',
                    style: TextStyle(color: Colors.white),
                  ),
                  const SizedBox(width: 4),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) {
                        return RegisterPage(
                          onTap: widget.onTap,
                        );
                      }));
                    },
                    child: const Text(
                      'Register now',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              )
            ]),
          ),
        ),
      ),
    );
  }
}