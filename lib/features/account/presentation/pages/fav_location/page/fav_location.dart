import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restart_tagxi/core/utils/custom_navigation_icon.dart';
import 'package:restart_tagxi/l10n/app_localizations.dart';
import '../../../../../../common/app_arguments.dart';
import '../../../../../../core/utils/custom_text.dart';
import '../../../../../home/domain/models/stop_address_model.dart';
import '../../../../../home/presentation/pages/confirm_location_page.dart';
import '../../../../application/acc_bloc.dart';
import '../widget/delete_address_widget.dart';
import '../widget/favourites_shimmer_loading.dart';
import '../../../widgets/top_bar.dart';
import 'confirm_fav_location.dart';

class FavoriteLocationPage extends StatelessWidget {
  final FavouriteLocationPageArguments arg;
  static const String routeName = '/favoriteLocation';

  const FavoriteLocationPage({super.key, required this.arg});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return BlocProvider(
      create: (context) => AccBloc()
        ..add(GetFavListEvent(
            userData: arg.userData,
            favAddressList: arg.userData.favouriteLocations.data)),
      child: BlocListener<AccBloc, AccState>(
        listener: (context, state) {
          if (state is SelectFromFavAddressState) {
            Navigator.pushNamed(context, ConfirmLocationPage.routeName,
                    arguments: ConfirmLocationPageArguments(
                        isEditAddress: false,
                        userData: arg.userData,
                        isPickupEdit: false,
                        // isAddStopAddress: true,
                        mapType: context.read<AccBloc>().userData!.mapType,
                        transportType: ''))
                .then(
              (value) {
                if (!context.mounted) return;
                if (value != null) {
                  final address = value as AddressModel;
                  if (state.addressType == 'Home' ||
                      state.addressType == 'Work') {
                    context.read<AccBloc>().add(AddFavAddressEvent(
                        isOther: false,
                        address: address.address,
                        name: state.addressType,
                        lat: address.lat.toString(),
                        lng: address.lng.toString()));
                  } else {
                    if (context.read<AccBloc>().userData != null) {
                      Navigator.pushNamed(context, ConfirmFavLocation.routeName,
                              arguments: ConfirmFavouriteLocationPageArguments(
                                  userData: context.read<AccBloc>().userData!,
                                  selectedAddress: address))
                          .then(
                        (value) {
                          if (!context.mounted) return;
                          context.read<AccBloc>().add(AccGetUserDetailsEvent());
                        },
                      );
                    }
                  }
                }
              },
            );
          }
        },
        child: BlocBuilder<AccBloc, AccState>(builder: (context, state) {
          return Scaffold(
            body: TopBarDesign(
              isHistoryPage: false,
              title: AppLocalizations.of(context)!.favoriteLocation,
              onTap: () {
                Navigator.pop(context, context.read<AccBloc>().userData);
              },
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(
                      size.width * 0.05,
                      size.width * 0.025,
                      size.width * 0.05,
                      size.width * 0.025),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (context.read<AccBloc>().isFavLoading)
                        ListView.builder(
                          itemCount: 6,
                          shrinkWrap: true,
                          physics: const ClampingScrollPhysics(),
                          itemBuilder: (context, index) {
                            return FavouriteShimmerLoading(size: size);
                          },
                        ),
                      if (!context.read<AccBloc>().isFavLoading) ...[
                        (context.read<AccBloc>().home.isNotEmpty)
                            ?        Container(
                                   margin: const EdgeInsets.only(top: 8),
                                                  padding: const EdgeInsets.all(16.0),

                                        decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(5.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 5,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                              child: Row(
                                  children: [
                                    NavigationIconWidget(
                                      // color: Theme.of(context).cardColor,
                                      icon: Icon(
                                        Icons.home,
                                        color: Theme.of(context).primaryColorDark,
                                        size: size.width * 0.06,
                                      ),
                                    ),
                                    SizedBox(width: size.width * 0.02),
                                    Expanded(
                                        child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        MyText(
                                          text:
                                              AppLocalizations.of(context)!.home,
                                          textStyle: Theme.of(context)
                                              .textTheme
                                              .bodyMedium!
                                              .copyWith(
                                                  color: Theme.of(context)
                                                      .primaryColorDark,
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.bold),
                                        ),
                                          DottedLine( // ADDED: BY MG: Dotted line
                                  dashLength: 2,
                                  dashGapLength: 2,
                                  dashRadius: 1,
                                  lineThickness: 1,
                                  dashColor: Theme.of(context).dividerColor,
                                ),
                                        SingleChildScrollView(
                                          scrollDirection: Axis.horizontal,
                                          child: MyText(
                                            text: context
                                                .read<AccBloc>()
                                                .home[0]
                                                .pickAddress,
                                            textStyle: Theme.of(context)
                                                .textTheme
                                                .bodySmall!
                                                .copyWith(
                                                    color: Theme.of(context)
                                                        .disabledColor
                                                        .withOpacity(0.6)),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    )),
                                    SizedBox(width: size.width * 0.015),
                                    InkWell(
                                      onTap: () {
                                        showModalBottomSheet(
                                            context: context,
                                            isScrollControlled: true,
                                            builder: (_) {
                                              return DeleteAddressWidget(
                                                 cont: context,
                                                    isHome: true,
                                                    isWork: false,
                                                    isOthers: false,
                                                    addressId: context
                                                        .read<AccBloc>()
                                                        .home[0]
                                                        .id
                                              );
                                            });
                                      },
                                      child: Container(
                                          height: size.width * 0.07,
                                          width: size.width * 0.07,
                                          decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: Colors.red.shade50),
                                          alignment: Alignment.center,
                                          child: Icon(
                                            Icons.delete,
                                            size: size.width * 0.05,
                                            color: Colors.red,
                                          )),
                                    ),
                                  ],
                                ),
                            )
                            : InkWell(
                                onTap: () {
                                  context.read<AccBloc>().add(
                                      SelectFromFavAddressEvent(
                                          addressType: 'Home'));
                                },
                                child:   Container(
                                   margin: const EdgeInsets.only(top: 8),
                                                  padding: const EdgeInsets.all(16.0),

                                        decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(5.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 5,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                                  child: Row(
                                    children: [
                                      NavigationIconWidget(
                                        icon: Icon(
                                          Icons.home,
                                          color: Theme.of(context).primaryColorDark,
                                          size: size.width * 0.05,
                                        ),
                                      ),
                                      SizedBox(width: size.width * 0.02),
                                      Expanded(
                                          child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          MyText(
                                            text: AppLocalizations.of(context)!
                                                .home,
                                            textStyle: Theme.of(context)
                                                .textTheme
                                                .bodyMedium!
                                                .copyWith(
                                                    color: Theme.of(context)
                                                        .primaryColorDark,
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.bold),
                                          ),
                                        DottedLine( // ADDED: BY MG: Dotted line
                                  dashLength: 2,
                                  dashGapLength: 2,
                                  dashRadius: 1,
                                  lineThickness: 1,
                                  dashColor: Theme.of(context).dividerColor,
                                ),
                                        SingleChildScrollView(
                                          scrollDirection: Axis.horizontal,
                                          
                                            child: MyText(
                                              text: AppLocalizations.of(context)!
                                                  .tapAddAddress,
                                              textStyle: Theme.of(context)
                                                  .textTheme
                                                  .bodySmall!
                                                  .copyWith(
                                                      color: Theme.of(context)
                                                          .disabledColor
                                                          .withOpacity(0.6),
                                                      fontSize: 12),
                                            ),
                                          ),
                                        ],
                                      )),
                                      Icon(
                                        Icons.add_circle_outline,
                                        color: Theme.of(context).primaryColorDark,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                        // Row(
                        //   mainAxisAlignment: MainAxisAlignment.end,
                        //   children: [
                        //     Container(
                        //       margin: EdgeInsets.only(
                        //           top: size.width * 0.045,
                        //           bottom: size.width * 0.045),
                        //       height: size.width * 0.005,
                        //       width: size.width * 0.85,
                        //       color: Theme.of(context)
                        //           .dividerColor
                        //           .withOpacity(0.2),
                        //     ),
                        //   ],
                        // ),
                        (context.read<AccBloc>().work.isNotEmpty)
                            ? Container(
                                   margin: const EdgeInsets.only(top: 8),
                                                  padding: const EdgeInsets.all(16.0),

                                        decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(5.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 5,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                              child:  Row(
                                  children: [
                                       NavigationIconWidget(
                                      // color: Theme.of(context).cardColor,
                                      icon: Icon(
                                      Icons.work,
                                      color: Theme.of(context).primaryColorDark,
                                      size: size.width * 0.05,
                                    ),),
                                    SizedBox(width: size.width * 0.02),
                                    Expanded(
                                        child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        MyText(
                                          text:
                                              AppLocalizations.of(context)!.work,
                                          textStyle: Theme.of(context)
                                              .textTheme
                                              .bodyMedium!
                                              .copyWith(
                                                  color: Theme.of(context)
                                                      .primaryColorDark,
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.bold),
                                        ),
                                        DottedLine( // ADDED: BY MG: Dotted line
                                  dashLength: 2,
                                  dashGapLength: 2,
                                  dashRadius: 1,
                                  lineThickness: 1,
                                  dashColor: Theme.of(context).dividerColor,
                                ),
                                        SingleChildScrollView(
                                          scrollDirection: Axis.horizontal,
                                          child: MyText(
                                            text: context
                                                .read<AccBloc>()
                                                .work[0]
                                                .pickAddress,
                                            textStyle: Theme.of(context)
                                                .textTheme
                                                .bodySmall!
                                                .copyWith(
                                                    color: Theme.of(context)
                                                        .disabledColor
                                                        .withOpacity(0.6)),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    )),
                                    InkWell(
                                      onTap: () {
                                        showModalBottomSheet(
                                            context: context,
                                            isScrollControlled: true,
                                            builder: (_) {
                                              return DeleteAddressWidget(
                                                          cont: context,
                                                         isHome: false,
                                                    isWork: true,
                                                    isOthers: false,
                                                    addressId: context
                                                        .read<AccBloc>()
                                                        .work[0]
                                                        .id);
                                              
                                            });
                                      },
                                      child: Container(
                                          height: size.width * 0.07,
                                          width: size.width * 0.07,
                                          decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: Colors.red.shade50),
                                          alignment: Alignment.center,
                                          child: Icon(
                                            Icons.delete,
                                            size: size.width * 0.05,
                                            color: Colors.red,
                                          )),
                                    ),
                                  ],
                                ),
                            )
                            :   Container(
                                   margin: const EdgeInsets.only(top: 8),
                                                  padding: const EdgeInsets.all(16.0),

                                        decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(5.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 5,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                              child: InkWell(
                                  onTap: () {
                                    context.read<AccBloc>().add(
                                        SelectFromFavAddressEvent(
                                            addressType: 'Work'));
                                  },
                                  child: Row(
                                    children: [
                                    
                                      NavigationIconWidget(
                                      // color: Theme.of(context).cardColor,
                                      icon:  Icon(
                                          Icons.work,
                                          color: Theme.of(context).primaryColorDark,
                                          size: size.width * 0.05,
                                        ),
                                      ),
                                      SizedBox(width: size.width * 0.02),
                                      Expanded(
                                          child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          MyText(
                                            text: AppLocalizations.of(context)!
                                                .work,
                                            textStyle: Theme.of(context)
                                                .textTheme
                                                .bodyMedium!
                                                .copyWith(
                                                    color: Theme.of(context)
                                                        .primaryColorDark,
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.bold),
                                          ),
                                           DottedLine( // ADDED: BY MG: Dotted line
                                  dashLength: 2,
                                  dashGapLength: 2,
                                  dashRadius: 1,
                                  lineThickness: 1,
                                  dashColor: Theme.of(context).dividerColor,
                                ),
                                          MyText(
                                            text: AppLocalizations.of(context)!
                                                .tapAddAddress,
                                            textStyle: Theme.of(context)
                                                .textTheme
                                                .bodySmall!
                                                .copyWith(
                                                    fontSize: 12,
                                                    color: Theme.of(context)
                                                        .disabledColor
                                                        .withOpacity(0.6)),
                                          ),
                                        ],
                                      )),
                                      Icon(
                                        Icons.add_circle_outline,
                                        color: Theme.of(context).primaryColorDark,
                                      ),
                                    ],
                                  ),
                                ),
                            ),
                        // Row(
                        //   mainAxisAlignment: MainAxisAlignment.end,
                        //   children: [
                        //     Container(
                        //       margin: EdgeInsets.only(
                        //           top: size.width * 0.025,
                        //           bottom: size.width * 0.025),
                        //       height: size.width * 0.005,
                        //       width: size.width * 0.85,
                        //       color: Theme.of(context)
                        //           .dividerColor
                        //           .withOpacity(0.2),
                        //     ),
                        //   ],
                        // ),
                        SizedBox(height: 8,),
                        if (context.read<AccBloc>().others.isNotEmpty)
                          ListView.builder(
                            itemCount: context.read<AccBloc>().others.length,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            padding: const EdgeInsets.only(bottom: 8),
                            itemBuilder: (context, index) {
                              return Container(
                                //  margin: const EdgeInsets.only(top: 8),
                                                  padding: const EdgeInsets.all(16.0),
                                 decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(5.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 5,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                                margin:
                                    EdgeInsets.only(bottom: size.width * 0.025),
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                         NavigationIconWidget(
                                          icon: Icon(
                                            Icons.bookmark,
                                             size: size.width * 0.05,
                                            // color: Theme.of(context)
                                            //     .dividerColor
                                            //     .withOpacity(0.5),
                                          ),
                                        ),
                                        SizedBox(width: size.width * 0.02),
                                        Expanded(
                                            child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            MyText(
                                              text: context
                                                  .read<AccBloc>()
                                                  .others[index]
                                                  .addressName,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          
                                              DottedLine( // ADDED: BY MG: Dotted line
                                  dashLength: 2,
                                  dashGapLength: 2,
                                  dashRadius: 1,
                                  lineThickness: 1,
                                  dashColor: Theme.of(context).dividerColor,
                                ),
                                        SingleChildScrollView(
                                          scrollDirection: Axis.horizontal,
                                          child: MyText(
                                                text: context
                                                    .read<AccBloc>()
                                                    .others[index]
                                                    .pickAddress,
                                                textStyle: Theme.of(context)
                                                    .textTheme
                                                    .bodySmall!
                                                    .copyWith(
                                                        color: Theme.of(context)
                                                            .disabledColor),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          ],
                                        )),
                                        InkWell(
                                          onTap: () {
                                            showModalBottomSheet(
                                                context: context,
                                                isScrollControlled: true,
                                                builder: (_) {
                                                  return DeleteAddressWidget(
                                                        cont: context,
                                                        isHome: false,
                                                        isWork: false,
                                                        isOthers: true,
                                                        addressId: context
                                                            .read<AccBloc>()
                                                            .others[index]
                                                            .id);
                                                });
                                          },
                                          child: Container(
                                              height: size.width * 0.07,
                                              width: size.width * 0.07,
                                              decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: Colors.red.shade50),
                                              alignment: Alignment.center,
                                              child: Icon(
                                                Icons.delete,
                                                size: size.width * 0.05,
                                                color: Colors.red,
                                              )),
                                        ),
                                      ],
                                    ),
                                    // Row(
                                    //   mainAxisAlignment: MainAxisAlignment.end,
                                    //   children: [
                                    //     Container(
                                    //       margin: EdgeInsets.only(
                                    //           top: size.width * 0.025,
                                    //           bottom: size.width * 0.025),
                                    //       height: size.width * 0.005,
                                    //       width: size.width * 0.85,
                                    //       color: Theme.of(context)
                                    //           .dividerColor
                                    //           .withOpacity(0.2),
                                    //     ),
                                    //   ],
                                    // ),
                                  ],
                                ),
                              );
                            },
                          ),
                        if (context.read<AccBloc>().others.length < 2)
                          InkWell(
                            onTap: () async {
                              context
                                  .read<AccBloc>()
                                  .newAddressController
                                  .text = '';
                              context.read<AccBloc>().add(
                                  SelectFromFavAddressEvent(
                                      addressType: context
                                          .read<AccBloc>()
                                          .newAddressController
                                          .text));
                            },
                            child: Row(
                              children: [
                                Container(
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Theme.of(context)
                                          .cardColor
                                          // .withOpacity(0.15)
                                          ,
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(1.0),
                                      child: Icon(
                                        Icons.add,
                                        size: 20,
                                        color:
                                            Theme.of(context).primaryColorDark,
                                      ),
                                    )),
                                SizedBox(width: size.width * 0.02),
                                MyText(
                                  text: AppLocalizations.of(context)!.addMore,
                                  textStyle: Theme.of(context)
                                      .textTheme
                                      .bodyMedium!
                                      .copyWith(
                                        color:
                                            Theme.of(context).primaryColorDark,
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                              ],
                            ),
                          )
                      ],
                    ],
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
