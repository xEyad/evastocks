import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:nosooh/components/show_dialog_widget.dart';

import '../models/ratings_model/rating_model.dart';
import '../utils/colors.dart';
import '../utils/styles.dart';

class BuildAnalystProfileStocksItem extends StatefulWidget {
  final RatingModel? ratingData;
  final int index;

  const BuildAnalystProfileStocksItem(
      {super.key, required this.ratingData, required this.index});

  @override
  State<BuildAnalystProfileStocksItem> createState() =>
      _BuildAnalystProfileStocksItemState();
}

class _BuildAnalystProfileStocksItemState
    extends State<BuildAnalystProfileStocksItem> {
  bool showMore = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        color: HexColor('#FDFDFD'),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: GestureDetector(
            onTap: () {
              setState(() {
                showMore = !showMore;
              });
            },
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
                    if (showMore)
                      const SizedBox(
                        height: 10,
                      ),
                    if (showMore) secondPart(),
                    if (showMore)
                      const SizedBox(
                        height: 25,
                      ),
                    if (showMore) thirdPart(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget firstPart() {
    print(widget.ratingData!.data![widget.index].image);
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CircleAvatar(
          radius: 30,
          backgroundColor: HexColor('#D9D9D9'),
          backgroundImage: widget.ratingData!.data![widget.index].image != null
              ? NetworkImage(widget.ratingData!.data![widget.index].image ?? '')
              : null,
          child: (widget.ratingData!.data![widget.index].image == null ||
                  widget.ratingData!.data![widget.index].image
                      .toString()
                      .isEmpty)
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
          width: 20,
        ),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 8,
                  ),
                  Text(
                    widget.ratingData!.data![widget.index].stockName ?? '',
                    style: Styles.textStyle14Medium
                        .copyWith(color: HexColor('#212121')),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Expanded(
                    child: Text(
                      widget.ratingData!.data![widget.index].createdAt ?? '',
                      style: Styles.textStyle12Medium.copyWith(
                          color: HexColor('#212121').withOpacity(0.5)),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
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
                          widget.ratingData!.data![widget.index].stockSymbol ??
                              '',
                          style: Styles.textStyle14Bold.copyWith(
                            color: HexColor('#212121'),
                          ),
                        ),
                      ],
                    ),
                  ),
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
                          widget.ratingData!.data![widget.index].entryPrice
                                  .toString() ??
                              '',
                          style: Styles.textStyle14Bold.copyWith(
                            color: HexColor('#212121'),
                          ),
                        ),
                      ],
                    ),
                  ),
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
                          '${widget.ratingData!.data![widget.index].buyPercent.toString()} %' ??
                              '',
                          style: Styles.textStyle14Bold.copyWith(
                            color: HexColor('#212121'),
                          ),
                        ),
                      ],
                    ),
                  ),
                  showMore
                      ? GestureDetector(
                          child: const ImageIcon(
                              AssetImage('assets/icons/arrow_up.png')))
                      : GestureDetector(
                          onTap: () {
                            setState(() {
                              showMore = !showMore;
                            });
                          },
                          child: const ImageIcon(
                              AssetImage('assets/icons/arrow_down.png')),
                        ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget secondPart() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                AppLocalizations.of(context)!.todayPrice,
                style: Styles.textStyle12Medium.copyWith(
                  color: HexColor('#A0A0A0'),
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              Text(
                widget.ratingData!.data![widget.index].todayPrice.toString() ??
                    '',
                style: Styles.textStyle14Bold.copyWith(
                  color: HexColor('#212121'),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                AppLocalizations.of(context)!.changePercentage,
                style: Styles.textStyle12Medium.copyWith(
                  color: HexColor('#A0A0A0'),
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              Text(
                '${widget.ratingData!.data![widget.index].priceChange.toString()} %' ??
                    '',
                style: Styles.textStyle14Bold.copyWith(
                  color: HexColor('#212121'),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                AppLocalizations.of(context)!.marketCap,
                style: Styles.textStyle12Medium.copyWith(
                  color: HexColor('#A0A0A0'),
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              Text(
                widget.ratingData!.data![widget.index].marketCap ?? '',
                style: Styles.textStyle14Bold.copyWith(
                  color: HexColor('#212121'),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                AppLocalizations.of(context)!.sharia,
                style: Styles.textStyle12Medium.copyWith(
                  color: HexColor('#A0A0A0'),
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              widget.ratingData!.data![widget.index].shariahCompliance
                      .toString()
                      .contains('1')
                  ? Image.asset('assets/icons/correct_icon.png')
                  : Image.asset('assets/icons/wrong_icon.png'),
            ],
          ),
        ),
        const Opacity(
            opacity: 0,
            child: ImageIcon(AssetImage('assets/icons/arrow_down.png')))
      ],
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
                widget.ratingData!.data![widget.index].extraInfo ?? '',
                maxLines: 3,
                style: Styles.textStyle14Medium.copyWith(
                  color: dragImageColor,
                ),
              ),
              if (calculateNumberOfLines(
                        screenWidth: maxWid,
                        text:
                            widget.ratingData!.data![widget.index].extraInfo ??
                                '',
                        textStyle: Styles.textStyle14Medium.copyWith(
                          color: dragImageColor,
                        ),
                      ) >
                      3 ||
                  widget.ratingData!.data![widget.index].images!.isNotEmpty)
                TextButton(
                  onPressed: () {
                    showCustomDialog(
                      context: context,
                      title: AppLocalizations.of(context)!.moreInformation,
                      body: widget.ratingData!.data![widget.index].extraInfo ??
                          '',
                      images: widget.ratingData!.data![widget.index].images,
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
