package com.bartnett.flebang
{
	import org.osflash.signals.Signal;

	public final class MusicSegment
	{
		public static const TRANS_BEHAVIOR_PLAY2END:uint = 0;
		public static const TRANS_BEHAVIOR_STOP:uint = 1;
		
		private var _voice:SoundInstance;
		
		public var Tempo:Number;
		public var TransitionBeat:Number;
		public var FadeOutTimeSecs:Number;
		public var FadeInTimeSecs:Number;
		public var TransitionBehavior:uint = 0;
		private var _lengthInMS:Number;
//		private var _sourceLooped:Boolean;
		private var _loopCount:int = 0;
		
		public function get LengthInMS():Number { return _lengthInMS; }
		public function get Loop():Boolean { return _voice.Loop; }
		public function get LoopCount():int { return _loopCount; }
		
		public function set Loop(value:Boolean):void { _voice.Loop = value; }
		
		public function get Volume():Number { return _voice.Volume; }
		public function set Volume(value:Number):void { _voice.Volume = value; }
		
		public function MusicSegment(musicSource:SoundSource)
		{
			_voice = new SoundInstance(musicSource);
			_lengthInMS = musicSource.approxFrameCount * musicSource.SAMPLE_RATE_MS;
			_voice.OnLoop.add(onLoopSlot);
		}
		
		public function CheckTransitionBeatPassed():Boolean
		{
			if (TransitionBeat < 0) {
				return true;
			}
			var transitionFrame:Number = Math.floor(60.0 / Tempo * TransitionBeat * _voice.SampleRateSecs);
//			trace("need frame: " + transitionFrame + "     current frame: " + _voice.FramePos);
			if (_loopCount > 0 || _voice.FramePos >= transitionFrame) {
				return true;
			}
			return false;
		}
		
		private function onLoopSlot():void
		{
			++_loopCount;
		}
		
		public function play():void
		{
			if (_voice) _voice.play(Loop);
		}
		
		public function stop():void
		{
			if (_voice) _voice.stop();
		}
	}
}