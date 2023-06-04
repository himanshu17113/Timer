import 'dart:async';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:screen_state/screen_state.dart';
import 'timer_state.dart';

class ScreenStateEventEntry {
  ScreenStateEvent event;
  DateTime? time;

  ScreenStateEventEntry(this.event) {
    time = DateTime.now();
  }
}

class TimerCubit extends Cubit<TimerState> {
  TimerCubit() : super(const TimeInitial());
  @override
  final Screen _screen = Screen();
  late StreamSubscription<ScreenStateEvent> _subscription;
  bool started = false;
  List<ScreenStateEventEntry>? _log = [];

  // @override
  // void initState() {
  //   super.initState();
  //   initPlatformState();
  // }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    startListening();
  }

  void onData(ScreenStateEvent event) {
    // setState(() {
    _log?.add(ScreenStateEventEntry(event));
    //  });
    print(event);
  }

  void startListening() {
    try {
      _subscription = _screen.screenStateStream!.listen(onData);

      ///     setState(() => started = true);
    } on ScreenStateException catch (exception) {
      print(exception);
    }
  }

  void stopListening() {
    _subscription.cancel();
    // setState(() => started = false);
  }

  Timer? _timer;
  startTimer(int? time) {
    if (time != null) {
      initPlatformState();
      emit(TimeProgress(time, 0));
    } else {
      initPlatformState();
      emit(const TimeProgress(0, 0));
    }
    _timer = Timer.periodic(const Duration(seconds: 1), onTock);
  }

  void onTock(Timer timer) {
    final entry = _log;

    if (state is TimeProgress) {
      TimeProgress wip = state as TimeProgress;
      // if (wip.elapsed! < 20*60) {
      print(wip.sleep);
      print(wip.elapsed);
      if (entry!.isNotEmpty) {
        print(entry?.last.event.toString().split('.').last ?? "no entry yet");
      }
      if (wip.sleep! > 30) {
        emit(const TimeInitial());
      } else {
        if (wip.elapsed! < 1200) {
          if (entry!.isEmpty || entry == null) {
            emit(TimeProgress(wip.elapsed! + 1, wip.sleep));
          } else {
            if (entry.last.event.toString().split('.').last ==
                    "SCREEN_UNLOCKED" ||
                entry.last.event.toString().split('.').last == "SCREEN_ON") {
              emit(TimeProgress(wip.elapsed! + 1, wip.sleep));
            } else
            // if (entry.last.event
            //             .toString()
            //             .split('.')
            //             .last ==
            //         "SCREEN_OFF" ||
            //     entry.last.event.toString().split('.').last !=
            //         "SCREEN_UNLOCKED" ||
            //     entry.last.event.toString().split('.').last != "SCREEN_ON")
            {
              emit(TimeProgress(wip.elapsed!, wip.sleep! + 1));
            }
          }
        } else {
          AwesomeNotifications().createNotification(
              content: NotificationContent(
                  id: 10,
                  channelKey: 'basic_channel',
                  title: 'Simple Notification',
                  body: 'Simple body',
                  actionType: ActionType.Default));
          emit(TimerCompleted(wip.elapsed!, wip.sleep!));
          //emit(const TimeInitial());
          //   v.elapsed = wip.elapsed;
        }
      }
    }
    //  else if (state is TimerCompleted) {
    //   // TimerCompleted v = state as TimerCompleted;
    //   // //   TimerCompleted v = state as TimerCompleted;
    //   // emit(TimerCompleted(85 + 2));
    // }
    else {
      _subscription.cancel();
      _timer?.cancel();
      emit(const TimeInitial());
    }
  }
}
