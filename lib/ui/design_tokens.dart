import 'package:flutter/material.dart';

final dialogInputDecoration = InputDecoration(
  enabledBorder: OutlineInputBorder(
    borderSide: const BorderSide(color: ColorDark.text2),
    borderRadius: BorderRadius.circular(DesignValues.mediumBorderRadius),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: const BorderSide(color: ColorDark.text1),
    borderRadius: BorderRadius.circular(DesignValues.mediumBorderRadius),
  ),
  border: OutlineInputBorder(
    borderSide: const BorderSide(color: ColorDark.text3),
    borderRadius: BorderRadius.circular(DesignValues.mediumBorderRadius),
  ),
);

/// values
class DesignValues {
  static double appBarHeight = 32.0;
  static double smallIconSize = 16.0;
  static double mediumIconSize = 24.0;
  static double largeIconSize = 48.0;
  static double ultraSmallPadding = 4.0;
  static double smallPadding = 8.0;
  static double mediumPadding = 16.0;
  static double largePadding = 24.0;
  static double giantPadding = 32.0;
  static double smallBorderRadius = 4.0;
  static double mediumBorderRadius = 8.0;
  static double largeBorderRadius = 12.0;
}

class SemiTextStyles {
  const SemiTextStyles();

  static TextStyle get header1ENRegular => const TextStyle(
    fontSize: 32,
    decoration: TextDecoration.none,
    fontFamily: 'Inter-Regular',
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w400,
    height: 44 / 32,
    letterSpacing: 0,
  );

  static TextStyle get header1CNRegular => const TextStyle(
    fontSize: 32,
    decoration: TextDecoration.none,
    fontFamily: 'Inter-Regular',
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w400,
    height: 44 / 32,
    letterSpacing: 0,
  );

  static TextStyle get header1ENSemiBold => const TextStyle(
    fontSize: 32,
    decoration: TextDecoration.none,
    fontFamily: 'Inter-Bold',
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w700,
    height: 44 / 32,
    letterSpacing: 0,
  );

  static TextStyle get header1CNSemiBold => const TextStyle(
    fontSize: 32,
    decoration: TextDecoration.none,
    fontFamily: 'Inter-Regular',
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w400,
    height: 44 / 32,
    letterSpacing: 0,
  );

  static TextStyle get header2ENRegular => const TextStyle(
    fontSize: 28,
    decoration: TextDecoration.none,
    fontFamily: 'Inter-Regular',
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w400,
    height: 40 / 28,
    letterSpacing: 0,
  );

  static TextStyle get header2CNRegular => const TextStyle(
    fontSize: 28,
    decoration: TextDecoration.none,
    fontFamily: 'Inter-Regular',
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w400,
    height: 40 / 28,
    letterSpacing: 0,
  );

  static TextStyle get header2ENSemiBold => const TextStyle(
    fontSize: 28,
    decoration: TextDecoration.none,
    fontFamily: 'Inter-Bold',
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w700,
    height: 40 / 28,
    letterSpacing: 0,
  );

  static TextStyle get header2CNSemiBold => const TextStyle(
    fontSize: 28,
    decoration: TextDecoration.none,
    fontFamily: 'Inter-Regular',
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w400,
    height: 40 / 28,
    letterSpacing: 0,
  );

  static TextStyle get header3ENRegular => const TextStyle(
    fontSize: 24,
    decoration: TextDecoration.none,
    fontFamily: 'Inter-Regular',
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w400,
    height: 32 / 24,
    letterSpacing: 0,
  );

  static TextStyle get header3CNRegular => const TextStyle(
    fontSize: 24,
    decoration: TextDecoration.none,
    fontFamily: 'Inter-Regular',
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w400,
    height: 32 / 24,
    letterSpacing: 0,
  );

  static TextStyle get header3ENSemiBold => const TextStyle(
    fontSize: 24,
    decoration: TextDecoration.none,
    fontFamily: 'Inter-Bold',
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w700,
    height: 32 / 24,
    letterSpacing: 0,
  );

  static TextStyle get header3CNSemiBold => const TextStyle(
    fontSize: 24,
    decoration: TextDecoration.none,
    fontFamily: 'Inter-Regular',
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w400,
    height: 32 / 24,
    letterSpacing: 0,
  );

  static TextStyle get header4ENRegular => const TextStyle(
    fontSize: 20,
    decoration: TextDecoration.none,
    fontFamily: 'Inter-Regular',
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w400,
    height: 28 / 20,
    letterSpacing: 0,
  );

  static TextStyle get header4CNRegular => const TextStyle(
    fontSize: 20,
    decoration: TextDecoration.none,
    fontFamily: 'Inter-Regular',
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w400,
    height: 28 / 20,
    letterSpacing: 0,
  );

  static TextStyle get header4ENSemiBold => const TextStyle(
    fontSize: 20,
    decoration: TextDecoration.none,
    fontFamily: 'Inter-Bold',
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w700,
    height: 28 / 20,
    letterSpacing: 0,
  );

  static TextStyle get header4CNSemiBold => const TextStyle(
    fontSize: 20,
    decoration: TextDecoration.none,
    fontFamily: 'Inter-Regular',
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w400,
    height: 28 / 20,
    letterSpacing: 0,
  );

  static TextStyle get header5ENRegular => const TextStyle(
    fontSize: 18,
    decoration: TextDecoration.none,
    fontFamily: 'Inter-Regular',
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w400,
    height: 24 / 18,
    letterSpacing: 0,
  );

  static TextStyle get header5CNRegular => const TextStyle(
    fontSize: 18,
    decoration: TextDecoration.none,
    fontFamily: 'Inter-Regular',
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w400,
    height: 24 / 18,
    letterSpacing: 0,
  );

  static TextStyle get header5ENSemiBold => const TextStyle(
    fontSize: 18,
    decoration: TextDecoration.none,
    fontFamily: 'Inter-Bold',
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w700,
    height: 24 / 18,
    letterSpacing: 0,
  );

  static TextStyle get header5CNSemiBold => const TextStyle(
    fontSize: 18,
    decoration: TextDecoration.none,
    fontFamily: 'Inter-Regular',
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w400,
    height: 24 / 18,
    letterSpacing: 0,
  );

  static TextStyle get header6ENRegular => const TextStyle(
    fontSize: 16,
    decoration: TextDecoration.none,
    fontFamily: 'Inter-Regular',
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w400,
    height: 22 / 16,
    letterSpacing: 0,
  );

  static TextStyle get header6CNRegular => const TextStyle(
    fontSize: 16,
    decoration: TextDecoration.none,
    fontFamily: 'Inter-Regular',
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w400,
    height: 22 / 16,
    letterSpacing: 0,
  );

  static TextStyle get header6ENSemiBold => const TextStyle(
    fontSize: 16,
    decoration: TextDecoration.none,
    fontFamily: 'Inter-Bold',
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w700,
    height: 22 / 16,
    letterSpacing: 0,
  );

  static TextStyle get header6CNSemiBold => const TextStyle(
    fontSize: 16,
    decoration: TextDecoration.none,
    fontFamily: 'Inter-Regular',
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w400,
    height: 22 / 16,
    letterSpacing: 0,
  );

  static TextStyle get smallENRegular => const TextStyle(
    fontSize: 10,
    decoration: TextDecoration.none,
    fontFamily: 'Inter-Regular',
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w400,
    height: 14 / 10,
    letterSpacing: 0,
  );

  static TextStyle get smallCNRegular => const TextStyle(
    fontSize: 10,
    decoration: TextDecoration.none,
    fontFamily: 'Inter-Regular',
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w400,
    height: 14 / 10,
    letterSpacing: 0,
  );

  static TextStyle get smallENSemiBold => const TextStyle(
    fontSize: 10,
    decoration: TextDecoration.none,
    fontFamily: 'Inter-Bold',
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w700,
    height: 14 / 10,
    letterSpacing: 0,
  );

  static TextStyle get smallCNSemiBold => const TextStyle(
    fontSize: 10,
    decoration: TextDecoration.none,
    fontFamily: 'Inter-Regular',
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w400,
    height: 14 / 10,
    letterSpacing: 0,
  );

  static TextStyle get regularENRegular => const TextStyle(
    fontSize: 12,
    decoration: TextDecoration.none,
    fontFamily: 'Inter-Regular',
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w400,
    height: 16 / 12,
    letterSpacing: 0,
  );

  static TextStyle get regularCNRegular => const TextStyle(
    fontSize: 12,
    decoration: TextDecoration.none,
    fontFamily: 'Inter-Regular',
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w400,
    height: 16 / 12,
    letterSpacing: 0,
  );

  static TextStyle get regularENSemiBold => const TextStyle(
    fontSize: 12,
    decoration: TextDecoration.none,
    fontFamily: 'Inter-Bold',
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w700,
    height: 16 / 12,
    letterSpacing: 0,
  );

  static TextStyle get regularCNSemiBold => const TextStyle(
    fontSize: 12,
    decoration: TextDecoration.none,
    fontFamily: 'Inter-Regular',
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w400,
    height: 16 / 12,
    letterSpacing: 0,
  );
}

/// colors
class ColorLight {
  static const Color bg0 = Color(0xffffffff);
  static const Color bg1 = Color(0xffffffff);
  static const Color bg2 = Color(0xffffffff);
  static const Color bg3 = Color(0xffffffff);
  static const Color bg4 = Color(0xffffffff);
  static const Color info = Color(0xff0077fa);
  static const Color link = Color(0xff0077fa);
  static const Color navBg = Color(0xffffffff);
  static const Color black = Color(0xff000000);
  static const Color data0 = Color(0xff5769ff);
  static const Color data1 = Color(0xff8ed4e7);
  static const Color data2 = Color(0xfff58700);
  static const Color data3 = Color(0xffdcb7fc);
  static const Color data4 = Color(0xff4a9cf7);
  static const Color data5 = Color(0xfff3cc35);
  static const Color data6 = Color(0xfffe8090);
  static const Color data7 = Color(0xff8bd7d2);
  static const Color data8 = Color(0xff83b023);
  static const Color data9 = Color(0xffe9a5e5);
  static const Color fill0 = Color(0x0c2e3238);
  static const Color fill1 = Color(0x162e3238);
  static const Color fill2 = Color(0x212e3238);
  static const Color text0 = Color(0xff1c1f23);
  static const Color text1 = Color(0xcc1c1f23);
  static const Color text2 = Color(0x991c1f23);
  static const Color text3 = Color(0x591c1f23);
  static const Color white = Color(0xffffffff);
  static const Color data10 = Color(0xff30a7ce);
  static const Color data11 = Color(0xfff9c064);
  static const Color data12 = Color(0xffb171f9);
  static const Color data13 = Color(0xff77b6f9);
  static const Color data14 = Color(0xffc88f02);
  static const Color data15 = Color(0xffffaab2);
  static const Color data16 = Color(0xff33b0ab);
  static const Color data17 = Color(0xffb6d781);
  static const Color data18 = Color(0xffd458d4);
  static const Color data19 = Color(0xffbcc6ff);
  static const Color border = Color(0x141c1f23);
  static const Color danger = Color(0xfff93920);
  static const Color shadow = Color(0x0a000000);

  // static const Color default = Color(0xfff9f9f9);
  static const Color infoHover = Color(0xff0062d6);
  static const Color linkHover = Color(0xff0062d6);
  static const Color primary = Color(0xff0077fa);
  static const Color success = Color(0xff3bb346);
  static const Color warning = Color(0xfffc8800);
  static const Color infoActive = Color(0xff004fb3);
  static const Color linkActive = Color(0xff004fb3);
  static const Color linkVisited = Color(0xff0077fa);
  static const Color tertiary = Color(0xff6b7075);
  static const Color focusBorder = Color(0xff0077fa);
  static const Color infoDisabled = Color(0xff98cdfd);
  static const Color overlayBg = Color(0x9916161a);
  static const Color dangerHover = Color(0xffd52515);
  static const Color highlight = Color(0xff000000);
  static const Color secondary = Color(0xff0095ee);
  static const Color dangerActive = Color(0xffb2140c);
  static const Color disabledBg = Color(0xffe6e8ea);
  static const Color defaultHover = Color(0xffe6e8ea);
  static const Color primaryHover = Color(0xff0062d6);
  static const Color successHover = Color(0xff30953b);
  static const Color warningHover = Color(0xffd26700);
  static const Color defaultActive = Color(0xffc6cacd);
  static const Color disabledFill = Color(0x0a2e3238);
  static const Color disabledText = Color(0x591c1f23);
  static const Color highlightBg = Color(0xfffbda32);
  static const Color primaryActive = Color(0xff004fb3);
  static const Color successActive = Color(0xff25772f);
  static const Color warningActive = Color(0xffa84a00);
  static const Color tertiaryHover = Color(0xff555b61);
  static const Color disabledBorder = Color(0xffe6e8ea);
  static const Color primaryDisabled = Color(0xff98cdfd);
  static const Color successDisabled = Color(0xffa4e0a7);
  static const Color tertiaryActive = Color(0xff41464c);
  static const Color secondaryHover = Color(0xff007bca);
  static const Color secondaryActive = Color(0xff0063a7);
  static const Color infoLightHover = Color(0xffcbe7fe);
  static const Color infoLightActive = Color(0xff98cdfd);
  static const Color secondaryDisabled = Color(0xff95d8f8);
  static const Color infoLightDefault = Color(0xffeaf5ff);
  static const Color dangerLightHover = Color(0xfffeddd2);
  static const Color dangerLightActive = Color(0xfffdb7a5);
  static const Color dangerLightDefault = Color(0xfffef2ed);
  static const Color primaryLightHover = Color(0xffcbe7fe);
  static const Color successLightHover = Color(0xffd0f0d1);
  static const Color warningLightHover = Color(0xfffeeecc);
  static const Color primaryLightActive = Color(0xff98cdfd);
  static const Color successLightActive = Color(0xffa4e0a7);
  static const Color warningLightActive = Color(0xfffed998);
  static const Color primaryLightDefault = Color(0xffeaf5ff);
  static const Color successLightDefault = Color(0xffecf7ec);
  static const Color tertiaryLightHover = Color(0xffe6e8ea);
  static const Color warningLightDefault = Color(0xfffff8ea);
  static const Color tertiaryLightActive = Color(0xffc6cacd);
  static const Color secondaryLightHover = Color(0xffcbe7fe);
  static const Color tertiaryLightDefault = Color(0xfff9f9f9);
  static const Color secondaryLightActive = Color(0xff98cdfd);
  static const Color secondaryLightDefault = Color(0xffe9f7fd);

  // static const Color black = Color(0xff000000);
  static const Color red0 = Color(0xfffef2ed);
  static const Color red1 = Color(0xfffeddd2);
  static const Color red2 = Color(0xfffdb7a5);
  static const Color red3 = Color(0xfffb9078);
  static const Color red4 = Color(0xfffa664c);
  static const Color red5 = Color(0xfff93920);
  static const Color red6 = Color(0xffd52515);
  static const Color red7 = Color(0xffb2140c);
  static const Color red8 = Color(0xff8e0805);
  static const Color red9 = Color(0xff6a0103);

  // static const Color white = Color(0xffffffff);
  static const Color blue0 = Color(0xffeaf5ff);
  static const Color blue1 = Color(0xffcbe7fe);
  static const Color blue2 = Color(0xff98cdfd);
  static const Color blue3 = Color(0xff65b2fc);
  static const Color blue4 = Color(0xff3295fb);
  static const Color blue5 = Color(0xff0077fa);
  static const Color blue6 = Color(0xff0062d6);
  static const Color blue7 = Color(0xff004fb3);
  static const Color blue8 = Color(0xff003d8f);
  static const Color blue9 = Color(0xff002c6b);
  static const Color cyan0 = Color(0xffe5f7f8);
  static const Color cyan1 = Color(0xffc2eff0);
  static const Color cyan2 = Color(0xff8adde2);
  static const Color cyan3 = Color(0xff58cbd3);
  static const Color cyan4 = Color(0xff2cb8c5);
  static const Color cyan5 = Color(0xff05a4b6);
  static const Color cyan6 = Color(0xff038698);
  static const Color cyan7 = Color(0xff016979);
  static const Color cyan8 = Color(0xff004d5b);
  static const Color cyan9 = Color(0xff00323d);
  static const Color grey0 = Color(0xfff9f9f9);
  static const Color grey1 = Color(0xffe6e8ea);
  static const Color grey2 = Color(0xffc6cacd);
  static const Color grey3 = Color(0xffa7abb0);
  static const Color grey4 = Color(0xff888d92);
  static const Color grey5 = Color(0xff6b7075);
  static const Color grey6 = Color(0xff555b61);
  static const Color grey7 = Color(0xff41464c);
  static const Color grey8 = Color(0xff2e3238);
  static const Color grey9 = Color(0xff1c1f23);
  static const Color lime0 = Color(0xfff2fae6);
  static const Color lime1 = Color(0xffe3f6c5);
  static const Color lime2 = Color(0xffcbed8e);
  static const Color lime3 = Color(0xffb7e35b);
  static const Color lime4 = Color(0xffa7da2c);
  static const Color lime5 = Color(0xff9bd100);
  static const Color lime6 = Color(0xff7eae00);
  static const Color lime7 = Color(0xff638b00);
  static const Color lime8 = Color(0xff486800);
  static const Color lime9 = Color(0xff2f4600);
  static const Color pink0 = Color(0xfffdecef);
  static const Color pink1 = Color(0xfffbcfd8);
  static const Color pink2 = Color(0xfff6a0b5);
  static const Color pink3 = Color(0xfff27396);
  static const Color pink4 = Color(0xffed487b);
  static const Color pink5 = Color(0xffe91e63);
  static const Color pink6 = Color(0xffc51356);
  static const Color pink7 = Color(0xffa20b48);
  static const Color pink8 = Color(0xff7e053a);
  static const Color pink9 = Color(0xff5a012b);
  static const Color teal0 = Color(0xffe4f7f4);
  static const Color teal1 = Color(0xffc0f0e8);
  static const Color teal2 = Color(0xff87e0d3);
  static const Color teal3 = Color(0xff54d1c1);
  static const Color teal4 = Color(0xff27c2b0);
  static const Color teal5 = Color(0xff00b3a1);
  static const Color teal6 = Color(0xff009589);
  static const Color teal7 = Color(0xff00776f);
  static const Color teal8 = Color(0xff005955);
  static const Color teal9 = Color(0xff003c3a);
  static const Color amber0 = Color(0xfffefbeb);
  static const Color amber1 = Color(0xfffcf5ce);
  static const Color amber2 = Color(0xfff9e89e);
  static const Color amber3 = Color(0xfff6d86f);
  static const Color amber4 = Color(0xfff3c641);
  static const Color amber5 = Color(0xfff0b114);
  static const Color amber6 = Color(0xffc88a0f);
  static const Color amber7 = Color(0xffa0660a);
  static const Color amber8 = Color(0xff784606);
  static const Color amber9 = Color(0xff502b03);
  static const Color brand0 = Color(0xffeaf5ff);
  static const Color brand1 = Color(0xffcbe7fe);
  static const Color brand2 = Color(0xff98cdfd);
  static const Color brand3 = Color(0xff65b2fc);
  static const Color brand4 = Color(0xff3295fb);
  static const Color brand5 = Color(0xff0077fa);
  static const Color brand6 = Color(0xff0062d6);
  static const Color brand7 = Color(0xff004fb3);
  static const Color brand8 = Color(0xff003d8f);
  static const Color brand9 = Color(0xff002c6b);
  static const Color green0 = Color(0xffecf7ec);
  static const Color green1 = Color(0xffd0f0d1);
  static const Color green2 = Color(0xffa4e0a7);
  static const Color green3 = Color(0xff7dd182);
  static const Color green4 = Color(0xff5ac262);
  static const Color green5 = Color(0xff3bb346);
  static const Color green6 = Color(0xff30953b);
  static const Color green7 = Color(0xff25772f);
  static const Color green8 = Color(0xff1b5924);
  static const Color green9 = Color(0xff113c18);
  static const Color indigo0 = Color(0xffeceff8);
  static const Color indigo1 = Color(0xffd1d8f0);
  static const Color indigo2 = Color(0xffa7b3e1);
  static const Color indigo3 = Color(0xff8090d3);
  static const Color indigo4 = Color(0xff5e6fc4);
  static const Color indigo5 = Color(0xff3f51b5);
  static const Color indigo6 = Color(0xff3342a1);
  static const Color indigo7 = Color(0xff28348c);
  static const Color indigo8 = Color(0xff1f2878);
  static const Color indigo9 = Color(0xff171d63);
  static const Color orange0 = Color(0xfffff8ea);
  static const Color orange1 = Color(0xfffeeecc);
  static const Color orange2 = Color(0xfffed998);
  static const Color orange3 = Color(0xfffdc165);
  static const Color orange4 = Color(0xfffda633);
  static const Color orange5 = Color(0xfffc8800);
  static const Color orange6 = Color(0xffd26700);
  static const Color orange7 = Color(0xffa84a00);
  static const Color orange8 = Color(0xff7e3100);
  static const Color orange9 = Color(0xff541d00);
  static const Color purple0 = Color(0xfff7e9f7);
  static const Color purple1 = Color(0xffefcaf0);
  static const Color purple2 = Color(0xffdd9be0);
  static const Color purple3 = Color(0xffc96fd1);
  static const Color purple4 = Color(0xffb449c2);
  static const Color purple5 = Color(0xff9e28b3);
  static const Color purple6 = Color(0xff871e9e);
  static const Color purple7 = Color(0xff71168a);
  static const Color purple8 = Color(0xff5c0f75);
  static const Color purple9 = Color(0xff490a61);
  static const Color violet0 = Color(0xfff3edf9);
  static const Color violet1 = Color(0xffe2d1f4);
  static const Color violet2 = Color(0xffc4a7e9);
  static const Color violet3 = Color(0xffa67fdd);
  static const Color violet4 = Color(0xff885bd2);
  static const Color violet5 = Color(0xff6a3ac7);
  static const Color violet6 = Color(0xff572fb3);
  static const Color violet7 = Color(0xff46259e);
  static const Color violet8 = Color(0xff361c8a);
  static const Color violet9 = Color(0xff281475);
  static const Color yellow0 = Color(0xfffffdea);
  static const Color yellow1 = Color(0xfffefbcb);
  static const Color yellow2 = Color(0xfffdf398);
  static const Color yellow3 = Color(0xfffce865);
  static const Color yellow4 = Color(0xfffbda32);
  static const Color yellow5 = Color(0xfffac800);
  static const Color yellow6 = Color(0xffd0aa00);
  static const Color yellow7 = Color(0xffa78b00);
  static const Color yellow8 = Color(0xff7d6a00);
  static const Color yellow9 = Color(0xff534800);
  static const Color lightBlue0 = Color(0xffe9f7fd);
  static const Color lightBlue1 = Color(0xffc9ecfc);
  static const Color lightBlue2 = Color(0xff95d8f8);
  static const Color lightBlue3 = Color(0xff62c3f5);
  static const Color lightBlue4 = Color(0xff30acf1);
  static const Color lightBlue5 = Color(0xff0095ee);
  static const Color lightBlue6 = Color(0xff007bca);
  static const Color lightBlue7 = Color(0xff0063a7);
  static const Color lightBlue8 = Color(0xff004b83);
  static const Color lightBlue9 = Color(0xff00355f);
  static const Color lightGreen0 = Color(0xfff3f8ec);
  static const Color lightGreen1 = Color(0xffe3f0d0);
  static const Color lightGreen2 = Color(0xffc8e2a5);
  static const Color lightGreen3 = Color(0xffadd37e);
  static const Color lightGreen4 = Color(0xff93c55b);
  static const Color lightGreen5 = Color(0xff7bb63c);
  static const Color lightGreen6 = Color(0xff649830);
  static const Color lightGreen7 = Color(0xff4e7926);
  static const Color lightGreen8 = Color(0xff395b1b);
  static const Color lightGreen9 = Color(0xff253d12);
}

class ColorDark {
  static const Color bg0 = Color(0xff16161a);
  static const Color bg1 = Color(0xff232429);
  static const Color bg2 = Color(0xff35363c);
  static const Color bg3 = Color(0xff43444a);
  static const Color bg4 = Color(0xff4f5159);
  static const Color info = Color(0xff54a9ff);
  static const Color link = Color(0xff54a9ff);
  static const Color navBg = Color(0xff232429);
  static const Color black = Color(0xff000000);
  static const Color data0 = Color(0xff5e6dc2);
  static const Color data1 = Color(0xff086878);
  static const Color data2 = Color(0xfffaad3f);
  static const Color data3 = Color(0xff4c2b9c);
  static const Color data4 = Color(0xff107df8);
  static const Color data5 = Color(0xfff8ca10);
  static const Color data6 = Color(0xffc31e57);
  static const Color data7 = Color(0xff057773);
  static const Color data8 = Color(0xff9acf0d);
  static const Color data9 = Color(0xff751d8a);
  static const Color fill0 = Color(0x0cffffff);
  static const Color fill1 = Color(0x16ffffff);
  static const Color fill2 = Color(0x21ffffff);
  static const Color text0 = Color(0xfff9f9f9);
  static const Color text1 = Color(0xccf9f9f9);
  static const Color text2 = Color(0x99f9f9f9);
  static const Color text3 = Color(0x59f9f9f9);
  static const Color white = Color(0xffe4e7f5);
  static const Color data10 = Color(0xff10a2b4);
  static const Color data11 = Color(0xffd06e0b);
  static const Color data12 = Color(0xff7142c5);
  static const Color data13 = Color(0xff0764d4);
  static const Color data14 = Color(0xfffbe86e);
  static const Color data15 = Color(0xffa01349);
  static const Color data16 = Color(0xff0bb3a7);
  static const Color data17 = Color(0xff628a06);
  static const Color data18 = Color(0xffa230b3);
  static const Color data19 = Color(0xff28338a);
  static const Color border = Color(0x14ffffff);
  static const Color danger = Color(0xfffc725a);
  static const Color shadow = Color(0x0a000000);

  // static const Color default = Color(0xff1c1f23);
  static const Color infoHover = Color(0xff7fc1ff);
  static const Color linkHover = Color(0xff7fc1ff);
  static const Color primary = Color(0xff3295fb);
  static const Color success = Color(0xff5dc264);
  static const Color warning = Color(0xffffae43);
  static const Color infoActive = Color(0xffa9d7ff);
  static const Color linkActive = Color(0xffa9d7ff);
  static const Color linkVisited = Color(0xff54a9ff);
  static const Color tertiary = Color(0xff888d92);
  static const Color focusBorder = Color(0xff3295fb);
  static const Color infoDisabled = Color(0xff135cb8);
  static const Color overlayBg = Color(0x9916161a);
  static const Color dangerHover = Color(0xfffd9983);
  static const Color highlight = Color(0xffffffff);
  static const Color secondary = Color(0xff40b4f3);
  static const Color dangerActive = Color(0xfffdbeac);
  static const Color disabledBg = Color(0xff2e3238);
  static const Color defaultHover = Color(0xff2e3238);
  static const Color primaryHover = Color(0xff65b2fc);
  static const Color successHover = Color(0xff7fd184);
  static const Color warningHover = Color(0xffffc772);
  static const Color defaultActive = Color(0xff41464c);
  static const Color disabledFill = Color(0x0ae6e8ea);
  static const Color disabledText = Color(0x59f9f9f9);
  static const Color highlightBg = Color(0xffa88e0a);
  static const Color primaryActive = Color(0xff98cdfd);
  static const Color successActive = Color(0xffa6e1a8);
  static const Color warningActive = Color(0xffffdda1);
  static const Color tertiaryHover = Color(0xffa7abb0);
  static const Color disabledBorder = Color(0xff2e3238);
  static const Color primaryDisabled = Color(0xff004fb3);
  static const Color successDisabled = Color(0xff277731);
  static const Color tertiaryActive = Color(0xffc6cacd);
  static const Color secondaryHover = Color(0xff6ec8f6);
  static const Color secondaryActive = Color(0xff9ddcf9);
  static const Color infoLightHover = Color(0x4c54a9ff);
  static const Color infoLightActive = Color(0x6654a9ff);
  static const Color secondaryDisabled = Color(0xff0366a9);
  static const Color infoLightDefault = Color(0x3354a9ff);
  static const Color dangerLightHover = Color(0x4cfc725a);
  static const Color dangerLightActive = Color(0x66fc725a);
  static const Color dangerLightDefault = Color(0x33fc725a);
  static const Color primaryLightHover = Color(0x4c3295fb);
  static const Color successLightHover = Color(0x4c5dc264);
  static const Color warningLightHover = Color(0x4cffae43);
  static const Color primaryLightActive = Color(0x663295fb);
  static const Color successLightActive = Color(0x665dc264);
  static const Color warningLightActive = Color(0x66ffae43);
  static const Color primaryLightDefault = Color(0x333295fb);
  static const Color successLightDefault = Color(0x335dc264);
  static const Color tertiaryLightHover = Color(0x4c888d92);
  static const Color warningLightDefault = Color(0x33ffae43);
  static const Color tertiaryLightActive = Color(0x66888d92);
  static const Color secondaryLightHover = Color(0x4c40b4f3);
  static const Color tertiaryLightDefault = Color(0x33888d92);
  static const Color secondaryLightActive = Color(0x6640b4f3);
  static const Color secondaryLightDefault = Color(0x3340b4f3);

  // static const Color black = Color(0xff000000);
  static const Color red0 = Color(0xff6c090b);
  static const Color red1 = Color(0xff901110);
  static const Color red2 = Color(0xffb42019);
  static const Color red3 = Color(0xffd73324);
  static const Color red4 = Color(0xfffb4932);
  static const Color red5 = Color(0xfffc725a);
  static const Color red6 = Color(0xfffd9983);
  static const Color red7 = Color(0xfffdbeac);
  static const Color red8 = Color(0xfffee0d5);
  static const Color red9 = Color(0xfffff3ef);

  // static const Color white = Color(0xffffffff);
  static const Color blue0 = Color(0xff053170);
  static const Color blue1 = Color(0xff0a4694);
  static const Color blue2 = Color(0xff135cb8);
  static const Color blue3 = Color(0xff1d75db);
  static const Color blue4 = Color(0xff2990ff);
  static const Color blue5 = Color(0xff54a9ff);
  static const Color blue6 = Color(0xff7fc1ff);
  static const Color blue7 = Color(0xffa9d7ff);
  static const Color blue8 = Color(0xffd4ecff);
  static const Color blue9 = Color(0xffeff8ff);
  static const Color cyan0 = Color(0xff04343d);
  static const Color cyan1 = Color(0xff074f5c);
  static const Color cyan2 = Color(0xff0a6c7b);
  static const Color cyan3 = Color(0xff0e8999);
  static const Color cyan4 = Color(0xff13a8b8);
  static const Color cyan5 = Color(0xff38bbc6);
  static const Color cyan6 = Color(0xff62cdd4);
  static const Color cyan7 = Color(0xff91dfe3);
  static const Color cyan8 = Color(0xffc6eff1);
  static const Color cyan9 = Color(0xffe7f7f8);
  static const Color grey0 = Color(0xff1c1f23);
  static const Color grey1 = Color(0xff2e3238);
  static const Color grey2 = Color(0xff41464c);
  static const Color grey3 = Color(0xff555b61);
  static const Color grey4 = Color(0xff6b7075);
  static const Color grey5 = Color(0xff888d92);
  static const Color grey6 = Color(0xffa7abb0);
  static const Color grey7 = Color(0xffc6cacd);
  static const Color grey8 = Color(0xffe6e8ea);
  static const Color grey9 = Color(0xfff9f9f9);
  static const Color lime0 = Color(0xff314603);
  static const Color lime1 = Color(0xff4b6905);
  static const Color lime2 = Color(0xff678d09);
  static const Color lime3 = Color(0xff84b00c);
  static const Color lime4 = Color(0xffa2d311);
  static const Color lime5 = Color(0xffaedc3a);
  static const Color lime6 = Color(0xffbde566);
  static const Color lime7 = Color(0xffcfed96);
  static const Color lime8 = Color(0xffe5f6c9);
  static const Color lime9 = Color(0xfff3fbe9);
  static const Color pink0 = Color(0xff5c0730);
  static const Color pink1 = Color(0xff800e41);
  static const Color pink2 = Color(0xffa41751);
  static const Color pink3 = Color(0xffc72261);
  static const Color pink4 = Color(0xffeb2f71);
  static const Color pink5 = Color(0xffef5686);
  static const Color pink6 = Color(0xfff37e9f);
  static const Color pink7 = Color(0xfff7a8bc);
  static const Color pink8 = Color(0xfffbd3dc);
  static const Color pink9 = Color(0xfffdeef1);
  static const Color teal0 = Color(0xff023c39);
  static const Color teal1 = Color(0xff045a55);
  static const Color teal2 = Color(0xff07776f);
  static const Color teal3 = Color(0xff0a9588);
  static const Color teal4 = Color(0xff0eb3a1);
  static const Color teal5 = Color(0xff33c2b0);
  static const Color teal6 = Color(0xff5ed1c1);
  static const Color teal7 = Color(0xff8ee1d3);
  static const Color teal8 = Color(0xffc4f0e8);
  static const Color teal9 = Color(0xffe6f7f4);
  static const Color amber0 = Color(0xff512e09);
  static const Color amber1 = Color(0xff794b0f);
  static const Color amber2 = Color(0xffa16b16);
  static const Color amber3 = Color(0xffca8f1e);
  static const Color amber4 = Color(0xfff2b726);
  static const Color amber5 = Color(0xfff5ca50);
  static const Color amber6 = Color(0xfff7db7a);
  static const Color amber7 = Color(0xfffaeaa6);
  static const Color amber8 = Color(0xfffcf6d2);
  static const Color amber9 = Color(0xfffefbed);
  static const Color brand0 = Color(0xff002c6b);
  static const Color brand1 = Color(0xff003d8f);
  static const Color brand2 = Color(0xff004fb3);
  static const Color brand3 = Color(0xff0062d6);
  static const Color brand4 = Color(0xff0077fa);
  static const Color brand5 = Color(0xff3295fb);
  static const Color brand6 = Color(0xff65b2fc);
  static const Color brand7 = Color(0xff98cdfd);
  static const Color brand8 = Color(0xffcbe7fe);
  static const Color brand9 = Color(0xffeaf5ff);
  static const Color green0 = Color(0xff123c19);
  static const Color green1 = Color(0xff1c5a25);
  static const Color green2 = Color(0xff277731);
  static const Color green3 = Color(0xff32953d);
  static const Color green4 = Color(0xff3eb349);
  static const Color green5 = Color(0xff5dc264);
  static const Color green6 = Color(0xff7fd184);
  static const Color green7 = Color(0xffa6e1a8);
  static const Color green8 = Color(0xffd0f0d1);
  static const Color green9 = Color(0xffecf7ec);
  static const Color indigo0 = Color(0xff171e65);
  static const Color indigo1 = Color(0xff20297a);
  static const Color indigo2 = Color(0xff29368e);
  static const Color indigo3 = Color(0xff3444a3);
  static const Color indigo4 = Color(0xff4053b7);
  static const Color indigo5 = Color(0xff5f71c5);
  static const Color indigo6 = Color(0xff8191d4);
  static const Color indigo7 = Color(0xffa7b4e2);
  static const Color indigo8 = Color(0xffd1d8f1);
  static const Color indigo9 = Color(0xffedeff8);
  static const Color orange0 = Color(0xff551f03);
  static const Color orange1 = Color(0xff803506);
  static const Color orange2 = Color(0xffaa500a);
  static const Color orange3 = Color(0xffd56f0f);
  static const Color orange4 = Color(0xffff9214);
  static const Color orange5 = Color(0xffffae43);
  static const Color orange6 = Color(0xffffc772);
  static const Color orange7 = Color(0xffffdda1);
  static const Color orange8 = Color(0xffffefd0);
  static const Color orange9 = Color(0xfffff9ed);
  static const Color purple0 = Color(0xff4a1061);
  static const Color purple1 = Color(0xff5e1776);
  static const Color purple2 = Color(0xff731f8a);
  static const Color purple3 = Color(0xff89289f);
  static const Color purple4 = Color(0xffa033b3);
  static const Color purple5 = Color(0xffb553c2);
  static const Color purple6 = Color(0xffca78d1);
  static const Color purple7 = Color(0xffdda0e1);
  static const Color purple8 = Color(0xffefcef0);
  static const Color purple9 = Color(0xfff7ebf7);
  static const Color violet0 = Color(0xff401b77);
  static const Color violet1 = Color(0xff4c248c);
  static const Color violet2 = Color(0xff582ea0);
  static const Color violet3 = Color(0xff6439b5);
  static const Color violet4 = Color(0xff7246c9);
  static const Color violet5 = Color(0xff8865d4);
  static const Color violet6 = Color(0xffa288df);
  static const Color violet7 = Color(0xffbeade9);
  static const Color violet8 = Color(0xffddd4f4);
  static const Color violet9 = Color(0xfff1eefa);
  static const Color yellow0 = Color(0xff544903);
  static const Color yellow1 = Color(0xff7e6c06);
  static const Color yellow2 = Color(0xffa88e0a);
  static const Color yellow3 = Color(0xffd2af0f);
  static const Color yellow4 = Color(0xfffcce14);
  static const Color yellow5 = Color(0xfffdde43);
  static const Color yellow6 = Color(0xfffdeb71);
  static const Color yellow7 = Color(0xfffef5a0);
  static const Color yellow8 = Color(0xfffefbd0);
  static const Color yellow9 = Color(0xfffffeec);
  static const Color lightBlue0 = Color(0xff003761);
  static const Color lightBlue1 = Color(0xff004d85);
  static const Color lightBlue2 = Color(0xff0366a9);
  static const Color lightBlue3 = Color(0xff0a81cc);
  static const Color lightBlue4 = Color(0xff139ff0);
  static const Color lightBlue5 = Color(0xff40b4f3);
  static const Color lightBlue6 = Color(0xff6ec8f6);
  static const Color lightBlue7 = Color(0xff9ddcf9);
  static const Color lightBlue8 = Color(0xffceeefc);
  static const Color lightBlue9 = Color(0xffebf8fe);
  static const Color lightGreen0 = Color(0xff263d13);
  static const Color lightGreen1 = Color(0xff3b5c1d);
  static const Color lightGreen2 = Color(0xff517b28);
  static const Color lightGreen3 = Color(0xff679934);
  static const Color lightGreen4 = Color(0xff7fb840);
  static const Color lightGreen5 = Color(0xff97c65f);
  static const Color lightGreen6 = Color(0xffb0d481);
  static const Color lightGreen7 = Color(0xffc9e3a7);
  static const Color lightGreen8 = Color(0xffe4f1d1);
  static const Color lightGreen9 = Color(0xfff3f8ed);
}
