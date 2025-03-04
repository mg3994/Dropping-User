import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../core/utils/custom_button.dart';
import '../../../../../../core/utils/custom_loader.dart';
import '../../../../../../core/utils/custom_text.dart';
import '../../../../../../l10n/app_localizations.dart';
import '../../../../application/acc_bloc.dart';
import '../../../../domain/models/walletpage_model.dart';

class WalletPaymentGatewayListWidget extends StatelessWidget {
  final BuildContext cont;
  final List<PaymentGateway> walletPaymentGatways;
  const WalletPaymentGatewayListWidget({super.key, required this.cont, required this.walletPaymentGatways});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return BlocProvider.value(value: cont.read<AccBloc>(),
    child: BlocBuilder<AccBloc, AccState>(builder: (context, state) {
      return walletPaymentGatways.isNotEmpty
          ? Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                children: [
                  SizedBox(height: size.width * 0.05),
                  ListView.builder(
                    itemCount: walletPaymentGatways.length,
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    itemBuilder: (_, index) {
                      return (walletPaymentGatways[index].enabled == true)
                          ? Padding(
                              padding:
                                  EdgeInsets.only(bottom: size.width * 0.025),
                              child: InkWell(
                                onTap: () {
                                  context.read<AccBloc>().add(PaymentOnTapEvent(
                                      selectedPaymentIndex: index));
                                },
                                child: Container(
                                  width: size.width * 0.9,
                                  padding: EdgeInsets.all(size.width * 0.02),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      border: Border.all(
                                          width: 0.5,
                                          color:
                                              Theme.of(context).disabledColor)),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Row(
                                          children: [
                                            SizedBox(
                                              height: size.width * 0.1,
                                              width: size.width * 0.08,
                                              child: CachedNetworkImage(
                                                imageUrl:
                                                    walletPaymentGatways[index]
                                                        .image,
                                                fit: BoxFit.contain,
                                                placeholder: (context, url) =>
                                                    const Center(
                                                  child: Loader(),
                                                ),
                                                errorWidget:
                                                    (context, url, error) =>
                                                        const Center(
                                                  child: Text(""),
                                                ),
                                              ),
                                            ),
                                            SizedBox(width: size.width * 0.03),
                                            MyText(
                                                text:
                                                    walletPaymentGatways[index]
                                                        .gateway
                                                        .toString(),
                                                textStyle: Theme.of(context)
                                                    .textTheme
                                                    .bodyMedium!
                                                    .copyWith(
                                                        color: Theme.of(context)
                                                            .primaryColorDark)),
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
                              ),
                            )
                          : const SizedBox();
                    },
                  ),
                  const Spacer(),
                  CustomButton(
                      buttonName: AppLocalizations.of(context)!.pay,
                      onTap: () async {
                        Navigator.pop(context);
                        context.read<AccBloc>().add(WalletPageReUpdateEvent(
                            currencySymbol: context
                                .read<AccBloc>()
                                .walletResponse!
                                .currencySymbol,
                            from: '',
                            requestId: '',
                            money: context.read<AccBloc>().addMoney.toString(),
                            url: walletPaymentGatways[context
                                    .read<AccBloc>()
                                    .choosenPaymentIndex!]
                                .url,
                            userId: context
                                .read<AccBloc>()
                                .userData!
                                .id
                                .toString()));
                      }),
                  SizedBox(height: size.width * 0.05)
                ],
              ),
            )
          : const SizedBox();
    })
  ,);
  }
}