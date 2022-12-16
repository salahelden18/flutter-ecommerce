import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app_api_course_abdallah_mansour_design/providers/shop_login_provider.dart';
import 'package:shopping_app_api_course_abdallah_mansour_design/screens/shop_layout.dart';

import '../components/components.dart';
import '../components/constants.dart';
import '../helpers/cache_helper.dart';
import '../models/shop_login_model.dart';

class ShopRegisterScreen extends StatelessWidget {
  ShopRegisterScreen({super.key});
  static const routeName = '/register-screen';

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final phoneController = TextEditingController();
  final nameController = TextEditingController();

  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
      ),
      body: Consumer<ShopLoginProvider>(
        builder: (ctx, provider, _) => Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Register',
                      style: Theme.of(context)
                          .textTheme
                          .headline4!
                          .copyWith(color: Colors.black),
                    ),
                    Text(
                      'Register now to browse our hot offers',
                      style: Theme.of(context)
                          .textTheme
                          .bodyText1!
                          .copyWith(color: Colors.grey),
                    ),
                    const SizedBox(height: 30),
                    defaultFormField(
                      controller: nameController,
                      type: TextInputType.name,
                      validate: (value) {
                        if (value!.isEmpty) {
                          return 'Please Enter your name';
                        }
                        return null;
                      },
                      label: 'Your Name',
                      prefix: Icons.person,
                    ),
                    const SizedBox(height: 15),
                    defaultFormField(
                      controller: phoneController,
                      type: TextInputType.number,
                      validate: (value) {
                        if (value!.isEmpty) {
                          return 'Please Enter your Phone Number';
                        }
                        return null;
                      },
                      label: 'Your Phone',
                      prefix: Icons.call,
                    ),
                    const SizedBox(height: 15),
                    defaultFormField(
                      controller: emailController,
                      type: TextInputType.emailAddress,
                      validate: (value) {
                        if (value!.isEmpty) {
                          return 'Please Enter your email address';
                        }
                        return null;
                      },
                      label: 'Email Address',
                      prefix: Icons.email_outlined,
                    ),
                    const SizedBox(height: 15),
                    defaultFormField(
                      controller: passwordController,
                      type: TextInputType.visiblePassword,
                      suffix: provider.suffix,
                      isPassword: provider.isPassword,
                      onSubmit: (value) {
                        loginOrRegisterFn(provider, context);
                      },
                      suffixPressed: provider.changePasswordVisibility,
                      validate: (value) {
                        if (value!.isEmpty) {
                          return 'Please Enter your Password';
                        }
                        return null;
                      },
                      label: 'Password',
                      prefix: Icons.lock_outline,
                    ),
                    const SizedBox(height: 15),
                    provider.isLoading
                        ? const Center(
                            child: CircularProgressIndicator(),
                          )
                        : defaultButton(
                            function: () {
                              loginOrRegisterFn(provider, context);
                            },
                            text: 'Register',
                            isUpperCase: true,
                          ),
                    const SizedBox(height: 15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('Already have an account? '),
                        defaultTextButton(
                            function: () {
                              Navigator.of(context).pop();
                            },
                            text: 'Login'),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void loginOrRegisterFn(
      ShopLoginProvider provider, BuildContext context) async {
    if (formKey.currentState!.validate()) {
      ShopLoginModel loginOrRegisterData = await provider
          .userLoginOrRegister(
        email: emailController.text,
        password: passwordController.text,
        name: nameController.text,
        phone: phoneController.text,
        endPoint: 'register',
      )
          .catchError((e) {
        showToast(
            text: 'Something Went Wrong, We are sorry',
            state: ToastStates.ERROR);
      });

      if (loginOrRegisterData.status == false) {
        showToast(text: loginOrRegisterData.message!, state: ToastStates.ERROR);
      } else {
        await CacheHelper.saveData(
                key: "token", value: loginOrRegisterData.data?.token)
            .then((value) {
          token = loginOrRegisterData.data?.token;
          navigateAndFinish(context, const ShopLayout());
        });
        showToast(
            text: loginOrRegisterData.message!, state: ToastStates.SUCCESS);
      }
    }
  }
}
