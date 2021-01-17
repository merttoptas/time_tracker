import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker/app/utils/constants.dart';
import 'package:time_tracker/common_widget/platform_alert_dialog.dart';
import 'package:time_tracker/common_widget/platform_exception_alert_dialog.dart';
import 'package:time_tracker/common_widget/text_field_container.dart';
import 'package:time_tracker/services/database.dart';

import 'models/Job.dart';

class EditJobPage extends StatefulWidget {
  const EditJobPage({Key, key, @required this.database, this.job})
      : super(key: key);
  final Database database;
  final Job job;

  static Future<void> show(BuildContext context, {Job job}) async {
    final database = Provider.of<Database>(context);
    await Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => EditJobPage(
        database: database,
        job: job,
      ),
      fullscreenDialog: true,
    ));
  }

  @override
  _EditJobPageState createState() => _EditJobPageState();
}

final _formKey = GlobalKey<FormState>();
String _name;
int _ratePerHour;

class _EditJobPageState extends State<EditJobPage> {
  bool _validateAndSaveForm() {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  @override
  void initState() {
    super.initState();
    if (widget.job != null) {
      _name = widget.job.name;
      _ratePerHour = widget.job.ratePerHour;
    }
  }

  Future<void> _submit() async {
    if (_validateAndSaveForm()) {
      try {
        final jobs = await widget.database.jobsStream().first;
        final allNames = jobs.map((job) => job.name).toList();
        if(widget.job != null) {
          allNames.remove(widget.job.name);
        }
        if (allNames.contains(_name)) {
          PlatformAlertDialog(
            title: 'Name already used',
            content: 'Please choose a different job name',
            defaultActionText: 'Ok',
          ).show(context);

        } else {
          final id = widget.job?.id ?? documentIdFromCurrentDate();
          final job = Job(id: id, name: _name, ratePerHour: _ratePerHour);
          await widget.database.setJob(job);
          Navigator.of(context).pop();
        }
      } on PlatformException catch (e) {
        PlatformExceptionAlertDialog(
          title: 'Save in failed',
          exception: e,
        ).show(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 2.0,
        title: Text(widget.job == null ? 'New Job' : 'Edit Job'),
        actions: [
          FlatButton(
              onPressed: _submit,
              child: Text(
                'Save',
                style: TextStyle(fontSize: 18, color: Colors.white),
              ))
        ],
      ),
      body: _buildContents(),
      backgroundColor: Colors.grey[100],
    );
  }

  Widget _buildContents() {
    Size size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              "images/icons/form_add.svg",
              height: size.height * 0.20,
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(29),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: _buildForm(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildForm() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: _buildFormChildren(),
      ),
    );
  }

  List<Widget> _buildFormChildren() {
    return [
      TextFieldContainer(
        child: TextFormField(
          initialValue: _name,
          decoration: InputDecoration(
            icon: Icon(
              Icons.work,
              color: kPrimaryColor,
            ),
            labelText: 'Job Name',
            border: InputBorder.none,
          ),
          onSaved: (value) => _name = value,
          validator: (value) => value.isNotEmpty ? null : 'Name cant be empty',
        ),
      ),
      TextFieldContainer(
        child: TextFormField(
          initialValue: _ratePerHour != null ? '$_ratePerHour' : '',
          decoration: InputDecoration(
            icon: Icon(
              Icons.hourglass_bottom,
              color: kPrimaryColor,
            ),
            labelText: 'Rate Per Hour',
            border: InputBorder.none,
          ),
          onSaved: (value) => _ratePerHour = int.tryParse(value) ?? 0,
          validator: (value) => value.isNotEmpty ? null : 'Hour cant be empty',
          keyboardType:
              TextInputType.numberWithOptions(signed: false, decimal: false),
        ),
      )
    ];
  }
}
