import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/models/home_model.dart';
import 'package:shop_app/modules/categories/categories_screen.dart';
import 'package:shop_app/modules/favorites/favorites_screen.dart';
import 'package:shop_app/modules/settings/settings_screen.dart';
import 'package:shop_app/shared/components/components.dart';
import 'package:shop_app/shared/components/constants.dart';
import 'package:shop_app/shared/network/end_points.dart';
import 'package:shop_app/shared/network/remote/dio_helper.dart';

import '../../models/categories_model.dart';
import '../../models/change_favorites_model.dart';
import '../../models/favorites_model.dart';
import '../../models/login_model.dart';
import '../../modules/products/products_screen.dart';
import '../network/local/cash_helper.dart';
import 'states.dart';

class AppCubit extends Cubit<AppStates>
{
  AppCubit() : super(AppInitialState());

  // Get context to Easily use in a different places in all Project
  static AppCubit get(context) => BlocProvider.of(context);

  // Get Home Data
  HomeModel? homeModel;
  Map<int, bool> favorites = {};
  void getHomeData()
  {
    emit(AppLoadingHomeDataState());
    
    DioHelper.getData(url: HOME, token: token).then((value)
    {
      homeModel = HomeModel.fromJson(value.data);
      for (var element in homeModel!.data!.products!) {
        favorites.addAll({
          element.id!: element.inFavorites!,
        });
      }
      emit(AppSuccessHomeDataState());
    }).catchError((error)
    {
      emit(AppErrorHomeDataState());
    });
  }

  // Function to Get Categories Data with API by using Dio
  CategoriesModel? categoriesModel;
  void getCategoriesModel() {
    DioHelper.getData(
      url: GET_CATEGORIES,
      token: token,
    ).then((value) {
      categoriesModel = CategoriesModel.fromJson(value.data);
      emit(AppGetCategoriesSuccessState());
    }).catchError((error) {
      emit(AppGetCategoriesErrorState(error));
    });
  }

  // Change Favorites
  ChangeFavoritesModel? changeFavoritesModel;
  void changeFavorites(int productId) {
    favorites[productId] = !favorites[productId]!;

    emit(AppChangeFavoritesState());

    DioHelper.postData(
      url: FAVORITES,
      data: {
        'product_id': productId,
      },
      token: token,
    ).then((value) {
      changeFavoritesModel = ChangeFavoritesModel.fromJson(value.data);

      if (!changeFavoritesModel!.status!) {
        favorites[productId] = !favorites[productId]!;
      }else
      {
        getFavorites();
      }

      emit(AppChangeFavoritesSuccessState(changeFavoritesModel!));
    }).catchError((error) {
      favorites[productId] = !favorites[productId]!;

      emit(AppChangeFavoritesErrorState());
    });
  }

  // Function to Get Favorites Data with API by using Dio
  FavoritesModel? favoritesModel;
  void getFavorites() {
    emit(AppGetFavoritesLoadingState());
    DioHelper.getData(
      url: FAVORITES,
      token: token,
    ).then((value) {
      favoritesModel = FavoritesModel.fromJson(value.data);
      emit(AppGetFavoritesSuccessState());
    }).catchError((error) {
      emit(AppGetFavoritesErrorState());
    });
  }

  // Get User Data
  LoginModel? userModel;
  void getUserData() {
    emit(AppGetUserDataLoadingState());

    DioHelper.getData(
      url: PROFILE,
      token: token,
    ).then((value) {
      userModel = LoginModel.fromJson(value.data);
      emit(AppGetUserDataSuccessState(userModel));
    }).catchError((error) {
      emit(AppGetUserDataErrorState(error));
    });
  }

  // Update User Data
  void updateUserData({
    required String name,
    required String email,
    required String phone,
  }) {
    emit(AppUpdateUserDataLoadingState());

    DioHelper.putData(
      url: UPDATE_PROFILE,
      token: token,
      data: {
        'name': name,
        'email': email,
        'phone': phone,
      },
    ).then((value) {
      userModel = LoginModel.fromJson(value.data);

      emit(AppUpdateUserDataSuccessState(userModel));
    }).catchError((error) {
      emit(AppUpdateUserDataErrorState(error));
    });
  }


  int counter = 0;
  void plus()
  {
    counter++;
    emit(AppCounterPlusState());
  }
  void minus()
  {
    counter--;
    emit(AppCounterMinusState());
  }

  // Bottom Nav Bar
  int currentIndex = 0;
  List<Widget> bottomScreen = [
    const ProductsScreen(),
    const CategoriesScreen(),
    const FavoriteScreen(),
    SettingsScreen(),
  ];

  void changeBottomNavBar(int index)
  {
    currentIndex = index;
    emit(AppChangeBottomNavigationBarState());
  }


  // Function to Change Theme mode
  bool isDark = false;

  void changeAppModeTheme({bool? fromShared}) {
    if (fromShared != null) {
      isDark = fromShared;
      emit(AppChangeModeThemeState());
    } else {
      isDark = !isDark;
      CacheHelper.saveData(key: 'isDark', value: isDark).then((value) {
        emit(AppChangeModeThemeState());
      });
    }
  }
}
