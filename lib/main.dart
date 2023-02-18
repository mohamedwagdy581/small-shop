import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


import 'firebase_options.dart';
import 'layout/home_layout.dart';
import 'modules/login/login_screen.dart';
import 'modules/on_boarding/on_boarding_screen.dart';
import 'shared/components/constants.dart';
import 'shared/cubit/cubit.dart';
import 'shared/cubit/states.dart';
import 'shared/network/local/cash_helper.dart';
import 'shared/network/remote/dio_helper.dart';
import 'shared/style/themes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  DioHelper.init();
  await CacheHelper.init();

  //bool? isDark = CacheHelper.getData(key: 'isDark');
  Widget? widget;
  bool? onBoarding = CacheHelper.getData(key: 'onBoarding');
  token = CacheHelper.getData(key: 'token');
  print(token);

  // ignore: unnecessary_null_comparison
  if (onBoarding != null) {
    // ignore: unnecessary_null_comparison
    if (token != null) {
      widget = const HomeLayout();
    } else {
      widget = LoginScreen();
    }
  } else {
    widget = const OnBoardingScreen();
  }
  runApp(ShopApp(startWidget: widget,));
}

class ShopApp extends StatelessWidget {
  final bool? isDark;
  final Widget startWidget;
  const ShopApp({super.key, this.isDark, required this.startWidget,});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AppCubit()
        ..getHomeData()
        ..getCategoriesModel()
        ..getFavorites()
        ..getUserData()
        ..changeAppModeTheme(fromShared: isDark,),
      child: BlocConsumer<AppCubit, AppStates>(
        listener: (context, state) {
          // TODO: implement listener
        },
        builder: (context, state) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Shop App',
            theme: lightTheme,
            darkTheme: darkTheme,
            themeMode: AppCubit.get(context).isDark ? ThemeMode.light : ThemeMode.dark,
            home: startWidget,
          );
        },
      ),
    );
  }
}