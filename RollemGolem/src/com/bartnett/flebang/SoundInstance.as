package com.bartnett.flebang
{
	import flash.events.SampleDataEvent;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	
	import org.flixel.FlxG;
	import org.flixel.FlxU;
	import org.osflash.signals.Signal;
	
	// This class represents a single instance of sound occurring in the world
	public final class SoundInstance
	{
		private const FRAME_BUFFER_SIZE:int = 2048;
		
		// The DSPUnit object that will process samples each frame if present
//		public var dspUnit:DSPUnit;
		
		// The source of the audio data
		private var _soundSource:SoundSource;
		
		// The empty sound used by SampleDataEvent
		private var _soundObject:Sound = new Sound();
		// The playback channel used to stop/pause/mute sounds
		private var _channel:SoundChannel;
		
		private var _volume:Number = 1.0;
		public function get Volume():Number { return _volume; }
		public function set Volume(value:Number):void {
			_volume = FlxU.bound(value, 0.0, 1.0);
			if (_channel) {
				var transform:SoundTransform = _channel.soundTransform;
				transform.volume = _volume;
				_channel.soundTransform = transform;
			}
		}
		
		
		// The position we're 
		private var _frameIndex:int = 0;
		private var _frameBuffer:Vector.<Number> = new Vector.<Number>();
		
		// temporary state
		private var _framesRead:int;
		
		/**
		 * The current frame position in the audio channel 
		 * @return 
		 */		
		public function get FramePos():int { return _frameIndex; }
		
		public function get SampleRateSecs():Number { return _soundSource.SAMPLE_RATE_MS * 1000; }
		
		
		public function get MilliSecPos():Number { return _frameIndex * _soundSource.SAMPLE_RATE_MS; }
		
		public function get OnLoop():Signal { return _onLoop; }
		private var _onLoop:Signal = new Signal();
		private var _justLoopedFlag:Boolean = false;
		
		public var Loop:Boolean = false;
		
		// SoundInstance requires a source object to function
		public function SoundInstance(soundSource:SoundSource)
		{
			_soundSource = soundSource;
			_soundObject.addEventListener(SampleDataEvent.SAMPLE_DATA, sampleDataCallback);
		}
		
		// Plays the sound
		public function play(looped:Boolean=false):void
		{
			Loop = looped;
			var transform:SoundTransform = new SoundTransform(_volume);
			_channel = _soundObject.play(0, 0, transform);
		}
		
		// Stops the sound (not used in this demo)
		public function stop():void
		{
			if (_channel) {
				_channel.stop();
			}
		}
		
		
		
		// The function that streams samples to the empty sound object
		// *Not gonna bother commenting this, it's problem domain specific*
		private function sampleDataCallback(event:SampleDataEvent):void
		{
			_framesRead = _soundSource.getFrames(
				_frameIndex, 
				FRAME_BUFFER_SIZE, 
				_frameBuffer);
			_frameIndex += _framesRead;
			
			if (_framesRead != FRAME_BUFFER_SIZE) {
				_frameIndex = 0;
				if (Loop) {
					_framesRead = _soundSource.getFrames(
						_frameIndex,
						FRAME_BUFFER_SIZE - _framesRead,
						_frameBuffer);
					_frameIndex += _framesRead;
					_justLoopedFlag = true;
				}
			}
			
			while (_frameBuffer.length > 0) {
				event.data.writeFloat(_frameBuffer.shift());
			}
			
			if (_justLoopedFlag) {
				_justLoopedFlag = false;
			}
		}
	}
}