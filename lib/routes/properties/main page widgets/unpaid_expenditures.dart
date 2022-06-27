import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:villadex/model/expenditure_model.dart';
import 'package:villadex/style/colors.dart';
import 'package:villadex/style/text_styles.dart';

import '../../../model/category_model.dart';
import '../../../model/property_model.dart';

//////////////////////////////////////////////////////////////
/// Displays the expenditures that are marked as unpaid
//////////////////////////////////////////////////////////////
class UnpaidExpenditures extends StatefulWidget {
  final Property property;

  const UnpaidExpenditures({
    required this.property,
    Key? key,
  }) : super(key: key);

  @override
  State<UnpaidExpenditures> createState() => _UnpaidExpendituresState();
}

class _UnpaidExpendituresState extends State<UnpaidExpenditures> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Material(
        elevation: 20,
        borderRadius: const BorderRadius.all(Radius.circular(20)),
        child: Container(
          height: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            color: VilladexColors().background2,
            borderRadius: const BorderRadius.all(Radius.circular(20)),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              /// Title
              Center(
                child: Text(
                  "Unpaid",
                  style: VilladexTextStyles().getTertiaryTextStyle(),
                ),
              ),

              /// Body
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    color: VilladexColors().background2,
                    child: FutureBuilder<List<Expenditure?>?>(
                      future: Expenditure.fetchUnpaid(widget.property.key),
                      builder: (context, snapshot) {
                        List<_UnpaidListItem> data = [];

                        if (snapshot.hasData) {
                          data = snapshot.data?.map((debt) {
                            return _UnpaidListItem(
                                expenditure: debt ??
                                    Expenditure(
                                        name: "Error: Not Found",
                                        expenditureDate: DateTime.now(),
                                        category: Category(name: ""),
                                        amount: 0,
                                        numUnits: 0,
                                        propertyKey: widget.property.key));
                          }).toList() ??
                              [];
                        }

                        return ListView.builder(
                            shrinkWrap: true,
                            itemCount: data.length,
                            itemBuilder: (BuildContext context, int index) {
                              data.sort((a, b) {
                                return a.expenditure.expenditureDate
                                    .compareTo(b.expenditure.expenditureDate);
                              });
                              return data[index];
                            });
                      },
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class _UnpaidListItem extends StatefulWidget {
  final Expenditure expenditure;

  const _UnpaidListItem({required this.expenditure, Key? key})
      : super(key: key);

  @override
  State<_UnpaidListItem> createState() => _UnpaidListItemState();
}

class _UnpaidListItemState extends State<_UnpaidListItem> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Material(
        elevation: 10,
        borderRadius: const BorderRadius.all(Radius.circular(20)),
        child: GestureDetector(
          onTap: () {
            showDialog(
                context: context,
                builder: (context) {
                  return SimpleDialog(
                    children: [
                      /// Title
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        child: Text(
                          widget.expenditure.name,
                          style: VilladexTextStyles().getTertiaryTextStyle(),
                          maxLines: 2,
                          overflow: TextOverflow.fade,
                          softWrap: false,
                        ),
                      ),

                      /// Date
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        child: Text(
                          DateFormat.yMMMMd('en_US')
                              .format(widget.expenditure.expenditureDate),
                          style: VilladexTextStyles().getQuaternaryTextStyle(),
                          maxLines: 1,
                          overflow: TextOverflow.fade,
                          softWrap: false,
                        ),
                      ),

                      /// Description
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        child: Text(
                          widget.expenditure.description ?? "",
                          style: VilladexTextStyles()
                              .getQuaternaryTextStyle()
                              .copyWith(fontSize: 20),
                          maxLines: 5,
                          overflow: TextOverflow.fade,
                          //softWrap: false,
                        ),
                      ),

                      /// Amount, num units
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          child: Text(
                            '${widget.expenditure.numUnits} units at \$${widget.expenditure.amount.toStringAsFixed(2)} each',
                            style: VilladexTextStyles()
                                .getQuaternaryTextStyle()
                                .copyWith(
                                color: VilladexColors().accent,
                                fontSize: 20),
                          ),
                        ),
                      ),

                      /// Total amount
                      widget.expenditure.isPaid
                          ?
                      // It is paid
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          child: Text(
                            "Paid (Total: ${widget.expenditure.total})",
                            style: VilladexTextStyles()
                                .getQuaternaryTextStyle()
                                .copyWith(
                                color: VilladexColors().primary,
                                fontSize: 20),
                          ),
                        ),
                      )
                          :
                      // It is not paid
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          child: Text(
                            '\$${widget.expenditure.total} Total',
                            style: VilladexTextStyles()
                                .getQuaternaryTextStyle()
                                .copyWith(
                                color: VilladexColors().error,
                                fontSize: 20),
                          ),
                        ),
                      ),

                      /// Paid Button
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 6,
                        ),
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width * .01,
                          child: ElevatedButton(
                            onPressed: () {
                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    return SimpleDialog(
                                      title: const Center(
                                        child: Text("Really Mark as Paid?"),
                                      ),
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 12,
                                            vertical: 6,
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                            crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                            children: [
                                              /// No
                                              Container(
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                    .3,
                                                height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                    .05,
                                                color: VilladexColors()
                                                    .background2,
                                                child: SimpleDialogOption(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                    horizontal: 12,
                                                    vertical: 6,
                                                  ),
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                  },
                                                  child: const Center(
                                                    child: Text("No"),
                                                  ),
                                                ),
                                              ),

                                              /// Yes
                                              Container(
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                    .3,
                                                height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                    .05,
                                                color: VilladexColors().primary,
                                                child: SimpleDialogOption(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                    horizontal: 12,
                                                    vertical: 6,
                                                  ),
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                    Navigator.pop(context);

                                                    setState(() {
                                                      widget.expenditure
                                                          .isPaid = true;

                                                      widget.expenditure
                                                          .update();
                                                    });
                                                  },
                                                  child: const Center(
                                                    child: Text("Yes"),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    );
                                  });
                            },
                            child: Text(
                              "Mark as Paid",
                              style: VilladexTextStyles()
                                  .getTertiaryTextStyleWhite(),
                            ),
                          ),
                        ),
                      )
                    ],
                  );
                });
          },
          child: Container(
            height: 100,
            decoration: BoxDecoration(
              color: VilladexColors().background,
              borderRadius: const BorderRadius.all(Radius.circular(20)),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 8),

                /// Title and Date
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    /// Title
                    Expanded(
                      child: Center(
                        child: Text(
                          widget.expenditure.name,
                          style: VilladexTextStyles().getQuaternaryTextStyle(),
                          overflow: TextOverflow.fade,
                          maxLines: 1,
                          softWrap: false,
                        ),
                      ),
                    ),

                    /// Date
                    Expanded(
                      child: Center(
                        child: Text(
                          DateFormat.yMMMMd('en_US')
                              .format(widget.expenditure.expenditureDate),
                          style: VilladexTextStyles().getQuaternaryTextStyle(),
                          overflow: TextOverflow.fade,
                          maxLines: 1,
                        ),
                      ),
                    ),
                  ],
                ),

                /// Description
                Text(
                  widget.expenditure.description ?? "",
                  style: VilladexTextStyles().getQuaternaryTextStyle(),
                  overflow: TextOverflow.fade,
                  maxLines: 3,
                ),

                /// Amount owed
                widget.expenditure.isPaid
                    ?
                // It is paid
                Text(
                  "Paid",
                  style: VilladexTextStyles()
                      .getQuaternaryTextStyle()
                      .copyWith(color: VilladexColors().primary),
                )
                    :
                // It is not paid
                Text(
                  '\$${widget.expenditure.total}',
                  style: VilladexTextStyles()
                      .getQuaternaryTextStyle()
                      .copyWith(color: VilladexColors().error),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
