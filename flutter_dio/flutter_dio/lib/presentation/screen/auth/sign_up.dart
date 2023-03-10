import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dio/user.dart';
import 'package:flutter_dio/presentation/screen/auth/sign_in.dart';
import 'package:flutter_dio/presentation/widgets/custom_button.dart';
import 'package:flutter_dio/presentation/widgets/text_field_obscure.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dio/state/cubit/auth/auth_cubit.dart';


class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);
  static const routeName = '/signup';

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  GlobalKey<FormState> _key = GlobalKey();

  TextEditingController _lastNameController = TextEditingController();
  TextEditingController _firstNameController = TextEditingController();
  TextEditingController _middleNameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _loginController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  bool isObscure = false;


@override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _key,
            child: BlocConsumer<AuthCubit, AuthState>(
              listener: (context, state) {
                if(state is ErrorState){
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message)));
                }
                if(state is SuccesState){
    //context.read<AuthCubit>().close();

                  Navigator.pushNamedAndRemoveUntil(context, SignIn.routeName, (route) => false);
                }
              },
              builder: (context, state) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Spacer(),
                    const Text(
                      '??????????????????????',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 26),
                    ),
                    const Spacer(),
                    TextFormField(
                      maxLength: 30,
                      controller: _emailController,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return '???????? ?????????????????????? ?????????? ????????????';
                        }
                        if (!isValidEmail(value)) {
                          return '???????????????????????? ???????? ?????????????????????? ??????????';
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                        hintText: 'Email',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      maxLength: 16,
                      controller: _loginController,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return '???????? ?????????? ????????????';
                        }
                        if (value.length < 3) {
                          return '?????????? ???????????? ???????? ???? ?????????? 3 ????????????????';
                        }
                        if (isValidFIOLogin(value)) {
                          return '?????????? ???????????? ?????????????????? ???????????? ???????? ?????????????? ?? ???????? ?????????????????? ??????????';
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                        hintText: '??????????',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      maxLength: 8,
                      controller: _passwordController,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return '???????? ???????????? ????????????';
                        }
                        if (value.length < 8) {
                          return '???????????? ???????????? ???????? ?????????????? 8 ????????????????';
                        }
                        if (!isValidPassword(value)) {
                          return '???????????? ???????????? ???????????????????? ?????????????? 1 ?????????????? ?????????????? ?????????????? 1 ???????????????? ?????????? ?????????????? 1 ???????????????? ?????????? ?????????????? 1 ?????????????????????? ???????????? ?????????? ???????????????????????????? ???????????? ( ! @ # \$ & * ~ )';
                        }
                        return null;
                      },
                      obscureText: isObscure,
                      decoration: InputDecoration(
                        hintText: '????????????',
                        suffixIcon: TextFieldObscure(isObscure: (value) {
                          setState(() {
                            isObscure = value;
                          });
                        }),
                        border: const OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 20),
                    CustomButton(
                      content: '??????????????????????',
                      onPressed: () {
                        if (_key.currentState!.validate()) {
                          signUp();
                        } else {}
                      },
                    ),
                    const Spacer(flex: 3),
                    Align(
                      alignment: Alignment.bottomLeft,
                      child: ElevatedButton(
                        onPressed: () => Navigator.pop(context),
                        style: ElevatedButton.styleFrom(
                          shape: const CircleBorder(),
                          padding: const EdgeInsets.all(15),
                        ),
                        child:
                            const Icon(Icons.arrow_back, color: Colors.white),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  void signUp() async {
    context.read<AuthCubit>().singUp(User(
      userName: _loginController.text,
      email: _emailController.text,
      password: _passwordController.text
    ));
  }

  bool isValidPassword(String value) {
    String pattern =
        r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';
    RegExp regExp = new RegExp(pattern);
    return regExp.hasMatch(value);
  }

  bool isValidEmail(String value) {
    String pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regExp = new RegExp(pattern);
    return regExp.hasMatch(value);
  }

  bool isValidFIOLogin(String value) {
    String pattern = r'^(?=.*?[A-Z])(?=.*?[a-z])$';
    RegExp regExp = new RegExp(pattern);
    return regExp.hasMatch(value);
  }
}
