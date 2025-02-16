import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:emovie_finder_mobile/src/presentation/screens/navigationscreen/screen_tabs/carttabscreen/widgets/cart_items.dart';
import '../../../../../style/theme/theme.dart';
import '../../../../../utils/helpers/basestate.dart';
import '../../../../../utils/helpers/dialog.dart';
import '../../../../../utils/providers/paypal_provider.dart';
import 'cart_tab_screen_view_model.dart';

class CartTabScreen extends StatefulWidget {
  static const String routeName = 'carttabscreen';
  static const String path = '/carttabscreen';

  @override
  State<CartTabScreen> createState() => _CartTabScreenState();
}

class _CartTabScreenState extends State<CartTabScreen> {
  late CartTabScreenViewModel viewModel;
  late PayPalProvider payPalProvider;

  @override
  void initState() {
    viewModel = CartTabScreenViewModel();
    payPalProvider = PayPalProvider();
    viewModel.fetchData();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<CartTabScreenViewModel>(
      create: (context) => viewModel,
      child: BlocConsumer<CartTabScreenViewModel, BaseState>(
        listener: (context, state) {
          if (state is ShowLoadingState) {
            MyDialogUtils.showLoadingDialog(context, state.message);
          } else if (state is HideDialog) {
            MyDialogUtils.hideDialog(context);
          } else if (state is ShowSuccessMessageState) {
            MyDialogUtils.showSuccessMessage(
                context: context, message: state.message, posActionTitle: "Ok");
          } else if (state is BackAction) {
            context.pop(context);
          } else if (state is ShowQuestionMessageState) {
            MyDialogUtils.showQuestionMessage(
                context: context,
                message: state.message,
                posActionTitle: "Yes",
                posAction: () async {
                  viewModel.removeMovieFromCart(state.id as int);
                },
                negativeActionTitle: "No");
          }
        },
        buildWhen: (previous, current) {
          return (previous is EmptyListState && current is LoadingState) ||
              (previous is LoadingState && current is EmptyListState) ||
              (previous is LoadingState && current is DataLoadedState) ||
              (previous is LoadingState && current is ShowErrorMessageState) ||
              (previous is DataLoadedState && current is LoadingState) ||
              (previous is ShowErrorMessageState && current is LoadingState) ||
              (previous is ShowSuccessMessageState &&
                  current is DataLoadedState) ||
              (previous is ShowSuccessMessageState &&
                  current is EmptyListState) ||
              (previous is LoadingState && current is ShowErrorMessageState);
        },
        builder: (context, state) {
          if (state is EmptyListState) {
            return Container(
              color: MyTheme.backGroundColor,
              child: Column(
                children: [
                  const SizedBox(
                    height: 30,
                  ),
                  IconButton(
                    onPressed: () {
                      viewModel.onPressBackAction();
                    },
                    icon: const Icon(
                      Icons.arrow_back_ios,
                      color: Colors.white,
                      size: 28,
                    ),
                  ),
                  Expanded(
                    child: Center(
                      child: Image.asset('assets/images/empty.png'),
                    ),
                  ),
                ],
              ),
            );
          } else if (state is LoadingState) {
            return Container(
              color: MyTheme.backGroundColor,
              child: const Center(
                child: CircularProgressIndicator(color: MyTheme.gold),
              ),
            );
          } else if (state is DataLoadedState) {
            return Container(
              color: MyTheme.backGroundColor,
              child: Column(
                children: [
                  IconButton(
                    onPressed: () {
                      viewModel.onPressBackAction();
                    },
                    icon: const Icon(
                      Icons.arrow_back_ios,
                      color: Colors.white,
                      size: 28,
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.only(bottom: 80),
                      itemCount: state.cartItem?.length,
                      itemBuilder: (context, index) {
                        final cartItem = state.cartItem?[index];
                        return CartItemWidget(
                            cartItem, context.read<CartTabScreenViewModel>());
                      },
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 15.0, vertical: 8.0),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "Total",
                              style: TextStyle(
                                fontSize: 18,
                                color: MyTheme.white,
                                decoration: TextDecoration.none,
                              ),
                            ),
                            Text(
                              "${viewModel.cartTotalPrice} EUR",
                              style: const TextStyle(
                                fontSize: 18,
                                color: MyTheme.white,
                                fontWeight: FontWeight.bold,
                                decoration: TextDecoration.none,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 15),
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                color: MyTheme.white,
                                height: 2,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 15),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ButtonStyle(
                              shape: MaterialStateProperty.all(
                                  RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              )),
                              backgroundColor:
                                  MaterialStateProperty.all(MyTheme.gold),
                            ),
                            onPressed: () {
                              final totalAmount = Decimal.parse(viewModel.cartTotalPrice);
                              payPalProvider.startPaymentProcess(context, totalAmount);
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "Go To Payment",
                                style: Theme.of(context)
                                    .textTheme
                                    .displaySmall!
                                    .copyWith(fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          } else if (state is ShowErrorMessageState) {
            return Center(child: Image.asset('assets/images/empty.png'));
          } else {
            return Container();
          }
        },
      ),
    );
  }
}
