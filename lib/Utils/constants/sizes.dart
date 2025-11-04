import  'package:flutter/widgets.dart';

class  KSizes  {
    //  padding  and  margin  sizes
    static  const  double  xs  =  4.0;
    ///  8
    static  const  double  sm  =  8.0;
    static  const  double  md  =  16.0;
    static  const  double  lg  =  24.0;
    static  const  double  xl  =  32.0;

    //  icon  sizes
    static  const  double  iconXs  =  8.0;
    static  const  double  iconSm  =  16.0;
    static  const  double  iconMd  =  24.0;
    static  const  double  iconLg  =  40.0;

    //  Font  sizes
    static  const  double  fontSizeXs  =  4.0;
    static  const  double  fontSizeMd  =  16.0;
    static  const  double  fontSizeLg  =  24.0;

    //  Buttom  sizes
    static  const  double  buttonHeight  =  18.0;
    static  const  double  buttonRadius  =  12.0;
    static  const  double  buttonWidth  =  120.0;
    static  const  double  buttonElevation  =  4.0;

    //  Appbar  height
    static  const  double  appBarHeight  =  56.0;

    //  Image  sizes
    static  const  double  imageThumbSize  =  88.0;

    //  Default  spacing  between  section
    static  const  double  defaultSpace  =  24.0;
    static  const  double  spaceBewItems  =  16.0;
    static  const  double  spaceBtwSections  =  32.0;

    //  border  radius
    static  const  double  borderRadiusSm  =  8.0;
    static  const  double  borderRadiusSmMd  =  10.0;
    static  const  double  borderRadiusSmLg  =  20.0;

    //  Divider    height
    static  const  double  dividerHeight  =  1.0;

    //  Product  Items  dimensions
    static  const  double  productImageSize  =  120.0;
    static  const  double  productImageRadius  =  16.0;
    static  const  double  productItemHeight  =  160.0;

    //  Input  field
    static  const  double  inputFieldRadius  =  12.0;
    static  const  double  spaceBteInputFields  =  16.0;

    //Card  Size
    static  const  double  cardRadiusLg  =  16.0;
    static  const  double  cardRadiusMd  =  12.0;
    static  const  double  cardRadiusSm  =  10.0;
    static  const  double  cardRadiusXs  =  6.0;
    static  const  double  cardElevation  =  2.0;

    //  Imagecarousel  height
    static  const  double  imageCarouselHeight  =  200.0;

    //  Loading  indicator  size
    static  const  double  loadingIndicatorSize  =  36.0;

    //  Grid  view  spacing
    static  const  double  gridViewSpacing  =  16.0;
}

class  AppSizes  {
    static  late  MediaQueryData  _mediaQueryData;
    static  late  double  screenWidth;
    static  late  double  screenHeight;
    static  late  double  blockSizeHorizontal;
    static  late  double  blockSizeVertical;

    void  init(BuildContext  context)  {
        _mediaQueryData  =  MediaQuery.of(context);
        screenWidth  =  _mediaQueryData.size.width;
        screenHeight  =  _mediaQueryData.size.height;
        blockSizeHorizontal  =  screenWidth  /  100;
        blockSizeVertical  =  screenHeight  /  100;
    }
}
