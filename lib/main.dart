import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app_api_course_abdallah_mansour_design/providers/shop_login_provider.dart';
import 'package:shopping_app_api_course_abdallah_mansour_design/screens/cart_screen.dart';
import 'package:shopping_app_api_course_abdallah_mansour_design/screens/details_screen.dart';
import './helpers/cache_helper.dart';
import './providers/shop_layout_provider.dart';
import './screens/search_screen.dart';
import './screens/shop_layout.dart';
import './screens/shop_register_screen.dart';
import './screens/shop_login_screen.dart';
import './themes/themes.dart';
import './screens/onboarding_screen.dart';
import './components/constants.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await CacheHelper.init();

  bool? isDark = CacheHelper.getData(key: "isDark");

  Widget widget;

  bool? onBoarding = CacheHelper.getData(key: "onBoarding");

  token = CacheHelper.getData(key: "token");

  if (onBoarding != null) {
    if (token != null) {
      widget = const ShopLayout();
    } else {
      widget = ShopLoginScreen();
    }
  } else {
    widget = const OnBoardingScreen();
  }

  runApp(MyApp(isDark ?? false, widget));
}

class MyApp extends StatelessWidget {
  const MyApp(this.isDark, this.startWidget, {super.key});

  final bool isDark;
  final Widget startWidget;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (ctx) => ShopLoginProvider(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => ShopLayoutProvider()
            ..getHomeData()
            ..getCategories()
            ..getFavorites()
            ..getUserData()
            ..getCart(),
        )
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Shop App',
        theme: lightTheme,
        darkTheme: darkTheme,
        themeMode: ThemeMode.light,
        home: startWidget,
        routes: {
          ShopLoginScreen.routeName: (ctx) => ShopLoginScreen(),
          ShopRegisterScreen.routeName: (ctx) => ShopRegisterScreen(),
          SearchScreen.routeName: (ctx) => const SearchScreen(),
          DetailsScreen.routeName: (ctx) => const DetailsScreen(),
          CartScreen.routeName: (ctx) => const CartScreen(),
        },
      ),
    );
  }
}
