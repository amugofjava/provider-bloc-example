// Copyright 2019 Ben Hills (ben.hills@amugofjava.me.uk).
// Use of this source code is governed by a MIT-style license that can be
// found in the LICENSE file.

/// These related classes are used to indicate either the current state of the
/// stopwatch or the state you wish to transition the stopwatch to.
abstract class StopwatchState {}

class StopwatchStartState extends StopwatchState {}

class StopwatchStopState extends StopwatchState {}

class StopwatchResetState extends StopwatchState {}
