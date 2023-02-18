import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:shop_app/shared/components/components.dart';

import '../../models/categories_model.dart';
import '../../models/home_model.dart';
import '../../shared/cubit/cubit.dart';
import '../../shared/cubit/states.dart';
import '../../shared/style/colors.dart';
import 'products_details.dart';

class ProductsScreen extends StatelessWidget {
  const ProductsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {
        // TODO: implement listener
        if(state is AppChangeFavoritesSuccessState)
        {
          if(!state.model.status!)
          {
            showToast(message: state.model.message!, state: ToastStates.ERROR,);
          }
        }
      },
      builder: (context, state) {
        var cubit = AppCubit.get(context);
        return ConditionalBuilder(
          condition: cubit.homeModel != null &&
              AppCubit.get(context).categoriesModel != null,
          builder: (context) => productsBuilder(
            cubit.homeModel!,
            cubit.categoriesModel!,
            context,
          ),
          fallback: (context) => const Center(child: CircularProgressIndicator()),
        );
      },
    );
  }

  Widget productsBuilder(
      HomeModel model,
      CategoriesModel categoriesModel,
      context,
      ) =>
      SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            CarouselSlider(
              items: model.data!.banners!
                  .map(
                    (e) => Image(
                  image: NetworkImage(
                    e.image!,
                  ),
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
              )
                  .toList(),
              options: CarouselOptions(
                height: 250.0,
                initialPage: 0,
                viewportFraction: 1.0,
                autoPlay: true,
                autoPlayInterval: const Duration(
                  seconds: 2,
                ),
                autoPlayAnimationDuration: const Duration(
                  seconds: 1,
                ),
                autoPlayCurve: Curves.fastLinearToSlowEaseIn,
                scrollDirection: Axis.horizontal,
                reverse: false,
                enableInfiniteScroll: true,
              ),
            ),
            const SizedBox(
              height: 10.0,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Categories',
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  SizedBox(
                    height: 120.0,
                    child: ListView.separated(
                      physics: const BouncingScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) =>
                          buildCategoryItem(categoriesModel.data!.data[index]),
                      separatorBuilder: (context, index) => const SizedBox(
                        width: 10.0,
                      ),
                      itemCount: categoriesModel.data!.data.length,
                    ),
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  const Text(
                    'New Products',
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 10.0,
            ),
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              mainAxisSpacing: 1.0,
              crossAxisSpacing: 1.0,
              childAspectRatio: 1 / 1.168,
              children: List.generate(
                model.data!.products!.length,
                    (index) => buildGridViewProduct(
                  model.data!.products![index],
                      context,
                ),
              ),
            ),
          ],
        ),
      );

  // The GridView
  Widget buildGridViewProduct(
      ProductModel model,
      context,
      ) =>
      InkWell(
        onTap: () {
          navigateTo(
            context,
            ProductDetailsScreen(
              productDetailsName: model.name!,
              productDetailsPicture: model.image!,
              productDetailsPrice: model.price,
              productDetailsOldPrice: model.oldPrice,
              productDetailsDescription: model.description!,
              productDetailsId: model.id!,
            ),
          );
        },
        child: Container(
          color: Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                alignment: AlignmentDirectional.bottomStart,
                children: [
                  Image(
                    image: NetworkImage(model.image!),
                    width: double.infinity,
                    height: 120.0,
                  ),
                  if (model.discount != 0)
                    Container(
                      color: Colors.red,
                      padding: const EdgeInsets.symmetric(horizontal: 2.0),
                      child: const Text(
                        'DISCOUNT',
                        style: TextStyle(
                          fontSize: 13.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                ],
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        model.name!,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          height: 1.3,
                        ),
                      ),
                      const Spacer(),
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 9.0),
                            child: Text(
                              '${model.price.round()}',
                              style: const TextStyle(
                                color: defaultColor,
                                fontSize: 13.0,
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 10.0,
                          ),
                          if (model.discount != 0)
                            Text(
                              '${model.oldPrice.round()}',
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                                decoration: TextDecoration.lineThrough,
                              ),
                            ),
                          const Spacer(),
                          IconButton(
                            onPressed: () {
                              AppCubit.get(context).changeFavorites(model.id!);
                            },
                            icon: CircleAvatar(
                              radius: 14.0,
                              backgroundColor: AppCubit.get(context).favorites[model.id]! ? defaultColor: Colors.grey[300],
                              child: const Icon(
                                Icons.favorite_border,
                                size: 18.0,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );

  // Category item
  Widget buildCategoryItem(DataModel model) => Stack(
    alignment: AlignmentDirectional.bottomCenter,
    children: [
      Image(
        image: NetworkImage(
          '${model.image}',
        ),
        width: 100,
        height: 110,
        fit: BoxFit.cover,
      ),
      Container(
        width: 100,
        height: 20,
        color: Colors.black.withOpacity(0.7),
        child: Text(
          '${model.name}',
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontSize: 13.0,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    ],
  );
}
