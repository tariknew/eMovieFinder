import 'package:flutter/material.dart';

import '../../../../../../style/theme/theme.dart';
import '../../../../../../models/entities/order.dart';

class OrderCardWidget extends StatelessWidget {
  Order ordersHistory;

  OrderCardWidget(this.ordersHistory);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
            child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          decoration: BoxDecoration(
              color: MyTheme.blackOne, borderRadius: BorderRadius.circular(20)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        "${ordersHistory.finalMoviePrice} EUR",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            color: MyTheme.gold,
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.none),
                      ),
                    ),
                    const Text(
                      "Completed",
                      style: TextStyle(
                          color: Colors.green,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.none),
                    ),
                  ],
                ),
              )
            ],
          ),
        )),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          padding: const EdgeInsets.only(bottom: 50),
          child: Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
                color: MyTheme.blackOne,
                borderRadius: BorderRadius.circular(20)),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      ordersHistory.formattedOrderDate!,
                      style: const TextStyle(
                          color: Color(0xFF97A1A3),
                          fontSize: 12,
                          decoration: TextDecoration.none),
                    ),
                  ],
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 10.0),
                  child: Row(
                    children: [
                      Text(
                        "Movie",
                        style: TextStyle(
                          color: Color(0xFF97A1A3),
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.none,
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  children: ordersHistory.orderMovies!
                      .map((e) => Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5.0),
                            child: Row(
                              children: [
                                Expanded(
                                    child: Text(
                                  e.formattedMovieTitle!,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                      decoration: TextDecoration.none),
                                )),
                              ],
                            ),
                          ))
                      .toList(),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}
