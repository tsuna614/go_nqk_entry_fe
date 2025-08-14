import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/rendering.dart';

class ConstraintsCubit extends Cubit<BoxConstraints?> {
  ConstraintsCubit() : super(null);

  void setConstraints(BoxConstraints constraints) {
    emit(constraints);
  }
}
