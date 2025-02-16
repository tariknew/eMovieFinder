import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../../../../../../models/entities/cartitem.dart';
import '../../../../../../style/theme/theme.dart';
import '../cart_tab_screen_view_model.dart';

class CartItemWidget extends StatelessWidget {
  final CartItem cartItem;
  final CartTabScreenViewModel viewModel;

  CartItemWidget(this.cartItem, this.viewModel);

  @override
  Widget build(BuildContext context) {
    final movie = cartItem.movie;
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      decoration: BoxDecoration(
        color: MyTheme.blackThree,
        borderRadius: BorderRadius.circular(15),
      ),
      height: 170,
      child: Slidable(
        endActionPane: ActionPane(
          extentRatio: 0.3,
          motion: const ScrollMotion(),
          children: [
            SlidableAction(
              backgroundColor: Colors.red,
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(15),
                bottomRight: Radius.circular(15),
              ),
              label: "Remove",
              icon: Icons.delete,
              onPressed: (BuildContext context) {
                viewModel.onRemoveMovieFromCartPress(
                    "Are You Sure You Want To Remove This Movie From The Cart?",
                    movie!.id!);
              },
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              flex: 4,
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(15),
                  bottomLeft: Radius.circular(15),
                ),
                child: movie?.image != null
                    ? Image.memory(
                        base64Decode(movie!.image!),
                        fit: BoxFit.fill,
                        width: double.infinity,
                        height: double.infinity,
                      )
                    : Container(
                        color: Colors.grey.shade800,
                        child: const Center(
                          child: Icon(
                            Icons.movie,
                            color: Colors.white70,
                            size: 50,
                          ),
                        ),
                      ),
              ),
            ),
            Expanded(
              flex: 6,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      movie!.title!,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.displaySmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                            color: Colors.white,
                          ),
                    ),
                    const Spacer(),
                    Text(
                      '${cartItem.formattedFinalMoviePrice} EUR',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: MyTheme.gold,
                          ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
