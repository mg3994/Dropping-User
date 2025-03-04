// ignore_for_file: deprecated_member_use

import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:restart_tagxi/core/utils/custom_button.dart";
import "package:restart_tagxi/features/account/presentation/pages/complaint/page/complaint_list.dart";
import "package:restart_tagxi/features/account/presentation/pages/history/widget/trip_fare_breakup_widget.dart";
import "../../../../../../common/common.dart";
import "../../../../../../core/utils/custom_loader.dart";
import "../../../../../../core/utils/custom_text.dart";
import "../../../../../../l10n/app_localizations.dart";
import "../../../../application/acc_bloc.dart";

import "../widget/cancel_ride_widget.dart";
import "../widget/delivery_proof_view.dart";
import "../widget/trip_driver_details_widget.dart";
import "../widget/trip_map_widget.dart";
import "../widget/trip_vehicle_info_widget.dart";

class HistoryTripSummaryPage extends StatelessWidget {
  static const String routeName = '/historytripsummary';
  final HistoryPageArguments arg;

  const HistoryTripSummaryPage({super.key, required this.arg});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return BlocProvider(
      create: (context) => AccBloc()
        ..add(AccGetDirectionEvent())
        ..add(AddHistoryMarkerEvent(
            stops: (arg.historyData.requestStops != null)
                ? arg.historyData.requestStops!.data
                : [],
            pickLat: arg.historyData.pickLat,
            pickLng: arg.historyData.pickLng,
            dropLat: arg.historyData.dropLat,
            dropLng: arg.historyData.dropLng,
            polyline: arg.historyData.polyLine))
        ..add(ComplaintEvent(complaintType: 'request')),
      child: BlocListener<AccBloc, AccState>(
        listener: (context, state) {
          if (state is AccInitialState) {
            CustomLoader.loader(context);
          }
          if (state is RequestCancelState) {
            Navigator.pop(context);
            Navigator.pop(context);
          }
        },
        child: BlocBuilder<AccBloc, AccState>(builder: (context, state) {
          if (Theme.of(context).brightness == Brightness.dark) {
            if (context.read<AccBloc>().googleMapController != null) {
              context
                  .read<AccBloc>()
                  .googleMapController!
                  .setMapStyle(context.read<AccBloc>().darkMapString);
            }
          } else {
            if (context.read<AccBloc>().googleMapController != null) {
              context
                  .read<AccBloc>()
                  .googleMapController!
                  .setMapStyle(context.read<AccBloc>().lightMapString);
            }
          }
          return Directionality(
            textDirection: context.read<AccBloc>().textDirection == 'rtl'
                ? TextDirection.rtl
                : TextDirection.ltr,
            child: Scaffold(
              backgroundColor: const Color(0xffDEDCDC),
              body: Stack(
                children: [
                  SizedBox(
                    height: size.height,
                    width: size.width,
                    child: CustomScrollView(
                      slivers: [
                        SliverAppBar(
                            stretch: false,
                            expandedHeight: size.width * 0.7,
                            pinned: true,
                            backgroundColor:
                                Theme.of(context).scaffoldBackgroundColor,
                            leading: InkWell(
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                child: const Icon(
                                  Icons.arrow_back,
                                  color: AppColors.black,
                                )),
                            flexibleSpace: LayoutBuilder(builder:
                                (BuildContext context,
                                    BoxConstraints constraints) {
                              var top = constraints.biggest.height;
                              return FlexibleSpaceBar(
                                title: AnimatedOpacity(
                                    duration: const Duration(milliseconds: 300),
                                    opacity: top > 71 && top < 91 ? 1.0 : 0.0,
                                    child: Text(
                                      top > 71 && top < 91
                                          ? AppLocalizations.of(context)!
                                              .rideDetails
                                          : "",
                                      style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                    )),
                                background: TripMapWidget(cont : context,arg: arg,));
                            })),
                        SliverList(
                            delegate: SliverChildBuilderDelegate(childCount: 1,
                                (context, index) {
                          return Container(
                            padding: EdgeInsets.all(size.width * 0.03),
                            width: size.width,
                            color: const Color(0xffDEDCDC),
                            child: Column(
                              children: [
                                TripFarebreakupWidget(cont: context, arg: arg),
                                SizedBox(height: size.width * 0.04),

                                TripDriverDetailsWidget(cont:context,arg: arg),
                                SizedBox(height: size.height * 0.01),
                                
                                TripVehicleInfoWidget(cont:context,arg:arg),
                                // delivery ride proof
                                Column(
                                  children: [
                                    if (arg.historyData.transportType ==
                                            'delivery' &&
                                        arg.historyData.requestProofs.data
                                            .isNotEmpty)
                                      Container(
                                          padding:
                                              EdgeInsets.all(size.width * 0.05),
                                          decoration: BoxDecoration(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .secondary
                                                .withOpacity(0.10),
                                            borderRadius:
                                                BorderRadius.circular(5),
                                          ),
                                          child: Column(
                                            children: [
                                              InkWell(
                                                onTap: () {
                                                  if (arg
                                                      .historyData
                                                      .requestProofs
                                                      .data
                                                      .isNotEmpty) {
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) =>
                                                            DeliveryProofViewPage(
                                                                images: arg
                                                                    .historyData
                                                                    .requestProofs
                                                                    .data),
                                                      ),
                                                    );
                                                  }
                                                },
                                                child: Row(
                                                  children: [
                                                    const Icon(Icons.image,
                                                        color: Colors.blue),
                                                    MyText(
                                                      text: AppLocalizations.of(
                                                              context)!
                                                          .loadShipmentProof,
                                                      textStyle: const TextStyle(
                                                          color: Colors.blue,
                                                          decoration:
                                                              TextDecoration
                                                                  .underline,
                                                          decorationColor:
                                                              Colors.blue),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          )),
                                    SizedBox(height: size.width * 0.05),
                                  ],
                                ),
                                Container(
                                    padding: EdgeInsets.all(size.width * 0.05),
                                    decoration: BoxDecoration(
                                      color: Theme.of(context)
                                          .scaffoldBackgroundColor,
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: Row(
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            MyText(
                                              text:
                                                  arg.historyData.requestNumber,
                                              textStyle: Theme.of(context)
                                                  .textTheme
                                                  .bodyMedium!
                                                  .copyWith(),
                                            ),
                                          ],
                                        ),
                                      ],
                                    )),
                                SizedBox(height: size.width * 0.5),
                              ],
                            ),
                          );
                        })),
                      ],
                    ),
                  ),
                  Positioned(
                    bottom: MediaQuery.viewPaddingOf(context).bottom,
                    left: 0,
                    right: 0,
                    child: (arg.historyData.isCompleted == 1)
                        ? Padding(
                            padding: const EdgeInsets.only(
                                left: 10, top: 10, right: 10, bottom: 10),
                            child: CustomButton(
                                buttonName:
                                    AppLocalizations.of(context)!.makeComplaint,
                                onTap: () {
                                  Navigator.pushNamed(
                                      context, ComplaintListPage.routeName,
                                      arguments: ComplaintListPageArguments(
                                          choosenHistoryId:
                                              arg.historyData.id.toString()));
                                }),
                          )
                        : (arg.historyData.isLater &&
                                arg.historyData.isCancelled == 0)
                            ? CustomButton(
                                buttonName:
                                    AppLocalizations.of(context)!.cancel,
                                buttonColor: Theme.of(context).primaryColor,
                                onTap: () {
                                  showModalBottomSheet(
                                      context: context,
                                      isScrollControlled: false,
                                      enableDrag: false,
                                      isDismissible: true,
                                      builder: (_) {
                                        return CancelRideWidget(cont:context, requestId: arg.historyData.id );
                                      });
                                })
                            : Container(),
                  )
                ],
              ),
            ),
          );
        }),
      ),
    );
  }

}
