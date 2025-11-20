import 'dart:developer' as devtools show log;
import 'package:client/app/theme/app_pallete.dart';
import 'package:client/core/widgets/auth_gradient_button.dart';
import 'package:client/core/widgets/custom_field.dart';
//import 'package:client/features/repositories/auth_remote_repository.dart';
import 'package:flutter/material.dart';

/// SignUp page
class LogInPage extends StatefulWidget {
  /// Creates a [LogInPage].
  const LogInPage({super.key});

  @override
  State<LogInPage> createState() => _LogInPageState();
}

class _LogInPageState extends State<LogInPage> {
  final formKey = GlobalKey<FormState>();
  late final List<TextEditingController> _controllers;
  final List<String> textFieldsHintMessages = [
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
                'Sign In.',
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
                text: 'Sign In',
                onPressed: () async {
                  try {
                    /* final response = await AuthRemoteRepository().login(
                      email: _controllers[0].text,
                      password: _controllers[1].text,
                    );
                    devtools.log(response.toString()); */
                  } catch (e) {
                    devtools.log(e.toString());
                  }
                },
              ),
              const SizedBox(
                height: 20,
              ),
              GestureDetector(
                onTap: () {
                  Navigator.pop(
                    context,
                  );
                },
                child: RichText(
                  text: TextSpan(
                    text: "Don't have an account? ",
                    style: Theme.of(context).textTheme.bodyMedium,
                    children: [
                      TextSpan(
                        text: 'Sign Up',
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
