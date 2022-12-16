import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/categories_model.dart';
import '../providers/shop_layout_provider.dart';

import '../components/components.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ShopLayoutProvider>(
      builder: (ctx, provider, child) => provider.categoriesModel != null
          ? ListView.separated(
              itemBuilder: (ctx, index) => buildCatItem(
                  provider.categoriesModel!.data!.data![index], context),
              separatorBuilder: (ctx, index) => child!,
              itemCount: provider.categoriesModel!.data!.data!.length,
            )
          : const Center(
              child: CircularProgressIndicator(),
            ),
      child: myDivider(),
    );
  }

  Widget buildCatItem(DataModel model, context) => Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          children: [
            Image(
              image: NetworkImage(model.image.toString()),
              width: 80,
              height: 80,
              fit: BoxFit.cover,
            ),
            const SizedBox(width: 20),
            Text(
              model.name!,
              softWrap: true,
              maxLines: 2,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Spacer(),
            if (MediaQuery.of(context).size.width > 320)
              const Icon(Icons.arrow_forward_ios),
          ],
        ),
      );
}
