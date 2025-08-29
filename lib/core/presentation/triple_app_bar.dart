import 'package:flutter/material.dart';
import 'package:kazan_guide/core/presentation/colors.dart';
import 'package:kazan_guide/core/presentation/context_expentions.dart';

class TripleAppBar extends AppBar {
  TripleAppBar(
    BuildContext context, {
    required String title,
    GestureTapCallback? leadingFunction,
    TextStyle? textStyle,
    super.key,
  }) : super(
         leading: InkWell(
           onTap: leadingFunction,
           child: Container(
             color: AppColors.green,
             child: Padding(
               padding: const EdgeInsets.only(top: 9, bottom: 4),
               child: Image.asset(
                 'assets/images/ornament.png',
                 color: Colors.white,
               ),
             ),
           ),
         ),
         leadingWidth: MediaQuery.sizeOf(context).width * 0.25,
         actions: [
           Container(
             color: AppColors.red,
             width: MediaQuery.sizeOf(context).width * 0.25,
             child: Padding(
               padding: const EdgeInsets.only(top: 9, bottom: 4),
               child: Image.asset(
                 'assets/images/ornament.png',
                 color: Colors.white,
               ),
             ),
           ),
         ],
         centerTitle: true,
         titleSpacing: 4,
         title:
             title.length > 20
                 ? SizedBox(
                   width: MediaQuery.sizeOf(context).width * 0.5,
                   child: FittedBox(
                     child: Text(
                       title,
                       style: textStyle ?? context.textTheme.bodyLarge,
                       maxLines: 2,
                       textAlign: TextAlign.center,
                     ),
                   ),
                 )
                 : Text(
                   title,
                   style: textStyle ?? context.textTheme.bodyLarge,
                   maxLines: 2,
                   textAlign: TextAlign.center,
                 ),
       );
}
