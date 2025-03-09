import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../common/common.dart';
import '../../../../core/utils/custom_text.dart';
import '../../../../l10n/app_localizations.dart';
import '../../application/home_bloc.dart';
import 'package:dotted_line/dotted_line.dart'; // Add this package // ADDED: BY MG: Dotted line


class ServicesModuleWidget extends StatelessWidget {
  final BuildContext cont;
  const ServicesModuleWidget({super.key, required this.cont});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return Container(
        padding: const EdgeInsets.all(12),
        
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(6),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 5,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
      
          MyText(
            text: AppLocalizations.of(context)!.service,
            textStyle: Theme.of(context).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.bold),
          ),
      DottedLine( // ADDED: BY MG: Dotted line
                                  dashLength: 2,
                                  dashGapLength: 2,
                                  dashRadius: 1,
                                  lineThickness: 1,
                                  dashColor: Theme.of(context).dividerColor,
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
                    child: 
                    
                    InkWell(
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
                         mainAxisAlignment:  MainAxisAlignment.spaceBetween,
                          children: [
                            Image.asset(
                              context.read<HomeBloc>().serviceTypeImages[0],
                              height: size.width * 0.10,
                            ),
                            const SizedBox(height: 6),
                            Container(
                                   decoration: BoxDecoration(
      color: (context.read<HomeBloc>().isSheetAtTop) ? Colors.transparent:Theme.of(context).primaryColor,
      // borderRadius: BorderRadius.circular(8), // Optional: rounded corners
          borderRadius: const BorderRadius.only(
      bottomLeft: Radius.circular(3),  // Adjust the radius as needed
      bottomRight: Radius.circular(3),  // Adjust the radius as needed
    ),
        ),
        alignment: Alignment.center,
                              child: MyText(
                                text: AppLocalizations.of(context)!.taxi,
                                 textStyle:
                                    Theme.of(context).textTheme.bodySmall!.copyWith(
                                          color:(context.read<HomeBloc>().isSheetAtTop) ? Colors.black : AppColors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      //
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
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Image.asset(
                              context.read<HomeBloc>().serviceTypeImages[1],
                              height: size.width * 0.10,
                            ),
                            const SizedBox(height: 6),
                            Container(
                                     decoration: BoxDecoration(
      color: (context.read<HomeBloc>().isSheetAtTop) ? Colors.transparent:Colors.grey[500],
      // borderRadius: BorderRadius.circular(8), // Optional: rounded corners
          borderRadius: const BorderRadius.only(
      bottomLeft: Radius.circular(3),  // Adjust the radius as needed
      bottomRight: Radius.circular(3),  // Adjust the radius as needed
    ),
        ),
        alignment: Alignment.center,
                              child: MyText(
                                text: AppLocalizations.of(context)!.delivery,
                                // text: 'Delivery',
                            textStyle:
                                    Theme.of(context).textTheme.bodySmall!.copyWith(
                                          color:(context.read<HomeBloc>().isSheetAtTop) ? Colors.black : AppColors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
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
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Image.asset(
                              context.read<HomeBloc>().serviceTypeImages[2],
                              height: size.width * 0.11,
                            ),
                            const SizedBox(height: 2),
                            Container(
                                decoration: BoxDecoration(
      color: (context.read<HomeBloc>().isSheetAtTop) ? Colors.transparent:Colors.grey[500],
      // borderRadius: BorderRadius.circular(8), // Optional: rounded corners
          borderRadius: const BorderRadius.only(
      bottomLeft: Radius.circular(3),  // Adjust the radius as needed
      bottomRight: Radius.circular(3),  // Adjust the radius as needed
    ),
        ),
        alignment: Alignment.center,
                              child:MyText(
                                text: AppLocalizations.of(context)!.rental,
                                textStyle:
                                    Theme.of(context).textTheme.bodySmall!.copyWith(
                                          color:(context.read<HomeBloc>().isSheetAtTop) ? Colors.black : AppColors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
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
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Image.asset(
                              context.read<HomeBloc>().serviceTypeImages[3],
                              height: size.width * 0.11,
                            ),
                            const SizedBox(height: 2),
                               Container(
          decoration: BoxDecoration(
      color: (context.read<HomeBloc>().isSheetAtTop) ? Colors.transparent:Colors.grey[500],
      // borderRadius: BorderRadius.circular(8), // Optional: rounded corners
          borderRadius: const BorderRadius.only(
      bottomLeft: Radius.circular(3),  // Adjust the radius as needed
      bottomRight: Radius.circular(3),  // Adjust the radius as needed
    ),
        ),
        alignment: Alignment.center,
                              child: MyText(
                                text: AppLocalizations.of(context)!.outStation,
                                textStyle:
                                    Theme.of(context).textTheme.bodySmall!.copyWith(
                                          color:(context.read<HomeBloc>().isSheetAtTop) ? Colors.black : AppColors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
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
      ),
    );
  
  }
}