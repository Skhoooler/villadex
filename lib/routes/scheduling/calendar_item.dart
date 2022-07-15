import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:villadex/Style/colors.dart';
import 'package:villadex/routes/properties/forms/date_time_selector.dart';

import '../../Style/text_styles.dart';
import '../../model/event_model.dart';
import '../../util/notification_service.dart';

class CalendarListItem extends StatefulWidget {
  final Event event;

  const CalendarListItem({required this.event, Key? key}) : super(key: key);

  @override
  State<CalendarListItem> createState() => _CalendarListItemState();
}

class _CalendarListItemState extends State<CalendarListItem> {
  DateTime notificationDateTime = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showDialog(
            context: context,
            builder: (context) {
              return eventOptions();
            });
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Material(
          elevation: 20,
          borderRadius: const BorderRadius.all(
            Radius.circular(20),
          ),
          child: Container(
            width: double.infinity,
            height: MediaQuery.of(context).size.width * .25,
            decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(
                  Radius.circular(20),
                ),
                color: VilladexColors().background2),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// Title
                      Expanded(
                        child: Center(
                          child: Text(
                            widget.event.name,
                            style:
                                VilladexTextStyles().getQuaternaryTextStyle(),
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
                                .add_jm()
                                .format(widget.event.date),
                            style:
                                VilladexTextStyles().getQuaternaryTextStyle(),
                            overflow: TextOverflow.fade,
                            maxLines: 1,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(4),
                  child: Text(
                    widget.event.description ?? "",
                    style: VilladexTextStyles()
                        .getQuaternaryTextStyle()
                        .copyWith(fontSize: 20),
                    maxLines: 3,
                    overflow: TextOverflow.fade,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  SimpleDialog eventOptions() {
    return SimpleDialog(
      children: [
        Center(
          /// Name
          child: Text(
            widget.event.name,
            style: VilladexTextStyles().getTertiaryTextStyle(),
            maxLines: 2,
            overflow: TextOverflow.fade,
            softWrap: false,
          ),
        ),

        /// Date/Time/Location
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6),
          child: Text(
            DateFormat.yMMMMd('en_US').add_jm().format(widget.event.date),
            style: VilladexTextStyles().getQuaternaryTextStyle(),
            overflow: TextOverflow.fade,
            maxLines: 2,
            softWrap: true,
          ),
        ),

        if (!(widget.event.address?.isEmpty() ?? false))
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${widget.event.address?.street1} ${widget.event.address?.street2}",
                  style: VilladexTextStyles().getQuaternaryTextStyle(),
                  overflow: TextOverflow.fade,
                  maxLines: 2,
                  softWrap: true,
                ),
                Text(
                  "${widget.event.address?.city}, ${widget.event.address?.state} ${widget.event.address?.zip}",
                  style: VilladexTextStyles().getQuaternaryTextStyle(),
                  overflow: TextOverflow.fade,
                  maxLines: 2,
                  softWrap: true,
                ),
                Text(
                  "${widget.event.address?.country}",
                  style: VilladexTextStyles().getQuaternaryTextStyle(),
                  overflow: TextOverflow.fade,
                  maxLines: 2,
                  softWrap: true,
                ),
              ],
            ),
          ),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          child: Text(
            widget.event.description ?? "",
            style: VilladexTextStyles()
                .getTertiaryTextStyle()
                .copyWith(fontSize: 16),
            overflow: TextOverflow.fade,
            softWrap: true,
            maxLines: 8,
          ),
        ),

        IconButton(
          onPressed: () {
            setState(() {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return widget.event.notification
                        ? _deleteNotification()
                        : _setNotification();
                  });
            });
          },
          icon: Icon(
            Icons.notifications,
            color: widget.event.notification
                ? VilladexColors().primary
                : VilladexColors().accent,
          ),
        ),
      ],
    );
  }

  SimpleDialog _deleteNotification() {
    return SimpleDialog(
      title: Center(
        child: Column(
          children: [
            Text(
              "Set Notification",
              style: VilladexTextStyles().getSecondaryTextStyle(),
            ),
            Text(
              widget.event.name,
              style: VilladexTextStyles().getTertiaryTextStyle(),
              overflow: TextOverflow.fade,
              softWrap: true,
              maxLines: 2,
            ),
          ],
        ),
      ),
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: ElevatedButton(
            onPressed: () {
              //todo: Delete Notification here
              setState(() {
                widget.event.notification = false;
              });
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: Text(
              "Delete Notification",
              style: VilladexTextStyles().getTertiaryTextStyleWhite(),
            ),
          ),
        ),
      ],
    );
  }

  SimpleDialog _setNotification() {
    NotificationService notificationService = NotificationService();
    return SimpleDialog(
      title: Center(
        child: Column(
          children: [
            Text(
              "Set Notification",
              style: VilladexTextStyles().getSecondaryTextStyle(),
            ),
            Text(
              widget.event.name,
              style: VilladexTextStyles().getTertiaryTextStyle(),
              overflow: TextOverflow.fade,
              softWrap: true,
              maxLines: 2,
            ),
          ],
        ),
      ),
      children: [
        Center(child: DateTimeSelector(callback: _setDateTime)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: ElevatedButton(
            onPressed: () {
              //todo: Set Notification here
              setState(() {
                notificationService.scheduleNotification(
                    widget.event, notificationDateTime);
                widget.event.notification = true;
              });
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: Text(
              "Continue",
              style: VilladexTextStyles().getTertiaryTextStyleWhite(),
            ),
          ),
        ),
      ],
    );
  }

  /// Gets the DateTime from the DateSelector child widget
  _setDateTime(DateTime dateSelected) {
    setState(() {
      notificationDateTime = dateSelected;
    });
  }
}
