
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restart_tagxi/l10n/app_localizations.dart';
import '../../../../../../common/common.dart';
import '../../../../../../core/utils/custom_loader.dart';
import '../../../../../../core/utils/custom_text.dart';
import '../../../../../auth/application/auth_bloc.dart';
import '../../../../application/acc_bloc.dart';
import '../widget/add_money_wallet_widget.dart';
import '../widget/wallet_history_list_widget.dart';
import '../widget/wallet_history_shimmer.dart';
import '../../paymentgateways.dart';
import '../widget/wallet_transfer_money_widget.dart';
import '../widget/web_view_page.dart';

class WalletHistoryPage extends StatelessWidget {
  static const String routeName = '/walletHistory';
  final WalletPageArguments arg;

  const WalletHistoryPage({super.key, required this.arg});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return BlocProvider(
      create: (context) => AccBloc()..add(WalletPageInitEvent(arg: arg)),
      child: BlocListener<AccBloc, AccState>(
        listener: (context, state) {
          if (state is AuthInitialState) {
            CustomLoader.loader(context);
          } else if (state is MoneyTransferedSuccessState) {
            Navigator.pop(context);
          } else if (state is AddMoneyWebViewUrlState) {
            Navigator.pushNamed(
              context,
              WebViewPage.routeName,
            );
          } else if (state is WalletPageReUpdateState) {
            Navigator.pushNamed(
              context,
              PaymentGatwaysPage.routeName,
              arguments: PaymentGateWayPageArguments(
                currencySymbol: state.currencySymbol,
                from: '',
                requestId: state.requestId,
                money: state.money,
                url: state.url,
                userId: state.userId,
              ),
            ).then((value) {
              if (!context.mounted) return;
              if (value != null && value == true) {
                showDialog(
                  context: context,
                  barrierDismissible:
                      false, // Prevents closing the dialog by tapping outside
                  builder: (_) {
                    return AlertDialog(
                      content: SizedBox(
                        height: size.height * 0.4,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Image.asset(
                              AppImages.paymentSuccess,
                              fit: BoxFit.contain,
                              width: size.width * 0.5,
                            ),
                            SizedBox(height: size.width * 0.02),
                            Text(
                              AppLocalizations.of(context)!.paymentSuccess,
                              style: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: size.width * 0.02),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.pop(context);
                                context.read<AccBloc>().add(
                                      GetWalletHistoryListEvent(
                                          pageIndex: context
                                              .read<AccBloc>()
                                              .walletPaginations!
                                              .pagination
                                              .currentPage),
                                    );
                              },
                              child: Text(AppLocalizations.of(context)!.okText),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              } else {
                showDialog(
                  context: context,
                  barrierDismissible:
                      false, // Prevents closing the dialog by tapping outside
                  builder: (_) {
                    return AlertDialog(
                      content: SizedBox(
                        height: size.height * 0.45,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Image.asset(
                              AppImages.paymentFail,
                              fit: BoxFit.contain,
                              width: size.width * 0.4,
                            ),
                            SizedBox(height: size.width * 0.02),
                            Text(
                              AppLocalizations.of(context)!.paymentFailed,
                              style: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: size.width * 0.02),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text(AppLocalizations.of(context)!.okText),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              }
            });
          }
        },
        child: BlocBuilder<AccBloc, AccState>(builder: (context, state) {
          return Scaffold(
            backgroundColor: Theme.of(context).primaryColor,
            body: Stack(
              children: [
                SizedBox(
                  height: size.height,
                  child: Column(
                    children: [
                      SizedBox(
                        height: size.width * 0.5,
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              SizedBox(
                                height: MediaQuery.of(context).padding.top,
                              ),
                              Row(
                                children: [
                                  Container(
                                    height: size.height * 0.08,
                                    width: size.width * 0.08,
                                    margin: EdgeInsets.only(
                                        left: size.width * 0.05,
                                        right: size.width * 0.05),
                                    decoration: const BoxDecoration(
                                      color: AppColors.whiteText,
                                      shape: BoxShape.circle,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black26,
                                          offset: Offset(5.0, 5.0),
                                          blurRadius: 10.0,
                                          spreadRadius: 2.0,
                                        ),
                                      ],
                                    ),
                                    child: IconButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      icon: const Icon(
                                        CupertinoIcons.back,
                                        size: 20,
                                        color: AppColors.blackText,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: size.width * 0.25,
                                width: size.width,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    MyText(
                                        text: AppLocalizations.of(context)!
                                            .walletBalance,
                                        textStyle: Theme.of(context)
                                            .textTheme
                                            .bodyMedium!
                                            .copyWith(
                                                color: Colors.white,
                                                fontSize: 18)),
                                    // if (context.read<AccBloc>().walletResponse != null)
                                    if (context.read<AccBloc>().isLoading &&
                                        !context.read<AccBloc>().loadMore)
                                      SizedBox(
                                        height: size.width * 0.06,
                                        width: size.width * 0.06,
                                        child: const Loader(
                                          color: AppColors.white,
                                        ),
                                      ),
                                    if (context
                                            .read<AccBloc>()
                                            .walletResponse !=
                                        null)
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          MyText(
                                              text:
                                                  '${context.read<AccBloc>().walletResponse!.walletBalance.toString()} ${context.read<AccBloc>().walletResponse!.currencySymbol.toString()}',
                                              textStyle: Theme.of(context)
                                                  .textTheme
                                                  .displayLarge!
                                                  .copyWith(
                                                      color: Colors.white)),
                                        ],
                                      ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          width: size.width,
                          padding: EdgeInsets.all(size.width * 0.05),
                          decoration: BoxDecoration(
                            color: Theme.of(context).scaffoldBackgroundColor,
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(25),
                              topRight: Radius.circular(25),
                            ),
                          ),
                          child: Column(
                            children: [
                              SizedBox(height: size.width * 0.075),
                              Row(
                                children: [
                                  MyText(
                                    text: AppLocalizations.of(context)!
                                        .recentTransactions,
                                    textStyle: Theme.of(context)
                                        .textTheme
                                        .bodyLarge!
                                        .copyWith(
                                            color: Theme.of(context)
                                                .primaryColorDark),
                                  ),
                                ],
                              ),
                              SizedBox(height: size.width * 0.025),
                              if (context.read<AccBloc>().isLoading &&
                                  context.read<AccBloc>().firstLoad)
                                Expanded(
                                  child: ListView.builder(
                                    itemCount: 8,
                                    itemBuilder: (context, index) {
                                      return ShimmerWalletHistory(size: size);
                                    },
                                  ),
                                ),
                              Expanded(
                                child: SingleChildScrollView(
                                  controller:
                                      context.read<AccBloc>().scrollController,
                                  child: Column(
                                    children: [
                                      WalletHistoryListWidget(
                                       walletHistoryList:
                                        context
                                            .read<AccBloc>()
                                            .walletHistoryList,
                                        cont:context,
                                      ),
                                      if (context
                                              .read<AccBloc>()
                                              .walletHistoryList
                                              .isNotEmpty &&
                                          context.read<AccBloc>().loadMore)
                                        Center(
                                          child: SizedBox(
                                              height: size.width * 0.08,
                                              width: size.width * 0.08,
                                              child:
                                                  const CircularProgressIndicator()),
                                        ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                    top: size.width * 0.45,
                    left: size.width * 0.05,
                    right: size.width * 0.05,
                    child: Container(
                      padding: EdgeInsets.fromLTRB(
                          size.width * 0.05,
                          size.width * 0.025,
                          size.width * 0.05,
                          size.width * 0.025),
                      width: size.width * 0.7,
                      decoration: BoxDecoration(
                        color: Theme.of(context).scaffoldBackgroundColor,
                        borderRadius: BorderRadius.circular(5),
                        boxShadow: [
                          BoxShadow(
                              color: Theme.of(context).shadowColor,
                              offset: const Offset(0, 4),
                              spreadRadius: 0,
                              blurRadius: 5)
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          InkWell(
                            onTap: () {
                              context
                                  .read<AccBloc>()
                                  .walletAmountController
                                  .clear();
                              context.read<AccBloc>().addMoney = null;
                              showModalBottomSheet(
                                  context: context,
                                  isScrollControlled: true,
                                  enableDrag: false,
                                  isDismissible: true,
                                  backgroundColor:
                                      Theme.of(context).shadowColor,
                                  builder: (_) {
                                    return AddMoneyWalletWidget(cont :context);
                                  });
                            },
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                MyText(
                                    text:
                                        AppLocalizations.of(context)!.addMoney,
                                    textStyle: Theme.of(context)
                                        .textTheme
                                        .bodySmall!
                                        .copyWith(
                                            color: Theme.of(context)
                                                .primaryColorDark,
                                            fontSize: 16)),
                                SizedBox(
                                  width: size.width * 0.02,
                                ),
                                Container(
                                  height: size.width * 0.04,
                                  width: size.width * 0.04,
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                          color: Theme.of(context)
                                              .primaryColorDark)),
                                  alignment: Alignment.center,
                                  child: Icon(Icons.add,
                                      size: size.width * 0.03,
                                      color:
                                          Theme.of(context).primaryColorDark),
                                ),
                              ],
                            ),
                          ),
                          if (context.read<AccBloc>().userData != null &&
                              context
                                      .read<AccBloc>()
                                      .userData!
                                      .showWalletMoneyTransferFeatureOnMobileApp ==
                                  '1')
                            InkWell(
                              onTap: () {
                                context.read<AccBloc>().transferAmount.clear();
                                context
                                    .read<AccBloc>()
                                    .transferPhonenumber
                                    .clear();
                                context.read<AccBloc>().dropdownValue = 'user';
                                showModalBottomSheet(
                                    context: context,
                                    isScrollControlled: true,
                                    enableDrag: false,
                                    isDismissible: true,
                                    backgroundColor:
                                        Theme.of(context).shadowColor,
                                    builder: (_) {
                                      return WalletTransferMoneyWidget(cont:context, arg: arg);
                                    });
                              },
                              child: Row(
                                children: [
                                  MyText(
                                      text: AppLocalizations.of(context)!
                                          .transferMoney,
                                      textStyle: Theme.of(context)
                                          .textTheme
                                          .bodySmall!
                                          .copyWith(
                                              color: Theme.of(context)
                                                  .primaryColorDark,fontSize: 16)),
                                  SizedBox(
                                    width: size.width * 0.02,
                                  ),
                                  Container(
                                    height: size.width * 0.04,
                                    width: size.width * 0.04,
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                            color: Theme.of(context)
                                                .primaryColorDark)),
                                    alignment: Alignment.center,
                                    child: Icon(Icons.arrow_downward,
                                        size: size.width * 0.03,
                                        color:
                                            Theme.of(context).primaryColorDark),
                                  ),
                                ],
                              ),
                            )
                        ],
                      ),
                    )),
              ],
            ),
          );
        }),
      ),
    );
  }
}
