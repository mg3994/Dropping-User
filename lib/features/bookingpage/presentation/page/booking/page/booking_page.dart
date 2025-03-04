// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:restart_tagxi/l10n/app_localizations.dart';
import '../../../../../../common/common.dart';
import '../../../../../../core/utils/custom_dialoges.dart';
import '../../../../../../core/utils/custom_loader.dart';
import '../../../../../../core/utils/custom_snack_bar.dart';
import '../../../../../account/presentation/pages/outstation/page/outstation_page.dart';
import '../../../../../auth/presentation/pages/auth_page.dart';
import '../../../../../home/presentation/pages/home_page.dart';
import '../../../../application/booking_bloc.dart';
import '../widget/booking_body_widget.dart';
import '../widget/bottom/booking_bottom_widget.dart';
import '../widget/bidding_ride/bidding_offer_price.dart';
import '../widget/on_ride/chat_with_driver.dart';
import '../widget/eta_detail_view.dart';
import '../widget/no_driver_found.dart';
import '../widget/rental_ride/rental_package_select.dart';
import '../widget/on_ride/select_cancel_reason.dart';
import '../widget/select_goods_type.dart';
import '../widget/on_ride/sos_notify.dart';
import '../../invoice/page/invoice_page.dart';

class BookingPage extends StatefulWidget {
  static const String routeName = '/booking';
  final BookingPageArguments arg;

  const BookingPage({super.key, required this.arg});

  @override
  State<BookingPage> createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage>
    with TickerProviderStateMixin, WidgetsBindingObserver {


  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      BookingBloc().nearByVechileSubscription?.pause();
      BookingBloc().etaDurationStream?.pause();
    }
    if (state == AppLifecycleState.resumed) {
      BookingBloc().nearByVechileSubscription?.resume();
      BookingBloc().etaDurationStream?.resume();
    }
  }

  @override
  void dispose() {
    if (BookingBloc().nearByVechileSubscription != null) {
      BookingBloc().nearByVechileSubscription?.cancel();
      BookingBloc().nearByVechileSubscription = null;
    }
    if (BookingBloc().etaDurationStream != null) {
      BookingBloc().etaDurationStream?.cancel();
      BookingBloc().etaDurationStream = null;
    }
    BookingBloc().add(BookingNavigatorPopEvent());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return builderWidget();
  }

  Widget builderWidget() {
    return BlocProvider(
      create: (context) => BookingBloc()
        ..add(GetDirectionEvent(vsync: this))
        ..add(BookingInitEvent(arg: widget.arg, vsync: this)),
      child: BlocListener<BookingBloc, BookingState>(
        listener: (context, state) async {
          if (state is BookingLoadingStartState) {
            CustomLoader.loader(context);
          } else if (state is BookingLoadingStopState) {
            CustomLoader.dismiss(context);
          } else if (state is BookingSuccessState) {
            context.read<BookingBloc>().nearByVechileCheckStream(
                context,
                this,
                LatLng(double.parse(widget.arg.picklat),
                    double.parse(widget.arg.picklng)));
          } else if (state is LogoutState) {
            context.read<BookingBloc>().nearByVechileSubscription?.cancel();
            Navigator.pushNamedAndRemoveUntil(
                context, AuthPage.routeName, (route) => false);
            await AppSharedPreference.setLoginStatus(false);
          } else if (state is BookingNavigatorPopState) {
            context.read<BookingBloc>().nearByVechileSubscription?.cancel();
            if (context.read<BookingBloc>().isPop) {
              Navigator.pushNamedAndRemoveUntil(
                  context, HomePage.routeName, (route) => false);
            }
          } else if (state is SelectGoodsTypeState) {
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              isDismissible: false,
              enableDrag: false,
              barrierColor: Theme.of(context).shadowColor,
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              builder: (_) {
                return SelectGoodsType(cont: context);
              },
            );
          } else if (state is ShowEtaInfoState) {
            showModalBottomSheet(
              context: context,
              isDismissible: true,
              enableDrag: true,
              isScrollControlled: true,
              elevation: 0,
              barrierColor: Theme.of(context).shadowColor,
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(20.0),
                ),
              ),
              builder: (_) {
                return EtaDetailsWidget(
                  cont: context,
                      etaInfo: (!context.read<BookingBloc>().isRentalRide)
                          ? context.read<BookingBloc>().isMultiTypeVechiles
                              ? context
                                  .read<BookingBloc>()
                                  .sortedEtaDetailsList[state.infoIndex]
                              : context
                                  .read<BookingBloc>()
                                  .etaDetailsList[state.infoIndex]
                          : context
                              .read<BookingBloc>()
                              .rentalEtaDetailsList[state.infoIndex]);
              },
            );
          } else if (state is ShowBiddingState) {
            context.read<BookingBloc>().farePriceController.text =
                context.read<BookingBloc>().isMultiTypeVechiles
                    ? context
                        .read<BookingBloc>()
                        .sortedEtaDetailsList[
                            context.read<BookingBloc>().selectedVehicleIndex]
                        .total
                        .toString()
                    : context
                        .read<BookingBloc>()
                        .etaDetailsList[
                            context.read<BookingBloc>().selectedVehicleIndex]
                        .total
                        .toString();
            showModalBottomSheet(
              context: context,
              isDismissible: true,
              enableDrag: true,
              elevation: 0,
              isScrollControlled: true,
              barrierColor: Theme.of(context).shadowColor,
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(20.0),
                ),
              ),
              clipBehavior: Clip.antiAliasWithSaveLayer,
              builder: (_) {
                return BiddingOfferingPriceWidget(cont:context,arg: widget.arg);
              },
            );
          } else if (state is BiddingCreateRequestSuccessState) {
            context.read<BookingBloc>().timerCount(context,
                isNormalRide: false,
                duration: int.parse(widget
                    .arg.userData.maximumTimeForFindDriversForRegularRide));
          } else if (state is BookingCreateRequestSuccessState) {
            context.read<BookingBloc>().timerCount(context,
                isNormalRide: true,
                duration: int.parse(widget
                    .arg.userData.maximumTimeForFindDriversForRegularRide));
          } else if (state is BookingNoDriversFoundState) {
            final bookingBloc = context.read<BookingBloc>();
            showModalBottomSheet(
              context: context,
              isDismissible: false,
              enableDrag: false,
              elevation: 0,
              barrierColor: Theme.of(context).shadowColor,
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(20.0),
                ),
              ),
              builder: (_) {
                return BlocProvider.value(
                  value: bookingBloc,
                  child: const NoDriverFoundWidget(),
                );
              },
            );
          } else if (state is BookingLaterCreateRequestSuccessState) {
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (_) {
                return PopScope(
                  canPop: false,
                  child: CustomSingleButtonDialoge(
                    title: AppLocalizations.of(context)!.success,
                    content:
                        AppLocalizations.of(context)!.rideScheduledSuccessfully,
                    btnName: AppLocalizations.of(context)!.okText,
                    onTap: () {
                      context
                          .read<BookingBloc>()
                          .nearByVechileSubscription
                          ?.cancel();
                      Navigator.pop(context);
                      if (state.isOutstation) {
                        Navigator.pushNamed(
                            context, OutstationHistoryPage.routeName,
                            arguments: OutstationHistoryPageArguments(
                                isFromBooking: true));
                      } else {
                        Navigator.pushNamedAndRemoveUntil(
                            context, HomePage.routeName, (route) => false);
                      }
                    },
                  ),
                );
              },
            );
          } else if (state is BookingOnTripRequestState) {
            Navigator.pop(context);
          } else if (state is CancelReasonState) {
            final bookingBloc = context.read<BookingBloc>();
            showModalBottomSheet(
              context: context,
              isDismissible: false,
              enableDrag: false,
              isScrollControlled: true,
              showDragHandle: false,
              elevation: 0,
              barrierColor: AppColors.transparent,
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(20.0),
                ),
              ),
              useSafeArea: true,
              builder: (_) {
                return BlocProvider.value(
                  value: bookingBloc,
                  child: const SelectCancelReasonList(),
                );
              },
            );
          } else if (state is ChatWithDriverState) {
            final bookingBloc = context.read<BookingBloc>();
            // showModalBottomSheet(
            //   context: context,
            //   isDismissible: false,
            //   enableDrag: false,
            //   isScrollControlled: true,
            //   showDragHandle: false,
            //   backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            //   elevation: 0,
            //   barrierColor: AppColors.transparent,
            //   shape: const RoundedRectangleBorder(
            //     borderRadius: BorderRadius.vertical(
            //       top: Radius.circular(20.0),
            //     ),
            //   ),
            //   builder: (_) {
            //     return BlocProvider.value(
            //       value: bookingBloc,
            //       child: const ChatWithDriverWidget(),
            //     );
            //   },
            // );
            Navigator.push(context, MaterialPageRoute(builder: (context) => BlocProvider.value(
                  value: bookingBloc,
                  child: const ChatWithDriverWidget(),
                )));
          } else if (state is TripRideCancelState) {
            if (state.isCancelByDriver) {
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (_) {
                  return PopScope(
                    canPop: false,
                    child: CustomSingleButtonDialoge(
                      title: AppLocalizations.of(context)!.rideCancelled,
                      content:
                          AppLocalizations.of(context)!.rideCancelledByDriver,
                      btnName: AppLocalizations.of(context)!.okText,
                      onTap: () {
                        context
                            .read<BookingBloc>()
                            .nearByVechileSubscription
                            ?.cancel();
                        Navigator.pop(context);
                        context.read<BookingBloc>().isTripStart = false;
                        Navigator.pushNamedAndRemoveUntil(
                            context, HomePage.routeName, (route) => false);
                      },
                    ),
                  );
                },
              );
            } else if (!state.isCancelByDriver) {
              context.read<BookingBloc>().nearByVechileSubscription?.cancel();
              Navigator.pushNamedAndRemoveUntil(
                  context, HomePage.routeName, (route) => false);
            }
          } else if (state is SosState) {
            final bookingBloc = context.read<BookingBloc>();
            showModalBottomSheet(
              context: context,
              isDismissible: true,
              enableDrag: true,
              useRootNavigator: true,
              isScrollControlled: true,
              elevation: 0,
              barrierColor: Theme.of(context).shadowColor,
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(20.0),
                ),
              ),
              builder: (_) {
                return BlocProvider.value(
                    value: bookingBloc, child: const SOSAlertWidget());
              },
            );
          } else if (state is TripCompletedState) {
            context.read<BookingBloc>().nearByVechileSubscription?.cancel();
            Navigator.pushNamedAndRemoveUntil(
                context,
                InvoicePage.routeName,
                arguments: InvoicePageArguments(
                    requestData: context.read<BookingBloc>().requestData!,
                    requestBillData:
                        context.read<BookingBloc>().requestBillData!,
                    driverData: context.read<BookingBloc>().driverData!),
                (route) => false);
          } else if (state is EtaNotAvailableState) {
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (_) {
                return PopScope(
                  canPop: false,
                  child: CustomSingleButtonDialoge(
                    title: AppLocalizations.of(context)!.noDataAvailable,
                    content: AppLocalizations.of(context)!.noDriverFound,
                    btnName: AppLocalizations.of(context)!.okText,
                    onTap: () {
                      context
                          .read<BookingBloc>()
                          .nearByVechileSubscription
                          ?.cancel();
                      Navigator.pop(context);
                      Navigator.pushNamedAndRemoveUntil(
                          context, HomePage.routeName, (route) => false);
                    },
                  ),
                );
              },
            );
          } else if (state is RentalPackageSelectState) {
            final bookingBloc = context.read<BookingBloc>();
            bookingBloc.add(BookingRentalEtaRequestEvent(
              picklat: widget.arg.picklat,
              picklng: widget.arg.picklng,
              transporttype: bookingBloc.transportType,
            ));
            WidgetsBinding.instance.addPostFrameCallback(
              (timeStamp) {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  isDismissible: true,
                  enableDrag: true,
                  barrierColor: Theme.of(context).shadowColor,
                  backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                  builder: (_) {
                    return BlocProvider.value(
                      value: bookingBloc,
                      child: PopScope(
                          canPop: false,
                          child: packageList(context, widget.arg)),
                    );
                  },
                ).whenComplete(
                  () {
                    if (bookingBloc.rentalEtaDetailsList.isEmpty) {
                      bookingBloc.add(BookingNavigatorPopEvent());
                    }
                  },
                );
              },
            );
          } else if (state is RentalPackageConfirmState) {
            if (context.read<BookingBloc>().rentalEtaDetailsList.isNotEmpty) {
              Navigator.pop(context);
            } else {
              showToast(message: AppLocalizations.of(context)!.noDriverFound);
            }
          }
        },
        child: BlocBuilder<BookingBloc, BookingState>(
          buildWhen: (previousState, currentState) {
            return (previousState.hashCode != currentState.hashCode &&
             previousState.runtimeType != currentState.runtimeType);
          },
          builder: (context, state) {
            if (widget.arg.mapType == 'google_map') {
              if (Theme.of(context).brightness == Brightness.dark) {
                if (context.read<BookingBloc>().googleMapController != null) {
                  context
                      .read<BookingBloc>()
                      .googleMapController!
                      .setMapStyle(context.read<BookingBloc>().darkMapString);
                }
              } else {
                if (context.read<BookingBloc>().googleMapController != null) {
                  context
                      .read<BookingBloc>()
                      .googleMapController!
                      .setMapStyle(context.read<BookingBloc>().lightMapString);
                }
              }
            }
            return Material(
              child: Directionality(
                textDirection:
                    context.read<BookingBloc>().textDirection == 'rtl'
                        ? TextDirection.rtl
                        : TextDirection.ltr,
                child: PopScope(
                  canPop: true,
                  child: Scaffold(
                    body: BookingBodyWidget(cont: context,arg:widget.arg),
                    bottomNavigationBar: (context
                                .read<BookingBloc>()
                                .isNormalRideSearching ||
                            context.read<BookingBloc>().isBiddingRideSearching)
                        ? null
                        : (!context.read<BookingBloc>().isTripStart)
                            ? ((!context.read<BookingBloc>().isRentalRide &&
                                        context
                                            .read<BookingBloc>()
                                            .etaDetailsList
                                            .isNotEmpty) ||
                                    (context.read<BookingBloc>().isRentalRide &&
                                        context
                                            .read<BookingBloc>()
                                            .rentalEtaDetailsList
                                            .isNotEmpty))
                                ? BookingBottomWidget(cont: context,arg: widget.arg)
                                : null
                            : null,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
