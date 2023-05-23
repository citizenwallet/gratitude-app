import 'package:citizenwallet/state/vouchers/state.dart';
import 'package:citizenwallet/widgets/activity/card.dart';
import 'package:flutter/cupertino.dart';

class ActivityList extends StatelessWidget {
  final List<Activity> activities;
  final Function(String address) onPressed;

  const ActivityList({
    Key? key,
    required this.activities,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        childCount: activities.length,
        (context, index) {
          final activity = activities[index];

          return ActivityCard(
            key: Key(activity.address),
            title: activity.title,
            description: activity.description,
            icon: activity.icon,
            onPressed: onPressed,
          );
        },
      ),
    );
  }
}
