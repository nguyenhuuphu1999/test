import 'package:flutter/material.dart';
import 'package:vpncn2_app/constants/app_colors.dart';
import 'package:vpncn2_app/constants/app_strings.dart';
import 'package:vpncn2_app/constants/app_assets.dart';
import 'package:vpncn2_app/utils/responsive.dart';
import 'package:vpncn2_app/widgets/common_footer.dart';

class OtherPaymentMethodsScreen extends StatelessWidget {
  const OtherPaymentMethodsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.BACKGROUND_COLOR,
      appBar: AppBar(
        backgroundColor: AppColors.BACKGROUND_COLOR,
        elevation: 0,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Icon(
            Icons.arrow_back_ios,
            color: AppColors.TEXT_PRIMARY_COLOR,
            size: Responsive.getFontSize(context, 20),
          ),
        ),
        title: Text(
          AppStrings.payment,
          style: TextStyle(
            fontSize: Responsive.getFontSize(context, 14),
            fontWeight: FontWeight.w600,
            color: AppColors.TEXT_PRIMARY_COLOR,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: Responsive.width(context, 5),
              ),
              child: Column(
                children: [
                  SizedBox(height: Responsive.height(context, 2)),

                  // Decorative image
                  Center(
                    child: Image.asset(
                      AppAssets.ellipse757,
                      width: Responsive.width(
                        context,
                        11.25,
                      ), // 45px equivalent
                      height: Responsive.width(context, 11.25),
                    ),
                  ),

                  SizedBox(height: Responsive.height(context, 3)),

                  // Footer navigation row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Home section
                      Row(
                        children: [
                          Column(
                            children: [
                              Stack(
                                children: [
                                  Stack(
                                    children: [
                                      SizedBox(
                                        width: Responsive.width(
                                          context,
                                          5.09,
                                        ), // 20.34px
                                        height: Responsive.width(
                                          context,
                                          5.0,
                                        ), // 20px
                                      ),
                                      SizedBox(
                                        width: Responsive.width(
                                          context,
                                          6.0,
                                        ), // 24px
                                        height: Responsive.width(context, 6.0),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                          SizedBox(width: Responsive.width(context, 1)),
                          Text(
                            AppStrings.home,
                            style: TextStyle(
                              fontSize: Responsive.getFontSize(context, 14),
                              fontWeight: FontWeight.w700,
                              color: AppColors.TEXT_PRIMARY_COLOR,
                            ),
                          ),
                        ],
                      ),

                      // Cloud section
                      Column(
                        children: [
                          Image.asset(
                            AppAssets.cloudIcon,
                            width: Responsive.width(context, 8.45), // 33.79px
                            height: Responsive.width(context, 8.45),
                          ),
                          Column(
                            children: [
                              Stack(
                                children: [
                                  Stack(
                                    children: [
                                      SizedBox(
                                        width: Responsive.width(
                                          context,
                                          2.22,
                                        ), // 8.88px
                                        height: Responsive.width(
                                          context,
                                          2.22,
                                        ), // 8.87px
                                      ),
                                      SizedBox(
                                        width: Responsive.width(
                                          context,
                                          3.41,
                                        ), // 13.64px
                                        height: Responsive.width(
                                          context,
                                          2.16,
                                        ), // 8.62px
                                      ),
                                      SizedBox(
                                        width: Responsive.width(
                                          context,
                                          6.0,
                                        ), // 24px
                                        height: Responsive.width(context, 6.0),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),

                  SizedBox(height: Responsive.height(context, 4)),

                  // QR Code images
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Image.asset(
                        AppAssets.qrAlipay, // WeChat Pay QR
                        width: Responsive.width(context, 33.25), // 133px
                        height: Responsive.width(context, 33.25),
                      ),
                      Image.asset(
                        AppAssets.qrWechatPay, // Alipay QR
                        width: Responsive.width(context, 33.25), // 133px
                        height: Responsive.width(context, 33.75), // 135px
                      ),
                    ],
                  ),

                  SizedBox(height: Responsive.height(context, 3)),

                  // Transaction instruction
                  Text(
                    AppStrings.transactionInProgress,
                    style: TextStyle(
                      fontSize: Responsive.getFontSize(context, 14),
                      fontWeight: FontWeight.w400,
                      color: AppColors.TEXT_PRIMARY_COLOR,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  SizedBox(height: Responsive.height(context, 3)),

                  // Order details
                  Container(
                    padding: EdgeInsets.all(Responsive.width(context, 4)),
                    decoration: BoxDecoration(
                      color: AppColors.SURFACE_COLOR,
                      borderRadius: BorderRadius.circular(
                        Responsive.getFontSize(context, 8),
                      ),
                      border: Border.all(
                        color: AppColors.BORDER_COLOR,
                        width: 1,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${AppStrings.orderNo} ORD123456789',
                          style: TextStyle(
                            fontSize: Responsive.getFontSize(context, 14),
                            fontWeight: FontWeight.w400,
                            color: AppColors.TEXT_PRIMARY_COLOR,
                          ),
                        ),
                        SizedBox(height: Responsive.height(context, 1)),
                        Text(
                          '${AppStrings.amount} 100,000 VND',
                          style: TextStyle(
                            fontSize: Responsive.getFontSize(context, 14),
                            fontWeight: FontWeight.w400,
                            color: AppColors.TEXT_PRIMARY_COLOR,
                          ),
                        ),
                        SizedBox(height: Responsive.height(context, 1)),
                        Text(
                          '${AppStrings.dateCreated} ${DateTime.now().toString().split(' ')[0]}',
                          style: TextStyle(
                            fontSize: Responsive.getFontSize(context, 14),
                            fontWeight: FontWeight.w400,
                            color: AppColors.TEXT_PRIMARY_COLOR,
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: Responsive.height(context, 3)),

                  // Payment method labels
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        AppStrings.wechatPayChinese,
                        style: TextStyle(
                          fontSize: Responsive.getFontSize(context, 14),
                          fontWeight: FontWeight.w400,
                          color: AppColors.TEXT_PRIMARY_COLOR,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        AppStrings.alipay,
                        style: TextStyle(
                          fontSize: Responsive.getFontSize(context, 14),
                          fontWeight: FontWeight.w400,
                          color: AppColors.TEXT_PRIMARY_COLOR,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),

                  SizedBox(height: Responsive.height(context, 3)),

                  // Contact admin button
                  Center(
                    child: GestureDetector(
                      onTap: () {
                        // TODO: Implement contact admin functionality
                        print('Contact admin tapped');
                      },
                      child: Text(
                        AppStrings.contactToAdmin,
                        style: TextStyle(
                          fontSize: Responsive.getFontSize(context, 14),
                          fontWeight: FontWeight.w600,
                          color: AppColors.PRIMARY_COLOR,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: Responsive.height(context, 4)),
                ],
              ),
            ),
          ),

          // Common Footer
          CommonFooter(
            activeIndex: -1, // No active tab on other payment methods screen
            onTabChanged: (index) {
              switch (index) {
                case 0:
                  Navigator.pop(context);
                  break;
                case 1:
                case 2:
                  // TODO: Navigate to respective screens
                  break;
              }
            },
          ),
        ],
      ),
    );
  }
}
