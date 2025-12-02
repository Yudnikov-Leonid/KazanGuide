import 'package:flutter/foundation.dart';
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
         surfaceTintColor: Colors.transparent,
         shadowColor: Colors.black.withAlpha(100),
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
             color: AppColors.green,
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
             title.length > 20 && !kIsWeb
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
                   style:
                       textStyle ??
                       context.textTheme.bodyLarge?.copyWith(
                         fontWeight: FontWeight.w600,
                         fontSize: 18
                       ),
                   maxLines: 2,
                   textAlign: TextAlign.center,
                 ),
       );
}
