import 'package:flutter/material.dart';
import 'package:kekoldi_surveys/widgets/page_scaffold.dart';

class ErrorDetailsPage extends StatelessWidget {
  final Object exception;
  final StackTrace stacktrace;

  const ErrorDetailsPage({
    super.key,
    required this.exception,
    required this.stacktrace,
  });

  @override
  Widget build(BuildContext context) {
    return PageScaffold.withScrollableChildren(
      title: 'Error Details',
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 16),
          child: Text(
            'Oh no, something went wrong :-( Please send a screenshot or video of the following details to Cassie and she\'ll get it fixed',
          ),
        ),
        Text(exception.runtimeType.toString()),
        Text(stacktrace.toString()),
      ],
    );
  }
}
