import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../../../common/common.dart';
import '../../../../../../core/utils/custom_navigation_icon.dart';
import '../../../../application/booking_bloc.dart';
import 'bidding_ride/bidding_waiting_for_driver.dart';
import 'booking_map_widget.dart';
import 'delivery_booking_widget.dart';
import 'eta_list_shimmer.dart';
import 'on_ride/on_ride_bottom_sheet.dart';
import 'ride_preview_widget.dart';
import 'waiting_for_driver.dart';

class BookingBodyWidget extends StatelessWidget {
  final BuildContext cont;
  final BookingPageArguments arg;
  const BookingBodyWidget({super.key, required this.cont, required this.arg});

  @override
  Widget build(BuildContext context) {
    final size =MediaQuery.sizeOf(context);
    return BlocProvider.value(value: cont.read<BookingBloc>(),
    child: BlocBuilder<BookingBloc,BookingState>(builder: (context, state) {
      return Stack(
      children: [
        Stack(
          children: [
            if(context.read<BookingBloc>().animation != null)
            BookingMapWidget(cont:context,mapType:arg.mapType),

            if (!context.read<BookingBloc>().isNormalRideSearching &&
                !context.read<BookingBloc>().isBiddingRideSearching)
              SafeArea(
                child: Padding(
                  padding: EdgeInsets.all(size.width * 0.05),
                  child: Row(
                    children: [
                      if ((arg.isRentalRide != null &&
                              arg.isRentalRide! &&
                              context
                                  .read<BookingBloc>()
                                  .rentalEtaDetailsList
                                  .isNotEmpty) ||
                          arg.isRentalRide == null ||
                          !arg.isRentalRide!)
                        NavigationIconWidget(
                          onTap: () {
                            context
                                .read<BookingBloc>()
                                .add(BookingNavigatorPopEvent());
                          },
                          icon: Icon(Icons.arrow_back_ios_new_rounded,
                              size: 20,
                              color: Theme.of(context).primaryColorDark),
                          isShadowWidget: true,
                        ),
                    ],
                  ),
                ),
              ),
            Positioned(
              bottom: size.height * 0.55,
              right: size.width * 0.03,
              child: Column(
                children: [
                  if (!context.read<BookingBloc>().isNormalRideSearching &&
                      !context.read<BookingBloc>().isBiddingRideSearching)
                    InkWell(
                      onTap: () {
                        if (context.read<BookingBloc>().googleMapController !=
                                null &&
                            context.read<BookingBloc>().bound != null) {
                          context
                              .read<BookingBloc>()
                              .googleMapController
                              ?.animateCamera(CameraUpdate.newLatLngBounds(
                                  context.read<BookingBloc>().bound!, 100));
                        }
                      },
                      child: Container(
                        height: size.width * 0.11,
                        width: size.width * 0.11,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.white,
                          border: Border.all(
                            width: 1.2,
                            color: AppColors.black.withOpacity(0.8),
                          ),
                        ),
                        child: Center(
                          child: Icon(
                            Icons.my_location,
                            size: size.width * 0.05,
                            color: AppColors.black,
                          ),
                        ),
                      ),
                    ),
                  SizedBox(height: size.width * 0.02),
                  if (context.read<BookingBloc>().requestData != null &&
                      context.read<BookingBloc>().requestData!.isTripStart ==
                          1) ...[
                    InkWell(
                      onTap: () async {
                        await Share.share(
                            'Your Driver is ${context.read<BookingBloc>().driverData!.name}. ${context.read<BookingBloc>().driverData!.carColor} ${context.read<BookingBloc>().driverData!.carMakeName} ${context.read<BookingBloc>().driverData!.carModelName}, Vehicle Number: ${context.read<BookingBloc>().driverData!.carNumber}. Track with link: ${AppConstants.baseUrl}track/request/${context.read<BookingBloc>().requestData!.id}');
                      },
                      child: Container(
                        height: size.width * 0.11,
                        width: size.width * 0.11,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.white,
                          border: Border.all(
                            width: 1.2,
                            color: AppColors.black.withOpacity(0.8),
                          ),
                        ),
                        alignment: Alignment.center,
                        child: Icon(
                          Icons.share,
                          size: size.width * 0.05,
                          color: AppColors.black,
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        context.read<BookingBloc>().add(SOSEvent());
                      },
                      child: Container(
                        height: size.width * 0.18,
                        width: size.width * 0.18,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                        ),
                        child: Image.asset(AppImages.sosImage),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
        (context.read<BookingBloc>().isBiddingRideSearching)
            ? AnimatedPositioned(
                bottom: 0,
                curve: Curves.easeInOut,
                duration: const Duration(milliseconds: 100),
                child: GestureDetector(
                  onVerticalDragStart: (details) {
                    context.read<BookingBloc>().onRideBottomCurrentHeight =
                        details.globalPosition.dy;
                  },
                  onVerticalDragUpdate: (details) {
                    double deltaY = details.globalPosition.dy -
                        context.read<BookingBloc>().onRideBottomCurrentHeight;
                    double newPosition =
                        context.read<BookingBloc>().onRideBottomPosition -
                            deltaY;

                    // Set bounds for the new position
                    if (newPosition > 0) {
                      newPosition = 0; // Prevent going above screen
                    }
                    if (newPosition > size.height * 0.6) {
                      newPosition = size.height * 0.3; // Max height
                    }

                    context.read<BookingBloc>().onRideBottomPosition =
                        newPosition;

                    context.read<BookingBloc>().onRideBottomCurrentHeight =
                        details.globalPosition
                            .dy; // Update the drag start position
                    context.read<BookingBloc>().add(UpdateEvent());
                  },
                  onVerticalDragEnd: (details) {
                    debugPrint(
                        '${context.read<BookingBloc>().onRideBottomPosition} < ${-size.height * 0.35}');
                    // Optional: snap to positions if needed
                    if (context.read<BookingBloc>().onRideBottomPosition <
                        -size.height * 0.35) {
                      context.read<BookingBloc>().onRideBottomPosition =
                          -size.height * 0.33; // Snap to the top
                      context.read<BookingBloc>().add(UpdateEvent());
                    } else {
                      context.read<BookingBloc>().onRideBottomPosition =
                          0.0; // Snap to the bottom
                      context.read<BookingBloc>().add(UpdateEvent());
                    }
                  },
                  child: BiddingWaitingForDriverConfirmation(
                    maximumTime: double.parse(
                      arg.userData.maximumTimeForFindDriversForRegularRide),
                  ),
                ),
              )
            : (context.read<BookingBloc>().isNormalRideSearching)
                ? AnimatedPositioned(
                    bottom: context.read<BookingBloc>().onRideBottomPosition,
                    curve: Curves.easeInOut,
                    duration: const Duration(milliseconds: 100),
                    child: GestureDetector(
                      onVerticalDragStart: (details) {
                        context.read<BookingBloc>().onRideBottomCurrentHeight =
                            details.globalPosition.dy;
                      },
                      onVerticalDragUpdate: (details) {
                        double deltaY = details.globalPosition.dy -
                            context
                                .read<BookingBloc>()
                                .onRideBottomCurrentHeight;
                        double newPosition =
                            context.read<BookingBloc>().onRideBottomPosition -
                                deltaY;

                        // Set bounds for the new position
                        if (newPosition > 0) {
                          newPosition = 0; // Prevent going above screen
                        }
                        if (newPosition > size.height * 0.6) {
                          newPosition = size.height * 0.3; // Max height
                        }

                        context.read<BookingBloc>().onRideBottomPosition =
                            newPosition;

                        context.read<BookingBloc>().onRideBottomCurrentHeight =
                            details.globalPosition
                                .dy; // Update the drag start position
                        context.read<BookingBloc>().add(UpdateEvent());
                      },
                      onVerticalDragEnd: (details) {
                        debugPrint(
                            '${context.read<BookingBloc>().onRideBottomPosition} < ${-size.height * 0.35}');
                        // Optional: snap to positions if needed
                        if (context.read<BookingBloc>().onRideBottomPosition <
                            -size.height * 0.35) {
                          context.read<BookingBloc>().onRideBottomPosition =
                              -size.height * 0.33; // Snap to the top
                          context.read<BookingBloc>().add(UpdateEvent());
                        } else {
                          context.read<BookingBloc>().onRideBottomPosition =
                              0.0; // Snap to the bottom
                          context.read<BookingBloc>().add(UpdateEvent());
                        }
                      },
                      child: WaitingForDriverConfirmation(
                          maximumTime: double.parse(arg.userData
                              .maximumTimeForFindDriversForRegularRide)),
                    ),
                  )
                : (context.read<BookingBloc>().isTripStart)
                    ? AnimatedPositioned(
                        bottom:
                            context.read<BookingBloc>().onRideBottomPosition,
                        curve: Curves.easeInOut,
                        duration: const Duration(milliseconds: 100),
                        child: GestureDetector(
                          onVerticalDragStart: (details) {
                            context
                                    .read<BookingBloc>()
                                    .onRideBottomCurrentHeight =
                                details.globalPosition.dy;
                          },
                          onVerticalDragUpdate: (details) {
                            double deltaY = details.globalPosition.dy -
                                context
                                    .read<BookingBloc>()
                                    .onRideBottomCurrentHeight;
                            double newPosition = context
                                    .read<BookingBloc>()
                                    .onRideBottomPosition -
                                deltaY;

                            // Set bounds for the new position
                            if (newPosition > 0) {
                              newPosition = 0; // Prevent going above screen
                            }
                            if (newPosition > size.height * 0.6) {
                              newPosition = size.height * 0.3; // Max height
                            }

                            context.read<BookingBloc>().onRideBottomPosition =
                                newPosition;

                            context
                                    .read<BookingBloc>()
                                    .onRideBottomCurrentHeight =
                                details.globalPosition
                                    .dy; // Update the drag start position
                            context.read<BookingBloc>().add(UpdateEvent());
                          },
                          onVerticalDragEnd: (details) {
                            debugPrint(
                                '${context.read<BookingBloc>().onRideBottomPosition} < ${-size.height * 0.35}');
                            // Optional: snap to positions if needed
                            if (context
                                    .read<BookingBloc>()
                                    .onRideBottomPosition <
                                -size.height * 0.35) {
                              context.read<BookingBloc>().onRideBottomPosition =
                                  -size.height * 0.33; // Snap to the top
                              context.read<BookingBloc>().add(UpdateEvent());
                            } else {
                              context.read<BookingBloc>().onRideBottomPosition =
                                  0.0; // Snap to the bottom
                              context.read<BookingBloc>().add(UpdateEvent());
                            }
                          },
                          child: const OnRideBottomSheet(),
                        ),
                      )
                    : ((!context.read<BookingBloc>().isRentalRide &&
                                context
                                    .read<BookingBloc>()
                                    .etaDetailsList
                                    .isNotEmpty) ||
                            (context.read<BookingBloc>().isRentalRide &&
                                context
                                    .read<BookingBloc>()
                                    .rentalEtaDetailsList
                                    .isNotEmpty))
                        ? Align(
                            alignment: Alignment.bottomCenter,
                            child: BlocBuilder<BookingBloc, BookingState>(
                              builder: (context, state) {
                                return StatefulBuilder(
                                  builder:
                                      (BuildContext context, StateSetter set) {
                                    return GestureDetector(
                                      onVerticalDragUpdate: (details) {
                                        final dragAmount =
                                            details.primaryDelta!;

                                        set(() {
                                          if (context
                                              .read<BookingBloc>()
                                              .detailView) {
                                            if (dragAmount > 0) {
                                              context
                                                  .read<BookingBloc>()
                                                  .detailView = false;
                                              context
                                                  .read<BookingBloc>()
                                                  .add(UpdateEvent());
                                            }
                                          } else {
                                            if (arg.stopAddressList
                                                    .length ==
                                                1) {
                                              context
                                                  .read<BookingBloc>()
                                                  .currentSize = (context
                                                          .read<BookingBloc>()
                                                          .currentSize -
                                                      (dragAmount /
                                                          size.height))
                                                  .clamp(
                                                      context
                                                          .read<BookingBloc>()
                                                          .minChildSize,
                                                      context
                                                          .read<BookingBloc>()
                                                          .maxChildSize);
                                            } else if (arg
                                                    .stopAddressList.length ==
                                                2) {
                                              context
                                                  .read<BookingBloc>()
                                                  .currentSizeTwo = (context
                                                          .read<BookingBloc>()
                                                          .currentSizeTwo -
                                                      (dragAmount /
                                                          size.height))
                                                  .clamp(
                                                      context
                                                          .read<BookingBloc>()
                                                          .minChildSizeTwo,
                                                      context
                                                          .read<BookingBloc>()
                                                          .maxChildSize);
                                            } else {
                                              context
                                                  .read<BookingBloc>()
                                                  .currentSizeThree = (context
                                                          .read<BookingBloc>()
                                                          .currentSizeThree -
                                                      (dragAmount /
                                                          size.height))
                                                  .clamp(
                                                      context
                                                          .read<BookingBloc>()
                                                          .minChildSizeThree,
                                                      context
                                                          .read<BookingBloc>()
                                                          .maxChildSize);
                                            }
                                          }
                                        });
                                      },
                                      onVerticalDragEnd: (details) {
                                        set(() {
                                          // Snap to position logic for non-detail view
                                          if (!context
                                              .read<BookingBloc>()
                                              .detailView) {
                                            if (arg.stopAddressList
                                                    .length ==
                                                1) {
                                              context
                                                      .read<BookingBloc>()
                                                      .currentSize =
                                                  context
                                                      .read<BookingBloc>()
                                                      .snapToPosition(
                                                          context
                                                              .read<
                                                                  BookingBloc>()
                                                              .currentSize,
                                                          context
                                                              .read<
                                                                  BookingBloc>()
                                                              .minChildSize,
                                                          context
                                                              .read<
                                                                  BookingBloc>()
                                                              .maxChildSize);
                                            } else if (arg
                                                    .stopAddressList.length ==
                                                2) {
                                              context
                                                      .read<BookingBloc>()
                                                      .currentSizeTwo =
                                                  context
                                                      .read<BookingBloc>()
                                                      .snapToPosition(
                                                          context
                                                              .read<
                                                                  BookingBloc>()
                                                              .currentSizeTwo,
                                                          context
                                                              .read<
                                                                  BookingBloc>()
                                                              .minChildSizeTwo,
                                                          context
                                                              .read<
                                                                  BookingBloc>()
                                                              .maxChildSize);
                                            } else {
                                              context
                                                      .read<BookingBloc>()
                                                      .currentSizeThree =
                                                  context
                                                      .read<BookingBloc>()
                                                      .snapToPosition(
                                                          context
                                                              .read<
                                                                  BookingBloc>()
                                                              .currentSizeThree,
                                                          context
                                                              .read<
                                                                  BookingBloc>()
                                                              .minChildSizeThree,
                                                          context
                                                              .read<
                                                                  BookingBloc>()
                                                              .maxChildSize);
                                            }
                                          }
                                        });
                                      },
                                      child: AnimatedContainer(
                                        duration:
                                            const Duration(milliseconds: 300),
                                        height: (context
                                                .read<BookingBloc>()
                                                .detailView)
                                            ? size.height *
                                                context
                                                    .read<BookingBloc>()
                                                    .maxChildSize
                                            : arg.stopAddressList
                                                        .length ==
                                                    1
                                                ? (size.height *
                                                    (context
                                                            .read<BookingBloc>()
                                                            .currentSize +
                                                        (arg
                                                                .isOutstationRide
                                                            ? 0.14
                                                            : 0)))
                                                : arg.stopAddressList
                                                            .length ==
                                                        2
                                                    ? size.height *
                                                        context
                                                            .read<BookingBloc>()
                                                            .currentSizeTwo
                                                    : size.height *
                                                        context
                                                            .read<BookingBloc>()
                                                            .currentSizeThree,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              const BorderRadius.vertical(
                                            top: Radius.circular(20.0),
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                              color:
                                                  Theme.of(context).shadowColor,
                                              blurRadius: 4.0,
                                              spreadRadius: 2.0,
                                            ),
                                          ],
                                        ),
                                        child: SingleChildScrollView(
                                          physics: !context
                                                  .read<BookingBloc>()
                                                  .detailView
                                              ? const NeverScrollableScrollPhysics()
                                              : const AlwaysScrollableScrollPhysics(),
                                          child: (!context
                                                  .read<BookingBloc>()
                                                  .detailView)
                                              ? RidePreviewWidget(cont: context,arg: arg)
                                              : DeliveryBookingWidget(
                                                  cont: context,
                                                  arg: arg,
                                                  eta:(context
                                                          .read<BookingBloc>()
                                                          .isRentalRide
                                                      ? context
                                                              .read<BookingBloc>()
                                                              .rentalEtaDetailsList[
                                                          context
                                                              .read<
                                                                  BookingBloc>()
                                                              .selectedVehicleIndex]
                                                      : context
                                                              .read<
                                                                  BookingBloc>()
                                                              .isMultiTypeVechiles
                                                          ? context
                                                                  .read<
                                                                      BookingBloc>()
                                                                  .sortedEtaDetailsList[
                                                              context
                                                                  .read<
                                                                      BookingBloc>()
                                                                  .selectedVehicleIndex]
                                                          : context
                                                                  .read<
                                                                      BookingBloc>()
                                                                  .etaDetailsList[
                                                              context
                                                                  .read<
                                                                      BookingBloc>()
                                                                  .selectedVehicleIndex]),
                                                ),
                                        ),
                                      ),
                                    );
                                  },
                                );
                              },
                            ),
                          )
                        : Align(
                            alignment: Alignment.bottomCenter,
                            child: EtaListShimmer(size: size))
      ],
    );
  
    },),);
  }
}