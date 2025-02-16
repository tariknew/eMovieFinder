import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../../style/theme/theme.dart';
import '../../../../../utils/helpers/basestate.dart';
import '../../../../../utils/helpers/dialog.dart';
import 'order_history_tab_screen_view_model.dart';
import 'package:emovie_finder_mobile/src/presentation/screens/navigationscreen/screen_tabs/orderhistorytabscreen/widgets/order_card_widget.dart';

class OrderHistoryTabScreen extends StatefulWidget {
  static const String routeName = 'orderhistorytabscreen';
  static const String path = '/orderhistorytabscreen';

  @override
  State<OrderHistoryTabScreen> createState() => _OrderHistoryTabScreenState();
}

class _OrderHistoryTabScreenState extends State<OrderHistoryTabScreen> {
  late OrderHistoryTabScreenViewModel viewModel;

  @override
  void initState() {
    viewModel = OrderHistoryTabScreenViewModel();
    viewModel.fetchData();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<OrderHistoryTabScreenViewModel>(
      create: (context) => viewModel,
      child: BlocConsumer<OrderHistoryTabScreenViewModel, BaseState>(
        listener: (context, state) {
          if (state is ShowLoadingState) {
            MyDialogUtils.showLoadingDialog(context, state.message);
          } else if (state is HideDialog) {
            MyDialogUtils.hideDialog(context);
          } else if (state is BackAction) {
            context.pop(context);
          }
        },
        buildWhen: (previous, current) {
          return (previous is EmptyListState && current is LoadingState) ||
              (previous is LoadingState && current is EmptyListState) ||
              (previous is LoadingState && current is DataLoadedState) ||
              (previous is LoadingState && current is ShowErrorMessageState) ||
              (previous is DataLoadedState && current is LoadingState) ||
              (previous is ShowErrorMessageState && current is LoadingState);
        },
        builder: (context, state) {
          if (state is EmptyListState) {
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
                  const SizedBox(
                    height: 20,
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
                    child: SingleChildScrollView(
                      child: Column(
                        children: state.orders!
                            .map((o) => OrderCardWidget(o))
                            .toList(),
                      ),
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
