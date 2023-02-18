import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../cubit/cubit.dart';
import '../style/colors.dart';
//import 'package:fluttertoast/fluttertoast.dart';

// Reusable Navigate Function and return to the previous screen
void navigateTo(context, widget) => Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => widget,
  ),
);

// Reusable Navigate Function and remove the previous screen
void navigateAndFinish(context, widget) => Navigator.pushAndRemoveUntil(
  context,
  MaterialPageRoute(
    builder: (context) => widget,
  ),
      (route) => false,
);

// Reusable TextFormField Function with validator
Widget defaultTextFormField({
  required TextEditingController? controller,
  required TextInputType keyboardType,
  required String? label,
  TextStyle? textStyle,
  VoidCallback? onTap,
  required String? Function(String?)? validator,
  Function(String)? onSubmitted,
  bool secure = false,
  IconData? prefix,
  Color? prefixColor,
  IconData? suffix,
  Color? suffixColor,
  VoidCallback? suffixPressed,
  bool? isClickable,
}) =>
    TextFormField(
      style: textStyle,
      controller: controller,
      keyboardType: keyboardType,
      onTap: onTap,
      enabled: isClickable,
      validator: validator,
      obscureText: secure,
      onFieldSubmitted: onSubmitted,
      decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(
            prefix,
            color: prefixColor,
          ),
          suffixIcon: IconButton(
            icon: Icon(suffix),
            onPressed: suffixPressed,
            color: suffixColor,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5.0),
          )),
    );

Widget defaultSigningInRowButton({
  required String title,
  TextStyle? titleStyle,
  required double width,
  required IconData icon,
  Color iconColor = Colors.black,
  Color rowBackgroundColor = Colors.white,
  required VoidCallback onPressed,
}) =>
    Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: MaterialButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        color: rowBackgroundColor,
        onPressed: onPressed,
        child: Row(
          // mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 15.0),
              child: Icon(
                icon,
                color: iconColor,
              ),
            ),
            SizedBox(
              width: width,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                title,
                style: titleStyle,
              ),
            ),
          ],
        ),
      ),
    );

Widget defaultButton({
  required VoidCallback onPressed,
  required String text,
  Color? backgroundColor,
}) =>
    Container(
      //height: 50.0,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          textStyle: const TextStyle(fontSize: 20,fontWeight: FontWeight.bold,),
          shape: const BeveledRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10.0),),),
        ),
        child: Text(
          text,
        ),
      ),
    );

Widget customButton({
  required VoidCallback onPressed,
  required String text,
  Color? backgroundColor,
}) =>
    Container(
      //height: 50.0,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          textStyle: const TextStyle(fontSize: 20,fontWeight: FontWeight.bold,),
          shape: const BeveledRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10.0),),),
        ),
        child: Text(
          text,
        ),
      ),
    );

Widget customCard({
  required VoidCallback onTap,
  required String title,
}) =>
    Container(
      padding: const EdgeInsets.all(5.0),
      margin: const EdgeInsets.all(5.0),
      height: 200.0,
      width: 180.0,
      child: InkWell(
        onTap: onTap,
        child: Card(
          elevation: 15.0,
          child: Center(
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );


Widget defaultTextButton({
  required VoidCallback onPressed,
  required String text,
}) =>
    TextButton(
      onPressed: onPressed,
      child: Text(
        text.toUpperCase(),
        style: const TextStyle(
          fontSize: 15.0,
          fontWeight: FontWeight.bold,
        ),
      ),
    );

void showToast({
  required String message,
  required ToastStates state,
}) =>
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 5,
        backgroundColor: chooseToastColor(state),
        textColor: Colors.white,
        fontSize: 16.0);

// ignore: constant_identifier_names
enum ToastStates { SUCCESS, ERROR, WARNING }

Color? chooseToastColor(ToastStates state) {
  Color? color;

  switch (state) {
    case ToastStates.SUCCESS:
      color = Colors.green;
      break;
    case ToastStates.ERROR:
      color = Colors.red;
      break;
    case ToastStates.WARNING:
      color = Colors.yellow;
      break;
  }
  return color;
}

Widget customListTile({
  required VoidCallback onTapped,
  required Widget title,
  Widget? leadingWidget,
  Widget? trailingWidget,
}) {
  return InkWell(
    onTap: onTapped,
    child: ListTile(
      title: title,
      leading: leadingWidget,
      trailing: trailingWidget,
    ),
  );
}

// New Widget to build Favorite Product UI
Widget buildListProduct(model, context, {bool isOldPrice = true,}) => Padding(
  padding: const EdgeInsets.all(20.0),
  child: SizedBox(
    height: 120.0,
    child: Row(
      children: [
        Stack(
          alignment: AlignmentDirectional.bottomStart,
          children: [
            Image(
              image: NetworkImage(
                model.image!,
              ),
              width: 100,
              height: 100.0,
            ),
            if (model.discount != 0 && isOldPrice)
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
        const SizedBox(
          width: 10.0,
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
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
                  Text(
                    model.price.toString(),
                    style: const TextStyle(
                      color: defaultColor,
                      fontSize: 13.0,
                    ),
                  ),
                  const SizedBox(
                    width: 10.0,
                  ),
                  if (model.discount != 0 && isOldPrice)
                    Text(
                      model.oldPrice.toString(),
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
                      //print(model.id);
                    },
                    icon: CircleAvatar(
                      radius: 14.0,
                      backgroundColor: AppCubit.get(context)
                          .favorites[model.id]!
                          ? Colors.red
                          : Colors.grey,
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
      ],
    ),
  ),
);
