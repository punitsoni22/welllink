import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:welllink/utils/common_widgets/common_app_bar.dart';
import 'package:welllink/utils/common_widgets/common_button.dart';
import 'package:welllink/utils/common_widgets/common_textfield.dart';
import 'package:welllink/utils/constant/extensions/text_style_extensions.dart';

import '../login_view/controller/login_controller.dart';

class RegisterView extends GetView<LoginController> {
  const RegisterView({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        body: Column(
          children: [
            CommonAppBar(
              title: 'Sign Up',
              colorScheme: colorScheme,
              isBackAllowed: false,
            ),
            Expanded(
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 12.w, vertical: 40.h),
                  child: Column(
                    children: [
                      _logInWidget(context),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _logInWidget(BuildContext context) {
    return Column(
      children: [
        CommonTextField(
          label: 'Name',
          hintText: 'John Doe',
          controller: controller.nameController,
          leadingIcon: Icons.person,
        ),
        SizedBox(height: 12.h),
        CommonTextField(
          label: 'Email',
          hintText: 'example@gmail.com',
          controller: controller.emailController,
          leadingIcon: Icons.email,
        ),
        SizedBox(height: 12.h),
        CommonTextField(
          label: 'Password',
          hintText: '********',
          controller: controller.passwordController,
          leadingIcon: Icons.password,
          initialObscure: true,
        ),
        SizedBox(height: 10.h),
        Obx(
          () => Row(
            children: [
              Checkbox(
                value: controller.isTermsAccepted.value,
                onChanged: (value) {
                  controller.isTermsAccepted.value =
                      !controller.isTermsAccepted.value;
                },
                activeColor: Theme.of(context).colorScheme.primary,
              ),
              Flexible(
                child: RichText(
                  text: TextSpan(
                    text: 'I agree to the ',
                    style: context.mediumBodyText(),
                    children: [
                      TextSpan(
                        text: 'Terms of Service',
                        style: context.linkText(),
                      ),
                      TextSpan(
                        text: ' and ',
                        style: context.mediumBodyText(),
                      ),
                      TextSpan(
                        text: 'Privacy Policy',
                        style: context.linkText(),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 30.h),
        Obx(
          () => CommonButton(
            onPressed:
                controller.isLoading.value || !controller.isTermsAccepted.value
                    ? null
                    : () {
                        controller.register();
                      },
            text: 'Sign up',
            isSaving: controller.isLoading.value,
          ),
        ),
        SizedBox(height: 8.h),
        GestureDetector(
          onTap: () {
            Get.back();
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Already have an account? ',
                  style: context.mediumBodyText()),
              Text('Sign in', style: context.linkText())
            ],
          ),
        ),
      ],
    );
  }
}
