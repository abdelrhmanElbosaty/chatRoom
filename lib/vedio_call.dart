import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class VideoScreen extends StatefulWidget {
  const VideoScreen({Key? key}) : super(key: key);

  @override
  State<VideoScreen> createState() => _VideoScreenState();
}

class _VideoScreenState extends State<VideoScreen> {
  // int? remoteId;
  // late RtcEngine agoraEngine;

  @override
  void initState() {
    super.initState();
    // initForAgora();
    setupVideoSDKEngine();
  }

  String token = "007eJxTYLhesWrBKb2CWfGsL7f6Hryxj19E6E0Gl3HTsktK7e9vM1coMCRbmJkaJBmaJyUbJZsYWaZZpJgkmplYmhunGiUbJltavEiuT24IZGRYt/4rKyMDBIL4PAxumUXFJQFF+VmpySUMDACe3CPj";
  String channelName = "FirstProject";

  int uid = 0; // uid of the local user
  String? appId = "c8650b17bc2c429f8d4a64973e2c1c98";

  int? _remoteUid; // uid of the remote user
  bool _isJoined = false; // Indicates if the local user has joined the channel
  late RtcEngine agoraEngine; // Agora engine instance

  final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey
  = GlobalKey<ScaffoldMessengerState>(); // Global key to access the scaffold

  showMessage(String message) {
    scaffoldMessengerKey.currentState?.showSnackBar(SnackBar(
      content: Text(message),
    ));
  }

  // Build UI
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      scaffoldMessengerKey: scaffoldMessengerKey,
      home: Scaffold(
          appBar: AppBar(
            title: const Text('Get started with Video Calling'),
          ),
          body: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            children: [
              // Container for the local video
              Container(
                height: 240,
                decoration: BoxDecoration(border: Border.all()),
                child: Center(child: _localPreview()),
              ),
              const SizedBox(height: 10),
              //Container for the Remote video
              Container(
                height: 240,
                decoration: BoxDecoration(border: Border.all()),
                child: Center(child: _remoteVideo()),
              ),
              // Button Row
              Row(
                children: <Widget>[
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _isJoined ? null : () => {join()},
                      child: const Text("Join"),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _isJoined ? () => {leave()} : null,
                      child: const Text("Leave"),
                    ),
                  ),
                ],
              ),
              // Button Row ends
            ],
          )),
    );
  }

// Display local video preview
  Widget _localPreview() {
    if (_isJoined) {
      return AgoraVideoView(
        controller: VideoViewController(
          rtcEngine: agoraEngine,
          canvas: VideoCanvas(uid: uid),
        ),
      );
    } else {
      return const Text(
        'Join a channel',
        textAlign: TextAlign.center,
      );
    }
  }

// Display remote user's video
  Widget _remoteVideo() {
    if (_remoteUid != null) {
      return AgoraVideoView(
        controller: VideoViewController.remote(
          rtcEngine: agoraEngine,
          canvas: VideoCanvas(uid: _remoteUid),
          connection: RtcConnection(channelId: channelName),
        ),
      );
    } else {
      String msg = '';
      if (_isJoined) msg = 'Waiting for a remote user to join';
      return Text(
        msg,
        textAlign: TextAlign.center,
      );
    }
  }

  Future<void> setupVideoSDKEngine() async {
    // retrieve or request camera and microphone permissions
    await [Permission.microphone, Permission.camera].request();

    //create an instance of the Agora engine
    agoraEngine = createAgoraRtcEngine();
    await agoraEngine.initialize( RtcEngineContext(
        appId: appId
    ));

    await agoraEngine.enableVideo();

    // Register the event handler
    agoraEngine.registerEventHandler(
      RtcEngineEventHandler(
        onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
          showMessage("Local user uid:${connection.localUid} joined the channel");
          setState(() {
            _isJoined = true;
          });
        },
        onUserJoined: (RtcConnection connection, int remoteUid, int elapsed) {
          showMessage("Remote user uid:$remoteUid joined the channel");
          setState(() {
            _remoteUid = remoteUid;
          });
        },
        onUserOffline: (RtcConnection connection, int remoteUid,
            UserOfflineReasonType reason) {
          showMessage("Remote user uid:$remoteUid left the channel");
          setState(() {
            _remoteUid = null;
          });
        },
      ),
    );
  }

  void  join() async {
    await agoraEngine.startPreview();

    // Set channel options including the client role and channel profile
    ChannelMediaOptions options = const ChannelMediaOptions(
      clientRoleType: ClientRoleType.clientRoleBroadcaster,
      channelProfile: ChannelProfileType.channelProfileCommunication,
    );

    await agoraEngine.joinChannel(
      token: token,
      channelId: channelName,
      options: options,
      uid: uid,
    );
  }

  void leave() {
    setState(() {
      _isJoined = false;
      _remoteUid = null;
    });
    agoraEngine.leaveChannel();
  }

// Widget build(BuildContext context) {
  //   return Scaffold(
  //       appBar: AppBar(
  //         title: const Text('Video call with agora'),
  //       ),
  //       body: Stack(
  //         children: [
  //           Center(
  //             child: renderRemoteVideo(),
  //           ),
  //           Align(
  //             alignment: Alignment.topLeft,
  //             child: SizedBox(
  //               width: 150,
  //               height: 150,
  //               child: Center(
  //                 child: renderLocalVideo(),
  //               ),
  //             ),
  //           )
  //         ],
  //       ));
  // }

  // Future<void> initForAgora() async {
  //   try {
  //     await [Permission.microphone, Permission.camera].request();
  //
  //     agoraEngine = createAgoraRtcEngine();
  //     await agoraEngine.initialize(const RtcEngineContext(appId: appId));
  //     await agoraEngine.enableVideo();
  //
  //     agoraEngine.registerEventHandler(
  //       RtcEngineEventHandler(
  //         onJoinChannelSuccess: (connection, elapsed) {
  //           print(
  //               'localUserJoins${connection.localUid} channel id ${connection.channelId}');
  //         },
  //         onUserJoined: (connection, remoteUid, elapsed) {
  //           print(
  //               'remoteUserJoins${remoteUid} channel id ${connection.channelId}');
  //           setState(() {
  //             remoteId = remoteUid;
  //           });
  //         },
  //         onUserOffline: (connection, remoteUid, reason) {
  //           print(
  //               'remoteUserLeft${remoteUid} channel id ${connection.channelId}');
  //           setState(() {
  //             remoteId = null;
  //           });
  //         },
  //       ),
  //     );
  //
  //     ChannelMediaOptions options;
  //
  //     // Set channel profile and client role
  //     if (true) {
  //       options = const ChannelMediaOptions(
  //         clientRoleType: ClientRoleType.clientRoleBroadcaster,
  //         channelProfile: ChannelProfileType.channelProfileLiveBroadcasting,
  //       );
  //       await agoraEngine.startPreview();
  //     } else {
  //       options = const ChannelMediaOptions(
  //         clientRoleType: ClientRoleType.clientRoleAudience,
  //         channelProfile: ChannelProfileType.channelProfileLiveBroadcasting,
  //       );
  //     }
  //
  //     await agoraEngine.joinChannel(
  //       token: token,
  //       channelId: 'FirstProject',
  //       options: options,
  //       uid: 0,
  //     );
  //   } catch (e) {
  //     print(e);
  //   }
  // }
  //
  // Widget renderRemoteVideo() {
  //   if (remoteId != null) {
  //     return AgoraVideoView(
  //       controller: VideoViewController.remote(
  //         rtcEngine: agoraEngine,
  //         canvas: VideoCanvas(uid: remoteId),
  //         connection: const RtcConnection(channelId: 'FirstProject'),
  //       ),
  //     );
  //   } else {
  //     return const Text('Please wait other to join');
  //   }
  // }
  //
  // Widget renderLocalVideo() {
  //   return AgoraVideoView(
  //     controller: VideoViewController(
  //       rtcEngine: agoraEngine,
  //       canvas: const VideoCanvas(uid: 0),
  //     ),
  //   );
  // }
}
