import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:nosooh/utils/colors.dart';
import 'package:nosooh/utils/constants.dart';

import '../utils/styles.dart';



class AnalystContainer2 extends StatelessWidget {
  final String companyId;
  final String companyName;
  final String successRate;
  final String buyingOpinions;
  final String sellingOpinions;
  final bool followed;
  final String image;
  final Function() onTap;
  final Function() subscribeOnTap;

  const AnalystContainer2(
      {super.key,
      required this.followed,
      required this.companyId,
      required this.companyName,
      required this.successRate,
      required this.buyingOpinions,
      required this.sellingOpinions,
      required this.image,
      required this.onTap,
      required this.subscribeOnTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15),
      child: Container(
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                blurRadius: 2,
                offset: const Offset(0, 1),
              ),
            ],
            borderRadius: BorderRadius.circular(20)),
        child: Column(
          children: [
            GestureDetector(
              onTap: onTap,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                color: const Color.fromRGBO(209, 209, 209, 0.1),
                child: Row(
                  children: [
                    ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child: Image.network(
                          image,
                          width: 40,
                          errorBuilder: (context, error, stackTrace) =>
                              Image.asset('assets/images/user.png', width: 40),
                        )),
                    const SizedBox(
                      width: 20,
                    ),
                    Text(
                      companyName,
                      style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w400,
                          color: kMainColor),
                    ),
                    const Spacer(),
                    const Icon(
                      Icons.arrow_forward_ios,
                      color: iconColor,
                      size: 17,
                    )
                  ],
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox(
                  width: 5,
                ),
                Column(
                  children: [
                    Text(
                      AppLocalizations.of(context)!.sellOpinions,
                      style: const TextStyle(
                        color: Color.fromRGBO(152, 152, 152, 1),
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Text(
                      sellingOpinions,
                      style: const TextStyle(
                          color: Color.fromRGBO(48, 92, 213, 1)),
                    )
                  ],
                ),
                Column(
                  children: [
                    Text(
                      AppLocalizations.of(context)!.buyOpinions,
                      style: const TextStyle(
                        color: kSecondColor,
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Text(
                      buyingOpinions,
                      style: const TextStyle(
                          color: Color.fromRGBO(255, 179, 0, 1)),
                    )
                  ],
                ),
                Column(
                  children: [
                    Text(
                      AppLocalizations.of(context)!.successRate,
                      style: TextStyle(
                        color: HexColor('#989898'),
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Text(
                      '${num.parse(successRate).toStringAsFixed(2)}%',
                      style: const TextStyle(
                          color: Color.fromRGBO(49, 213, 200, 1)),
                    )
                  ],
                ),
                followed
                    ? GestureDetector(
                        onTap: onTap,
                        child: Container(
                          constraints: const BoxConstraints(
                            minWidth: 100,
                          ),
                          padding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 15),
                          decoration: BoxDecoration(
                              color: HexColor('#31D5C8'),
                              borderRadius:
                                  AppLocalizations.of(context)!.localeName ==
                                          'ar'
                                      ? const BorderRadius.only(
                                          bottomLeft: Radius.circular(20))
                                      : const BorderRadius.only(
                                          bottomRight: Radius.circular(20))),
                          child: Column(
                            children: [
                              Text(
                                AppLocalizations.of(context)!.subscribed,
                                style: const TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              const ImageIcon(
                                AssetImage('assets/icons/follow.png'),
                                color: Colors.white,
                              )
                            ],
                          ),
                        ),
                      )
                    : GestureDetector(
                        onTap: subscribeOnTap,
                        child: Container(
                          constraints: const BoxConstraints(
                            minWidth: 100,
                          ),
                          padding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 15),
                          decoration: BoxDecoration(
                              color: HexColor('#e8f9f7'),
                              borderRadius:
                                  AppLocalizations.of(context)!.localeName ==
                                          'ar'
                                      ? const BorderRadius.only(
                                          bottomLeft: Radius.circular(20))
                                      : const BorderRadius.only(
                                          bottomRight: Radius.circular(20))),
                          child: Column(
                            children: [
                              Text(
                                AppLocalizations.of(context)!.subscribe,
                                style: TextStyle(
                                  color: HexColor('#31D5C8'),
                                ),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              ImageIcon(
                                AssetImage('assets/icons/follow.png'),
                                color: HexColor('#31d5c8'),
                              )
                            ],
                          ),
                        ),
                      )
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class AnalystListContainer2 extends StatelessWidget {
  final bool followed;
  final String image;
  final String bio;
  final String name;
  final num stockNumber;
  final int index;
  final Function() onTap;
  final Function() subscribeOnTap;

  const AnalystListContainer2(
      {super.key,
      required this.followed,
      required this.image,
      required this.index,
      required this.onTap,
      required this.bio,
      required this.name,
      required this.stockNumber,
      required this.subscribeOnTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Column(
        children: [
          GestureDetector(
            onTap: onTap,

            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              color: const Color(0xfffdfdfd),
              child: Row(
                children: [
                  ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: Image.network(
                        image,
                        width: 40,
                        errorBuilder: (context, error, stackTrace) =>
                            Image.asset('assets/images/user.png', width: 40),
                      )),
                  const SizedBox(
                    width: 20,
                  ),
                  Text(
                    name,
                    style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w400,
                        color: kMainColor),
                  ),
                  const Spacer(),
                  Row(
                    children: [
                      Text(
                        '${AppLocalizations.of(context)!.stocksNumber}:  ',
                        style: Styles.textStyle12Regular.copyWith(
                          color: HexColor('#989898'),
                          fontFamily: globalFontFamily
                        ),
                      ),
                      Text(
                        '$stockNumber',
                        style: Styles.textStyle12Medium.copyWith(
                          fontWeight: FontWeight.bold,
                          color: HexColor('#31D5C8'),
                            fontFamily: globalFontFamily

                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  const Icon(
                    Icons.arrow_forward_ios,
                    color: iconColor,
                    size: 17,
                  )
                ],
              ),
            ),
          ),
          Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: Text(
                    bio,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Styles.textStyle12Regular.copyWith(
                      color: HexColor('#8D8D8D'),
                        fontFamily: globalFontFamily

                    ),
                  ),
                ),
              ),
              followed
                  ? GestureDetector(
                      onTap: onTap,
                      child: Container(
                        constraints: const BoxConstraints(
                          minWidth: 90,
                        ),
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 15),
                        decoration: BoxDecoration(
                            color: HexColor('#31D5C8'),
                            borderRadius:
                                AppLocalizations.of(context)!.localeName ==
                                        'ar'
                                    ? const BorderRadius.only(
                                        bottomLeft: Radius.circular(20))
                                    : const BorderRadius.only(
                                        bottomRight: Radius.circular(20))),
                        child: Column(
                          children: [
                            Text(
                              AppLocalizations.of(context)!.subscribed,
                              style: const TextStyle(
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            const ImageIcon(
                              AssetImage('assets/icons/follow.png'),
                              color: Colors.white,
                            )
                          ],
                        ),
                      ),
                    )
                  : GestureDetector(
                      onTap: subscribeOnTap,
                      child: Container(
                        constraints: const BoxConstraints(
                          minWidth: 90,
                        ),
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 15),
                        decoration: BoxDecoration(
                            color: HexColor('#e8f9f7'),
                            borderRadius:
                                AppLocalizations.of(context)!.localeName ==
                                        'ar'
                                    ? const BorderRadius.only(
                                        bottomLeft: Radius.circular(20))
                                    : const BorderRadius.only(
                                        bottomRight: Radius.circular(20))),
                        child: Column(
                          children: [
                            Text(
                              AppLocalizations.of(context)!.subscribe,
                              style: const TextStyle(
                                color:kMainColor2
                                //Color.fromRGBO(111, 107, 178, 1),
                              ),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            ImageIcon(
                              AssetImage('assets/icons/follow.png'),
                              color: HexColor('#31d5c8'),
                            )
                          ],
                        ),
                      ),
                    )
            ],
          ),
        ],
      ),
    );
  }
}
