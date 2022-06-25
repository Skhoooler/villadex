import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:villadex/model/expenditure_model.dart';
import 'package:villadex/style/colors.dart';
import 'package:villadex/style/text_styles.dart';

import '../../model/property_model.dart';
import '../../model/category_model.dart';

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
                Text(
                  widget.expenditure.description ?? "",
                  style: VilladexTextStyles().getQuaternaryTextStyle(),
                  overflow: TextOverflow.fade,
                  maxLines: 3,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

//////////////////////////////////////////////////////////////
/// Displays the net and gross profits of the property
//////////////////////////////////////////////////////////////
class Profits extends StatefulWidget {
  final Property property;

  const Profits({
    required this.property,
    Key? key,
  }) : super(key: key);

  @override
  State<Profits> createState() => _ProfitState();
}

class _ProfitState extends State<Profits> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Material(
        elevation: 20,
        borderRadius: const BorderRadius.all(Radius.circular(20)),
        child: Container(
          height: 150,
          decoration: BoxDecoration(
            color: VilladexColors().background2,
            borderRadius: const BorderRadius.all(Radius.circular(20)),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(
                child: Text(
                  "Profits",
                  style: VilladexTextStyles().getTertiaryTextStyle(),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

//////////////////////////////////////////////////////////////
///
//////////////////////////////////////////////////////////////
class MainExpenditures extends StatefulWidget {
  final Property property;

  const MainExpenditures({required this.property, Key? key}) : super(key: key);

  @override
  State<MainExpenditures> createState() => _MainExpendituresState();
}

class _MainExpendituresState extends State<MainExpenditures> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Material(
        elevation: 20,
        borderRadius: const BorderRadius.all(Radius.circular(20)),
        child: Container(
          height: 150,
          decoration: BoxDecoration(
            color: VilladexColors().background2,
            borderRadius: const BorderRadius.all(Radius.circular(20)),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(
                child: Text(
                  "Main Expenses",
                  style: VilladexTextStyles().getTertiaryTextStyle(),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
