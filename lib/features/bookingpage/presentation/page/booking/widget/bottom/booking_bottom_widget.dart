import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../../common/common.dart';
import '../../../../../../../core/utils/custom_button.dart';
import '../../../../../../../core/utils/custom_snack_bar.dart';
import '../../../../../../../core/utils/custom_text.dart';
import '../../../../../../../l10n/app_localizations.dart';
import '../../../../../application/booking_bloc.dart';
import 'apply_coupons_widget.dart';
import 'select_payment_widget.dart';
import 'select_preference_widget.dart';

class BookingBottomWidget extends StatelessWidget {
  final BuildContext cont;
  final BookingPageArguments arg;
  const BookingBottomWidget({super.key, required this.cont, required this.arg});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return BlocProvider.value(value: cont.read<BookingBloc>(),
    child: BlocBuilder<BookingBloc,BookingState>(builder: (context, state) {
      return SafeArea(
      child: Container(
        width: size.width,
        margin: const EdgeInsets.only(top: 1),
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
          boxShadow: [
            BoxShadow(
                offset: const Offset(-1, -2),
                blurRadius: 10,
                spreadRadius: 1,
                color: Theme.of(context).splashColor)
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: size.width * 0.03),
              Row(
                mainAxisAlignment:
                    context.read<BookingBloc>().transportType == 'taxi'
                        ? MainAxisAlignment.spaceAround
                        : MainAxisAlignment.start,
                children: [
                  // PAYMENT
                  if (context.read<BookingBloc>().transportType == 'taxi')
                    InkWell(
                      onTap: () {
                        showModalBottomSheet(
                            context: context,
                            barrierColor: Theme.of(context).shadowColor,
                            backgroundColor:
                                Theme.of(context).scaffoldBackgroundColor,
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.vertical(
                                top: Radius.circular(
                                    20.0), // Adjust the radius to your linking
                              ),
                            ),
                            builder: (_) {
                              return SelectPaymentMethodWidget(cont : context);
                            });
                      },
                      child: Row(
                        children: [
                          Icon(
                              context.read<BookingBloc>().selectedPaymentType ==
                                      'cash'
                                  ? Icons.payments_outlined
                                  : context
                                              .read<BookingBloc>()
                                              .selectedPaymentType ==
                                          'card'
                                      ? Icons.credit_card_rounded
                                      : Icons.account_balance_wallet_outlined,
                              color: Theme.of(context).primaryColorDark),
                          SizedBox(width: size.width * 0.05),
                          MyText(
                              text: context
                                  .read<BookingBloc>()
                                  .selectedPaymentType,
                              textStyle: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(fontWeight: FontWeight.bold))
                        ],
                      ),
                    ),
                  if (context.read<BookingBloc>().transportType == 'taxi') ...[
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: Container(
                          height: 20,
                          width: 1,
                          color: Theme.of(context).disabledColor),
                    ),
                    // PREFERENCE
                    InkWell(
                      onTap: () {
                        if (context
                                    .read<BookingBloc>()
                                    .userData!
                                    .enablePetPreferenceForUser ==
                                '1' ||
                            context
                                    .read<BookingBloc>()
                                    .userData!
                                    .enableLuggagePreferenceForUser ==
                                '1') {
                          showModalBottomSheet(
                              context: context,
                              isScrollControlled: false,
                              enableDrag: false,
                              isDismissible: true,
                              barrierColor: Theme.of(context).shadowColor,
                              backgroundColor:
                                  Theme.of(context).scaffoldBackgroundColor,
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(20.0),
                                  topRight: Radius.circular(
                                      20.0), // Adjust the radius to your liking
                                ),
                              ),
                              builder: (_) {
                                return SelectPreferenceWidget(cont:context);
                              });
                        } else {
                          showToast(message: "Unavailable");
                        }
                      },
                      child: Row(children: [
                        Icon(Icons.tune,
                            size: 20,
                            color: Theme.of(context).primaryColorDark),
                        SizedBox(width: size.width * 0.03),
                        Column(
                          children: [
                            MyText(
                                text: AppLocalizations.of(context)!.preference,
                                textStyle: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .copyWith(fontWeight: FontWeight.bold)),
                            Row(
                              children: [
                                if (context
                                        .read<BookingBloc>()
                                        .luggagePreference ==
                                    true)
                                  Icon(
                                    Icons.luggage,
                                    size: 15,
                                    color: Theme.of(context).primaryColorDark,
                                  ),
                                SizedBox(width: size.width * 0.01),
                                if (context.read<BookingBloc>().petPreference ==
                                    true)
                                  Icon(
                                    Icons.pets,
                                    size: 15,
                                    color: Theme.of(context).primaryColorDark,
                                  )
                              ],
                            )
                          ],
                        )
                      ]),
                    ),
                  ],
                  if ((context.read<BookingBloc>().transportType == 'taxi' &&
                          !context.read<BookingBloc>().showBiddingVehicles &&
                          !context.read<BookingBloc>().isRentalRide) ||
                      (context.read<BookingBloc>().transportType == 'taxi' &&
                          context.read<BookingBloc>().isRentalRide)) ...[
                    if (context.read<BookingBloc>().transportType == 'taxi')
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        child: Container(
                            height: 20,
                            width: 1,
                            color: Theme.of(context).disabledColor),
                      ),
                    // COUPONS
                    InkWell(
                      onTap: () {
                        context.read<BookingBloc>().promoErrorText = '';
                        context.read<BookingBloc>().add(UpdateEvent());
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          barrierColor: Theme.of(context).shadowColor,
                          backgroundColor:
                              Theme.of(context).scaffoldBackgroundColor,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(20.0),
                            ),
                          ),
                          builder: (_) {
                            return ApplyCouponWidget(cont:context,arg:arg);
                          },
                        );
                      },
                      child: Row(children: [
                        Icon(Icons.percent,
                            size: 20,
                            color: Theme.of(context).primaryColorDark),
                        SizedBox(width: size.width * 0.03),
                        MyText(
                            text: AppLocalizations.of(context)!.coupon,
                            textStyle: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(fontWeight: FontWeight.bold))
                      ]),
                    )
                  ]
                ],
              ),
              SizedBox(height: size.width * 0.05),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (context.read<BookingBloc>().detailView)
                    Expanded(
                        child: Align(
                            alignment: Alignment.centerLeft,
                            child: SizedBox(width: size.width * 0.1))),
                  Center(
                    child: CustomButton(
                      buttonColor: Theme.of(context).primaryColor,
                      buttonName: (context.read<BookingBloc>().transportType ==
                                  'delivery' &&
                              !context.read<BookingBloc>().detailView)
                          ? AppLocalizations.of(context)!.continueN
                          : (context
                                  .read<BookingBloc>()
                                  .scheduleDateTime
                                  .isEmpty)
                              ? AppLocalizations.of(context)!.rideNow
                              : AppLocalizations.of(context)!.scheduleRide,
                      isLoader: context.read<BookingBloc>().isLoading,
                      onTap: () {
                        if (context.read<BookingBloc>().selectedVehicleIndex !=
                            999) {
                          if (context.read<BookingBloc>().transportType ==
                                  'delivery' &&
                              !context.read<BookingBloc>().detailView) {
                            // Update detail view state using DetailViewUpdateEvent
                            context
                                .read<BookingBloc>()
                                .add(DetailViewUpdateEvent(true));
                            Future.delayed(const Duration(milliseconds: 301),
                                () {
                              if (!context.mounted) return;
                              context.read<BookingBloc>().detailView = true;
                              context.read<BookingBloc>().add(UpdateEvent());
                            });
                          } else {
                            if ((arg.isOutstationRide &&
                                    context.read<BookingBloc>().isRoundTrip &&
                                    context
                                        .read<BookingBloc>()
                                        .scheduleDateTimeForReturn
                                        .isNotEmpty) ||
                                ((arg.isOutstationRide &&
                                        !context
                                            .read<BookingBloc>()
                                            .isRoundTrip) ||
                                    (!arg.isOutstationRide))) {
                              if (context.read<BookingBloc>().transportType ==
                                      'taxi' ||
                                  (context.read<BookingBloc>().transportType ==
                                          'delivery' &&
                                      context
                                              .read<BookingBloc>()
                                              .selectedGoodsTypeId !=
                                          0)) {
                                context.read<BookingBloc>().detailView = false;
                                bool biddingDispatch = !context
                                        .read<BookingBloc>()
                                        .isRentalRide
                                    ? context
                                            .read<BookingBloc>()
                                            .isMultiTypeVechiles
                                        ? context
                                                .read<BookingBloc>()
                                                .sortedEtaDetailsList[context
                                                    .read<BookingBloc>()
                                                    .selectedVehicleIndex]
                                                .dispatchType !=
                                            'normal'
                                        : context
                                                .read<BookingBloc>()
                                                .etaDetailsList[context
                                                    .read<BookingBloc>()
                                                    .selectedVehicleIndex]
                                                .dispatchType !=
                                            'normal'
                                    : false;
                                if ((!context
                                            .read<BookingBloc>()
                                            .isMultiTypeVechiles &&
                                        biddingDispatch) ||
                                    (context
                                            .read<BookingBloc>()
                                            .isMultiTypeVechiles &&
                                        context
                                            .read<BookingBloc>()
                                            .showBiddingVehicles &&
                                        biddingDispatch)) {
                                  context
                                      .read<BookingBloc>()
                                      .add(EnableBiddingEvent());
                                } else {
                                  context.read<BookingBloc>().add(
                                        BookingCreateRequestEvent(
                                            userData: arg.userData,
                                            vehicleData: !context
                                                    .read<BookingBloc>()
                                                    .isRentalRide
                                                ? context
                                                        .read<BookingBloc>()
                                                        .isMultiTypeVechiles
                                                    ? context.read<BookingBloc>().sortedEtaDetailsList[context
                                                        .read<BookingBloc>()
                                                        .selectedVehicleIndex]
                                                    : context.read<BookingBloc>().etaDetailsList[context
                                                        .read<BookingBloc>()
                                                        .selectedVehicleIndex]
                                                : context
                                                        .read<BookingBloc>()
                                                        .rentalEtaDetailsList[
                                                    context
                                                        .read<BookingBloc>()
                                                        .selectedVehicleIndex],
                                            pickupAddressList:
                                                arg.pickupAddressList,
                                            dropAddressList:
                                                arg.stopAddressList,
                                            selectedTransportType: context
                                                .read<BookingBloc>()
                                                .transportType,
                                            paidAt: context.read<BookingBloc>().payAtDrop
                                                ? 'Receiver'
                                                : 'Sender',
                                            selectedPaymentType: context
                                                .read<BookingBloc>()
                                                .selectedPaymentType,
                                            scheduleDateTime: context
                                                .read<BookingBloc>()
                                                .scheduleDateTime,
                                            goodsTypeId: context
                                                .read<BookingBloc>()
                                                .selectedGoodsTypeId
                                                .toString(),
                                            goodsQuantity: context
                                                .read<BookingBloc>()
                                                .goodsQtyController
                                                .text,
                                            polyLine: context.read<BookingBloc>().polyLine,
                                            isPetAvailable: context.read<BookingBloc>().petPreference,
                                            isLuggageAvailable: context.read<BookingBloc>().luggagePreference,
                                            isRentalRide: context.read<BookingBloc>().isRentalRide),
                                      );
                                }
                              } else {
                                showToast(
                                    message: AppLocalizations.of(context)!
                                        .pleaseSelectGoodsType);
                              }
                            } else {
                              showToast(
                                  message: AppLocalizations.of(context)!
                                      .pleaseSelectReturnDate);
                            }
                          }
                        } else {
                          showToast(
                              message: AppLocalizations.of(context)!
                                  .pleaseSelectVehicle);
                        }
                      },
                    ),
                  ),
                  if (context.read<BookingBloc>().detailView)
                    Expanded(
                      child: Align(
                        alignment: Alignment.center,
                        child: InkWell(
                          onTap: () {
                            context.read<BookingBloc>().add(
                                  DetailViewUpdateEvent(
                                      context.read<BookingBloc>().detailView
                                          ? false
                                          : true),
                                );
                          },
                          child: Icon(
                            context.read<BookingBloc>().detailView
                                ? Icons.keyboard_arrow_down_rounded
                                : Icons.tune,
                            color: Theme.of(context).primaryColorDark,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              SizedBox(height: size.width * 0.05)
            ],
          ),
        ),
      ),
    );
  
    },),);
  }
}