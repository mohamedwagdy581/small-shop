import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/modules/search/search_cubit/search_state.dart';

import '../../shared/components/components.dart';
import 'search_cubit/search_cubit.dart';

// ignore: must_be_immutable
class SearchScreen extends StatelessWidget {
  SearchScreen({Key? key}) : super(key: key);

  late var formKey = GlobalKey<FormState>();
  var searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SearchCubit(),
      child: BlocConsumer<SearchCubit, SearchStates>(
        listener: (context, state) {
          // TODO: implement listener
        },
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Search'),
            ),
            body: Form(
              key: formKey,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children:
                  [
                    // TextFormField of Password
                    defaultTextFormField(
                      controller: searchController,
                      keyboardType: TextInputType.text,
                      label: 'Search',
                      validator: (String? value) {
                        if (value!.isEmpty) {
                          return 'Enter text to search';
                        }
                        return null;
                      },
                      onSubmitted: (String text)
                      {
                        SearchCubit.get(context).search(text);
                      },
                      prefix: Icons.search,
                    ),

                    const SizedBox(height: 10.0,),
                    if(state is SearchLoadingState)
                      const LinearProgressIndicator(),
                    const SizedBox(height: 10.0,),
                    if(state is SearchSuccessState)
                      Expanded(
                      child: ListView.separated(
                        physics: const BouncingScrollPhysics(),
                        itemBuilder: (context, index) => buildListProduct(
                            SearchCubit.get(context).searchModel!.data!.data![index], context, isOldPrice: false),
                        separatorBuilder: (context, index) => const Padding(
                          padding: EdgeInsets.only(left: 20.0),
                          child: Divider(
                            thickness: 2,
                          ),
                        ),
                        itemCount: SearchCubit.get(context).searchModel!.data!.data!.length,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
