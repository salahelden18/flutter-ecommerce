import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app_api_course_abdallah_mansour_design/components/constants.dart';
import '../models/favorite_model.dart';

import '../components/components.dart';
import '../models/change_favorites_model.dart';
import '../providers/shop_layout_provider.dart';
import '../themes/colors.dart';

class FavoriteScreen extends StatelessWidget {
  const FavoriteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ShopLayoutProvider>(
      builder: (ctx, provider, child) =>
          provider.isFavoritesModelLoading != true
              ? ListView.separated(
                  itemBuilder: (ctx, index) =>
                      buildFavItem(provider.favoritesModel!.data!.data![index]),
                  separatorBuilder: (ctx, index) => child!,
                  itemCount: provider.favoritesModel!.data!.data!.length,
                )
              : const Center(
                  child: CircularProgressIndicator(),
                ),
      child: myDivider(),
    );
  }

  Widget buildFavItem(FavoritesData model) => Padding(
        padding: const EdgeInsets.all(20.0),
        child: SizedBox(
          height: 120,
          child: Row(
            children: [
              Stack(
                alignment: AlignmentDirectional.bottomStart,
                children: [
                  Image(
                    image: NetworkImage(
                      model.product!.image!,
                    ),
                    width: 120,
                    height: 120,
                  ),
                  if (model.product?.discount != 0)
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
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      model.product!.name!,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(height: 1.3),
                    ),
                    const Spacer(),
                    Row(
                      children: [
                        Text(
                          formatCurrency.format(model.product!.price.round()),
                          style: const TextStyle(
                            fontSize: 12,
                            color: defaultColor,
                          ),
                        ),
                        const SizedBox(width: 5),
                        if (model.product!.discount != 0)
                          Text(
                            '${model.product!.oldPrice.round()}',
                            style: const TextStyle(
                              fontSize: 10,
                              decoration: TextDecoration.lineThrough,
                              color: Colors.grey,
                            ),
                          ),
                        const Spacer(),
                        Consumer<ShopLayoutProvider>(
                          builder: (context, provider, child) => IconButton(
                            onPressed: () async {
                              ChangeFavoriteModel changeFavoriteModel =
                                  await provider
                                      .changeFavorite(model.product!.id!);

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
                              backgroundColor:
                                  provider.favorites[model.product!.id]!
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
