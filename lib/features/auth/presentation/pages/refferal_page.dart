import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../common/app_colors.dart';
import '../../../../core/utils/custom_background.dart';
import '../../../../core/utils/custom_button.dart';
import '../../../../core/utils/custom_loader.dart';
import '../../../../core/utils/custom_text.dart';
import '../../../../core/utils/custom_textfield.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../home/presentation/pages/home_page.dart';
import '../../../loading/application/loader_bloc.dart';
import '../../application/auth_bloc.dart';
import 'package:dotted_line/dotted_line.dart'; // Add this package // ADDED: BY MG: Dotted line


class RefferalPage extends StatelessWidget {
  static const String routeName = '/refferalPage';
  const RefferalPage({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return BlocProvider(
      create: (context) => AuthBloc()..add(GetDirectionEvent()),
      child: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthInitialState) {
            CustomLoader.loader(context);
          }
          if (state is AuthDataLoadingState) {
            CustomLoader.loader(context);
          }
          if (state is AuthDataSuccessState) {
            CustomLoader.dismiss(context);
          }
          if (state is LoginLoadingState) {
            CustomLoader.loader(context);
          }
          if (state is LoginFailureState) {
            CustomLoader.dismiss(context);
          }
          if (state is ReferralSuccessState) {
            context.read<LoaderBloc>().add(UpdateUserLocationEvent());
            Navigator.pushNamedAndRemoveUntil(
                context, HomePage.routeName, (route) => false);
          }
        },
        child: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            return Directionality(
              textDirection: context.read<AuthBloc>().textDirection == 'rtl'
                  ? TextDirection.rtl
                  : TextDirection.ltr,
              child: Scaffold(
                body:
                //  CustomBackground(child:
                  SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                                                  padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(2.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 5,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                                  child: 
                          Column( 
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children:[
                          SizedBox(height: size.width * 0.1),
                          MyText(
                              text: AppLocalizations.of(context)!.applyRefferal,
                              textStyle: Theme.of(context)
                                  .textTheme
                                  .displayLarge!
                                  .copyWith(
                                      color: AppColors.black,)),
                            DottedLine( // ADDED: BY MG: Dotted line
                                dashLength: 2,
                                dashGapLength: 2,
                                dashRadius: 1,
                                lineThickness: 1,
                                dashColor: Theme.of(context).dividerColor,
                              ),           
                          SizedBox(height: size.width * 0.1),
                          CustomTextField(
                            controller: context
                                .read<AuthBloc>()
                                .rReferralCodeController,
                            filled: true,
                            hintText:
                                AppLocalizations.of(context)!.enterRefferalCode,
                          ),
                          SizedBox(height: size.width * 0.1), ],),),
                          //
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              CustomButton(
                                borderRadius:2,
                                buttonName: AppLocalizations.of(context)!.skip,
                                width: size.width * 0.4,
                                onTap: () {
                                  context
                                      .read<AuthBloc>()
                                      .add(ReferralEvent(
                                      referralCode: 'Skip', context: context));
                                },
                              ),
                              CustomButton(
                                borderRadius:2,
                                buttonName: AppLocalizations.of(context)!.apply,
                                isLoader: context.read<AuthBloc>().isLoading,
                                width: size.width * 0.4,
                                onTap: () {
                                  context.read<AuthBloc>().add(ReferralEvent(
                                      referralCode: context
                                          .read<AuthBloc>()
                                          .rReferralCodeController
                                          .text,
                                      context: context));
                                },
                              ),
                              
                            ],
                          ),
                          SizedBox(height: size.width * 0.05),
                        ],
                      ),
                    ),
                  ),
                // ),
              ),
            );
          },
        ),
      ),
    );
  }
}
