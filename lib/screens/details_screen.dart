import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app_api_course_abdallah_mansour_design/components/components.dart';
import 'package:shopping_app_api_course_abdallah_mansour_design/providers/shop_layout_provider.dart';
import 'package:shopping_app_api_course_abdallah_mansour_design/themes/colors.dart';

import '../components/constants.dart';

class DetailsScreen extends StatefulWidget {
  const DetailsScreen({super.key});
  static const routeName = '/details-screen';

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  @override
  Widget build(BuildContext context) {
    final productId = ModalRoute.of(context)!.settings.arguments as int;
    final data = Provider.of<ShopLayoutProvider>(context);
    final product = data.findById(productId);
    final provider = Provider.of<ShopLayoutProvider>(context);
    return Scaffold(
      bottomSheet: Container(
        height: 60,
        width: double.infinity,
        decoration: const BoxDecoration(
          border: Border.symmetric(
            horizontal: BorderSide(width: .5, color: Colors.grey),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Text(
                  formatCurrency.format(product.price),
                  style: const TextStyle(fontSize: 16),
                ),
              ),
              Expanded(
                child: ElevatedButton(
                  onPressed: provider.inCart[productId]!
                      ? null
                      : () {
                          provider.changeCart(productId).then((value) {
                            if (value.status!) {
                              showToast(
                                  text: value.message!,
                                  state: ToastStates.SUCCESS);
                            } else {
                              showToast(
                                  text: value.message!,
                                  state: ToastStates.ERROR);
                            }
                          });
                        },
                  child: const Text(
                    'Add To Cart',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      backgroundColor: Colors.grey[300],
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            expandedHeight: MediaQuery.of(context).size.height * 0.5,
            actions: [
              IconButton(
                onPressed: () async {
                  await data.changeFavorite(productId).then((value) {
                    if (value.status!) {
                      showToast(
                          text: value.message!, state: ToastStates.SUCCESS);
                    } else {
                      showToast(text: value.message!, state: ToastStates.ERROR);
                    }
                  }).catchError((error) {
                    showToast(
                        text: 'Something Went Wrong', state: ToastStates.ERROR);
                  });
                },
                icon: Icon(
                  data.favorites[productId]!
                      ? Icons.favorite
                      : Icons.favorite_border,
                  color: defaultColor,
                ),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: CarouselSlider(
                options: CarouselOptions(
                  viewportFraction: 1,
                  height: MediaQuery.of(context).size.height * 0.5,
                  autoPlay: false,
                  enableInfiniteScroll: true,
                  reverse: false,
                  autoPlayInterval: const Duration(seconds: 3),
                  autoPlayAnimationDuration: const Duration(milliseconds: 800),
                  autoPlayCurve: Curves.fastOutSlowIn,
                ),
                items: product.images!
                    .map(
                      (image) => Image.network(
                        image,
                      ),
                    )
                    .toList(),
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                const Divider(),
                Container(
                  width: double.infinity,
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          product.name!,
                          style: Theme.of(context).textTheme.headline6,
                        ),
                        const Divider(),
                        const Text(
                            'Cargo Will be delivered in 2 to 5 working days')
                      ],
                    ),
                  ),
                ),
                const Divider(),
                Container(
                  width: double.infinity,
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Description',
                          style: Theme.of(context).textTheme.headline6,
                        ),
                        const Divider(
                          thickness: 2,
                        ),
                        Text(product.description!),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 80),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
