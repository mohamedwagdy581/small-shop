import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../models/login_model.dart';
import '../../shared/components/components.dart';
import '../../shared/components/constants.dart';
import '../../shared/cubit/cubit.dart';
import '../../shared/cubit/states.dart';

// ignore: must_be_immutable
class SettingsScreen extends StatelessWidget {
  SettingsScreen({Key? key}) : super(key: key);

  var formKey = GlobalKey<FormState>();
  late var emailController = TextEditingController();
  late var nameController = TextEditingController();
  late var phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {
        if (state is AppGetUserDataSuccessState) {
          nameController.text = AppCubit.get(context).userModel!.data!.name!;
          emailController.text = AppCubit.get(context).userModel!.data!.email!;
          phoneController.text = AppCubit.get(context).userModel!.data!.phone!;
        }
      },
      builder: (context, state) {
        LoginModel? model = AppCubit.get(context).userModel;

        nameController.text = model!.data!.name!;
        emailController.text = model.data!.email!;
        phoneController.text = model.data!.phone!;
        return ConditionalBuilder(
          condition: AppCubit.get(context).userModel != null,
          builder: (context) => Padding(
            padding: const EdgeInsets.all(20.0),
            child: Form(
              key: formKey,
              child: Column(
                children: [
                  if (state is AppUpdateUserDataLoadingState)
                    const LinearProgressIndicator(),

                  const SizedBox(
                    height: 20.0,
                  ),

                  // Name TextFormField of User
                  defaultTextFormField(
                    controller: nameController,
                    keyboardType: TextInputType.name,
                    label: 'Name',
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Name must not be Empty';
                      }
                      return null;
                    },
                    prefix: Icons.person,
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),

                  // Email TextFormField of User
                  defaultTextFormField(
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    label: 'Email Address',
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Email must not be empty';
                      }
                      return null;
                    },
                    prefix: Icons.email,
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),

                  // Phone TextFormField of user
                  defaultTextFormField(
                    controller: phoneController,
                    keyboardType: TextInputType.phone,
                    label: 'Phone',
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Phone must not be empty';
                      }
                      return null;
                    },
                    prefix: Icons.phone,
                  ),

                  const SizedBox(
                    height: 30.0,
                  ),

                  // Update Button
                  defaultButton(
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        AppCubit.get(context).updateUserData(
                          name: nameController.text,
                          email: emailController.text,
                          phone: phoneController.text,
                        );
                      }
                    },
                    text: 'UPDATE',
                  ),

                  const SizedBox(
                    height: 20.0,
                  ),

                  // Logout Button
                  defaultButton(
                    onPressed: () {
                      signOut(context);
                    },
                    text: 'LOGOUT',
                  ),
                ],
              ),
            ),
          ),
          fallback: (context) => const Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }
}
