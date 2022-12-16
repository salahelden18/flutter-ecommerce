import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app_api_course_abdallah_mansour_design/components/constants.dart';
import 'package:shopping_app_api_course_abdallah_mansour_design/screens/details_screen.dart';
import '../components/components.dart';
import '../models/categories_model.dart';
import '../models/change_favorites_model.dart';
import '../models/home_model.dart';
import '../providers/shop_layout_provider.dart';
import '../themes/colors.dart';

class ProductsScreen extends StatelessWidget {
  const ProductsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ShopLayoutProvider>(context);

    return provider.homeModel == null || provider.categoriesModel == null
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : productsBuilder(
            provider.homeModel!, provider.categoriesModel!, context);
  }

  Widget productsBuilder(HomeModel model, CategoriesModel categoriesModel,
          BuildContext context) =>
      SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CarouselSlider(
              items: model.data?.banners
                  .map(
                    (e) => Image(
                      image: NetworkImage(e.image!),
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  )
                  .toList(),
              options: CarouselOptions(
                height: 250,
                initialPage: 0,
                viewportFraction: 1,
                enableInfiniteScroll: true,
                reverse: false,
                autoPlay: true,
                autoPlayInterval: const Duration(seconds: 3),
                autoPlayAnimationDuration: const Duration(seconds: 1),
                autoPlayCurve: Curves.fastOutSlowIn,
                scrollDirection: Axis.horizontal,
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Categories',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    height: 100,
                    child: ListView.separated(
                      physics: const BouncingScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (ctx, index) =>
                          buildCategoryItem(categoriesModel.data!.data![index]),
                      separatorBuilder: (ctx, index) =>
                          const SizedBox(width: 10),
                      itemCount: categoriesModel.data!.data!.length,
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'New Products',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Container(
              color: Colors.grey[300],
              child: GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                mainAxisSpacing: 1,
                crossAxisSpacing: 1,
                childAspectRatio: 1 / 1.94,
                children: List.generate(
                  model.data!.products.length,
                  (index) =>
                      buildGridProduct(model.data!.products[index], context),
                ),
              ),
            ),
          ],
        ),
      );

  Widget buildCategoryItem(DataModel model) => Stack(
        alignment: AlignmentDirectional.bottomCenter,
        children: [
          Image(
            image: NetworkImage(model.image.toString()),
            height: 100,
            width: 100,
            fit: BoxFit.cover,
          ),
          Container(
            color: Colors.black.withOpacity(.8),
            width: 100,
            child: Text(
              model.name.toString(),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ],
      );

  Widget buildGridProduct(ProductModel model, BuildContext context) => InkWell(
        onTap: () {
          Navigator.of(context)
              .pushNamed(DetailsScreen.routeName, arguments: model.id);
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
                    image: NetworkImage(
                      model.image.toString(),
                    ),
                    width: double.infinity,
                    height: 200,
                  ),
                  if (model.discount != 0)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      color: Colors.red,
                      child: const Text(
                        'DISCOUNT',
                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.white,
                        ),
                      ),
                    ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      model.name.toString(),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(height: 1.3),
                    ),
                    Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              formatCurrency.format(model.price.round()),
                              style: const TextStyle(
                                fontSize: 12,
                                color: defaultColor,
                              ),
                            ),
                            const SizedBox(width: 5),
                            if (model.discount != 0)
                              Text(
                                formatCurrency.format(model.oldPrice.round()),
                                style: const TextStyle(
                                  fontSize: 10,
                                  decoration: TextDecoration.lineThrough,
                                  color: Colors.grey,
                                ),
                              ),
                          ],
                        ),
                        const Spacer(),
                        Consumer<ShopLayoutProvider>(
                          builder: (context, provider, child) => IconButton(
                            onPressed: () async {
                              ChangeFavoriteModel changeFavoriteModel =
                                  await provider.changeFavorite(model.id!);

                              if (changeFavoriteModel.status!) {
                                showToast(
                                    text: changeFavoriteModel.message!,
                                    state: ToastStates.SUCCESS);
                              } else {
                                showToast(
                                    text: changeFavoriteModel.message ??
                                        'Something went wrong',
                                    state: ToastStates.ERROR);
                              }
                            },
                            icon: CircleAvatar(
                              radius: 15,
                              backgroundColor: provider.favorites[model.id]!
                                  ? defaultColor
                                  : Colors.grey,
                              child: const Icon(
                                Icons.favorite_border,
                                size: 16,
                                color: Colors.white,
                              ),
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
}
