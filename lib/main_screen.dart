import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_zoom_sdk/zoom_options.dart';
import 'package:flutter_zoom_sdk/zoom_view.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(onPressed: (){
            joinMeetiasfsafng(context);
          }, child: Text("JOIN ZOOM"))
        ],
      ),
    );
  }

  void joinMeetiasfsafng(BuildContext context) async {
    print("HALO");
    bool _isMeetingEnded(String status) {
      var result = false;
      if (Platform.isAndroid) {
        result = status == "MEETING_STATUS_DISCONNECTING" || status == "MEETING_STATUS_FAILED";
      } else {
        result = status == "MEETING_STATUS_IDLE";
      }
      return result;
    }

    ZoomOptions zoomOptions = ZoomOptions(
      domain: "zoom.us",
      appKey: "pSBz06f9Tq-LkCe98Ri2Yw", //API KEY FROM ZOOM
      appSecret: "H9sLQKf91EAp7YVZtrEPI5epGIw4Hr502aIv", //API SECRET FROM ZOOM
    );
    ZoomMeetingOptions zoomMeetingOptions = ZoomMeetingOptions(
        userId: 'username', //pass username for join meeting only --- Any name eg:- EVILRATT.
        meetingId: '331 009 0463', //pass meeting id for join meeting only
        meetingPassword: 'QYw919', //pass meeting password for join meeting only
        disableDialIn: "true",
        disableDrive: "true",
        disableInvite: "true",
        disableShare: "true",
        noAudio: "false",
        noDisconnectAudio: "false"
    );
    Timer? timer;
    ZoomView zoom = ZoomView();
    // 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
    try{
      await zoom.initZoom(zoomOptions).then((results) {
        if(results[0] == 0) {
          zoom.onMeetingStatus().listen((status) {
            print("[Meeting Status Stream] : " + status[0] + " - " + status[1]);
            if (_isMeetingEnded(status[0])) {
              print("[Meeting Status] :- Ended");
              timer?.cancel();
            }
          });
          print("listen on event channel");
          zoom.joinMeeting(zoomMeetingOptions).then((joinMeetingResult) {
            timer = Timer.periodic(Duration(seconds: 2), (timer) {
              zoom.meetingStatus(zoomMeetingOptions.meetingId!)
                  .then((status) {
                print("[Meeting Status Polling] : " + status[0] + " - " + status[1]);
              });
            });
          });
        }
      });
    }catch(e) {
      print("MASUK ERROR ${e.toString()}");
    }
  }
}
