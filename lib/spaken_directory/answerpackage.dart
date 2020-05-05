enum Result { TimedOut, Incorrect, Correct }

/// Answer package class
///
/// Contains details about the user performance of an Activity
class AnswerPackage {
  Result result;
  List<String> selectedAnswers;
  List<String> correctAnswers;
  int answerTime;

  AnswerPackage(
      {this.result,
      this.selectedAnswers,
      this.correctAnswers,
      this.answerTime});
}
