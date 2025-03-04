import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_map/flutter_map.dart' as fm;
import 'package:latlong2/latlong.dart' as fmlt;

import '../../../../../../common/common.dart';
import '../../../../../../core/utils/avatar_glow.dart';
import '../../../../application/booking_bloc.dart';

class BookingMapWidget extends StatelessWidget {
  final BuildContext cont;
  final String mapType;
  const BookingMapWidget(
      {super.key, required this.cont, required this.mapType});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return BlocProvider.value(
      value: cont.read<BookingBloc>(),
      child: BlocBuilder<BookingBloc, BookingState>(
        buildWhen: (previousState, currentState) {
          return (previousState.hashCode != currentState.hashCode &&
              previousState.runtimeType != currentState.runtimeType);
        },
        builder: (context, state) {
          return (mapType == 'google_map')
              // Google Map
              ? Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      height: size.height,
                      width: size.width,
                      child: BlocBuilder<BookingBloc, BookingState>(
                        builder: (_, state) {
                           // Stop the animation if requestData is not null
                          if (context.read<BookingBloc>().requestData != null) {
                            context.read<BookingBloc>().animationController?.stop();
                          }
                          return AnimatedBuilder(
                            animation: context.read<BookingBloc>().animation!,
                            builder: (_, child) {
                              return GoogleMap(
                                padding: EdgeInsets.fromLTRB(
                                  size.width * 0.05,
                                  (context.read<BookingBloc>().requestData !=
                                          null)
                                      ? size.width * 0.10 +
                                          MediaQuery.of(context).padding.top
                                      : size.width * 0.05 +
                                          MediaQuery.of(context).padding.top,
                                  size.width * 0.05,
                                  size.width * 0.8,
                                ),
                                gestureRecognizers: {
                                  Factory<OneSequenceGestureRecognizer>(
                                    () => EagerGestureRecognizer(),
                                  ),
                                },
                                onMapCreated: (GoogleMapController controller) {
                                  context
                                      .read<BookingBloc>()
                                      .googleMapController = controller;
                                },
                                compassEnabled: false,
                                initialCameraPosition: CameraPosition(
                                  target: LatLng(
                                    AppConstants.currentLocations.latitude,
                                    AppConstants.currentLocations.longitude,
                                  ),
                                  zoom: 15.0,
                                ),
                                minMaxZoomPreference:
                                    const MinMaxZoomPreference(0, 20),
                                buildingsEnabled: false,
                                zoomControlsEnabled: false,
                                myLocationEnabled: (context
                                            .read<BookingBloc>()
                                            .isNormalRideSearching ||
                                        context
                                            .read<BookingBloc>()
                                            .isBiddingRideSearching ||
                                        (context
                                                .read<BookingBloc>()
                                                .requestData !=
                                            null))
                                    ? false
                                    : true,
                                myLocationButtonEnabled: false,
                                markers: (context
                                            .read<BookingBloc>()
                                            .isNormalRideSearching ||
                                        context
                                            .read<BookingBloc>()
                                            .isBiddingRideSearching)
                                    ? {}
                                    : Set.from(
                                        context.read<BookingBloc>().markerList),
                                polylines: (context
                                            .read<BookingBloc>()
                                            .isNormalRideSearching ||
                                        context
                                            .read<BookingBloc>()
                                            .isBiddingRideSearching)
                                    ? {}
                                    : (context
                                                .read<BookingBloc>()
                                                .requestData !=
                                            null)
                                        ? context.read<BookingBloc>().polylines
                                        : {
                                            Polyline(
                                              polylineId:
                                                  const PolylineId('greyRoute'),
                                              points: context
                                                  .read<BookingBloc>()
                                                  .polylist,
                                              color: Colors.grey,
                                              width: 5,
                                            ),
                                            Polyline(
                                              polylineId: const PolylineId(
                                                  'animatedRoute'),
                                              points: context
                                                  .read<BookingBloc>()
                                                  .getGoogleMapAnimatedPolyline(
                                                      context
                                                          .read<BookingBloc>()
                                                          .polylist,
                                                      context
                                                          .read<BookingBloc>()
                                                          .animation!
                                                          .value),
                                              color: Theme.of(context)
                                                  .primaryColor,
                                              width: 5,
                                            ),
                                          },
                                rotateGesturesEnabled: (context
                                            .read<BookingBloc>()
                                            .isNormalRideSearching ||
                                        context
                                            .read<BookingBloc>()
                                            .isBiddingRideSearching)
                                    ? false
                                    : true,
                                zoomGesturesEnabled: (context
                                            .read<BookingBloc>()
                                            .isNormalRideSearching ||
                                        context
                                            .read<BookingBloc>()
                                            .isBiddingRideSearching)
                                    ? false
                                    : true,
                                scrollGesturesEnabled: (context
                                            .read<BookingBloc>()
                                            .isNormalRideSearching ||
                                        context
                                            .read<BookingBloc>()
                                            .isBiddingRideSearching)
                                    ? false
                                    : true,
                              );
                            },
                          );
                        },
                      ),
                    ),
                    if (context.read<BookingBloc>().isNormalRideSearching ||
                        context.read<BookingBloc>().isBiddingRideSearching)
                      AvatarGlow(
                        glowColor: AppColors.green,
                        glowRadiusFactor: 2.5,
                        glowCount: 8,
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 25),
                          child: Image.asset(
                            AppImages.confirmationPin,
                            height: 30,
                          ),
                        ),
                      ),
                  ],
                )
              // Flutter Map
              : Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      height: size.height,
                      width: size.width,
                      child: fm.FlutterMap(
                        mapController: context.read<BookingBloc>().fmController,
                        options: fm.MapOptions(
                          onTap: (tapPosition, latLng) {},
                          onMapEvent: (v) async {},
                          onPositionChanged: (p, l) async {},
                          initialCenter: fmlt.LatLng(
                              AppConstants.currentLocations.latitude,
                              AppConstants.currentLocations.longitude),
                          initialZoom: 16,
                          minZoom: 5,
                          maxZoom: 20,
                        ),
                        children: [
                          fm.TileLayer(
                            urlTemplate: Theme.of(context).brightness ==
                                    Brightness.dark
                                ? 'https://cartodb-basemaps-{s}.global.ssl.fastly.net/{z}/{x}/{y}@4x.png'
                                : 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                            subdomains: const ['a', 'b', 'c', 'd', 'e'],
                          ),
                          if (!context
                                  .read<BookingBloc>()
                                  .isNormalRideSearching &&
                              !context
                                  .read<BookingBloc>()
                                  .isBiddingRideSearching)
                            fm.MarkerLayer(
                              markers: List.generate(
                                  context.read<BookingBloc>().markerList.length,
                                  (index) {
                                final marker = context
                                    .read<BookingBloc>()
                                    .markerList
                                    .elementAt(index);
                                return fm.Marker(
                                  point: fmlt.LatLng(marker.position.latitude,
                                      marker.position.longitude),
                                  alignment: Alignment.topCenter,
                                  child: RotationTransition(
                                    turns: AlwaysStoppedAnimation(
                                        marker.rotation / 360),
                                    child: Image.asset(
                                      marker.markerId.value.toString() == 'pick'
                                          ? AppImages.pickPin
                                          : (marker.markerId.value.toString() ==
                                                      'drop' ||
                                                  marker.markerId.value
                                                      .toString()
                                                      .contains('drop'))
                                              ? AppImages.dropPin
                                              : (marker.markerId.value
                                                      .toString()
                                                      .contains('truck'))
                                                  ? AppImages.truck
                                                  : marker.markerId.value
                                                          .toString()
                                                          .contains(
                                                              'motor_bike')
                                                      ? AppImages.bike
                                                      : marker.markerId.value
                                                              .toString()
                                                              .contains('auto')
                                                          ? AppImages.auto
                                                          : marker.markerId
                                                                  .value
                                                                  .toString()
                                                                  .contains(
                                                                      'lcv')
                                                              ? AppImages.lcv
                                                              : marker.markerId
                                                                      .value
                                                                      .toString()
                                                                      .contains(
                                                                          'ehcv')
                                                                  ? AppImages
                                                                      .ehcv
                                                                  : marker.markerId
                                                                          .value
                                                                          .toString()
                                                                          .contains(
                                                                              'hatchback')
                                                                      ? AppImages
                                                                          .hatchBack
                                                                      : marker.markerId
                                                                              .value
                                                                              .toString()
                                                                              .contains('hcv')
                                                                          ? AppImages.hcv
                                                                          : marker.markerId.value.toString().contains('mcv')
                                                                              ? AppImages.mcv
                                                                              : marker.markerId.value.toString().contains('luxury')
                                                                                  ? AppImages.luxury
                                                                                  : marker.markerId.value.toString().contains('premium')
                                                                                      ? AppImages.premium
                                                                                      : marker.markerId.value.toString().contains('suv')
                                                                                          ? AppImages.suv
                                                                                          : (marker.markerId.value.toString().contains('car'))
                                                                                              ? AppImages.car
                                                                                              : '',
                                      width: 16,
                                      height: 30,
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                        return const SizedBox();
                                      },
                                    ),
                                  ),
                                );
                              }),
                            ),
                          // Grey background polyline
                          if (!context
                                  .read<BookingBloc>()
                                  .isNormalRideSearching &&
                              !context
                                  .read<BookingBloc>()
                                  .isBiddingRideSearching) ...[
                            fm.PolylineLayer(
                              polylines: [
                                fm.Polyline(
                                  points: context.read<BookingBloc>().fmpoly,
                                  color: Theme.of(context).dividerColor,
                                  // Grey polyline as background
                                  strokeWidth: 4,
                                ),
                              ],
                            ),
                            AnimatedBuilder(
                              animation: context.read<BookingBloc>().animation!,
                              builder: (context, child) {
                                final fmpoly =
                                    context.read<BookingBloc>().fmpoly;
                                final animatedPoints = context
                                    .read<BookingBloc>()
                                    .getFlutterMapAnimatedPolyline(
                                        fmpoly,
                                        context
                                            .read<BookingBloc>()
                                            .animation!
                                            .value);
                                return fm.PolylineLayer(
                                  polylines: [
                                    fm.Polyline(
                                      points: animatedPoints,
                                      color: Theme.of(context)
                                          .primaryColor, // Red animated polyline
                                      strokeWidth: 6,
                                    ),
                                  ],
                                );
                              },
                            ),
                          ],
                          const fm.RichAttributionWidget(attributions: []),
                        ],
                      ),
                    ),
                    if (context.read<BookingBloc>().isNormalRideSearching ||
                        context.read<BookingBloc>().isBiddingRideSearching)
                      AvatarGlow(
                        glowColor: AppColors.green,
                        glowRadiusFactor: 2.0,
                        glowCount: 10,
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 25),
                          child: Image.asset(
                            AppImages.confirmationPin,
                            height: 30,
                          ),
                        ),
                      ),
                  ],
                );
        },
      ),
    );
  }
}
