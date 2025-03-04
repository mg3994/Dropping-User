import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../../common/common.dart';
import '../../../../../../../core/utils/custom_button.dart';
import '../../../../../../../core/utils/custom_text.dart';
import '../../../../../../../l10n/app_localizations.dart';
import '../../../../../../account/application/acc_bloc.dart';
import '../../../../../../account/presentation/pages/paymentgateways.dart';
import '../../../../../../home/domain/models/user_details_model.dart';
import '../../../../../application/booking_bloc.dart';

class OnridePaymentGatewayWidget extends StatelessWidget {
  final BuildContext cont;
 final List<PaymentGatewayData> walletPaymentGatways;
  const OnridePaymentGatewayWidget({super.key, required this.cont, required this.walletPaymentGatways});

  @override
  Widget build(BuildContext context) {
    final size =MediaQuery.sizeOf(context);
    return BlocProvider(
      create: (context) =>
          AccBloc()..add(GetWalletHistoryListEvent(pageIndex: 1)),
      child: BlocBuilder<AccBloc, AccState>(builder: (context, state) {
        return walletPaymentGatways.isNotEmpty
            ? Column(
                children: [
                  SizedBox(height: size.width * 0.05),
                  Expanded(
                    child: ListView.builder(
                      itemCount: walletPaymentGatways.length,
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: EdgeInsets.zero,
                      shrinkWrap: true,
                      itemBuilder: (_, index) {
                        return Column(
                          children: [
                            (walletPaymentGatways[index].enabled == true)
                                ? InkWell(
                                    onTap: () {
                                      context.read<AccBloc>().add(
                                          PaymentOnTapEvent(
                                              selectedPaymentIndex: index));
                                    },
                                    child: Container(
                                      width: size.width * 0.9,
                                      padding:
                                          EdgeInsets.all(size.width * 0.02),
                                      margin: EdgeInsets.only(
                                          bottom: size.width * 0.025),
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          border: Border.all(
                                              width: 0.5,
                                              color: Theme.of(context)
                                                  .primaryColorDark
                                                  .withOpacity(0.5))),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: Row(
                                              children: [
                                                Container(
                                                  padding: EdgeInsets.all(
                                                      size.width * 0.05),
                                                ),
                                                MyText(
                                                    text: walletPaymentGatways[
                                                            index]
                                                        .gateway
                                                        .toString(),
                                                    textStyle: Theme.of(context)
                                                        .textTheme
                                                        .bodyMedium!
                                                        .copyWith(
                                                            color: Theme.of(
                                                                    context)
                                                                .primaryColorDark,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w600)),
                                              ],
                                            ),
                                          ),
                                          Container(
                                            width: size.width * 0.05,
                                            height: size.width * 0.05,
                                            decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                border: Border.all(
                                                    width: 1.5,
                                                    color: Theme.of(context)
                                                        .primaryColorDark)),
                                            alignment: Alignment.center,
                                            child: Container(
                                              width: size.width * 0.03,
                                              height: size.width * 0.03,
                                              decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: (context
                                                              .read<AccBloc>()
                                                              .choosenPaymentIndex ==
                                                          index)
                                                      ? Theme.of(context)
                                                          .primaryColorDark
                                                      : Colors.transparent),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  )
                                : Container(),
                          ],
                        );
                      },
                    ),
                  ),
                  CustomButton(
                      buttonName: AppLocalizations.of(cont)!.pay,
                      onTap: () async {
                        Navigator.pop(cont); // Use 'cont' instead of 'context'
                        Navigator.pushNamed(
                          cont,
                          PaymentGatwaysPage.routeName,
                          arguments: PaymentGateWayPageArguments(
                            currencySymbol: context
                                .read<BookingBloc>()
                                .requestData!
                                .requestedCurrencySymbol,
                            from: '1',
                            requestId:
                                context.read<BookingBloc>().requestData!.id,
                            money: (context
                                        .read<BookingBloc>()
                                        .requestData!
                                        .isBidRide ==
                                    1)
                                ? context
                                    .read<BookingBloc>()
                                    .requestData!
                                    .acceptedRideFare
                                : context
                                    .read<BookingBloc>()
                                    .requestData!
                                    .requestEtaAmount,
                            url: walletPaymentGatways[context
                                    .read<AccBloc>()
                                    .choosenPaymentIndex!]
                                .url,
                            userId: context
                                .read<BookingBloc>()
                                .requestData!
                                .userId
                                .toString(),
                          ),
                        ).then((value) {
                          if (!context.mounted) return;
                          if (value != null && value == true) {
                            showDialog(
                              context: cont, // Use 'cont' for the context here
                              barrierDismissible: false,
                              builder: (_) {
                                return AlertDialog(
                                  content: SizedBox(
                                    height: size.height * 0.4,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Image.asset(
                                          AppImages.paymentSuccess,
                                          fit: BoxFit.contain,
                                          width: size.width * 0.5,
                                        ),
                                        const SizedBox(height: 20),
                                        Text(
                                          AppLocalizations.of(cont)!
                                              .paymentSuccess,
                                          style: const TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold),
                                          textAlign: TextAlign.center,
                                        ),
                                        const SizedBox(height: 20),
                                        ElevatedButton(
                                          onPressed: () {
                                            Navigator.pop(cont);
                                          },
                                          child: Text(AppLocalizations.of(cont)!
                                              .okText),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            );
                          } else {
                            showDialog(
                              context: cont, // Use 'cont' for the context here
                              barrierDismissible: false,
                              builder: (_) {
                                return AlertDialog(
                                  content: SizedBox(
                                    height: size.height * 0.4,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Image.asset(
                                          AppImages.paymentFail,
                                          fit: BoxFit.contain,
                                          width: size.width * 0.5,
                                        ),
                                        const SizedBox(height: 20),
                                        Text(
                                          AppLocalizations.of(cont)!
                                              .paymentFailed,
                                          style: const TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold),
                                          textAlign: TextAlign.center,
                                        ),
                                        const SizedBox(height: 20),
                                        ElevatedButton(
                                          onPressed: () {
                                            Navigator.pop(cont);
                                          },
                                          child: Text(AppLocalizations.of(cont)!
                                              .okText),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            );
                          }
                        });
                      }),
                  SizedBox(height: size.width * 0.05)
                ],
              )
            : const SizedBox();
      }),
    );
  
  }
}