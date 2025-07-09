import 'package:flutter/material.dart';
import 'package:messanger_app/presentation/login/login_screen.dart';
import 'package:messanger_app/presentation/login/signup_screen.dart';

import 'onboarding_image.dart';



class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {

    double screenWidth = MediaQuery.of(context).size.width;


    return Scaffold(
      backgroundColor: Colors.white,
      body:
      Column(
        children: [
          Expanded(
            flex: 4,
            child: Center(
              child: SizedBox(
                width: screenWidth * 1.2,
                height: screenWidth * 1.2,
                child: const AnimatedHeroStack(),
              ),
            ),
          ),

          Expanded(
              flex: 2,
              child:
              Padding(padding: const EdgeInsets.all(20.0), child: Column(
                children: [
                  RichText(
                    textAlign: TextAlign.left,
                    text: const TextSpan(
                      style: TextStyle(fontSize: 24, height: 1.4),
                      children: [
                        TextSpan(
                          text: 'Connect with people \n',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.indigo,
                            fontSize: 28,
                          ),
                        ),
                        TextSpan(
                          text: 'around you ',
                          style: TextStyle(
                            color: Colors.black87,
                            fontWeight: FontWeight.bold,
                            fontSize: 28,
                          ),
                        ),
                        TextSpan(
                          text: 'effortlessly and instantly',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.orange,
                            fontSize: 28,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    "Your chats are protected with end-to-end encryption so you can message freely and securely.",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[700],
                    ),
                  ),
                ],
              ), )
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16),
            child: Column(
              children: [
                // Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (_) => const LoginScreen()));
                    },
                    icon: const Icon(Icons.rocket_launch_outlined, color: Colors.white),
                    label: const Text(
                      'Start Messaging',
                      style: TextStyle(color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(40),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                  ),
                ),

                const SizedBox(height: 24),

              ],
            ),
          ),
        ],
      ),
    );
  }

}