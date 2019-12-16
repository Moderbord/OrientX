enum Result { TimedOut, Incorrect, Correct }

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
