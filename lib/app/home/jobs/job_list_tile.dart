import 'package:flutter/material.dart';
import 'package:time_tracker/app/home/jobs/models/Job.dart';
import 'package:time_tracker/app/utils/constants.dart';

class JobListTile extends StatelessWidget {
  final Job job;
  final VoidCallback onTap;

  const JobListTile({Key key, @required this.job, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        trailing: Icon(Icons.chevron_right,color: kPrimaryColor,),
        title: Text(job.name),
        onTap: onTap,
      ),
    );
  }
}
