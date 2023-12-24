import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:nosooh/components/show_dialog_widget.dart';

import '../models/ratings_logs_model/rating_logs_model.dart';
import '../utils/colors.dart';
import '../utils/styles.dart';

class BuildAnalystProfileRatingListItem extends StatefulWidget {
  final int index;
  final RatingLogsModel logsData;
  const BuildAnalystProfileRatingListItem(
      {super.key, required this.index, required this.logsData});

  @override
  State<BuildAnalystProfileRatingListItem> createState() =>
      _BuildAnalystProfileRatingListItemState();
}

class _BuildAnalystProfileRatingListItemState
    extends State<BuildAnalystProfileRatingListItem> {
  bool showMore = false;
  Color buttonColor = Colors.white;
  Color textColor = Colors.white;

  @override
  Widget build(BuildContext context) {
    print(widget.logsData.data[widget.index].type.toString());
    if (widget.logsData.data[widget.index].type.toString().contains('BUY')||widget.logsData.data[widget.index].type.toString().contains('شراء')) {
      buttonColor = HexColor('#e8f9f7'); //FFD1D1
      textColor = HexColor('#31d5c8'); //FFB300
    }  else if (widget.logsData.data[widget.index].type
        .toString()
        .contains('SELL')||widget.logsData.data[widget.index].type
        .toString()
        .contains('بيع')) {
      buttonColor = HexColor('#ffd1d1'); //FFB30033
      textColor = HexColor('#c95858');
    }
    else if (widget.logsData.data[widget.index].type
        .toString()
        .contains('EDIT')) {
      buttonColor = HexColor('#fdeeca');
      textColor = HexColor('#ffb300');
    }else{
      buttonColor = HexColor('#d4ddf6'); //FFD1D1
      textColor = HexColor('#305cd5'); //FFB300
    }
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        color: HexColor('#FDFDFD'),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 6,horizontal: 18.0),
          child: Container(
            //height: 80,
            width: double.infinity,
            decoration: BoxDecoration(

              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: HexColor('#EDEDED80'),
                width: 0.2,
              ),
              boxShadow: [
                BoxShadow(
                  color: HexColor('#00000029'), // shadow color
                  //spreadRadius: 2, // shadow spread radius
                  blurRadius: 2, // shadow blur radius
                  offset: const Offset(0, 2), // shadow offset
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  firstPart(),
                  const SizedBox(
                    height: 10,
                  ),
                  secondPart(),
                  const SizedBox(
                    height: 25,
                  ),
                  if(widget.logsData.data[widget.index].data.sellReason != null &&
                      widget.logsData.data[widget.index].data.sellReason
                          .toString()
                          .isNotEmpty)

                    sellReason(),

                  if (widget.logsData.data[widget.index].data.extraInfo != null &&
                      widget.logsData.data[widget.index].data.extraInfo
                          .toString()
                          .isNotEmpty)
                    thirdPart(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget firstPart() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.logsData.data[widget.index].stockName ?? "",
                    style: Styles.textStyle14Medium
                        .copyWith(color: HexColor('#212121')),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Directionality(
                    textDirection: TextDirection.ltr,
                    child: Text(
                      '${widget.logsData.data[widget.index].createdAt.toString() ?? ""} ${widget.logsData.data[widget.index].createdTime.toString() ?? ""} ',
                      style: Styles.textStyle14Bold
                          .copyWith(color: HexColor('#212121')),
                    ),
                  ),
                ],
              ),
              const Spacer(),
              Container(
                width: 70,
                height: 40,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(29),
                    color: buttonColor,
                    border: Border.all(
                      color: buttonColor,
                    )),
                child: Center(
                  child: Text(
                    buyText(
                      text: widget.logsData.data[widget.index].type.toString(),
                    ),
                    style: Styles.textStyle13Bold.copyWith(
                      color: textColor,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget secondPart() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                AppLocalizations.of(context)!.stockSymbol,
                style: Styles.textStyle12Medium.copyWith(
                  color: HexColor('#A0A0A0'),
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              Text(
                widget.logsData.data[widget.index].stockSymbol ?? "",
                style: Styles.textStyle14Bold.copyWith(
                  color: HexColor('#212121'),
                ),
              ),
            ],
          ),
        ),
        if(!widget.logsData.data[widget.index].type.contains('DIVIDEND'))
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                AppLocalizations.of(context)!.entryPrice,
                style: Styles.textStyle12Medium.copyWith(
                  color: HexColor('#A0A0A0'),
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              Text(
                widget.logsData.data[widget.index].entryPrice ?? "",
                style: Styles.textStyle14Bold.copyWith(
                  color: HexColor('#212121'),
                ),
              ),
            ],
          ),
        ),
        if (!widget.logsData.data[widget.index].type.contains('DIVIDEND')&&widget.logsData.data[widget.index].data.buyPercent != null &&
            widget.logsData.data[widget.index].data.buyPercent
                .toString()
                .isNotEmpty&& (!widget.logsData.data[widget.index].type.contains('بيع') && !widget.logsData.data[widget.index].type.contains('SELL')))
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  AppLocalizations.of(context)!.entryPercentage,
                  style: Styles.textStyle12Medium.copyWith(
                    color: HexColor('#A0A0A0'),
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                Text(
                  '${
                        widget.logsData.data[widget.index].data.buyPercent
                            .toString()
                      } %' ??
                      "",
                  style: Styles.textStyle14Bold.copyWith(
                    color: HexColor('#212121'),
                  ),
                ),
              ],
            ),
          ),
        if (widget.logsData.data[widget.index].data.exitPrice != null &&
            widget.logsData.data[widget.index].data.exitPrice
                .toString()
                .isNotEmpty)
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  AppLocalizations.of(context)!.exitPrice,
                  style: Styles.textStyle12Medium.copyWith(
                    color: HexColor('#A0A0A0'),
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                Text(
                  widget.logsData.data[widget.index].data.exitPrice
                          .toString() ??
                      "",
                  style: Styles.textStyle14Bold.copyWith(
                    color: HexColor('#212121'),
                  ),
                ),
              ],
            ),
          ),
        if (widget.logsData.data[widget.index].data.sellReason != null &&
            widget.logsData.data[widget.index].data.sellReason
                .toString()
                .isNotEmpty)
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  AppLocalizations.of(context)!.sellStatus,
                  style: Styles.textStyle12Medium.copyWith(
                    color: HexColor('#A0A0A0'),
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                InkWell(
                  onTap: (){
                    /*showCustomDialog(
                      context: context,
                      title:
                      AppLocalizations.of(context)!.sellStatus,
                      body:
                      widget.logsData.data[widget.index].data.sellReason
                          .toString(),
                    );*/
                  },
                  child: Text(
                    (double.tryParse(widget.logsData.data[widget.index].entryPrice)??0) <= (double.tryParse(widget.logsData.data[widget.index].data.exitPrice.toString())??0) ? 'ربح' : "خسارة",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Styles.textStyle14Bold.copyWith(
                      color: (double.tryParse(widget.logsData.data[widget.index].entryPrice)??0) <= (double.tryParse(widget.logsData.data[widget.index].data.exitPrice.toString())??0) ?  kMainColor2 : Colors.red.shade700,
                    ),
                  ),
                ),
              ],
            ),
          ),

        if (widget.logsData.data[widget.index].type.contains('DIVIDEND') &&
            widget.logsData.data[widget.index].data.price!=null)
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  AppLocalizations.of(context)!.entitlementToDividends,
                  style: Styles.textStyle12Medium.copyWith(
                    color: HexColor('#A0A0A0'),
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                InkWell(
                  onTap: (){
                  },
                  child: Text(
                    widget.logsData.data[widget.index].data.price.toString(),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Styles.textStyle14Bold.copyWith(
                      color: HexColor('#212121'),
                    ),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget sellReason() {
    return LayoutBuilder(
      builder: (context, constraints) {
        double maxWid = constraints.maxWidth;
        return Wrap(
            crossAxisAlignment: WrapCrossAlignment
                .center, // Ensure children are centered vertically

            direction: Axis.horizontal,
            children: [
              Text(
                widget.logsData.data[widget.index].data.sellReason ?? "",
                maxLines: 3,
                style: Styles.textStyle14Medium.copyWith(
                  color: dragImageColor,
                ),
              ),
              if (calculateNumberOfLines(
                screenWidth: maxWid,
                text:
                widget.logsData.data[widget.index].data.sellReason ?? "",
                textStyle: Styles.textStyle14Medium.copyWith(
                  color: dragImageColor,
                ),
              ) >
                  3)
                TextButton(
                  onPressed: () {
                    showCustomDialog(
                      context: context,
                      title: AppLocalizations.of(context)!.moreInformation,
                      body: widget.logsData.data[widget.index].data.extraInfo ??
                          "",
                    );
                  },
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
    );
  }

  Widget thirdPart() {
    return LayoutBuilder(
      builder: (context, constraints) {
        double maxWid = constraints.maxWidth;
        return Wrap(
            crossAxisAlignment: WrapCrossAlignment
                .center, // Ensure children are centered vertically

            direction: Axis.horizontal,
            children: [
              Text(
                widget.logsData.data[widget.index].data.extraInfo ?? "",
                maxLines: 3,
                style: Styles.textStyle14Medium.copyWith(
                  color: dragImageColor,
                ),
              ),
              if (calculateNumberOfLines(
                    screenWidth: maxWid,
                    text:
                        widget.logsData.data[widget.index].data.extraInfo ?? "",
                    textStyle: Styles.textStyle14Medium.copyWith(
                      color: dragImageColor,
                    ),
                  ) >
                  3)
                TextButton(
                  onPressed: () {
                    showCustomDialog(
                      context: context,
                      title: AppLocalizations.of(context)!.moreInformation,
                      body: widget.logsData.data[widget.index].data.extraInfo ??
                          "",
                    );
                  },
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
    );
  }

  String buyText({required String text}) {
    if (text.contains('بيع') || text.contains('SELL')) {
      return AppLocalizations.of(context)!.sell;
    } else if (text.contains('تعديل') || text.contains('EDIT')) {
      return AppLocalizations.of(context)!.edit;
    } else if (text.contains('شراء') || text.contains('BUY')) {
      return AppLocalizations.of(context)!.buy;
    }else{
      return AppLocalizations.of(context)!.dividend;

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
