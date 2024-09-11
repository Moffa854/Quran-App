import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../Core/Constant/color_app.dart';
import '../../../../Core/Constant/sizes_app.dart';
import '../../../../Core/Widget/build_elevated_button.dart';
import '../../../../Core/Widget/create_slide_transation.dart';
import '../../../../cubit/Username/username_cubit.dart';
import '../../../Home/Screens/home_page.dart';

class SignUpButtom extends StatelessWidget {
  const SignUpButtom({
    super.key,
    required this.formKey,
    required this.emailController,
    required this.passwordController,
    required this.nameController,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController nameController;

  @override
  Widget build(BuildContext context) {
    return BuildElevatedButton(
      fontSPhone: 13,
      fontSDesktop: 13,
      fontSTablet: 13,
      phoneWidth: 100,
      tabletWidth: 115,
      desktopWidth: 200,
      phonehight: 50,
      tablethight: 70,
      desktophight: 70,
      borderRadios: sizesApp(context, 10, 15, 20).toDouble(),
      backgroundColor: ColorApp.whitePink,
      colorText: ColorApp.purple,
      onPressed: () async {
        if (formKey.currentState!.validate()) {
          try {
            await FirebaseAuth.instance
                .createUserWithEmailAndPassword(
              email: emailController.text,
              password: passwordController.text,
            )
                .then((value) {
              if (context.mounted) {
                context.read<UsernameCubit>().saveUsername(nameController.text);
                Navigator.of(context).push(
                  createSlideTransation(
                    HomePage(
                      username: nameController.text,
                    ),
                    const Offset(0.0, 1.0),
                  ),
                );

                nameController.clear();
                passwordController.clear();
                emailController.clear();
              }
            });
          } on FirebaseAuthException catch (e) {
            String errorMessage;
            if (e.code == 'weak-password') {
              errorMessage = 'The password provided is too weak.';
            } else if (e.code == 'email-already-in-use') {
              errorMessage = 'The account already exists for that email.';
            } else {
              errorMessage = 'An error occurred. Please try again.';
            }

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Center(
                  child: Text(
                    errorMessage,
                    style: const TextStyle(
                      fontSize: 16,
                      fontFamily: 'Poppins SemiBold',
                      color: ColorApp.whitePink,
                    ),
                  ),
                ),
              ),
            );
          } catch (e) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Center(
                  child: Text(
                    'An unexpected error occurred. Please try again.',
                    style: TextStyle(
                      fontSize: 16,
                      fontFamily: 'Poppins SemiBold',
                      color: ColorApp.whitePink,
                    ),
                  ),
                ),
              ),
            );
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Center(
                child: Text(
                  'Please enter valid information.',
                  style: TextStyle(
                    fontSize: 16,
                    fontFamily: 'Poppins SemiBold',
                    color: ColorApp.whitePink,
                  ),
                ),
              ),
            ),
          );
        }
      },
      text: 'Sign Up',
      fontFamily: 'Poppins SemiBold',
    );
  }
}
