
import 'package:flutter/cupertino.dart';
import 'package:flutter_boilerplate/core/config/responsive_scale.dart';
import 'package:flutter_boilerplate/core/config/size_config.dart';


class FontConstants{
  static double appTextLS = -0.4;
  static double appTitleLS = -0.8;
  static double drawerUserNameLS = 0.2;

}

class FontSize{
  /// Same as 24
  static double title24 = SizeConfig.blockSizeHorizontal! * 6.15;
  static double title30 = SizeConfig.blockSizeHorizontal! * 8.15;
  /// Same as 14
  static double subtitle14 = SizeConfig.blockSizeHorizontal! * 3.6;
  static double text20 = SizeConfig.blockSizeHorizontal! * 5.15;
  static double text18 = SizeConfig.blockSizeHorizontal! * 4.60;
  static double text16 = SizeConfig.blockSizeHorizontal! * 4.1;
  static double text14 = SizeConfig.blockSizeHorizontal! * 3.6;
  static double text12 = SizeConfig.blockSizeHorizontal! * 3.08;
}

class TextSize {
  static double font8(BuildContext context) => ResponsiveScale.of(context).fontSize(1.0);
  static double font10(BuildContext context) => ResponsiveScale.of(context).fontSize(1.15);
  static double font12(BuildContext context) => ResponsiveScale.of(context).fontSize(1.37);
  static double font13(BuildContext context) => ResponsiveScale.of(context).fontSize(1.5);
  static double font14(BuildContext context) => ResponsiveScale.of(context).fontSize(1.6);
  static double font15(BuildContext context) => ResponsiveScale.of(context).fontSize(1.7);
  static double font16(BuildContext context) => ResponsiveScale.of(context).fontSize(1.82);
  static double font18(BuildContext context) => ResponsiveScale.of(context).fontSize(2.06);
  static double font20(BuildContext context) => ResponsiveScale.of(context).fontSize(2.3);
  static double font22(BuildContext context) => ResponsiveScale.of(context).fontSize(2.5);
  static double font24(BuildContext context) => ResponsiveScale.of(context).fontSize(2.7);
  static double font28(BuildContext context) => ResponsiveScale.of(context).fontSize(3.2);
  static double font30(BuildContext context) => ResponsiveScale.of(context).fontSize(4.3);
  static double font36(BuildContext context) => ResponsiveScale.of(context).fontSize(4.1);
  static double font48(BuildContext context) => ResponsiveScale.of(context).fontSize(5.5);
  static double font54(BuildContext context) => ResponsiveScale.of(context).fontSize(6.17);
}
