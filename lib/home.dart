import 'dart:async';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:screen_state/screen_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:health/timer_cubit.dart';
import 'package:health/timer_state.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

// class ScreenStateEventEntry {
//   ScreenStateEvent event;
//   DateTime? time;

//   ScreenStateEventEntry(this.event) {
//     time = DateTime.now();
//   }
// }

class _HomeState extends State<Home> {
  @override
  void initState() {
    super.initState();
    AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
      if (!isAllowed) {
        AwesomeNotifications().requestPermissionToSendNotifications();
      }
    });
  }

  // final Screen _screen = Screen();
  // late StreamSubscription<ScreenStateEvent> _subscription;
  // bool started = false;
  // List<ScreenStateEventEntry> _log = [];

  // @override
  // void initState() {
  //   super.initState();
  //   initPlatformState();
  // }

  // // Platform messages are asynchronous, so we initialize in an async method.
  // Future<void> initPlatformState() async {
  //   startListening();
  // }

  // void onData(ScreenStateEvent event) {
  //   setState(() {
  //     _log.add(ScreenStateEventEntry(event));
  //   });
  //   print(event);
  // }

  // void startListening() {
  //   try {
  //     _subscription = _screen.screenStateStream!.listen(onData);
  //     setState(() => started = true);
  //   } on ScreenStateException catch (exception) {
  //     print(exception);
  //   }
  // }

  // void stopListening() {
  //   _subscription.cancel();
  //   setState(() => started = false);
  // }

  @override
  Widget build(BuildContext context) {
    return
        // Scaffold(
        //   body: Center(
        //       child: ListView.builder(
        //           itemCount: _log.length,
        //           reverse: true,
        //           itemBuilder: (BuildContext context, int idx) {
        //             final entry = _log[idx];
        //             return ListTile(
        //                 leading: Text(
        //                   entry.time.toString().substring(0, 19),
        //                   style: TextStyle(color: Colors.amber),
        //                 ),
        //                 trailing: Text(
        //                   entry.event.toString().split('.').last,
        //                   style: TextStyle(color: Colors.black),
        //                 ));
        //           })),
        //   floatingActionButton: FloatingActionButton(
        //     onPressed: started ? stopListening : startListening,
        //     tooltip: 'Start/Stop sensing',
        //     child: started ? const Icon(Icons.stop) : Icon(Icons.play_arrow),
        //   ),
        // );

        BlocProvider(
      create: (context) => TimerCubit(),
      child: Scaffold(
        body: BlocBuilder<TimerCubit, TimerState>(builder: (context, state) {
          if (state is TimeInitial) {
            return Center(
              child: TextButton(
                  onPressed: () =>
                      BlocProvider.of<TimerCubit>(context).startTimer(0),
                  child: const Text("press")),
            );
          } else if (state is TimeProgress) {
            Duration duration = Duration(seconds: state.elapsed!);
            return Center(
              child: Text(duration.toString().trimLeft()),
              // child: Text(state.elapsed!.toString()),
            );
          } else if (state is TimerCompleted) {
            return Center(
              child: Text(state.elapsed!.toString()),
            );
          }
          return Container();
        }),
      ),
    );
  }
}
