// Copyright 2019 Ben Hills (ben.hills@amugofjava.me.uk).
// Use of this source code is governed by a MIT-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stopwatch_bloc_example/stopwatch_bloc.dart';
import 'package:stopwatch_bloc_example/stopwatch_widget.dart';

/// A simple stopwatch app with Start, Stop and reset buttons.
class StopwatchApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    /// We wrap the MaterialApp in a Provider which handles the instatiating
    /// and disposing of our Stopwatch BLoC.
    return Provider(
      builder: (context) => StopwatchBloc(),
      dispose: (context, value) => value.dispose(),
      child: MaterialApp(
        title: 'Provider with BLoC Example',
        theme: ThemeData(
          primarySwatch: Colors.green,
        ),
        home: Scaffold(
          appBar: AppBar(
            title: Text('Stopwatch BLoC & Provider Example'),
          ),
          body: Center(
            child: StopwatchWidget(),
          ),
        ),
      ),
    );
  }
}
