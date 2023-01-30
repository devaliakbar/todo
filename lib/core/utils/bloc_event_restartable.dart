import 'package:stream_transform/stream_transform.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BlocEventRestartable {
  EventTransformer<Event> restartable<Event>() =>
      (events, mapper) => events.switchMap(mapper);
}
