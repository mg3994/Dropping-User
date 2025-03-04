import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restart_tagxi/l10n/app_localizations.dart';
import '../../../../../../common/app_images.dart';
import '../../../../../../core/utils/custom_dialoges.dart';
import '../../../../../../core/utils/custom_loader.dart';
import '../../../../../../core/utils/custom_text.dart';
import '../../../../application/acc_bloc.dart';
import '../widget/notification_card_widget.dart';
import '../widget/notification_page_shimmer.dart';
import '../../../widgets/top_bar.dart';

class NotificationPage extends StatelessWidget {
  static const String routeName = '/notification';

  const NotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return BlocProvider(
      create: (context) => AccBloc()
        ..add(AccGetDirectionEvent())
        ..add(NotificationPageInitEvent()),
      child: BlocListener<AccBloc, AccState>(
        listener: (context, state) {
          if (state is AccInitialState) {
            CustomLoader.loader(context);
          } else if (state is NotificationDeletedSuccess ||
              state is NotificationClearedSuccess) {
            context.read<AccBloc>().add(NotificationGetEvent());
          }
        },
        child: BlocBuilder<AccBloc, AccState>(builder: (context, state) {
          return Directionality(
            textDirection: context.read<AccBloc>().textDirection == 'rtl'
                ? TextDirection.rtl
                : TextDirection.ltr,
            child: Scaffold(
              body: TopBarDesign(
                controller: context.read<AccBloc>().scrollController,
                isHistoryPage: false,
                title: AppLocalizations.of(context)!.notifications,
                onTap: () {
                  Navigator.of(context).pop();
                  context.read<AccBloc>().scrollController.dispose();
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (context
                        .read<AccBloc>()
                        .notificationDatas
                        .isNotEmpty) ...[
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            MyText(
                              text: AppLocalizations.of(context)!.notifications,
                              textStyle: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(context).primaryColorDark,
                                      fontSize: 18),
                            ),
                            InkWell(
                              onTap: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext _) {
                                    return BlocProvider.value(
                                        value:
                                            BlocProvider.of<AccBloc>(context),
                                        child: CustomDoubleButtonDialoge(
                                          title: AppLocalizations.of(context)!
                                              .clearNotifications,
                                          content: AppLocalizations.of(context)!
                                              .clearNotificationsText,
                                          yesBtnName:
                                              AppLocalizations.of(context)!
                                                  .confirm,
                                          noBtnName:
                                              AppLocalizations.of(context)!
                                                  .cancel,
                                          yesBtnFunc: () {
                                            context.read<AccBloc>().add(
                                                ClearAllNotificationsEvent());
                                          },
                                          noBtnFunc: () {
                                            Navigator.pop(context);
                                          },
                                        ));
                                  },
                                );
                              },
                              child: Text(
                                AppLocalizations.of(context)!.clearAll,
                                style: TextStyle(
                                    color: Theme.of(context).primaryColorDark),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: size.width * 0.05),
                    ],
                    if (context.read<AccBloc>().isLoading)
                      NotificationShimmer(
                        size: size,
                      ),
                    if (!context.read<AccBloc>().isLoading &&
                        context.read<AccBloc>().notificationDatas.isEmpty)
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                AppImages.notificationsNoData,
                                height: size.width,
                              ),
                              MyText(
                                maxLines: 2,
                                text: AppLocalizations.of(context)!
                                    .noNotification,
                                textStyle: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .copyWith(
                                        color: Theme.of(context)
                                            .disabledColor
                                            .withOpacity(0.5)),
                              ),
                            ],
                          ),
                        ),
                      ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 18),
                      child: SizedBox(
                        child: ListView.builder(
                          shrinkWrap: true,
                          padding: EdgeInsets.zero,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount:
                              context.read<AccBloc>().notificationDatas.length,
                          itemBuilder: (_, index) {
                            final notification = context
                                .read<AccBloc>()
                                .notificationDatas
                                .elementAt(index);
                            return NotificationCardWidget(cont: context,notification:notification);
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
          );
        }),
      ),
    );
  }
}
