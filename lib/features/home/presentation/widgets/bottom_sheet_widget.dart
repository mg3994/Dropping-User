import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../common/common.dart';
import '../../../../core/utils/custom_divider.dart';
import '../../../../core/utils/custom_navigation_icon.dart';
import '../../../../core/utils/custom_text.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../account/presentation/pages/account_page.dart';
import '../../application/home_bloc.dart';
import '../../domain/models/user_details_model.dart';
import 'banner_widget.dart';
import 'home_on_going_rides.dart';
import 'recent_search_places_widget.dart';
import 'services_module_widget.dart';

class BottomSheetWidget extends StatelessWidget {
  final BuildContext cont;

  const BottomSheetWidget({super.key, required this.cont});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return BlocProvider.value(
        value: cont.read<HomeBloc>(),
        child: BlocBuilder<HomeBloc, HomeState>(
          builder: (context, state) {
            return Container(
              height: size.height,
              margin: const EdgeInsets.only(top: 1),
              decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(1),
                    topRight: Radius.circular(1)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (!context.read<HomeBloc>().isSheetAtTop) ...[
                    SizedBox(height: size.width * 0.03),
                    Center(
                        child: CustomDivider(
                            height: 5,
                            width: size.width * 0.2,
                            color: Theme.of(context)
                                .dividerColor
                                .withOpacity(0.4))),
                    SizedBox(height: size.width * 0.02),
                  ],
                  if (context.read<HomeBloc>().isSheetAtTop)
                    SizedBox(height: size.width * 0.15),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: BlocBuilder<HomeBloc, HomeState>(
                      builder: (context, state) {
                        // Access the current sheetSize directly from HomeBloc
                        double sheetSize = context.read<HomeBloc>().sheetSize;
                        double maxSheetSize =
                            context.read<HomeBloc>().maxChildSize;
                        double recentSearchWidth = sheetSize == maxSheetSize
                            ? size.width * 0.9
                            : size.width * 0.9;
                        return Container(
                          width: size.width,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(2),
                          ),
                          child: Padding(
                            padding: EdgeInsets.only(
                                right: size.width * 0.0,
                                left: size.width * 0,
                                top: size.width * 0.020,
                                bottom: size.width * 0.020),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    SizedBox(width: size.width * 0.02),
                                    if (context.read<HomeBloc>().isSheetAtTop ==
                                            true &&
                                        context.read<HomeBloc>().userData !=
                                            null)
                                      Flexible(
                                        child: NavigationIconWidget(
                                          icon: InkWell(
                                            onTap: () {
                                              Navigator.pushNamed(context,
                                                      AccountPage.routeName,
                                                      arguments:
                                                          AccountPageArguments(
                                                              userData: context
                                                                  .read<
                                                                      HomeBloc>()
                                                                  .userData!))
                                                  .then((value) {
                                                if (!context.mounted) return;
                                                context
                                                    .read<HomeBloc>()
                                                    .add(GetDirectionEvent());
                                                if (value != null) {
                                                  context
                                                          .read<HomeBloc>()
                                                          .userData =
                                                      value as UserDetail;
                                                  context
                                                      .read<HomeBloc>()
                                                      .add(UpdateEvent());
                                                }
                                              });
                                            },
                                            child: Icon(
                                              Icons.menu,
                                              size: 20,
                                              color: Theme.of(context)
                                                  .primaryColorDark,
                                            ),
                                          ),
                                          isShadowWidget: true,
                                        ),
                                      ),
                                    if (context.read<HomeBloc>().isSheetAtTop)
                                      SizedBox(width: size.width * 0.02),
                                    Flexible(
                                      flex: context
                                          .read<HomeBloc>()
                                          .calculateResponsiveFlex(size.width),
                                      child: InkWell(
                                        onTap: () {
                                          if (context
                                                      .read<HomeBloc>()
                                                      .userData!
                                                      .enableModulesForApplications ==
                                                  'both' ||
                                              context
                                                      .read<HomeBloc>()
                                                      .userData!
                                                      .enableModulesForApplications ==
                                                  'taxi') {
                                            context.read<HomeBloc>().add(
                                                DestinationSelectEvent(
                                                    isPickupChange: false));
                                          } else {
                                            context.read<HomeBloc>().add(
                                                ServiceTypeChangeEvent(
                                                    serviceTypeIndex: 1));
                                          }
                                        },
                                        child: AnimatedContainer(
                                          transformAlignment:
                                              Alignment.centerRight,
                                          duration:
                                              const Duration(milliseconds: 100),
                                          width: recentSearchWidth,
                                          padding:
                                              EdgeInsets.all(size.width * 0.02),
                                          decoration: BoxDecoration(
                                            color: Theme.of(context)
                                                .scaffoldBackgroundColor,
                                            borderRadius:
                                                BorderRadius.circular(2),
                                            border: Border.all(
                                              color: Theme.of(context)
                                                  .disabledColor
                                                  .withOpacity(0.5),
                                            ),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Theme.of(context)
                                                    .shadowColor
                                                    .withOpacity(0.1),
                                                blurRadius: 15,
                                                offset: const Offset(0, 1),
                                                spreadRadius: 1,
                                              ),
                                            ],
                                          ),
                                          child: Row(
                                            children: [
                                              Container(
                                                width: size.width * 0.075,
                                                height: size.width * 0.075,
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: Theme.of(context)
                                                      .disabledColor
                                                      .withOpacity(0.3),
                                                ),
                                                alignment: Alignment.center,
                                                child: Icon(
                                                  Icons.search,
                                                  size: 20,
                                                  color: Theme.of(context)
                                                      .scaffoldBackgroundColor,
                                                ),
                                              ),
                                              SizedBox(
                                                  width: size.width * 0.02),
                                              Expanded(
                                                // Place Expanded inside Row to prevent overflow here
                                                child: MyText(
                                                  text: AppLocalizations.of(
                                                          context)!
                                                      .whereAreYouGoing,
                                                  textStyle: Theme.of(context)
                                                      .textTheme
                                                      .bodyMedium!
                                                      .copyWith(
                                                          color: Theme.of(
                                                                  context)
                                                              .primaryColorDark.withOpacity(0.5),
                                                          fontSize: 9),
                                                ),
                                              ),
                                              if (context
                                                          .read<HomeBloc>()
                                                          .userData !=
                                                      null &&
                                                  (context
                                                          .read<HomeBloc>()
                                                          .userData!
                                                          .showRideWithoutDestination ==
                                                      "1") &&
                                                  (context
                                                              .read<HomeBloc>()
                                                              .userData!
                                                              .enableModulesForApplications ==
                                                          'taxi' ||
                                                      context
                                                              .read<HomeBloc>()
                                                              .userData!
                                                              .enableModulesForApplications ==
                                                          'both'))
                                                InkWell(
                                                  onTap: () {
                                                    context.read<HomeBloc>().add(
                                                        RideWithoutDestinationEvent());
                                                  },
                                                  child: Container(
                                                    height: size.width * 0.075,
                                                    alignment: Alignment.center,
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              right: 5),
                                                      child: MyText(
                                                        text:
                                                            AppLocalizations.of(
                                                                    context)!
                                                                .skip,
                                                        textStyle:
                                                            Theme.of(context)
                                                                .textTheme
                                                                .bodyLarge!
                                                                .copyWith(
                                                                  fontSize: 12,
                                                                  color: Theme.of(
                                                                          context)
                                                                      .disabledColor
                                                                      .withOpacity(
                                                                          0.5),
                                                                ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                // Banner
                                if (context.read<HomeBloc>().isSheetAtTop ==
                                        false &&
                                    context.read<HomeBloc>().userData != null &&
                                    context
                                        .read<HomeBloc>()
                                        .userData!
                                        .bannerImage
                                        .data
                                        .isNotEmpty) ...[
                                  SizedBox(height: size.width * 0.025),
                                  BannerWidget(cont: context),
                                ],
                                // Service Modules
                                  if (context.read<HomeBloc>().isSheetAtTop) ...[
                                    Divider(
                                      color: Theme.of(context)
                                          .dividerColor
                                          .withOpacity(0.4),
                                    ),
                                  ],
                                if (context.read<HomeBloc>().userData != null &&
                                    ((context
                                                .read<HomeBloc>()
                                                .userData!
                                                .enableModulesForApplications ==
                                            'both') ||
                                        (context
                                                    .read<HomeBloc>()
                                                    .userData!
                                                    .enableModulesForApplications ==
                                                'taxi' &&
                                            context
                                                .read<HomeBloc>()
                                                .userData!
                                                .showRentalRide) ||
                                        (context
                                                    .read<HomeBloc>()
                                                    .userData!
                                                    .enableModulesForApplications ==
                                                'delivery' &&
                                            context
                                                .read<HomeBloc>()
                                                .userData!
                                                .showRentalRide)))
                                
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 5 ,vertical: 15),
                                    child: ServicesModuleWidget(cont: cont),
                                  ),

                                // ON GOING RIDES
                                if (context
                                    .read<HomeBloc>()
                                    .isMultipleRide) ...[
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        MyText(
                                            text: AppLocalizations.of(context)!
                                                .onGoingRides,
                                            textStyle: Theme.of(context)
                                                .textTheme
                                                .bodyMedium!
                                                .copyWith(
                                                    fontWeight: FontWeight.bold,
                                                    color: Theme.of(context)
                                                        .primaryColorDark)),
                                      ],
                                    ),
                                  ),
                                   DottedLine( // ADDED: BY MG: Dotted line
                                dashLength: 2,
                                dashGapLength: 2,
                                dashRadius: 1,
                                lineThickness: 1,
                                dashColor: Theme.of(context).dividerColor,
                              ),
                                  SizedBox(height: size.width * 0.01),
                                  HomeOnGoingRidesWidget(cont: context),
                                ],
                                // Recent search places
                                if (context
                                    .read<HomeBloc>()
                                    .recentSearchPlaces
                                    .isNotEmpty) ...[
                                  SizedBox(
                                      height: context
                                                  .read<HomeBloc>()
                                                  .isSheetAtTop ==
                                              false
                                          ? size.width * 0.01
                                          : size.width * 0.02),
                                  RecentSearchPlacesWidget(cont: context)
                                ],
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  SizedBox(height: size.width * 0.01),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (context.read<HomeBloc>().isSheetAtTop == true &&
                          context.read<HomeBloc>().userData != null &&
                          context
                              .read<HomeBloc>()
                              .userData!
                              .bannerImage
                              .data
                              .isNotEmpty) ...[
                        SizedBox(height: size.width * 0.025),
                        BannerWidget(cont: context),
                      ],
                    ],
                  ),
                  SizedBox(height: size.width * 0.1),
                  Expanded(
                      child: Container(
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(AppImages.bottomBackground),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ))
                ],
              ),
            );
          },
        ));
  }
}
