abstract class CounterStates {}

class CounterInitialStates extends CounterStates {}

class CounterPlusStates extends CounterStates {
  CounterPlusStates({this.counter});
  final int? counter;
}

class CounterMinusStates extends CounterStates {
  CounterMinusStates({this.counter});
  final int? counter;
}
