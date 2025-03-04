import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../common/common.dart';
import '../../../../core/utils/custom_text.dart';
import '../../../../l10n/app_localizations.dart';
import '../../application/home_bloc.dart';

class ServicesModuleWidget extends StatelessWidget {
  final BuildContext cont;
  const ServicesModuleWidget({super.key, required this.cont});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        MyText(
          text: AppLocalizations.of(context)!.service,
          textStyle: Theme.of(context).textTheme.bodyLarge,
        ),
        SizedBox(height: size.width * 0.025),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              if (context.read<HomeBloc>().userData != null &&
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
                Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: InkWell(
                    onTap: () {
                      context
                          .read<HomeBloc>()
                          .add(ServiceTypeChangeEvent(serviceTypeIndex: 0));
                    },
                    child: Container(
                      height: size.width * 0.19,
                      width: size.width * 0.21,
                      decoration: BoxDecoration(
                        color: context.read<HomeBloc>().selectedServiceType == 0
                            ? Theme.of(context).primaryColorLight
                            : Theme.of(context).splashColor,
                        border: Border.all(
                          color:
                              context.read<HomeBloc>().selectedServiceType == 0
                                  ? Theme.of(context).primaryColor
                                  : Theme.of(context).dividerColor,
                        ),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Column(
                        children: [
                          Image.asset(
                            context.read<HomeBloc>().serviceTypeImages[0],
                            height: size.width * 0.10,
                          ),
                          const SizedBox(height: 6),
                          MyText(
                            text: AppLocalizations.of(context)!.taxi,
                            textStyle:
                                Theme.of(context).textTheme.bodySmall!.copyWith(
                                      color: AppColors.black,
                                      fontWeight: FontWeight.bold,
                                    ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              if (context.read<HomeBloc>().userData != null &&
                  (context
                              .read<HomeBloc>()
                              .userData!
                              .enableModulesForApplications ==
                          'delivery' ||
                      context
                              .read<HomeBloc>()
                              .userData!
                              .enableModulesForApplications ==
                          'both'))
                Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: InkWell(
                    onTap: () {
                      context
                          .read<HomeBloc>()
                          .add(ServiceTypeChangeEvent(serviceTypeIndex: 1));
                    },
                    child: Container(
                      height: size.width * 0.19,
                      width: size.width * 0.21,
                      decoration: BoxDecoration(
                        color: context.read<HomeBloc>().selectedServiceType == 1
                            ? Theme.of(context).primaryColorLight
                            : Theme.of(context).splashColor,
                        border: Border.all(
                          color:
                              context.read<HomeBloc>().selectedServiceType == 1
                                  ? Theme.of(context).primaryColor
                                  : Theme.of(context).dividerColor,
                        ),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Column(
                        children: [
                          Image.asset(
                            context.read<HomeBloc>().serviceTypeImages[1],
                            height: size.width * 0.10,
                          ),
                          const SizedBox(height: 6),
                          MyText(
                            text: AppLocalizations.of(context)!.delivery,
                            // text: 'Delivery',
                            textStyle:
                                Theme.of(context).textTheme.bodySmall!.copyWith(
                                      color: AppColors.black,
                                      fontWeight: FontWeight.bold,
                                    ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              if (context.read<HomeBloc>().userData != null &&
                  (context.read<HomeBloc>().userData!.showRentalRide))
                Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: InkWell(
                    onTap: () {
                      context
                          .read<HomeBloc>()
                          .add(ServiceTypeChangeEvent(serviceTypeIndex: 2));
                    },
                    child: Container(
                      height: size.width * 0.19,
                      width: size.width * 0.21,
                      decoration: BoxDecoration(
                        color: context.read<HomeBloc>().selectedServiceType == 2
                            ? Theme.of(context).primaryColorLight
                            : Theme.of(context).splashColor,
                        border: Border.all(
                          color:
                              context.read<HomeBloc>().selectedServiceType == 2
                                  ? Theme.of(context).primaryColor
                                  : Theme.of(context).dividerColor,
                        ),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Column(
                        children: [
                          Image.asset(
                            context.read<HomeBloc>().serviceTypeImages[2],
                            height: size.width * 0.11,
                          ),
                          const SizedBox(height: 2),
                          MyText(
                            text: AppLocalizations.of(context)!.rental,
                            textStyle:
                                Theme.of(context).textTheme.bodySmall!.copyWith(
                                      color: AppColors.black,
                                      fontWeight: FontWeight.bold,
                                    ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              if (context.read<HomeBloc>().userData != null &&
                  (context
                          .read<HomeBloc>()
                          .userData!
                          .showOutstationRideFeature ==
                      '1'))
                Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: InkWell(
                    onTap: () {
                      if (context
                          .read<HomeBloc>()
                          .pickupAddressList
                          .isNotEmpty) {
                        context
                            .read<HomeBloc>()
                            .add(ServiceTypeChangeEvent(serviceTypeIndex: 3));
                      }
                    },
                    child: Container(
                      height: size.width * 0.19,
                      width: size.width * 0.21,
                      decoration: BoxDecoration(
                        color: context.read<HomeBloc>().selectedServiceType == 2
                            ? Theme.of(context).primaryColorLight
                            : Theme.of(context).splashColor,
                        border: Border.all(
                          color:
                              context.read<HomeBloc>().selectedServiceType == 2
                                  ? Theme.of(context).primaryColor
                                  : Theme.of(context).dividerColor,
                        ),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Column(
                        children: [
                          Image.asset(
                            context.read<HomeBloc>().serviceTypeImages[3],
                            height: size.width * 0.11,
                          ),
                          const SizedBox(height: 2),
                          MyText(
                            text: AppLocalizations.of(context)!.outStation,
                            textStyle:
                                Theme.of(context).textTheme.bodySmall!.copyWith(
                                      color: AppColors.black,
                                      fontWeight: FontWeight.bold,
                                    ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
            ],
          ),
        ),
      ],
    );
  
  }
}