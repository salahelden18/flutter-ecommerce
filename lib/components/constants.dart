import 'package:intl/intl.dart';

import '../helpers/cache_helper.dart';
import '../screens/shop_login_screen.dart';
import './components.dart';

var baseUrl = 'https://student.valuxapps.com/api/';
final formatCurrency = NumberFormat.simpleCurrency(name: 'EGP ');

void signOut(context) {
  CacheHelper.removeData(
    key: 'token',
  ).then((value) {
    if (value) {
      navigateAndFinish(
        context,
        ShopLoginScreen(),
      );
    }
  });
}

// void printFullText(String text) {
//   final pattern = RegExp('.{1,800}'); // 800 is the size of each chunk
//   pattern.allMatches(text).forEach((match) => print(match.group(0)));
// }

String? token;
