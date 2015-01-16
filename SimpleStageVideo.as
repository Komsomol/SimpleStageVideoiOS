package {
    import flash.display.Sprite;
    import flash.events.Event;
    import flash.events.NetStatusEvent;
    import flash.events.StageVideoAvailabilityEvent;
    import flash.events.StageVideoEvent;
    import flash.geom.Rectangle;
    import flash.media.StageVideo;
    import flash.media.StageVideoAvailability;
    import flash.media.Video;
    import flash.net.NetConnection;
    import flash.net.NetStream;

    import flash.events.EventDispatcher;
    import flash.display.Stage;
	
    public class SimpleStageVideo extends Sprite {
     
        public static const ENDED:String = "ENDED";
        private var _available:Boolean;
        public var _videoRect:Rectangle = new Rectangle(0, 0, 0, 0);
        public var _stage:Stage;
        public var _rc:Rectangle;
        public var _ns:NetStream;
        public var _nc:NetConnection;
        public var _video:Video;
        public var _sv:StageVideo;
        public var _width:uint;
        public var _height:uint;
        public var _videoPath:String;
		public var callBack:Function;
	
        public function start(dastage, width:uint=1024, height:uint=768) {
			_width = width, _height = height;
            trace(_width,_height)
            _stage = dastage;
			if (_stage) init();
			else _stage.addEventListener(Event.ADDED_TO_STAGE, init);
        }
	
		private function init(e:Event= null):void {
			_stage.removeEventListener(Event.ADDED_TO_STAGE, init);
			_stage.addEventListener(StageVideoAvailabilityEvent.STAGE_VIDEO_AVAILABILITY, onStageVideoAvailable);
		}
	
        private function onStageVideoAvailable(event:StageVideoAvailabilityEvent):void
        {
            _available = event.availability == StageVideoAvailability.AVAILABLE ;
			_stage.removeEventListener(StageVideoAvailabilityEvent.STAGE_VIDEO_AVAILABILITY, onStageVideoAvailable);
            initVideo();
        }

        private function initVideo():void{
            _nc = new NetConnection();
            _nc.connect(null);
            _ns = new NetStream(_nc);
            _ns.client = this;
            _ns.addEventListener(NetStatusEvent.NET_STATUS, statusHandler);
            trace("IS ITSV?" + _available)
            if(_available){
                _sv = _stage.stageVideos[0];
                _sv.addEventListener(StageVideoEvent.RENDER_STATE, onRenderReady);
                _sv.attachNetStream(_ns);
            } else {
                _video = new Video(_width , _height);
                _rc = new Rectangle(0, 0,_height,_width);
                _video.x = 0;
                _video.y = 0;
                _video.attachNetStream(_ns);
				_stage.addChildAt(_video, 0);
            }
        }

        public function playMyVideo(videoPath:String):void{
            _ns.play(videoPath);
            if (!_available){
                _stage.addChild(_video);
                _stage.setChildIndex(_video, 0);
            }
        }

        public function pause():void{
            _ns.togglePause(); 
        }

        private function onRenderReady(e:StageVideoEvent):void{
			_sv.viewPort = new Rectangle(0, 0, _width,_height );
        }
	
		private function statusHandler(event:NetStatusEvent):void 
		{ 
            switch (event.info.code) 
			{ 
                case "NetConnection.Connect.Success":
                    break;
				case "NetStream.Play.Start": 
					break; 
				case "NetStream.Buffer.Full":
				    dispatchEvent(new Event(ENDED));
				break; 
			}
		}

        // dispose
        public function dispose():void{
            _ns.close();
            _ns.dispose();
            if (!_available){
                if (_video.parent != null){
                    _stage.removeChild(_video);
                }
            }
        }
		
        public function onMetaData( info:Object ):void {
        }

        public function onXMPData( info:Object ):void {
        }
      
        public function onPlayStatus( info:Object):void{
        }
		
    }

}
