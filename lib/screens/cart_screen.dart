import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app_api_course_abdallah_mansour_design/components/components.dart';
import 'package:shopping_app_api_course_abdallah_mansour_design/components/constants.dart';
import 'package:shopping_app_api_course_abdallah_mansour_design/models/cart_change_model.dart';
import 'package:shopping_app_api_course_abdallah_mansour_design/providers/shop_layout_provider.dart';
import 'package:shopping_app_api_course_abdallah_mansour_design/themes/colors.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});
  static const routeName = '/cart-screen';

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ShopLayoutProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Cart'),
        centerTitle: true,
        automaticallyImplyLeading: false,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back_ios_new_outlined)),
      ),
      bottomSheet: Container(
        height: 70,
        decoration: const BoxDecoration(
          border: Border.symmetric(
            horizontal: BorderSide(width: .5, color: Colors.grey),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Total'),
                    Text(
                      formatCurrency.format(provider.cartModel!.data!.total),
                      style: const TextStyle(color: defaultColor),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {},
                  child: const Text('Order'),
                ),
              ),
            ],
          ),
        ),
      ),
      body: provider.isCartDataLoading == true
          ? const LinearProgressIndicator()
          : provider.cartModel!.data!.cartItems!.isEmpty
              ? const Center(
                  child: Text('You Don\'t have any products in the cart'),
                )
              : Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: ListView.builder(
                    itemBuilder: (ctx, index) {
                      return Column(
                        children: [
                          Row(
                            children: [
                              SizedBox(
                                height: 120,
                                width: 120,
                                child: Image(
                                  image: NetworkImage(
                                    provider.cartModel!.data!.cartItems![index]
                                        .product!.image!,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      provider.cartModel!.data!
                                          .cartItems![index].product!.name!,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    Text(
                                      formatCurrency.format(
                                        provider.cartModel!.data!
                                            .cartItems![index].product!.price,
                                      ),
                                      style:
                                          const TextStyle(color: defaultColor),
                                    ),
                                    Row(
                                      children: [
                                        IconButton(
                                          onPressed: () {
                                            provider
                                                .updateCart(
                                                    provider.cartModel!.data!
                                                        .cartItems![index].id!,
                                                    provider
                                                            .cartModel!
                                                            .data!
                                                            .cartItems![index]
                                                            .quantity! +
                                                        1)
                                                .then((value) {
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
                                          icon: const Icon(
                                            Icons.add,
                                            color: Colors.green,
                                          ),
                                        ),
                                        Text(
                                          provider.cartModel!.data!
                                              .cartItems![index].quantity
                                              .toString(),
                                          style: const TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        IconButton(
                                          onPressed: () async {
                                            if (provider
                                                    .cartModel!
                                                    .data!
                                                    .cartItems![index]
                                                    .quantity ==
                                                1) {
                                              CartChangeModel cartChangeModel =
                                                  await provider.changeCart(
                                                      provider
                                                          .cartModel!
                                                          .data!
                                                          .cartItems![index]
                                                          .product!
                                                          .id!);

                                              if (cartChangeModel.status!) {
                                                showToast(
                                                    text: cartChangeModel
                                                        .message!,
                                                    state: ToastStates.SUCCESS);
                                              } else {
                                                showToast(
                                                    text: cartChangeModel
                                                        .message!,
                                                    state: ToastStates.ERROR);
                                              }
                                            } else {
                                              provider
                                                  .updateCart(
                                                      provider
                                                          .cartModel!
                                                          .data!
                                                          .cartItems![index]
                                                          .id!,
                                                      provider
                                                              .cartModel!
                                                              .data!
                                                              .cartItems![index]
                                                              .quantity! -
                                                          1)
                                                  .then((value) {
                                                if (value.status!) {
                                                  showToast(
                                                      text: value.message!,
                                                      state:
                                                          ToastStates.SUCCESS);
                                                } else {
                                                  showToast(
                                                      text: value.message!,
                                                      state: ToastStates.ERROR);
                                                }
                                              });
                                            }
                                          },
                                          icon: const Icon(
                                            Icons.remove,
                                            color: Colors.red,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const Divider(),
                          const SizedBox(height: 10),
                        ],
                      );
                    },
                    itemCount: provider.cartModel?.data?.cartItems?.length,
                  ),
                ),
    );
  }
}
