import 'package:ashil_school/Utils/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

///  A  widget  for  displaying  an  animated  loading  indicator  with  optional  text  and  action  button.
class KAnimationLoaderWidget extends StatelessWidget {
  ///  Default  constructor  for  the  KAnimationLoaderWidget.
  ///
  ///  Parameters:
  ///  -  text:  The  text  to  be  displayed  below  the  animation.
  ///  -  animation:  The  path  to  the  Lottie  animation  file.
  ///  -  showAction:  Whether  to  show  an  action  button  below  the  text.
  ///  -  actionText:  The  text  to  be  displayed  on  the  action  button.
  ///  -  onActionPressed:  Callback  function  to  be  executed  when  the  action  button  is  pressed.
  const KAnimationLoaderWidget({
    super.key,
    required this.text,
    required this.animation,
    this.showAction = false,
    this.actionText,
    this.onActionPressed,
  });

  final String text;
  final String animation;
  final bool showAction;
  final String? actionText;
  final VoidCallback? onActionPressed;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Lottie.asset(
          animation,
          width:
              MediaQuery.of(context).size.width * 0.8, //  عرض  الرسوم  المتحركة
        ),
        const SizedBox(height: 15),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            text,
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(height: 15),
        if (showAction)
          SizedBox(
            width: 250,
            child: OutlinedButton(
              onPressed: onActionPressed,
              style: OutlinedButton.styleFrom(backgroundColor: KColors.dark),
              child: Text(
                actionText!,
                style: Theme.of(context).textTheme.bodyMedium!.apply(),
              ),
            ),
          ),
      ],
    );
  }
}
