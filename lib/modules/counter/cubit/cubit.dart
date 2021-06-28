import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/states.dart';

class CounterCubit extends Cubit<CounterStates> {
  CounterCubit() : super(CounterInitialStates());

  static CounterCubit get(context) => BlocProvider.of<CounterCubit>(context);

  int counter = 1;

  void plus() {
    counter++;
    emit(CounterPlusStates(counter: counter));
  }

  void minus() {
    counter--;
    emit(CounterMinusStates(counter: counter));
  }
}
