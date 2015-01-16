package {
 
    import flash.desktop.NativeApplication;
    import flash.desktop.SystemIdleMode;

    import flash.ui.Multitouch;
    import flash.ui.MultitouchInputMode;

    import flash.display.Sprite;
    import flash.events.MouseEvent;
    import flash.events.Event;
	import SimpleStageVideo;

    import flash.events.EventDispatcher;

    public class Main extends Sprite {

        private var ssv;
        private var videos:Array = ['video1.mp4', 'video2.mp4', 'video3.mp4', 'video4.mp4']
        private var num:uint = 0; 
        private var STAGE_HEIGHT:uint = stage.stageHeight;
        private var STAGE_WIDTH:uint = stage.stageWidth;
        private var onDevice:Boolean = false; 

        private var application:NativeApplication;

        private var dispatcher:EventDispatcher; 
        
        public function Main(){
            if (stage) init();
            else addEventListener(Event.ADDED_TO_STAGE, init);

            if(onDevice){
                // listen for application exit
                stage.addEventListener(Event.DEACTIVATE, deactivate);
                stage.addEventListener(Event.ACTIVATE, onComeBack);

                application = NativeApplication.nativeApplication;
                application.systemIdleMode = SystemIdleMode.KEEP_AWAKE;
            }
        }

        private function deactivate(e:Event):void{
            // auto close
            stat.text = "DEACTIVATE";
            trace("deactivate");
            NativeApplication.nativeApplication.exit();
        }
         
        private function onComeBack(event:Event):void{
            // keep awake
            stat.text = "onComeBack";
            trace("onComeBack");
            NativeApplication.nativeApplication.systemIdleMode = SystemIdleMode.KEEP_AWAKE;
        }

        public function init():void{
            removeEventListener(Event.ADDED_TO_STAGE, init);
            trace('Added to stage', STAGE_HEIGHT, STAGE_WIDTH);

            ssv = new SimpleStageVideo();
            ssv.start(stage);
            addChild(ssv);

            trace("main - vids = ",videos[num])
            trace("main passing stage ", stage)
            
			ssv.addEventListener(SimpleStageVideo.ENDED, videoEnded);

            pauseBtn.visible = false;
            nextBtn.visible = false;
            playBtn.addEventListener(MouseEvent.CLICK, startVideo);
            stat.text = 'total videos = ' + videos.length;
        }

        public function startVideo(event:MouseEvent):void{
            addButtons();

            playBtn.removeEventListener(MouseEvent.CLICK, startVideo);
            trace("starting at video num", num)
            // play video
            ssv.playMyVideo(videos[num]);
        }

        public function videoEnded(event:Event){
            trace("video has ended");
            playNextVideo();
        }

        public function addButtons():void{
            stat.text = 'Adding Buttons';
            playBtn.visible = false;
            nextBtn.visible = true;
            pauseBtn.visible = true;
            nextBtn.addEventListener(MouseEvent.CLICK, onClick);
            pauseBtn.addEventListener(MouseEvent.CLICK, onClick);

            stat.text = 'Current Video is =z' + String(num);
        }

        public function playNextVideo():void{
            num++;
            stat.text = 'Current Video is =z' + String(num);
            trace("current video num is " ,num ,"total video is ", videos.length - 1);
            if(num > videos.length - 1){
                num = 0;
            }

            ssv.playMyVideo(videos[num]);
            
        }

        public function onClick(event:MouseEvent):void{
            trace(event.currentTarget);
            
            switch (event.currentTarget) 
            { 
                case nextBtn:
                    stat.text = ' next button ' + num;
                    playNextVideo();
                break; 
                case pauseBtn: 
                    stat.text = 'play / pause';
                    ssv.pause(); 
                break; 
            }
        }
    }
}
