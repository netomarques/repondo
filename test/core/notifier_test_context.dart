import 'package:flutter_riverpod/flutter_riverpod.dart';

typedef NotifierTestContext<T, NotifierT extends AutoDisposeAsyncNotifier<T>>
    = ({
  NotifierT notifier,
  List<AsyncValue<T>> states,
});
