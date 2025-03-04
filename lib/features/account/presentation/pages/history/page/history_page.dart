import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restart_tagxi/l10n/app_localizations.dart';
import '../../../../../../common/common.dart';
import '../../../../../../core/utils/custom_loader.dart';
import '../../../../../../core/utils/custom_text.dart';
import '../../../../application/acc_bloc.dart';
import '../widget/history_card_shimmer.dart';
import '../../../widgets/top_bar.dart';
import '../../outstation/widget/outstation_offered_page.dart';
import '../widget/history_card_widget.dart';
import '../widget/history_nodata.dart';
import 'trip_summary_history.dart';

class HistoryPage extends StatelessWidget {
  static const String routeName = '/historyPage';

  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return BlocProvider(
      create: (context) => AccBloc()
        ..add(AccGetDirectionEvent())
        ..add(HistoryPageInitEvent()),
      child: BlocListener<AccBloc, AccState>(
        listener: (context, state) {
          if (state is AccInitialState) {
            CustomLoader.loader(context);
          } else if (state is HistoryDataLoadingState) {
            CustomLoader.loader(context);
          } else if (state is HistoryDataSuccessState) {
            CustomLoader.dismiss(context);
          }
        },
        child: BlocBuilder<AccBloc, AccState>(
          builder: (context, state) {
            return Directionality(
              textDirection: context.read<AccBloc>().textDirection == 'rtl'
                  ? TextDirection.rtl
                  : TextDirection.ltr,
              child: Scaffold(
                body: TopBarDesign(
                  controller: context.read<AccBloc>().scrollController,
                  isHistoryPage: true,
                  title: AppLocalizations.of(context)!.history,
                  onTap: () {
                    Navigator.of(context).pop();
                    context.read<AccBloc>().scrollController.dispose();
                  },
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        
                        if (context.read<AccBloc>().isLoading)
                          HistoryShimmer(size: size),
                        if (!context.read<AccBloc>().isLoading &&
                            context.read<AccBloc>().history.isEmpty)
                          const HistoryNodataWidget(),
                        if (context.read<AccBloc>().history.isNotEmpty) ...[
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Row(
                              children: [
                                MyText(
                                  text: AppLocalizations.of(context)!
                                      .historyDetails,
                                  textStyle: Theme.of(context)
                                      .textTheme
                                      .bodyMedium!
                                      .copyWith(
                                          fontWeight: FontWeight.bold,
                                          color: Theme.of(context)
                                              .primaryColorDark),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: size.width * 0.05),
                        ],  
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: SizedBox(
                            child: ListView.builder(
                              shrinkWrap: true,
                              padding: EdgeInsets.zero,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: context.read<AccBloc>().history.length,
                              itemBuilder: (_, index) {
                                final history = context
                                    .read<AccBloc>()
                                    .history
                                    .elementAt(index);
                                return Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(bottom: 5),
                                      child: InkWell(
                                        onTap: () {
                                          if (history.isLater == true&& history.isCancelled !=1) {
                                            if (history.isOutStation == 1 &&
                                                history.driverDetail == null) {
                                              Navigator.pushNamed(
                                                  context,
                                                  OutStationOfferedPage
                                                      .routeName,
                                                  arguments:
                                                      OutStationOfferedPageArguments(
                                                    requestId: history.id,
                                                    currencySymbol: history
                                                        .requestedCurrencySymbol,
                                                    dropAddress:
                                                        history.dropAddress,
                                                    pickAddress:
                                                        history.pickAddress,
                                                    updatedAt: history
                                                        .tripStartTimeWithDate,
                                                    offeredFare: history
                                                        .offerredRideFare
                                                        .toString(),
                                                    // userData: context
                                                    //     .read<AccBloc>()
                                                    //     .userData!
                                                  )).then(
                                                (value) {
                                                  if (!context.mounted) return;
                                                  context
                                                      .read<AccBloc>()
                                                      .history
                                                      .clear();
                                                  context.read<AccBloc>().add(
                                                      HistoryGetEvent(
                                                          historyFilter:
                                                              'is_later=1'));
                                                },
                                              );
                                            } else {
                                              Navigator.pushNamed(
                                                context,
                                                HistoryTripSummaryPage
                                                    .routeName,
                                                arguments: HistoryPageArguments(
                                                  historyData: history,
                                                ),
                                              ).then((value) {
                                                if (!context.mounted) return;
                                                context
                                                    .read<AccBloc>()
                                                    .history
                                                    .clear();
                                                context.read<AccBloc>().add(
                                                      HistoryGetEvent(
                                                          historyFilter:
                                                              'is_later=1'),
                                                    );
                                                context
                                                    .read<AccBloc>()
                                                    .add(AccUpdateEvent());
                                              });
                                            }
                                          } else {
                                            Navigator.pushNamed(
                                              context,
                                              HistoryTripSummaryPage.routeName,
                                              arguments: HistoryPageArguments(
                                                historyData: history,
                                              ),
                                            );
                                          }
                                        },
                                        child: HistoryCardWidget(cont: context,
                                                  history: history)),
                                    ),
                                  ],
                                );
                              },
                            ),
                          ),
                        ),
                        if (context.read<AccBloc>().loadMore)
                          Center(
                            child: SizedBox(
                                height: size.width * 0.08,
                                width: size.width * 0.08,
                                child: const CircularProgressIndicator()),
                          ),
                        SizedBox(height: size.width * 0.2),
                      ],
                    ),
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
