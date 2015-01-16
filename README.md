# SimpleStageVideoiOS
StageVideo implementation targetting iOS iPad - Tested on iOS 8.1.2

Simple implementation of StageVideo for iOS iPad.

This was developed as a class for a project. 

Video.fla - Contains a basic UI for usage. Be sure to included all the videos to be played when publishing to iOS.

Main.as - Controlling logic. Showing how to use the class. You define an array of videos.

SimpleStageVideo.as - The class.

The class uses this NetStatus events to find the end of the video. This is the only event I found that relibably
reported the end of the video on iPad iOS. 

				case "NetStream.Buffer.Full":
				    dispatchEvent(new Event(ENDED));
				break; 

Would love to have comments on improvements and such.
