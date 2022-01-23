package Audio
{
	import com.bartnett.flebang.MusicSegment;
	import com.bartnett.flebang.SoundSource;
	import com.greensock.TweenLite;
	
	import flash.utils.Dictionary;
	
	import org.flixel.FlxG;
	import org.flixel.FlxSound;
	import org.osflash.signals.Signal;
	
	// TODO: List of SFX
	// Landing after jump: multiple intensity levels
	// Jump up
	// Dash impact
	// 

	public class AudioManager
	{
		public static const JumpVolume:Number        = 1.0;
		public static const DashVolume:Number        = 1.0;
		public static const PlantGrowVolume:Number   = 1.0;
		public static const BlockMoveVolume:Number   = 1.0;
		public static const CollectVolume:Number     = 1.0;
		public static const LandVolume:Number        = 1.0;
		public static const StuntGrowthVolume:Number = 1.0;
		
		
		[Embed(source="../../assets/audio/MusicIntro.mp3")] private static var MusicIntroData:Class;
		[Embed(source="../../assets/audio/MusicLoop.mp3")] private static var MusicLoopData:Class;
		[Embed(source="../../assets/audio/MusicOutro.mp3")] private static var MusicOutroData:Class;
		
		private static var MusicBank:Dictionary = new Dictionary();
		{
			MusicBank["Intro"] = new SoundSource(new MusicIntroData);
			MusicBank["Loop"] = new SoundSource(new MusicLoopData);
			MusicBank["Outro"] = new SoundSource(new MusicOutroData);
		}
		
//		public function get OnMusicSegmentChange():Signal { return _onMusicSegmentChange; }
//		private var _onMusicSegmentChange:Signal = new Signal();
		
		private var currentSegment:MusicSegment;
		private var targetSegment:MusicSegment;
		private var outroSong:FlxSound = new FlxSound();
		
		private var _outroTriggered:Boolean = false;
		
		public function AudioManager()
		{
			outroSong.loadEmbedded(MusicOutroData);
		}
		
		public function targetMusic(cueName:String, looped:Boolean, tempo:Number, transitionBeat:Number, transitionBehavior:uint=0, fadeOutSecs:Number=0.0, fadeInSecs:Number=0.0):void
		{
			if (!currentSegment) {
				currentSegment = new MusicSegment(MusicBank[cueName]);
				currentSegment.Tempo = tempo;
				currentSegment.TransitionBeat = transitionBeat;
				currentSegment.Loop = looped;
				currentSegment.FadeInTimeSecs = fadeInSecs;
				currentSegment.FadeOutTimeSecs = fadeOutSecs;
				currentSegment.TransitionBehavior = transitionBehavior;
				currentSegment.play();
			} else {
				targetSegment = new MusicSegment(MusicBank[cueName]);
				targetSegment.Tempo = tempo;
				targetSegment.TransitionBeat = transitionBeat;
				targetSegment.Loop = looped;
				targetSegment.FadeInTimeSecs = fadeInSecs;
				targetSegment.FadeOutTimeSecs = fadeOutSecs;
				targetSegment.TransitionBehavior = transitionBehavior;
			}
		}
		
		public function cueFinishMusic():void
		{
			TweenLite.to(currentSegment, currentSegment.FadeOutTimeSecs, { Volume: 0.0 });
			outroSong.play(true);
		}
		
		public function resetEverything():void
		{
			targetSegment = null;
			_outroTriggered = false;
			outroSong.stop();
		}
		
		public function update():void
		{
			if (currentSegment) {
				if (targetSegment) {
				if (currentSegment.CheckTransitionBeatPassed()) {
					if (targetSegment.FadeInTimeSecs > 0) {
						targetSegment.Volume = 0.0;
						TweenLite.to(targetSegment, targetSegment.FadeInTimeSecs, { Volume: 1.0 });
					}
					
					targetSegment.play();
					
					switch (currentSegment.TransitionBehavior) {
						case MusicSegment.TRANS_BEHAVIOR_PLAY2END:
//						{
							currentSegment.Loop = false; // Make sure loop is false
							break;
//						}
						case MusicSegment.TRANS_BEHAVIOR_STOP:
//						{
							if (currentSegment.FadeOutTimeSecs <= 0)
								currentSegment.stop();
							else
								TweenLite.to(currentSegment,currentSegment.FadeOutTimeSecs, { Volume: 0.0, onComplete:advanceToNextSegment });
							break;
//						}
					}
//					_onMusicSegmentChange.dispatch(); // This may have been causing lag spikes
//					targetSegment.play();
					currentSegment = targetSegment;
					targetSegment = null;
				}
				}
			}
		}

		
		private function advanceToNextSegment():void
		{
			if (!_outroTriggered) {
//				currentSegment.stop();
//				_outroTriggered = true;
//				targetMusic("Outro", false, 130, 999);
			}
		}
	}
}