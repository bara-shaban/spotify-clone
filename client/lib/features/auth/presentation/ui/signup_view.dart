import 'dart:developer' as devtools show log;
import 'package:client/app/di/di.dart';
import 'package:client/app/theme/app_pallete.dart';
import 'package:client/core/errors/app_error.dart';
import 'package:client/core/widgets/auth_gradient_button.dart';
import 'package:client/core/widgets/custom_field.dart';
import 'package:client/features/auth/presentation/state/auth_notifier/auth_notifier.dart';
import 'package:client/features/auth/presentation/state/auth_state/auth_state.dart';
import 'package:client/features/auth/presentation/ui/login_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

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

  @override
  void dispose() {
    for (final controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.read(authProvider);

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
              CustomGradientButton(
                onPressed: () async {
                  try {
                    if (formKey.currentState!.validate()) {
                      await ref
                          .read(authProvider.notifier)
                          .signup(
                            name: _controllers[0].text.trim(),
                            email: _controllers[1].text.trim(),
                            password: _controllers[2].text.trim(),
                          );
                    }
                  } on ApiClientException catch (e) {
                    devtools.log(e.toString());
                  } catch (e) {
                    devtools.log(e.toString());
                  }
                },
                text: 'Sign Up',
              ),
              const SizedBox(
                height: 20,
              ),
              GestureDetector(
                onTap: () {
                  GoRouter.of(context).goNamed('login');
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
