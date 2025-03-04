import "package:cached_network_image/cached_network_image.dart";
import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:restart_tagxi/features/account/presentation/pages/paymentgateways.dart";
import "package:restart_tagxi/features/bookingpage/presentation/page/review/page/review_page.dart";
import "../../../../../../common/common.dart";
import "../../../../../../common/pickup_icon.dart";
import "../../../../../../core/utils/custom_button.dart";
import "../../../../../../core/utils/custom_loader.dart";
import "../../../../../../core/utils/custom_text.dart";
import "../../../../../../l10n/app_localizations.dart";
import "../../../../application/booking_bloc.dart";
import "../widget/custom_shape.dart";
import "../widget/fare_breakup.dart";
import "../widget/payment_gateway_list.dart";

class InvoicePage extends StatelessWidget {
  static const String routeName = '/invoicePage';
  final InvoicePageArguments arg;
  InvoicePage({super.key, required this.arg});

  final bookingBloc = BookingBloc();
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return BlocProvider.value(
      value: bookingBloc,
      child: BlocListener<BookingBloc, BookingState>(
        listener: (context, state) {
          if (state is WalletPageReUpdateStates) {
            Navigator.pushNamed(
              context,
              PaymentGatwaysPage.routeName,
              arguments: PaymentGateWayPageArguments(
                currencySymbol: state.currencySymbol,
                from: '1',
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
                  barrierDismissible: false,
                  builder: (_) {
                    return PopScope(
                      canPop: false,
                      child: AlertDialog(
                        content: SizedBox(
                          height: size.height * 0.4,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                AppImages.paymentSuccess,
                                fit: BoxFit.contain,
                                width: size.width * 0.5,
                              ),
                              const SizedBox(height: 20),
                              Text(
                                AppLocalizations.of(context)!.paymentSuccess,
                                style: const TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 20),
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                  Navigator.pushNamedAndRemoveUntil(
                                      context,
                                      ReviewPage.routeName,
                                      arguments: ReviewPageArguments(
                                          requestId: arg.requestData.id,
                                          driverData: arg.driverData),
                                      (route) => false);
                                },
                                child:
                                    Text(AppLocalizations.of(context)!.okText),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              } else {
                if (!context.mounted) return;
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (_) {
                    return PopScope(
                      canPop: false,
                      child: AlertDialog(
                        content: SizedBox(
                          height: size.height * 0.4,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                AppImages.paymentFail,
                                fit: BoxFit.contain,
                                width: size.width * 0.5,
                              ),
                              const SizedBox(height: 20),
                              Text(
                                AppLocalizations.of(context)!.paymentFailed,
                                style: const TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 20),
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child:
                                    Text(AppLocalizations.of(context)!.okText),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              }
            });
          }
        },
        child: BlocBuilder<BookingBloc, BookingState>(
          builder: (context, state) {
            return Scaffold(
              backgroundColor: Theme.of(context).primaryColor,
              body: Stack(
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ClipPath(
                        clipper: ShapePainterBottom(),
                        child: Container(
                          padding: EdgeInsets.all(size.width * 0.025),
                          width: size.width,
                          height: size.height * 0.9,
                          color: const Color(0xffDEDCDC),
                          child: ClipPath(
                            clipper: ShapePainterCenter(),
                            child: Container(
                              padding: EdgeInsets.all(size.width * 0.05),
                              width: size.width,
                              height: size.height * 0.5,
                              color: Theme.of(context).scaffoldBackgroundColor,
                              child: Column(
                                children: [
                                  SizedBox(height: size.width * 0.4),
                                  Row(
                                    children: [
                                      MyText(
                                        text: arg.requestData.requestNumber,
                                        textStyle: Theme.of(context)
                                            .textTheme
                                            .bodyMedium!
                                            .copyWith(
                                              color: Theme.of(context)
                                                  .primaryColorDark,
                                              fontWeight: FontWeight.bold,
                                            ),
                                      )
                                    ],
                                  ),
                                  SizedBox(
                                    height: size.width * 0.05,
                                  ),
                                  Expanded(
                                    child: SingleChildScrollView(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          SizedBox(
                                            height: size.width * 0.05,
                                          ),
                                          Container(
                                            padding: EdgeInsets.all(
                                                size.width * 0.05),
                                            decoration: BoxDecoration(
                                              color: Theme.of(context)
                                                  .disabledColor
                                                  .withOpacity(0.5),
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                            ),
                                            child: Column(
                                              children: [
                                                Row(
                                                  children: [
                                                    Expanded(
                                                        child: Row(
                                                      children: [
                                                        Icon(
                                                          Icons.play_arrow,
                                                          color: Theme.of(
                                                                  context)
                                                              .primaryColorDark,
                                                        ),
                                                        MyText(
                                                          text: AppLocalizations
                                                                  .of(context)!
                                                              .duration,
                                                          textStyle: Theme.of(
                                                                  context)
                                                              .textTheme
                                                              .bodyMedium!
                                                              .copyWith(
                                                                  color: Theme.of(
                                                                          context)
                                                                      .scaffoldBackgroundColor
                                                                      .withOpacity(
                                                                          0.7)),
                                                        )
                                                      ],
                                                    )),
                                                    MyText(
                                                      text:
                                                          '${arg.requestData.totalTime} ${AppLocalizations.of(context)!.mins}',
                                                      textStyle: Theme.of(
                                                              context)
                                                          .textTheme
                                                          .bodyMedium!
                                                          .copyWith(
                                                              color: Theme.of(
                                                                      context)
                                                                  .scaffoldBackgroundColor
                                                                  .withOpacity(
                                                                      0.7)),
                                                    )
                                                  ],
                                                ),
                                                SizedBox(
                                                    height: size.width * 0.025),
                                                Row(
                                                  children: [
                                                    Expanded(
                                                        child: Row(
                                                      children: [
                                                        Icon(
                                                          Icons.play_arrow,
                                                          color: Theme.of(
                                                                  context)
                                                              .primaryColorDark,
                                                        ),
                                                        MyText(
                                                          text: AppLocalizations
                                                                  .of(context)!
                                                              .distance,
                                                          textStyle: Theme.of(
                                                                  context)
                                                              .textTheme
                                                              .bodyMedium!
                                                              .copyWith(
                                                                  color: Theme.of(
                                                                          context)
                                                                      .scaffoldBackgroundColor
                                                                      .withOpacity(
                                                                          0.7)),
                                                        )
                                                      ],
                                                    )),
                                                    MyText(
                                                      text:
                                                          '${arg.requestData.totalDistance} ${arg.requestData.unit}',
                                                      textStyle: Theme.of(
                                                              context)
                                                          .textTheme
                                                          .bodyMedium!
                                                          .copyWith(
                                                              color: Theme.of(
                                                                      context)
                                                                  .scaffoldBackgroundColor
                                                                  .withOpacity(
                                                                      0.7)),
                                                    )
                                                  ],
                                                ),
                                                SizedBox(
                                                    height: size.width * 0.025),
                                                Row(
                                                  children: [
                                                    Expanded(
                                                        child: Row(
                                                      children: [
                                                        Icon(
                                                          Icons.play_arrow,
                                                          color: Theme.of(
                                                                  context)
                                                              .primaryColorDark,
                                                        ),
                                                        MyText(
                                                          text: AppLocalizations
                                                                  .of(context)!
                                                              .typeofRide,
                                                          textStyle: Theme.of(
                                                                  context)
                                                              .textTheme
                                                              .bodyMedium!
                                                              .copyWith(
                                                                  color: Theme.of(
                                                                          context)
                                                                      .scaffoldBackgroundColor
                                                                      .withOpacity(
                                                                          0.7)),
                                                        )
                                                      ],
                                                    )),
                                                    MyText(
                                                      text: (arg.requestData
                                                                  .isOutStation ==
                                                              '1')
                                                          ? AppLocalizations.of(
                                                                  context)!
                                                              .outStation
                                                          : (arg.requestData
                                                                  .isRental)
                                                              ? AppLocalizations
                                                                      .of(
                                                                          context)!
                                                                  .rental
                                                              : AppLocalizations
                                                                      .of(context)!
                                                                  .regular,
                                                      textStyle: Theme.of(
                                                              context)
                                                          .textTheme
                                                          .bodyMedium!
                                                          .copyWith(
                                                              color: Theme.of(
                                                                      context)
                                                                  .scaffoldBackgroundColor
                                                                  .withOpacity(
                                                                      0.7)),
                                                    )
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                          SizedBox(height: size.width * 0.05),
                                          Container(
                                            padding: EdgeInsets.all(
                                                size.width * 0.020),
                                            decoration: BoxDecoration(
                                              color: Theme.of(context)
                                                  .scaffoldBackgroundColor,
                                              borderRadius:
                                                  BorderRadius.circular(2),
                                              border: Border.all(
                                                width: size.width * 0.001,
                                                color: Theme.of(context)
                                                    .disabledColor,
                                              ),
                                            ),
                                            child: Column(
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    const PickupIcon(),
                                                    Expanded(
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .symmetric(
                                                                horizontal: 5),
                                                        child: MyText(
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          text: arg.requestData
                                                              .pickAddress,
                                                          textStyle:
                                                              Theme.of(context)
                                                                  .textTheme
                                                                  .bodySmall,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                if (arg.requestData.requestStops
                                                    .data.isNotEmpty)
                                                  ListView.separated(
                                                    itemCount: arg
                                                        .requestData
                                                        .requestStops!
                                                        .data
                                                        .length,
                                                    shrinkWrap: true,
                                                    physics:
                                                        const NeverScrollableScrollPhysics(),
                                                    padding: EdgeInsets.zero,
                                                    itemBuilder:
                                                        (context, index) {
                                                      return Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        children: [
                                                          const DropIcon(),
                                                          SizedBox(
                                                              width:
                                                                  size.width *
                                                                      0.02),
                                                          Expanded(
                                                            child: MyText(
                                                              text: arg
                                                                  .requestData
                                                                  .requestStops!
                                                                  .data[index]
                                                                  .address,
                                                              textStyle: Theme.of(
                                                                      context)
                                                                  .textTheme
                                                                  .bodySmall,
                                                              maxLines: 1,
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                            ),
                                                          )
                                                        ],
                                                      );
                                                    },
                                                    separatorBuilder:
                                                        (context, index) {
                                                      return SizedBox(
                                                          height: size.width *
                                                              0.0025);
                                                    },
                                                  ),
                                                if (arg.requestData.requestStops
                                                    .data.isEmpty)
                                                  Padding(
                                                    padding: const EdgeInsets
                                                        .symmetric(vertical: 5),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceAround,
                                                      children: [
                                                        const DropIcon(),
                                                        Expanded(
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .only(
                                                                    left: 5),
                                                            child: MyText(
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                              text: arg
                                                                  .requestData
                                                                  .dropAddress,
                                                              textStyle: Theme.of(
                                                                      context)
                                                                  .textTheme
                                                                  .bodySmall,
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                              ],
                                            ),
                                          ),
                                          SizedBox(height: size.width * 0.05),
                                          if (arg.requestData.isBidRide ==
                                              1) ...[
                                            Center(
                                              child: MyText(
                                                text: (arg.requestData
                                                            .paymentOpt ==
                                                        '1')
                                                    ? AppLocalizations.of(
                                                            context)!
                                                        .cash
                                                    : (arg.requestData
                                                                .paymentOpt ==
                                                            '2')
                                                        ? AppLocalizations.of(
                                                                context)!
                                                            .wallet
                                                        : AppLocalizations.of(
                                                                context)!
                                                            .card,
                                                textStyle: Theme.of(context)
                                                    .textTheme
                                                    .bodyLarge!
                                                    .copyWith(
                                                        color: Theme.of(context)
                                                            .primaryColorDark,
                                                        fontSize: 25,
                                                        fontWeight:
                                                            FontWeight.bold),
                                              ),
                                            ),
                                            SizedBox(
                                                height: size.width * 0.025),
                                            Center(
                                              child: MyText(
                                                  text:
                                                      '${arg.requestBillData.requestedCurrencySymbol} ${arg.requestBillData.totalAmount}',
                                                  textStyle: Theme.of(context)
                                                      .textTheme
                                                      .bodyLarge!
                                                      .copyWith(fontSize: 25)),
                                            )
                                          ],
                                          if (arg.requestData.isBidRide ==
                                              0) ...[
                                            Center(
                                              child: MyText(
                                                text: AppLocalizations.of(
                                                        context)!
                                                    .fareBreakup,
                                                textStyle: Theme.of(context)
                                                    .textTheme
                                                    .bodyLarge!
                                                    .copyWith(
                                                        color: Theme.of(context)
                                                            .primaryColorDark,
                                                        fontWeight:
                                                            FontWeight.w600),
                                              ),
                                            ),
                                            SizedBox(
                                                height: size.width * 0.025),
                                            Column(
                                              children: [
                                                if (arg.requestBillData
                                                        .basePrice !=
                                                    0)
                                                  FareBreakup(
                                                      text: AppLocalizations.of(
                                                              context)!
                                                          .basePrice,
                                                      price:
                                                          '${arg.requestBillData.requestedCurrencySymbol} ${arg.requestBillData.basePrice}'),
                                                if (arg.requestBillData
                                                        .distancePrice !=
                                                    0)
                                                  FareBreakup(
                                                      text: AppLocalizations.of(
                                                              context)!
                                                          .distancePrice,
                                                      price:
                                                          '${arg.requestBillData.requestedCurrencySymbol} ${arg.requestBillData.distancePrice}'),
                                                if (arg.requestBillData
                                                        .timePrice !=
                                                    0)
                                                  FareBreakup(
                                                      text: AppLocalizations.of(
                                                              context)!
                                                          .timePrice,
                                                      price:
                                                          '${arg.requestBillData.requestedCurrencySymbol} ${arg.requestBillData.timePrice}'),
                                                if (arg.requestBillData
                                                        .waitingCharge !=
                                                    0)
                                                  FareBreakup(
                                                      text: AppLocalizations.of(
                                                              context)!
                                                          .waitingPrice,
                                                      price:
                                                          '${arg.requestBillData.requestedCurrencySymbol} ${arg.requestBillData.waitingCharge}'),
                                                if (arg.requestBillData
                                                        .adminCommision !=
                                                    0)
                                                  FareBreakup(
                                                      text: AppLocalizations.of(
                                                              context)!
                                                          .convenienceFee,
                                                      price:
                                                          '${arg.requestBillData.requestedCurrencySymbol} ${arg.requestBillData.adminCommision}'),
                                                if (arg.requestBillData
                                                        .promoDiscount !=
                                                    0)
                                                  FareBreakup(
                                                    text: AppLocalizations.of(
                                                            context)!
                                                        .discount,
                                                    price:
                                                        '${arg.requestBillData.requestedCurrencySymbol} ${arg.requestBillData.promoDiscount}',
                                                    textcolor: AppColors.green,
                                                    pricecolor: AppColors.green,
                                                  ),
                                                FareBreakup(
                                                    text: AppLocalizations.of(
                                                            context)!
                                                        .taxes,
                                                    price:
                                                        '${arg.requestBillData.requestedCurrencySymbol} ${arg.requestBillData.serviceTax}'),
                                                if (arg.requestBillData
                                                        .cancellationFee !=
                                                    0.0 && arg.requestBillData
                                                        .cancellationFee !=
                                                    0)
                                                  FareBreakup(
                                                      text: AppLocalizations.of(
                                                              context)!
                                                          .cancellationFee,
                                                      price:
                                                          '${arg.requestBillData.requestedCurrencySymbol} ${arg.requestBillData.cancellationFee}'),
                                                        
                                              ],
                                            ),
                                          ],
                                          SizedBox(height: size.width * 0.025),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      SizedBox(
                                        width: size.width * 0.4,
                                        child: Row(
                                          children: [
                                            MyText(
                                              text:
                                                  (arg.requestData.paymentOpt ==
                                                          '1')
                                                      ? AppLocalizations.of(
                                                              context)!
                                                          .cash
                                                      : (arg.requestData
                                                                  .paymentOpt ==
                                                              '2')
                                                          ? AppLocalizations.of(
                                                                  context)!
                                                              .wallet
                                                          : AppLocalizations.of(
                                                                  context)!
                                                              .card,
                                              textStyle: Theme.of(context)
                                                  .textTheme
                                                  .bodyLarge!
                                                  .copyWith(
                                                      color: Theme.of(context)
                                                          .primaryColorDark,
                                                      fontWeight:
                                                          FontWeight.bold),
                                            ),
                                            SizedBox(
                                              width: size.width * 0.025,
                                            ),
                                            MyText(
                                              text:
                                                  '${arg.requestBillData.requestedCurrencySymbol} ${arg.requestBillData.totalAmount}',
                                              textStyle: Theme.of(context)
                                                  .textTheme
                                                  .bodyMedium!
                                                  .copyWith(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize:
                                                          size.width * 0.045),
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        width: size.width * 0.02,
                                      ),
                                      Expanded(
                                        child: CustomButton(
                                          buttonColor:
                                              Theme.of(context).primaryColor,
                                          buttonName:
                                              AppLocalizations.of(context)!
                                                  .confirm,
                                          onTap: () {
                                            if (arg.requestData.isCompleted ==
                                                        1 &&
                                                    arg.requestData.isPaid ==
                                                        1 ||
                                                arg.requestData.isCompleted ==
                                                        1 &&
                                                    (arg.requestData
                                                                .paymentTypeString ==
                                                            'cash' ||
                                                        arg.requestData
                                                                .paymentTypeString ==
                                                            'wallet')) {
                                              Navigator.pushNamedAndRemoveUntil(
                                                  context,
                                                  ReviewPage.routeName,
                                                  arguments:
                                                      ReviewPageArguments(
                                                          requestId: arg
                                                              .requestData.id,
                                                          driverData:
                                                              arg.driverData),
                                                  (route) => false);
                                            } else if (arg.requestData
                                                        .isCompleted ==
                                                    1 &&
                                                arg.requestData.isPaid == 0 &&
                                                (arg.requestData
                                                            .paymentTypeString ==
                                                        'card' ||
                                                    arg.requestData
                                                            .paymentTypeString ==
                                                        'online')) {
                                              if (arg.requestData
                                                  .paymentGateways.isNotEmpty) {
                                                showModalBottomSheet(
                                                    context: context,
                                                    isScrollControlled: false,
                                                    enableDrag: true,
                                                    isDismissible: true,
                                                    builder: (_) {
                                                      return BlocProvider.value(
                                                        value: context.read<
                                                            BookingBloc>(),
                                                        child: PaymentGatewayListWidget(
                                                            cont: context,
                                                            arg : arg,
                                                            walletPaymentGatways : arg.requestData
                                                                .paymentGateways),
                                                      );
                                                    });
                                              }
                                            }
                                          },
                                        ),
                                      )
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Positioned(
                      top: size.height * 0.18,
                      child: SizedBox(
                        width: size.width,
                        child: Column(
                          children: [
                            SizedBox(
                              width: size.width * 0.8,
                              child: MyText(
                                text: arg.driverData.name.toUpperCase(),
                                textStyle: Theme.of(context)
                                    .textTheme
                                    .bodyLarge!
                                    .copyWith(color: AppColors.white),
                                textAlign: TextAlign.center,
                                maxLines: 1,
                              ),
                            ),
                            SizedBox(height: size.width * 0.025),
                            Container(
                              height: size.width * 0.2,
                              width: size.width * 0.2,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(40),
                                  color: Theme.of(context).dividerColor),
                              child: (arg.driverData.profilePicture.isEmpty)
                                  ? const Icon(
                                      Icons.person,
                                      size: 50,
                                    )
                                  : ClipRRect(
                                      borderRadius: BorderRadius.circular(40),
                                      child: CachedNetworkImage(
                                        imageUrl: arg.driverData.profilePicture,
                                        fit: BoxFit.fill,
                                        placeholder: (context, url) =>
                                            const Center(
                                          child: Loader(),
                                        ),
                                        errorWidget: (context, url, error) =>
                                            const Center(
                                          child: Text(""),
                                        ),
                                      ),
                                    ),
                            )
                          ],
                        ),
                      )),
                  Positioned(
                      child: SafeArea(
                    child: Column(
                      children: [
                        SizedBox(height: size.width * 0.05),
                        Container(
                          height: size.width * 0.1,
                          width: size.width * 0.5,
                          decoration: BoxDecoration(
                              color: Theme.of(context).scaffoldBackgroundColor,
                              borderRadius: const BorderRadius.only(
                                  topRight: Radius.circular(10),
                                  bottomLeft: Radius.circular(10))),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                height: size.width * 0.065,
                                width: size.width * 0.065,
                                child: Image.asset(AppImages.tripSummary),
                              ),
                              SizedBox(width: size.width * 0.05),
                              MyText(
                                text: AppLocalizations.of(context)!.tripSummary,
                                textStyle: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .copyWith(
                                        fontWeight: FontWeight.w600,
                                        color: Theme.of(context).disabledColor),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  )),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

}

