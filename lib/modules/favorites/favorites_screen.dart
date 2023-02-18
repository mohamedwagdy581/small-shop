import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/shared/components/components.dart';

import '../../shared/cubit/cubit.dart';
import '../../shared/cubit/states.dart';

class FavoriteScreen extends StatelessWidget {
  const FavoriteScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (BuildContext context, AppStates state) {},
      builder: (BuildContext context, AppStates state) {
        return ConditionalBuilder(
          condition: state is! AppGetFavoritesLoadingState,
          builder: (context) => ListView.separated(
            physics: const BouncingScrollPhysics(),
            itemBuilder: (context, index) => buildListProduct(
                AppCubit.get(context).favoritesModel!.data!.data![index].product!, context),
            separatorBuilder: (context, index) => const Padding(
              padding: EdgeInsets.only(left: 20.0),
              child: Divider(
                thickness: 2,
              ),
            ),
            itemCount: AppCubit.get(context).favoritesModel!.data!.data!.length,
          ),
          fallback: (context) => const Center(child: CircularProgressIndicator()),
        );
      },
    );
  }

}
