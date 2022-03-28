export 'path_provider_web.dart' if (dart.library.io) './path_provider_io.dart';

abstract class PathProviderStub {
  Future<String> getApplicationSupportDirectory();
}
