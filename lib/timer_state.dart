import 'package:equatable/equatable.dart';

abstract class TimerState extends Equatable {
  final int? elapsed;
  final int? sleep;
  const TimerState(this.elapsed, this.sleep);
  // @override
  // List<Object> get props => [elapsed];
}

class TimeInitial extends TimerState {
  // const TimeInitial(super.elapsed );
  const TimeInitial() : super(0, 0);

  @override
  List<Object?> get props => [];
}

class TimeProgress extends TimerState {
  const TimeProgress(super.elapsed, super.sleep);

  @override
  List<Object?> get props => [elapsed, sleep];
}

class TimerCompleted extends TimerState {
// const TimerCompleted(int? ela ):super(ela:elapsed);
  const TimerCompleted(super.elapsed, super.sleep);
//  double x = this.elapsed / 2;

  @override
  List<Object?> get props => [elapsed];
}

class OffTimer extends TimerState {
// const TimerCompleted(int? ela ):super(ela:elapsed);
  const OffTimer(super.elapsed, super.sleep);
//  double x = this.elapsed / 2;

  @override
  List<Object?> get props => [elapsed];
}
