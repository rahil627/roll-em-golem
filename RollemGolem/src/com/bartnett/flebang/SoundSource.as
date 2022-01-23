package com.bartnett.flebang
{
	import flash.media.Sound;
	import flash.utils.ByteArray;
	
	public final class SoundSource
	{
		public const SAMPLE_RATE_MS:Number = 44.1;
		private var _srcSnd:Sound;
		//		private const DECODER_FRAME_DELAY_MAGICNUM:int = 1152;
		private const DECODER_FRAME_DELAY_MAGICNUM:int = 2257;
		//		private const DECODER_FRAME_DELAY_MAGICNUM:int = 2271;
		//		private const DECODER_FRAME_DELAY_MAGICNUM:int = 2304;
		
		// Temp buffer for extracted sound data
		private var _extractionBuffer:ByteArray = new ByteArray();
		// Counter for number of frames extracted from sound
		private var _numFramesExtracted:int;
		
		// Function to approximate the number of frames in the sound
		// There's no way to get the actual number of frames,
		// We're working with milliseconds and mp3-encoded audio data
		public function get approxFrameCount():int
		{
			return Math.floor(_srcSnd.length * SAMPLE_RATE_MS) - DECODER_FRAME_DELAY_MAGICNUM;
		} 
		
		// Coincidentally, sound sources need source sounds to source a sound.
		// (web audio is dumb)
		public final function SoundSource(sourceSound:Sound)
		{
			_srcSnd = sourceSound;
		}
		
		// This function will extract frames from the sound data and pump them
		// Into the vector provided in the arguments
		public final function getFrames(index:int, numFrames:int, buffer:Vector.<Number>):int
		{
			_numFramesExtracted = int(_srcSnd.extract(
				_extractionBuffer, 
				numFrames, 
				index + DECODER_FRAME_DELAY_MAGICNUM));
			
			_extractionBuffer.position = 0;
			while (_extractionBuffer.bytesAvailable) {
				buffer.push(_extractionBuffer.readFloat()); // L
				buffer.push(_extractionBuffer.readFloat()); // R
			}
			_extractionBuffer.clear();
			return _numFramesExtracted;
		}
	}

}