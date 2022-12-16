import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app_api_course_abdallah_mansour_design/components/constants.dart';
import '../helpers/cache_helper.dart';
import '../models/shop_login_model.dart';
import '../providers/shop_login_provider.dart';
import './shop_layout.dart';
import '../components/components.dart';
import '../screens/shop_register_screen.dart';

class ShopLoginScreen extends StatelessWidget {
  ShopLoginScreen({super.key});
  static const routeName = '/shop-login-screen';

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Consumer<ShopLoginProvider>(
      builder: (ctx, provider, _) => Scaffold(
        appBar: AppBar(),
        body: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'LOGIN',
                      style: Theme.of(context)
                          .textTheme
                          .headline4!
                          .copyWith(color: Colors.black),
                    ),
                    Text(
                      'Login now to browse our hot offers',
                      style: Theme.of(context)
                          .textTheme
                          .bodyText1!
                          .copyWith(color: Colors.grey),
                    ),
                    const SizedBox(height: 30),
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
                        loginFn(provider, context);
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
                              loginFn(provider, context);
                            },
                            text: 'Login',
                            isUpperCase: true,
                          ),
                    const SizedBox(height: 15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('Don\'t have an account?'),
                        defaultTextButton(
                            function: () {
                              Navigator.of(context)
                                  .pushNamed(ShopRegisterScreen.routeName);
                            },
                            text: 'Register Now'),
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

  void loginFn(ShopLoginProvider provider, BuildContext context) async {
    if (formKey.currentState!.validate()) {
      ShopLoginModel loginData = await provider
          .userLoginOrRegister(
              email: emailController.text,
              password: passwordController.text,
              endPoint: 'login')
          .catchError((e) {
        showToast(
            text: 'Something Went Wrong, We are sorry',
            state: ToastStates.ERROR);
      });

      if (loginData.status == false) {
        showToast(text: loginData.message!, state: ToastStates.ERROR);
      } else {
        await CacheHelper.saveData(key: "token", value: loginData.data?.token)
            .then((value) {
          token = loginData.data?.token;
          navigateAndFinish(context, const ShopLayout());
        });
        showToast(text: loginData.message!, state: ToastStates.SUCCESS);
      }
    }
  }
}
