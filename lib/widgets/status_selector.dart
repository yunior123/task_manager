import 'package:flutter/material.dart';
import 'package:task_manager/widgets/small_button.dart';

const statuses = ['New', 'Open', 'On Progress', 'Closed'];

Color _getColorFromStatus(String status) {
  switch (status) {
    case 'New':
      return Colors.green;
    case 'Open':
      return Colors.greenAccent;

    case 'On Progress':
      return Colors.blue;

    case 'Closed':
      return Colors.red;

    default:
      return Colors.red;
  }
}

class StatusButton extends StatefulWidget {
  final String initialStatus;
  final ValueChanged<String> onStatusChanged;
  const StatusButton(
      {Key? key, required this.onStatusChanged, required this.initialStatus})
      : super(key: key);

  @override
  State<StatusButton> createState() => _StatusButtonState();
}

class _StatusButtonState extends State<StatusButton> {
  late String status;
  @override
  void initState() {
    status = widget.initialStatus;
    super.initState();
  }

  void _onSelectorChanged(String? lang) {
    setState(
      () {
        status = lang!;
      },
    );
  }

  Widget _header() {
    return Container(
      margin: const EdgeInsets.all(20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          RichText(
            text: TextSpan(
              text: 'Status',
              style: Theme.of(context).textTheme.headline4!,
            ),
          ),
        ],
      ),
    );
  }

  Widget _statusColumn() {
    return Center(
      child: Container(
        constraints: const BoxConstraints(
          maxWidth: 400,
        ),
        margin: const EdgeInsets.fromLTRB(
          20,
          15,
          20,
          30,
        ),
        child: SingleChildScrollView(
          child: Card(
            margin: const EdgeInsets.fromLTRB(
              2,
              1,
              2,
              20,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(
                30.0,
              ),
            ),
            elevation: 5.0,
            child: Column(
              children: [
                _header(),
                _Status(
                  initialStatus: status,
                  onStatusChanged: (v) {
                    _onSelectorChanged(v);
                    widget.onStatusChanged(v);
                  },
                ),
                const SizedBox(
                  height: 20,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SmallButton(
      key: ValueKey<String>(status),
      text: status,
      color: _getColorFromStatus(
        status,
      ),
      onPressed: () {
        showDialog(
          context: context,
          builder: (context) {
            return _statusColumn();
          },
        );
      },
    );
  }
}

class _Status extends StatefulWidget {
  final ValueChanged<String> onStatusChanged;
  final String initialStatus;
  const _Status(
      {Key? key, required this.onStatusChanged, required this.initialStatus})
      : super(key: key);

  @override
  State<_Status> createState() => _StatusState();
}

class _StatusState extends State<_Status> {
  late String status;
  @override
  void initState() {
    status = widget.initialStatus;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: statuses.map(
        (e) {
          return SizedBox(
            height: 60,
            child: ListTile(
              leading: SizedBox(
                width: 170,
                child: Row(
                  children: [
                    const SizedBox(width: 10.0),
                    Flexible(
                      child: RichText(
                        text: TextSpan(
                          text: e,
                          style: Theme.of(context).textTheme.headline5,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              trailing: Radio<String>(
                value: e,
                groupValue: status,
                onChanged: (v) {
                  if (v != null) {
                    setState(
                      () {
                        status = v;
                      },
                    );

                    widget.onStatusChanged(v);
                  }
                },
              ),
            ),
          );
        },
      ).toList(),
    );
  }
}
