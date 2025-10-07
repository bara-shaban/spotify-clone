import 'dart:developer' as devtools show log;
import 'package:client/core/theme/app_pallete.dart';
import 'package:client/features/auth/login/ui/login_view.dart';
import 'package:client/core/widgets/auth_gradient_button.dart';
import 'package:client/core/widgets/custom_field.dart';
import 'package:client/features/auth/view_model/auth_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// SignUp page
class SignUpPage extends ConsumerStatefulWidget {
  /// Creates a [SignUpPage].
  const SignUpPage({super.key});

  @override
  ConsumerState<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends ConsumerState<SignUpPage> {
  final formKey = GlobalKey<FormState>();
  late final List<TextEditingController> _controllers;
  final List<String> textFieldsHintMessages = [
    'Name',
    'Email',
    'Passwords',
  ];
  @override
  void initState() {
    _controllers = List.generate(
      textFieldsHintMessages.length,
      (index) => TextEditingController(),
    );
    super.initState();
  }

  Future<void> _signUpUser() async {
    try {
      if (formKey.currentState!.validate()) {
        await ref
            .read(authViewModelProvider.notifier)
            .signUpUser(
              name: _controllers[0].text,
              email: _controllers[1].text,
              password: _controllers[2].text,
            );
      }
    } on Exception catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString()),
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    for (final controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final value = ref.watch(authViewModelProvider);
    devtools.log('AuthViewModel state: $value');
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),

        child: Form(
          key: formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Sign Up.',
                style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 30,
              ),
              ...List.generate(
                textFieldsHintMessages.length - 1,
                (index) {
                  return Column(
                    children: [
                      CustomField(
                        hintText: textFieldsHintMessages[index],
                        controller: _controllers[index],
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                    ],
                  );
                },
              ),
              CustomField(
                hintText: textFieldsHintMessages.last,
                controller: _controllers.last,
                isPassword: true,
              ),
              const SizedBox(
                height: 20,
              ),
              ref
                  .watch(authViewModelProvider)
                  .when(
                    data: (user) => CustomGradientButton(
                      text: 'Sign Up',
                      onPressed: _signUpUser,
                    ),
                    loading: () => const CircularProgressIndicator(),
                    error: (error, stackTrace) {
                      Text('Error: $error');
                      return CustomGradientButton(
                        text: 'Sign Up',
                        onPressed: _signUpUser,
                      );
                    },
                  ),
              const SizedBox(
                height: 20,
              ),
              GestureDetector(
                onTap: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute<Widget>(
                      builder: (context) => const LogInPage(),
                    ),
                  );
                },
                child: RichText(
                  text: TextSpan(
                    text: 'Already have an account? ',
                    style: Theme.of(context).textTheme.bodyMedium,
                    children: [
                      TextSpan(
                        text: 'Sign In',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppPalette.gradient3,
                          fontWeight: FontWeight.bold,
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
    );
  }
}
