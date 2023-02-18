// ignore_for_file: must_be_immutable

import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../layout/home_layout.dart';
import '../../shared/components/components.dart';
import '../../shared/components/constants.dart';
import '../../shared/network/local/cash_helper.dart';
import '../login/login_screen.dart';
import 'register_cubit/register_cubit.dart';
import 'register_cubit/register_states.dart';

class RegisterScreen extends StatelessWidget {
  RegisterScreen({Key? key}) : super(key: key);

  late var formKey = GlobalKey<FormState>();
  var nameController = TextEditingController();
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => RegisterCubit(),
      child: BlocConsumer<RegisterCubit, RegisterStates>(
        listener: (BuildContext context, state) {
          if (state is RegisterSuccessState) {
            if (state.loginModel!.status!) {
              CacheHelper.saveData(
                key: 'token',
                value: state.loginModel?.data?.token,
              ).then((value) {
                token = state.loginModel?.data?.token;

                navigateAndFinish(
                  context,
                  const HomeLayout(),
                );
              });
              showToast(
                message: '${state.loginModel?.message}',
                state: ToastStates.SUCCESS,
              );
            } else {
              showToast(
                message: '${state.loginModel?.message}',
                state: ToastStates.ERROR,
              );
            }
          }
        },
        builder: (BuildContext context, state) {
          return Scaffold(
            appBar: AppBar(),
            body: Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(25.0),
                  child: Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'REGISTER',
                          style:
                          Theme.of(context).textTheme.headline4?.copyWith(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        //SizedBox between Register Text and Register to Start Text
                        const SizedBox(
                          height: 15.0,
                        ),

                        Text(
                          'Register to start brows our hot offers',
                          style: Theme.of(context)
                              .textTheme
                              .bodyText1
                              ?.copyWith(color: Colors.grey),
                        ),

                        //SizedBox between Register to start Text and Name TextFormField
                        const SizedBox(
                          height: 45.0,
                        ),

                        // TextFormField of Name
                        defaultTextFormField(
                          controller: nameController,
                          keyboardType: TextInputType.name,
                          label: 'User Name',
                          validator: (String? value) {
                            if (value!.isEmpty) {
                              return 'Name must not be empty';
                            }
                            return null;
                          },
                          prefix: Icons.person,
                        ),

                        //SizedBox between Email and Password TextFormField
                        const SizedBox(
                          height: 15.0,
                        ),

                        // TextFormField of Email
                        defaultTextFormField(
                          controller: emailController,
                          keyboardType: TextInputType.emailAddress,
                          label: 'Email Address',
                          validator: (String? value) {
                            if (value!.isEmpty) {
                              return 'Email must not be empty';
                            }
                            if (!RegExp(
                                "^[a-zA-Z0-9_.-]+@[a-zA-Z0-9.-]+.[a-z]")
                                .hasMatch(value)) {
                              return 'Enter valid email';
                            }
                            return null;
                          },
                          prefix: Icons.email_outlined,
                        ),

                        //SizedBox between Email and Password TextFormField
                        const SizedBox(
                          height: 15.0,
                        ),

                        // TextFormField of Password
                        defaultTextFormField(
                          controller: passwordController,
                          keyboardType: TextInputType.visiblePassword,
                          label: 'Password',
                          validator: (String? value) {
                            if (value!.isEmpty) {
                              return 'Please enter your email address';
                            }
                            return null;
                          },
                          secure: RegisterCubit.get(context).isPasswordShown,
                          prefix: Icons.password,
                          suffix: RegisterCubit.get(context).suffix,
                          suffixPressed: () {
                            RegisterCubit.get(context)
                                .changePasswordVisibility();
                          },
                        ),
                        //SizedBox between Password and Phone TextFormField
                        const SizedBox(
                          height: 30.0,
                        ),

                        // TextFormField of phone
                        defaultTextFormField(
                          controller: phoneController,
                          keyboardType: TextInputType.phone,
                          label: 'Phone',
                          validator: (String? value) {
                            if (value!.isEmpty) {
                              return 'Phone must not be empty';
                            }
                            return null;
                          },
                          prefix: Icons.person,
                        ),

                        //SizedBox between Email and Password TextFormField
                        const SizedBox(
                          height: 15.0,
                        ),

                        // Login Button
                        ConditionalBuilder(
                          condition: state is! RegisterLoadingState,
                          builder: (context) => Container(
                            alignment: Alignment.center,
                            child: defaultButton(
                              onPressed: () {
                                if (formKey.currentState!.validate()) {
                                  RegisterCubit.get(context).userRegister(
                                      name: nameController.text,
                                      email: emailController.text,
                                      password: passwordController.text,
                                      phone: phoneController.text);
                                }
                              },
                              text: 'REGISTER',
                            ),
                          ),
                          fallback: (context) =>
                          const Center(child: CircularProgressIndicator()),
                        ),

                        //SizedBox between Login Button and Don't have an account
                        const SizedBox(
                          height: 15.0,
                        ),

                        // Row that contain Don't have an account text and Register TextButton
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              'Have an account?',
                            ),
                            defaultTextButton(
                              onPressed: () {
                                navigateTo(
                                  context,
                                  LoginScreen(),
                                );
                              },
                              text: 'Login',
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}