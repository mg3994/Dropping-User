import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restart_tagxi/l10n/app_localizations.dart';

import '../../../../application/acc_bloc.dart';
import '../../../widgets/top_bar.dart';
import '../widget/faq_list_widget.dart';

class FaqPage extends StatelessWidget {
  static const String routeName = '/faqPage';

  const FaqPage({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return BlocProvider(
      create: (context) => AccBloc()
        ..add(AccGetDirectionEvent())
        ..add(GetFaqListEvent()),
      child: BlocListener<AccBloc, AccState>(
        listener: (context, state) {},
        child: BlocBuilder<AccBloc, AccState>(builder: (context, state) {
          return Directionality(
            textDirection: context.read<AccBloc>().textDirection == 'rtl'
                ? TextDirection.rtl
                : TextDirection.ltr,
            child: Scaffold(
              body: TopBarDesign(
                isHistoryPage: false,
                title: AppLocalizations.of(context)!.faq,
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                        FaqDataListWidget(
                            cont : context,faqDataList: context.read<AccBloc>().faqDataList),
                        SizedBox(height: size.width * 0.05),
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
