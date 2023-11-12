// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes

// Package imports:
import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;

// Project imports:
import '../helpers/e2ee/frame_crypto.dart' as _i8;
import '../helpers/logger/logger.dart' as _i7;
import '../helpers/stats/webrtc_stats.dart' as _i9;
import '../interfaces/socket_emiter_interface.dart' as _i5;
import '../interfaces/socket_handler_interface.dart' as _i14;
import '../interfaces/webrtc_interface.dart' as _i10;
import '../method_channels/native_channel.dart' as _i3;
import '../method_channels/replaykit.dart' as _i4;
import '../sdk_core.dart' as _i13;
import '../services/callkit/callkit_listener.dart' as _i12;
import '../services/socket/socket_emiter.dart' as _i6;
import '../services/socket/socket_handler.dart' as _i15;
import '../services/webrtc/webrtc.dart' as _i11;

// initializes the registration of main-scope dependencies inside of GetIt
_i1.GetIt $initGetIt(
  _i1.GetIt getIt, {
  String? environment,
  _i2.EnvironmentFilter? environmentFilter,
}) {
  final gh = _i2.GetItHelper(
    getIt,
    environment,
    environmentFilter,
  );
  gh.factory<_i3.NativeService>(() => _i3.NativeService());
  gh.singleton<_i4.ReplayKitChannel>(_i4.ReplayKitChannel());
  gh.factory<_i5.SocketEmiter>(() => _i6.SocketEmiterImpl());
  gh.factory<_i7.WaterbusLogger>(() => _i7.WaterbusLogger());
  gh.singleton<_i8.WebRTCFrameCrypto>(
      _i8.WebRTCFrameCrypto(gh<_i7.WaterbusLogger>()));
  gh.singleton<_i9.WebRTCStatsUtility>(_i9.WebRTCStatsUtility());
  gh.lazySingleton<_i10.WaterbusWebRTCManager>(
      () => _i11.WaterbusWebRTCManagerIpml(
            gh<_i8.WebRTCFrameCrypto>(),
            gh<_i5.SocketEmiter>(),
            gh<_i4.ReplayKitChannel>(),
            gh<_i3.NativeService>(),
            gh<_i9.WebRTCStatsUtility>(),
          ));
  gh.singleton<_i12.CallKitListener>(_i12.CallKitListener(
    gh<_i7.WaterbusLogger>(),
    gh<_i10.WaterbusWebRTCManager>(),
  ));
  gh.singleton<_i13.SdkCore>(_i13.SdkCore(
    gh<_i10.WaterbusWebRTCManager>(),
    gh<_i4.ReplayKitChannel>(),
    gh<_i7.WaterbusLogger>(),
  ));
  gh.singleton<_i14.SocketHandler>(_i15.SocketHandlerImpl(
    gh<_i10.WaterbusWebRTCManager>(),
    gh<_i7.WaterbusLogger>(),
  ));
  return getIt;
}
