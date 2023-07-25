import 'package:Somnolence/components/register_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'components/my_textfield.dart';

class ForgotPasswordPage extends StatefulWidget {
  final Function()? onTap;

  const ForgotPasswordPage({super.key, required this.onTap});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();

}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final usernameController = TextEditingController();
  
  void dispose() {
    usernameController.dispose();
    super.dispose();
  }

  Future passwordReset() async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: usernameController.text.trim());
      showDialog(
        context: context, 
        builder: (context) {
          return AlertDialog(
            content: Text("Password reset link sent! Check your email!"),
          );
      });
    } on FirebaseAuthException catch (e) {
      print(e);
      showDialog(
        context: context, 
        builder: (context) {
          return AlertDialog(
            content: Text(e.message.toString()),
          );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 230, 179, 178),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
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
                child: const Text(
                'Put in your email and we will send you a password reset link!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,)
                          ),
              ),
            const SizedBox(height: 25,),
          
            //username
            MyTextField(
              controller: usernameController,
              hintText: "Email",
              obscureText: false,
            ),
            SizedBox(height: 20,),
            
            ElevatedButton(
              onPressed: passwordReset, 
              child: Text('Reset Password'),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Colors.pink),
              ),
              
              ),

            SizedBox(height: 20,),

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
                      // Navigation.push(context, MaterialPageRoute(builder: (context) => RegisterPage(onTap: widget.onTap)));
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
              ),

              SizedBox(height: 10,),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Already have an account?',
                    style: TextStyle(color: Colors.white),
                  ),
                  const SizedBox(width: 4),
                  GestureDetector(
                    onTap: widget.onTap,
                    child: const Text(
                      'Login Here',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              )

          ],
        ),
      )
      )
      ) 
    );
  }
}