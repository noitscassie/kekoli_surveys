enum SurveyState {
  unstarted(prettyName: 'Unstarted'),
  inProgress(prettyName: 'In Progress'),
  completed(prettyName: 'Completed');

  const SurveyState({required this.prettyName});

  final String prettyName;
}
