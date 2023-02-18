import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/layout/home_layout.dart';
import 'package:shop_app/shared/components/components.dart';

import '../../shared/components/big_text.dart';
import '../../shared/components/expandable_widget.dart';
import '../../shared/cubit/cubit.dart';
import '../../shared/cubit/states.dart';

class ProductDetailsScreen extends StatelessWidget {
  final int productDetailsId;
  final String productDetailsName;
  final String productDetailsPicture;
  final dynamic productDetailsPrice;
  final dynamic productDetailsOldPrice;
  final String productDetailsDescription;
  const ProductDetailsScreen(
      {
        Key? key,
        required this.productDetailsId,
        required this.productDetailsName,
        required this.productDetailsPicture,
        required this.productDetailsPrice,
        required this.productDetailsOldPrice,
        required this.productDetailsDescription,
      }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return Scaffold(
          backgroundColor: Colors.white,
          body: CustomScrollView(
            slivers: [
              SliverAppBar(
                automaticallyImplyLeading: false,
                toolbarHeight: 70,
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    appIcon(
                      onTap: ()
                      {
                        navigateAndFinish(context, const HomeLayout());
                      },
                      icon: Icons.clear,
                    ),
                    Stack(
                      children: [
                        appIcon(
                          onTap: () {},
                          icon: Icons.shopping_cart_outlined,
                        ),

                        // BackGround of Quantity Number
                        Positioned(
                          right: 0,
                          top: 0,
                          child: appIcon(
                            onTap: () {},
                            icon: Icons.circle,
                            size: 20,
                            iconColor: Colors.transparent,
                            backgroundColor: const Color(0xFF89dad0),
                          ),
                        ),

                        // Quantity Numbers
                        Positioned(
                          right: 3,
                          top: 3,
                          child: BigText(text: '10',
                            size: 12.0, color: Colors.white,),
                        ),
                      ],
                    ),
                  ],
                ),
                pinned: true,
                backgroundColor: Colors.yellow,
                expandedHeight: 320,
                flexibleSpace: FlexibleSpaceBar(
                  background: Image.network(
                    productDetailsPicture,
                    width: double.maxFinite,
                    fit: BoxFit.cover,
                  ),
                ),
                bottom: PreferredSize(
                  preferredSize: const Size.fromHeight(20),
                  child: Container(
                    width: double.maxFinite,
                    padding: const EdgeInsets.only(
                      top: 5,
                      bottom: 10,
                    ),
                    alignment: Alignment.center,
                    decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(
                            20,
                          ),
                          topLeft: Radius.circular(
                            20,
                          ),
                        )),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20.0),
                      child: BigText(
                        text: productDetailsName,
                        size: 20,
                      ),
                    ),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(
                        left: 20,
                        right: 20,
                      ),
                      child: ExpandableTextWidget(
                        text: productDetailsDescription,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          bottomNavigationBar: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  left: 20,
                  right: 20,
                  top: 10,
                  bottom: 10,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    appIcon(
                      onTap: () {
                        if(AppCubit.get(context).counter > 0)
                        {
                          AppCubit.get(context).minus();
                        }else
                        {
                          showToast(message: "You can't reduce more !", state: ToastStates.ERROR);
                        }
                        //controller.setQuantity(false);
                      },
                      icon: Icons.remove,
                      iconSize: 26,
                      backgroundColor: const Color(0xFF89dad0),
                      iconColor: Colors.white,
                    ),
                    BigText(
                      text: '\$ $productDetailsPrice X  ${AppCubit.get(context).counter}',
                      //color: AppColors.mainBlackColor,
                      size: 26,
                    ),
                    appIcon(
                      onTap: () {
                        if(AppCubit.get(context).counter < 20)
                        {
                          AppCubit.get(context).plus();
                        }else
                        {
                          showToast(message: "You can't add more !", state: ToastStates.ERROR);
                        }

                        //controller.setQuantity(true);
                      },
                      icon: Icons.add,
                      iconSize: 26,
                      backgroundColor: const Color(0xFF89dad0),
                      iconColor: Colors.white,
                    ),
                  ],
                ),
              ),
              Container(
                height: 130,
                padding: const EdgeInsets.only(
                  top: 30,
                  bottom: 30,
                  left: 30,
                  right: 30,
                ),
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(
                      40,
                    ),
                    topLeft: Radius.circular(
                      40,
                    ),
                  ),
                  color: Color(0xFFf7f6f4),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.only(
                        top: 20,
                        bottom: 20,
                        right: 20,
                        left: 20,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(
                          20,
                        ),
                      ),
                      child: const Icon(
                        Icons.favorite, color: Color(0xFF89dad0), size: 26,),
                    ),
                    GestureDetector(
                      onTap: () {
                        //controller.addItem(product);
                      },
                      child: Container(
                        padding: const EdgeInsets.only(
                          top: 20,
                          bottom: 20,
                          right: 20,
                          left: 20,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFF89dad0),
                          borderRadius: BorderRadius.circular(
                            20,
                          ),
                        ),
                        child: BigText(
                          text: '\$ $productDetailsPrice | Add to Cart',
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget appIcon({
    required VoidCallback onTap,
    required IconData icon,
    Color iconColor = const Color(0xFF756d54),
    Color backgroundColor = const Color(0xFFfcf4e4),
    double size = 40.0,
    double iconSize = 16.0,
  }) =>
      GestureDetector(
        onTap: onTap,
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(size / 2),
            color: backgroundColor,
          ),
          child: Icon(
            icon, color: iconColor,
            size: iconSize,
          ),
        ),
      );

  Widget appSmallDetailsColumn({
    String? text,
    double textSize = 0,
    double rating = 4.5,
    double comments = 1287,
    double time = 32,
    double distance = 1.7,
  }) =>
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('dddddd'),
          const SizedBox(
            height: 10,
          ),
          Row(
            children: [
              Wrap(
                children: List.generate(
                  5,
                      (index) =>
                  const Icon(
                    Icons.star,
                    color: Colors.greenAccent,
                    size: 15.0,
                  ),
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              const Text('Rating'),
              const SizedBox(
                width: 15,
              ),
              const Text('2000'),
              const SizedBox(
                width: 10,
              ),
              const Text('Comments'),
            ],
          ),
          const SizedBox(
            height: 15,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              iconAndTextWidget(
                icon: Icons.circle_sharp,
                iconColor: Colors.black,
                text: 'Normal',
              ),
              iconAndTextWidget(
                icon: Icons.location_on,
                iconColor: Colors.greenAccent,
                text: '$distance km',
              ),
              iconAndTextWidget(
                icon: Icons.access_time_rounded,
                iconColor: Colors.pink,
                text: '$time min',
              ),
            ],
          ),
        ],
      );

  Widget iconAndTextWidget({
    required IconData icon, required Color iconColor, required String text,
  }) =>
      Row(
        children:
        [
          Icon(icon, color: iconColor, size: 24,),
          const SizedBox(width: 5.0,),
          Text(text),
        ],
      );

}
