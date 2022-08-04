import 'package:amazon/assistantMethods/cart_methods.dart';
import 'package:shared_preferences/shared_preferences.dart';

SharedPreferences? sharedPreferences;

final itemsImageList = [
  "slider/0.jpg",
  "slider/1.jpg",
  "slider/2.jpg",
  "slider/3.jpg",
  "slider/4.jpg",
  "slider/5.jpg",
  "slider/6.jpg",
  "slider/7.jpg",
  "slider/8.jpg",
  "slider/9.jpg",
  "slider/10.jpg",
  "slider/11.jpg",
  "slider/12.jpg",
  "slider/13.jpg",
];
double countStarsRating = 0.0;
String titleStarsRating = "";
CartMethods cartMethods = CartMethods();
String fcmServerToken =
    "key=AAAAfKkvPu8:APA91bG3WS25ilqsxHj1wFE9rwwOYGCCAK7ytdLCjAsx6-oZ9Y1xW9wITZ9B878uJ2em0dwnBTOOtcxpFmSoQGL0PHy7EXy6MkqHEgThDTVDrTwD8qVFgVS2_7qjJUUieGr3DqAmU9Qt";
