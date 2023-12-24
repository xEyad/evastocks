import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:nosooh/components/show_dialog_widget.dart';
import 'package:nosooh/utils/app_strings.dart';
import 'package:nosooh/utils/constants.dart';
import 'package:provider/provider.dart';

import '../models/trading_model/trading_model.dart';
import '../screens/about_app/e5la2.dart';
import '../services/service_provider.dart';
import '../utils/colors.dart';
import '../utils/functions.dart';
import '../utils/size_utility.dart';
import '../utils/styles.dart';
import 'network_image_viewer.dart';

class BuildHomeItem extends StatefulWidget {
  final TradingData data;
  final bool isTrading;
  final void Function()? opinionTypeOnTap;
  final void Function()? addCommentOnTap;
  final void Function()? likeOnTap;
  final void Function()? shariaOnTap;
  final void Function()? showMoreOnTap;
  final void Function()? disclaimerOnTap;

  const BuildHomeItem(
      {super.key,
      required this.data,
      this.opinionTypeOnTap,
      this.addCommentOnTap,
      this.shariaOnTap,
      this.disclaimerOnTap,
      this.likeOnTap,
      required this.isTrading,
      this.showMoreOnTap});

  @override
  State<BuildHomeItem> createState() => _BuildHomeItemState();
}

class _BuildHomeItemState extends State<BuildHomeItem> {
  bool showMoreText = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
              color: widget.data.opinionOrderType.toString().contains('2')
                  ? /*شراء*/ HexColor('#f5fbfb')
                  : /*بيع*/ HexColor('#fef5f5'),
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  blurRadius: 2,
                  offset: const Offset(0, 1),
                ),
              ],
              border: Border.all(
                color: notificationBorderColor,
                width: 0.2,
              )),
          child: bigContainerChild(),
        ),
        const SizedBox(
          height: 8,
        ),
        lastPartOfHomeItem(),
      ],
    );
  }

  Widget bigContainerChild() {
    return Column(
      children: [
        namePartOfContainer(),
        firstPartOfContainer(),
        secondPartOfContainer(),
        thirdPartOfContainer(),
        //fourthPartOfContainer(),
        if (widget.data.opinionImages != null &&
            widget.data.opinionImages!.isNotEmpty)
          bigImagesPart(),
        const SizedBox(
          height: 10,
        ),
        fifthPartOfContainer(),
      ],
    );
  }

  Widget namePartOfContainer() {
    return Container(
      color: widget.data.opinionOrderType.toString().contains('2')
          ? /*شراء*/ HexColor('#edf9f9')
          : /*بيع*/ HexColor('#fadfdf'),
      /*widget.data.opinionOrderType == '2'
              ? /*شراء*/ HexColor('#31D5C80A')
              : /*بيع*/ HexColor('#FADFDF'),*/
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          children: [
            Text(
              '${AppLocalizations.of(context)!.thisOpinionFrom}: ',
              style: TextStyle(
                color: textColor,
                fontWeight: FontWeight.w500,
                fontSize: 12,
              ),
            ),
            Expanded(
              child: Text(
                widget.data.listName??'',
                style: TextStyle(
                    color: HexColor('#31D5C8'),
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                    decoration: TextDecoration.underline),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget firstPartOfContainer() {
    return Container(
      color: widget.data.opinionOrderType.toString().contains('2')
          ? /*شراء*/ HexColor('#f5fbfb')
          : /*بيع*/ HexColor('#fef5f5'),
      /*widget.data.opinionOrderType == '2'
              ? /*شراء*/ HexColor('#31D5C80A')
              : /*بيع*/ HexColor('#FADFDF'),*/
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          children: [
            CircleAvatar(
              backgroundImage: (widget.data.opinionImage != null &&
                      widget.data.opinionImage.toString().isNotEmpty)
                  ? NetworkImage(widget.data.opinionImage!)
                  : null,
              radius: 21,
              backgroundColor: HexColor('#A7A7A7'),
              child: (widget.data.opinionImage == null ||
                      widget.data.opinionImage.toString().isEmpty)
                  ? Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Center(
                        child: Image.asset('assets/logos/logo.png',
                            color: Colors.white),
                      ),
                    )
                  : null,
            ),
            const SizedBox(
              width: 5,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      widget.data.stockName!,
                      style: Styles.textStyle15Medium.copyWith(
                        color: textColor,
                      ),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Text(
                      '(${widget.data.stockSymbol!})',
                      style: Styles.textStyle12Medium.copyWith(
                        color: customOrangeColor,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 7,
                ),
                Wrap(
                  children: [
                    Text(
                      widget.data.opinionDate!,
                      style: Styles.textStyle14Medium.copyWith(
                        color:textColor
                        //dragImageColor,
                      ),
                    ),
                  ],
                )
              ],
            ),
            const Spacer(),
            Container(
              width: 70,
              height: 40,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(29),
                  color: widget.data.opinionOrderType.toString().contains('2')
                      ? /*شراء*/ HexColor('#edf9f9')
                      : /*بيع*/ HexColor('#fadfdf'),
                  border: Border.all(
                    color: widget.data.opinionOrderType.toString().contains('2')
                        ? /*شراء*/ HexColor('#e2f8f6')
                        : /*بيع*/ HexColor('#fae0e0'),
                  )),
              child: Center(
                child: Text(
                  buyText(text: widget.data.opinionOrderTypeText!),
                  style: Styles.textStyle13Bold.copyWith(
                    color: widget.data.opinionOrderType.toString().contains('2')
                        ? /*شراء*/ HexColor('#31D5C8')
                        : /*بيع*/ HexColor('#e70000'),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget secondPartOfContainer() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10),
      child: Container(
        color: widget.data.opinionOrderType == '2'
            ? /*شراء*/ HexColor('#edfbf9')
            : /*بيع*/ HexColor('#fef5f5'),
        child: Align(
          alignment: AlignmentDirectional.center,
          child: LayoutBuilder(
            builder: (context, constraints) {
              double maxWidth = constraints.maxWidth;
              return Wrap(
                  alignment: WrapAlignment.center,

                  crossAxisAlignment: WrapCrossAlignment
                      .center, // Ensure children are centered vertically
                  direction: Axis.horizontal,
                  children: [
                    if (widget.data.opinionExtraInfo != null &&
                        widget.data.opinionExtraInfo.toString().isNotEmpty)
                      Text(
                        widget.data.opinionExtraInfo!,
                        maxLines: 3,
                        style: Styles.textStyle14Medium.copyWith(
                          color: dragImageColor,
                        ),
                      ),
                    if (widget.data.opinionExtraInfo != null &&
                        widget.data.opinionExtraInfo!.isNotEmpty &&
                        calculateNumberOfLines(
                              screenWidth: maxWidth,
                              text: widget.data.opinionExtraInfo!,
                              textStyle: Styles.textStyle14Medium.copyWith(
                                color: dragImageColor,
                              ),
                            ) >
                            3)
                      TextButton(
                        onPressed: widget.showMoreOnTap,
                        child: Text(
                          AppLocalizations.of(context)!.showMore,
                          style: Styles.textStyle14Bold.copyWith(
                            color: myBlue,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                  ]);
            },
          ),
        ),
      ),
    );
  }

  Widget thirdPartOfContainer() {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                InkWell(
                  onTap: widget.opinionTypeOnTap,
                  child: Wrap(
                    alignment: WrapAlignment.center,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Text(
                        AppLocalizations.of(context)!.opinionType,
                        style: Styles.textStyle12Medium.copyWith(
                          color: containerTextColor,
                        ),
                      ),
                      const ImageIcon(AssetImage('assets/icons/info.png')),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 6,
                ),
                Wrap(
                  alignment: WrapAlignment.center,

                  children: [
                    Text(
                    //  widget.data.opinionCategoryText!,
                      widget.data.opinionTypeText!,
                      style: Styles.textStyle16Bold.copyWith(
                        color: HexColor('#2E2E2E'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 17,
                ),
                InkWell(
                  onTap: (){
                    showCustomDialog(
                      context: context,
                      title:
                      AppLocalizations.of(context)!.targetChange,
                      body:
                      '${widget.data.changePercentage}%',
                    );
                  },
                  child: Wrap(
                    alignment: WrapAlignment.center,

                    crossAxisAlignment: WrapCrossAlignment.center,
                    direction: Axis.horizontal,
                    children: [
                      Text(
                        AppLocalizations.of(context)!.targetChange,
                        style: Styles.textStyle12Medium.copyWith(
                          color: containerTextColor,
                        ),
                      ),
                      const ImageIcon(AssetImage('assets/icons/info.png')),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 6,
                ),
                Wrap(
                  children: [
                    Text(
                      '${widget.data.changePercentage}%',
                      style: Styles.textStyle16Bold.copyWith(
                        color: widget.data.opinionOrderType == '2'
                            ? /*شراء*/ HexColor('#31d5c8')
                            : /*بيع*/ HexColor('#e70000'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                InkWell(
                  onTap: (){
                    showCustomDialog(
                      context: context,
                      title:
                      AppLocalizations.of(context)!.analystDuration,
                      body:
                      widget.data.opinionDuration!,
                    );
                  },
                  child: Wrap(
                    direction: Axis.horizontal,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Text(
                        AppLocalizations.of(context)!.analystDuration,
                        style: Styles.textStyle12Medium.copyWith(
                          color: HexColor('#515151'),
                        ),
                      ),
                      const ImageIcon(AssetImage('assets/icons/info.png')),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 6,
                ),
                Wrap(
                  children: [
                    Text(
                      widget.data.opinionDuration!,
                      style: Styles.textStyle16Bold.copyWith(
                        color: HexColor('#515151'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                InkWell(
                  onTap: (){
                    showCustomDialog(
                      context: context,
                      title:
                      AppLocalizations.of(context)!.marketCap,
                      body:
                      widget.data.marketCap ?? '',
                    );
                  },
                  child: Wrap(
                    direction: Axis.horizontal,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Text(
                        AppLocalizations.of(context)!.marketCap,
                        style: Styles.textStyle12Medium.copyWith(
                          color: HexColor('#515151'),
                        ),
                      ),
                      const ImageIcon(AssetImage('assets/icons/info.png')),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 6,
                ),
                Wrap(
                  children: [
                    Text(
                      widget.data.marketCap ?? '',
                      style: Styles.textStyle16Bold.copyWith(
                        color: HexColor('#515151'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: Column(
              children: [
                InkWell(
                  onTap:(){
                    showCustomDialog(
                      context: context,
                      title:
                      AppLocalizations.of(context)!.entryPrice,
                      body:
                      '${widget.data.opinionEntryPrice!} ${AppLocalizations.of(context)!.sar}',
                    );
                  },
                  child: Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    direction: Axis.horizontal,
                    children: [
                      Text(
                        AppLocalizations.of(context)!.entryPrice,
                        style: Styles.textStyle12Medium.copyWith(
                          color: containerTextColor,
                        ),
                      ),
                      const ImageIcon(AssetImage('assets/icons/info.png')),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 6,
                ),
                Wrap(
                  children: [
                    Text(
                      '${widget.data.opinionEntryPrice!} ${AppLocalizations.of(context)!.sar}',
                      style: Styles.textStyle16Bold.copyWith(
                        color: HexColor('#515151'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 17,
                ),
                InkWell(
                  onTap: (){
                    showCustomDialog(
                      context: context,
                      title:
                      AppLocalizations.of(context)!.todayPrice,
                      body:
                      '${widget.data.stockTodayPrice} ${AppLocalizations.of(context)!.sar}',
                    );
                  },
                  child: Wrap(
                    direction: Axis.horizontal,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Text(
                        AppLocalizations.of(context)!.todayPrice,
                        style: Styles.textStyle12Medium.copyWith(
                          color: containerTextColor,
                        ),
                      ),
                      const ImageIcon(AssetImage('assets/icons/info.png')),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 6,
                ),
                Wrap(
                  children: [
                    Text(
                      '${widget.data.stockTodayPrice} ${AppLocalizations.of(context)!.sar}',
                      style: Styles.textStyle16Bold.copyWith(
                        color: HexColor('#515151'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                InkWell(
                  onTap: (){
                    showCustomDialog(
                      context: context,
                      title:
                      AppLocalizations.of(context)!.waqfType,
                      body: widget.data.opinionStopLossValidity!
                    );
                  },
                  child: Wrap(
                    direction: Axis.horizontal,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Text(
                        AppLocalizations.of(context)!.waqfType,
                        style: Styles.textStyle12Medium.copyWith(
                          color: HexColor('#515151'),
                        ),
                      ),
                      const ImageIcon(AssetImage('assets/icons/info.png')),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 6,
                ),
                Wrap(
                  children: [
                    Text(
                      widget.data.opinionStopLossValidityText!,
                      style: Styles.textStyle16Bold.copyWith(
                        color: HexColor('#515151'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Wrap(
                  children: [
                    InkWell(
                      onTap: widget.shariaOnTap,
                      child: Column(
                        children: [
                          Wrap(
                            crossAxisAlignment: WrapCrossAlignment.center,
                            direction: Axis.horizontal,
                            children: [
                              Text(
                                AppLocalizations.of(context)!.sharia,
                                style: Styles.textStyle12Medium.copyWith(
                                  color: HexColor('#515151'),
                                ),
                              ),
                              const ImageIcon(
                                  AssetImage('assets/icons/info.png')),
                            ],
                          ),
                          const SizedBox(
                            height: 6,
                          ),
                          InkWell(
                            child: widget.data.shariaCompliance == 1
                                ? Image.asset('assets/icons/correct_icon.png')
                                : Image.asset('assets/icons/wrong_icon.png'),
                          ),
                        ],
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                InkWell(
                  onTap:(){
                    showCustomDialog(
                      context: context,
                      title:
                      AppLocalizations.of(context)!.targetPrice,
                      body:
                      '${widget.data.opinionTargetPrice!} ${AppLocalizations.of(context)!.sar}',
                    );
                   },
                  child: Wrap(
                    direction: Axis.horizontal,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Text(
                        AppLocalizations.of(context)!.targetPrice,
                        style: Styles.textStyle12Medium.copyWith(
                          color: containerTextColor,
                        ),
                      ),
                      const ImageIcon(AssetImage('assets/icons/info.png')),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 6,
                ),
                Wrap(
                  children: [
                    Text(
                      '${widget.data.opinionTargetPrice!} ${AppLocalizations.of(context)!.sar}',
                      style: Styles.textStyle16Bold.copyWith(
                        color: widget.data.opinionOrderType == '2'
                            ? /*شراء*/ HexColor('#31d5c8')
                            : /*بيع*/ HexColor('#e70000'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 17,
                ),
                InkWell(
                  onTap: (){
                    showCustomDialog(
                      context: context,
                      title:
                      AppLocalizations.of(context)!.analystType,
                      body:
                      widget.isTrading
                          ? AppLocalizations.of(context)!.trading
                          : AppLocalizations.of(context)!.investment,
                    );
                  },
                  child: Wrap(
                    direction: Axis.horizontal,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Text(
                        AppLocalizations.of(context)!.analystType,
                        style: Styles.textStyle12Medium.copyWith(
                          color: containerTextColor,
                        ),
                      ),
                      const ImageIcon(AssetImage('assets/icons/info.png')),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 6,
                ),
                Wrap(
                  children: [
                    Text(
    widget.data.opinionCategoryText.toString(),
                     /* widget.isTrading
                          ?
                      //AppLocalizations.of(context)!.trading
                            'قصير مدي'
                          : 'طويل مدي',
                      //AppLocalizations.of(context)!.investment,

                      */
                      style: Styles.textStyle16Bold.copyWith(
                        color: HexColor('#2E2E2E'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 17,
                ),
                InkWell(
                  onTap: (){
                    showCustomDialog(
                      context: context,
                      title:
                      AppLocalizations.of(context)!.stopLoss,
                      body:
                      widget.data.opinionStopLoss.toString(),
                    );
                  },
                  child: Wrap(
                    direction: Axis.horizontal,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Text(
                        AppLocalizations.of(context)!.stopLoss,
                        style: Styles.textStyle12Medium.copyWith(
                          color: containerTextColor,
                        ),
                      ),
                      const ImageIcon(AssetImage('assets/icons/info.png')),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 6,
                ),
                Wrap(
                  children: [
                    Text(
                      widget.data.opinionStopLoss.toString(),
                      style: Styles.textStyle16Bold.copyWith(
                        color: HexColor('#2E2E2E'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget fourthPartOfContainer() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Container(
          height: 32,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: HexColor('#FAFAFA'),
          ),
          child: Center(
            child: Row(
              children: [
                Icon(
                  Icons.check_circle_outline_outlined,
                  color: customOrangeColor,
                ),
                const SizedBox(
                  width: 4,
                ),
                Text(
                  AppLocalizations.of(context)!.success,
                  style: Styles.textStyle13Medium.copyWith(
                    color: HexColor('#6F6BB2'),
                  ),
                ),
              ],
            ),
          ),
        ),
        Container(
          height: 32,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: HexColor('#FAFAFA'),
          ),
          child: Center(
            child: Row(
              children: [
                Icon(
                  Icons.sports_volleyball_outlined,
                  color: HexColor('#6F6BB2'),
                ),
                const SizedBox(
                  width: 4,
                ),
                Text(
                  'شركة ريت للأبحاث',
                  style: Styles.textStyle13Medium.copyWith(
                    color: HexColor('#6F6BB2'),
                  ),
                ),
              ],
            ),
          ),
        ),
        Container(
          height: 32,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: HexColor('#FAFAFA'),
          ),
          child: Center(
            child: Row(
              children: [
                Icon(
                  Icons.cloud_done_outlined,
                  color: HexColor('#6F6BB2'),
                ),
                const SizedBox(
                  width: 4,
                ),
                Text(
                  'قطاع الأعمال',
                  style: Styles.textStyle13Medium.copyWith(
                    color: HexColor('#6F6BB2'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget fifthPartOfContainer() {
    return Row(
      children: [
        Expanded(
            child: GestureDetector(
          onTap: widget.addCommentOnTap,
          child: Container(
            height: 40,
            color: widget.data.opinionOrderType == '2'
                ? /*شراء*/ HexColor('#31d5c8')
                : /*بيع*/ HexColor('#e70000'),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/icons/comment.png',
                ),
                const SizedBox(
                  width: 5,
                ),
                Text(
                  AppLocalizations.of(context)!.addComment,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ],
            ),
          ),
        )),

        Expanded(
            child: GestureDetector(
             onTap: widget.likeOnTap,
          child: Container(
            height: 40,
            color: widget.data.opinionOrderType == '2'
                ? /*شراء*/ HexColor('#31d5c8')
                : /*بيع*/ HexColor('#e70000'),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                widget.data.isFavorite!
                    ? Image.asset(
                        'assets/icons/heart.png',
                        color: widget.data.opinionOrderType == '2'
                            ? /*شراء*/ HexColor('#e20505')
                            : /*بيع*/ Colors.white,
                      )
                    : Image.asset(
                        'assets/icons/empty_heart.png',
                        color: widget.data.opinionOrderType == '2'
                            ? /*شراء*/ HexColor('#e20505')
                            : /*بيع*/ Colors.white,
                      ),
                const SizedBox(
                  width: 5,
                ),
                Text(
                  '(${widget.data.favouritesCount})',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        )),

        Expanded(
            child: GestureDetector(
          onTap: () {},
          child: Container(
            height: 40,
            color: widget.data.opinionOrderType == '2'
                ? /*شراء*/ HexColor('#31D5C8')
                : /*بيع*/ HexColor('#e70000'),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                //نجح
                if (widget.data.opinionStatus == '1') widget.data.opinionOrderType == '2' ?
                  Container(
                    height: 12.0,
                    child: Image.asset(
                      'assets/icons/success.png',
                    ),
                  ):Container(
                  height:12.0,
                    child: Image.asset('assets/icons/success.png')) ,
                //فشل
                if (widget.data.opinionStatus == '2')
                widget.data.opinionOrderType == '1'?Image.asset(
              'assets/icons/failed_with_sell.png',
                ):Image.asset(
                  'assets/icons/wrong.png',
                ),

                //انتظار
                if (widget.data.opinionStatus == '3')
                  Image.asset(
                    'assets/icons/pending_icon.png',

                  ),

                const SizedBox(
                  width: 5,
                ),
                Text(
                  '${statusText(text: widget.data.opinionStatusText!)}',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        )),
      ],
    );
  }

  Widget bigImagesPart() {
    return Column(
      children: [
        const SizedBox(
          height: 15,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            GestureDetector(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => NetworkPictureViewer(
                        imagePath: widget.data.opinionImages![0]),
                  ));
                },
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.network(
                      widget.data.opinionImages![0],
                      width: widget.data.opinionImages!.length >= 2
                          ? SizeUtility(context).width * .40
                          : SizeUtility(context).width * .85,
                      height: 200,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          const SizedBox(),
                    ))),
            if (widget.data.opinionImages!.length >= 2)
              GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => NetworkPictureViewer(
                          imagePath: widget.data.opinionImages![1]),
                    ));
                  },
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.network(
                        widget.data.opinionImages![1],
                        width: SizeUtility(context).width * .40,
                        height: 200,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            const SizedBox(),
                      )))
          ],
        )
      ],
    );
  }

  Widget lastPartOfHomeItem() => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: const Color(0xfff9f9f9),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            child: Wrap(
              direction: Axis.horizontal,
              children: [
                Text(
                  AppLocalizations.of(context)!.usingAppAcceptance,
                  maxLines: null,
                  style: Styles.textStyle12Medium.copyWith(
                    color: HexColor('#EA3F3F'),
                  ),
                ),
                GestureDetector(
                  onTap: /*widget.disclaimerOnTap*/(){
                    disclaimerOnTap(context);
                  },
                  child: Text(
                    AppLocalizations.of(context)!.seeItHere,
                    style: Styles.textStyle12Medium.copyWith(
                        fontFamily: globalFontFamily,
                        color: HexColor('#EA3F3F'),
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline),
                  ),
                ),
              ],
            ),
          ),
        ),
      );

  String statusText({required String text}) {
    if (text.contains('ناجح')) {
      return AppLocalizations.of(context)!.success;
    } else if (text.contains('فشل')) {
      return AppLocalizations.of(context)!.failed;
    } else {
      return AppLocalizations.of(context)!.pending;
    }
  }

  String buyText({required String text}) {
    if (text.contains('شراء')) {
      return AppLocalizations.of(context)!.buy;

    } else {
      return AppLocalizations.of(context)!.sell;

    }
  }

  int calculateNumberOfLines(
      {required double screenWidth,
      required String text,
      required TextStyle textStyle}) {
    final textSpan = TextSpan(text: text, style: textStyle);
    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
      maxLines: 1000, // Set a high number to avoid text overflow
    );

    textPainter.layout(maxWidth: screenWidth);

    // Calculate the number of lines based on the textPainter's size and the screen width
    final numberOfLines =
        (textPainter.height / textPainter.preferredLineHeight).ceil();

    return numberOfLines;
  }
}

Future<void> disclaimerOnTap(
  context,
) async {
  var data= await   Provider.of<ServiceProvider>(context, listen: false)
      .getContent2(key: 'disclaimer');


  if(data['data'].isNotEmpty!=null&&data['data'].isNotEmpty)
  {
    showCustomDialog(
      context: context,
      title:
      AppLocalizations.of(context)!.bayanE5la2,
      body:
      data['data'],
      isHtml: true
    );
  }
}
