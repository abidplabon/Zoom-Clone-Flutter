import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_gradient_colors/flutter_gradient_colors.dart';
import 'package:jitsi_meet/jitsi_meet.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:zoom_clone/variables.dart';

class JoinMeeting extends StatefulWidget {
  @override
  _JoinMeetingState createState() => _JoinMeetingState();
}

class _JoinMeetingState extends State<JoinMeeting> {
  TextEditingController namecontroller = TextEditingController();
  TextEditingController roomcontroller = TextEditingController();
  bool? isVideoMuted = true;
  bool? isAudioMuted = true;

  joinmeeting() async {
    try {
      Map<FeatureFlagEnum, bool> feautureflags = {
        FeatureFlagEnum.WELCOME_PAGE_ENABLED: false
      };
      if (Platform.isAndroid) {
        feautureflags[FeatureFlagEnum.CALL_INTEGRATION_ENABLED] = false;
      } else if (Platform.isIOS) {
        feautureflags[FeatureFlagEnum.PIP_ENABLED] = false;
      }
      var options = JitsiMeetingOptions(room: roomcontroller.text)
        //..room = roomcontroller.text
        ..userDisplayName = namecontroller.text
        ..audioMuted = isAudioMuted
        ..videoMuted = isVideoMuted
        ..featureFlags.addAll(feautureflags);

      await JitsiMeet.joinMeeting(options);
    } catch (e) {
      print("Error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 24,
              ),
              Text(
                "Room code",
                style: mystyle(20),
              ),
              SizedBox(
                height: 20,
              ),
              PinCodeTextField(
                  controller: roomcontroller,
                  appContext: context,
                  autoDisposeControllers: false,
                  animationType: AnimationType.fade,
                  pinTheme: PinTheme(shape: PinCodeFieldShape.underline),
                  animationDuration: Duration(microseconds: 300),
                  length: 6,
                  onChanged: (value) {}),
              SizedBox(
                height: 10,
              ),
              TextField(
                controller: namecontroller,
                style: mystyle(20),
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Name (Leave if you want your username)",
                    labelStyle: mystyle(15)),
              ),
              SizedBox(
                height: 16,
              ),
              CheckboxListTile(
                value: isVideoMuted,
                onChanged: (value) {
                  setState(() {
                    isVideoMuted = value;
                  });
                },
                title: Text(
                  "Video Muted",
                  style: mystyle(18, Colors.black),
                ),
              ),
              SizedBox(
                height: 16,
              ),
              CheckboxListTile(
                value: isAudioMuted,
                onChanged: (value) {
                  setState(() {
                    isAudioMuted = value;
                  });
                },
                title: Text(
                  "Audio Muted",
                  style: mystyle(18, Colors.black),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                "Of course, you can customise your settings in the meeting",
                style: mystyle(15),
                textAlign: TextAlign.center,
              ),
              Divider(
                height: 48,
                thickness: 2.0,
              ),
              InkWell(
                onTap: () => joinmeeting(),
                child: Container(
                  width: double.maxFinite,
                  height: 64,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                        colors: GradientColors.facebookMessenger),
                  ),
                  child: Center(
                    child: Text(
                      "Join Meeting",
                      style: mystyle(20, Colors.white),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
