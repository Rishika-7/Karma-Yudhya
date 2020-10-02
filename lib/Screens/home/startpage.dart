import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/scheduler.dart';
import 'package:paap_punya/Screens/home/home.dart';
import 'package:google_fonts/google_fonts.dart';


class StartPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: ParticleBackgroundPage(),
      ),
    );
  }
}

class ParticleBackgroundPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Positioned.fill(child: AnimatedBackground()),
        Positioned.fill(child: Particles(10)),
        Positioned.fill(child: CenteredText()),
      ],
    );
  }
}

class Particles extends StatefulWidget {
  final int numberOfParticles;

  Particles(this.numberOfParticles);

  @override
  _ParticlesState createState() => _ParticlesState();
}

class _ParticlesState extends State<Particles> {
  final Random random = Random();

  final List<ParticleModel> particles = [];

  @override
  void initState() {
    List.generate(widget.numberOfParticles, (index) {
      particles.add(ParticleModel(random));
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Rendering(
      startTime: Duration(seconds: 30),
      onTick: _simulateParticles,
      builder: (context, time) {
        return CustomPaint(
          painter: ParticlePainter(particles, time),
        );
      },
    );
  }

  _simulateParticles(Duration time) {
    particles.forEach((particle) => particle.maintainRestart(time));
  }
}

class ParticleModel {
  Animatable tween;
  double size;
  AnimationProgress animationProgress;
  Random random;

  ParticleModel(this.random) {
    restart();
  }

  restart({Duration time = Duration.zero}) {
    final startPosition = Offset(-0.2 + 1.4 * random.nextDouble(), 1.2);
    final endPosition = Offset(-0.2 + 1.4 * random.nextDouble(), -0.2);
    final duration = Duration(milliseconds: 3000 + random.nextInt(6000));

    tween = MultiTrackTween([
      Track("x").add(
          duration, Tween(begin: startPosition.dx, end: endPosition.dx),
          curve: Curves.easeInOutSine),
      Track("y").add(
          duration, Tween(begin: startPosition.dy, end: endPosition.dy),
          curve: Curves.easeIn),
    ]);
    animationProgress = AnimationProgress(duration: duration, startTime: time);
    size = 0.2 + random.nextDouble() * 0.4;
  }

  maintainRestart(Duration time) {
    if (animationProgress.progress(time) == 1.0) {
      restart(time: time);
    }
  }
}

class ParticlePainter extends CustomPainter {
  List<ParticleModel> particles;
  Duration time;

  ParticlePainter(this.particles, this.time);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.white.withAlpha(50);

    particles.forEach((particle) {
      var progress = particle.animationProgress.progress(time);
      final animation = particle.tween.transform(progress);
      final position =
          Offset(animation["x"] * size.width, animation["y"] * size.height);
      canvas.drawCircle(position, size.width * 0.2 * particle.size, paint);
    });
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}

class AnimatedBackground extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final tween = MultiTrackTween([
      Track("color1").add(Duration(seconds: 3),
          ColorTween(begin: Colors.amber.shade500, end: Colors.cyan.shade800)),
      Track("color2").add(Duration(seconds: 3),
          ColorTween(begin: Colors.amber.shade600, end: Colors.cyan.shade600))
    ]);

    return ControlledAnimation(
      playback: Playback.MIRROR,
      tween: tween,
      duration: tween.duration,
      builder: (context, animation) {
        return Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [animation["color1"], animation["color2"]])),
        );
      },
    );
  }
}

class CenteredText extends StatelessWidget {
  const CenteredText({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Welcome to",
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              textScaleFactor: 3,
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 40,
            ),
            Text(
              "Paap & Punya",
              style: GoogleFonts.aladin(color: Colors.white),
              textScaleFactor: 6,
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 80,
            ),
            Text(
              "We help you keep track of all your good and bad deeds",
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.w300),
              textScaleFactor: 2,
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 30,
            ),
            Text(
              "Because what goes around comes around...",
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.w300),
              textScaleFactor: 2,
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 100,
            ),
            FloatingActionButton(
              backgroundColor: Colors.white,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Home()),
                );
              },
              tooltip: 'GO',
              child: Text("GO",
              style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18),
            )
            )
          ],
        ));
  }
}

class Rendering extends StatefulWidget {
  final Widget Function(BuildContext context, Duration timeElapsed) builder;
  final Function(Duration timeElapsed) onTick;
  final Duration startTime;
  final int startTimeSimulationTicks;

  Rendering(
      {this.builder,
      this.onTick,
      this.startTime = Duration.zero,
      this.startTimeSimulationTicks = 20})
      : assert(builder != null, "Builder needs to defined.");

  @override
  _RenderingState createState() => _RenderingState();
}

class _RenderingState extends State<Rendering>
    with SingleTickerProviderStateMixin {
  Ticker _ticker;
  Duration _timeElapsed = Duration(milliseconds: 0);

  @override
  void initState() {
    if (widget.startTime > Duration.zero) {
      _simulateStartTimeTicks();
    }

    _ticker = createTicker((elapsed) {
      _onRender(elapsed + widget.startTime);
    });
    _ticker.start();
    super.initState();
  }

  void _onRender(Duration effectiveElapsed) {
    if (widget.onTick != null) {
      widget.onTick(effectiveElapsed);
    }
    setState(() {
      _timeElapsed = effectiveElapsed;
    });
  }

  void _simulateStartTimeTicks() {
    if (widget.onTick != null) {
      Iterable.generate(widget.startTimeSimulationTicks + 1).forEach((i) {
        final simulatedTime = Duration(
            milliseconds: (widget.startTime.inMilliseconds *
                    i /
                    widget.startTimeSimulationTicks)
                .round());
        widget.onTick(simulatedTime);
      });
    }
  }

  @override
  void dispose() {
    _ticker.stop(canceled: true);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(context, _timeElapsed);
  }
}

class MultiTrackTween extends Animatable<Map<String, dynamic>> {
  final _tracksToTween = Map<String, _TweenData>();
  var _maxDuration = 0;

  MultiTrackTween(List<Track> tracks)
      : assert(tracks != null && tracks.length > 0,
            "Add a List<Track> to configure the tween."),
        assert(tracks.where((track) => track.items.length == 0).length == 0,
            "Each Track needs at least one added Tween by using the add()-method.") {
    _computeMaxDuration(tracks);
    _computeTrackTweens(tracks);
  }

  void _computeMaxDuration(List<Track> tracks) {
    tracks.forEach((track) {
      final trackDuration = track.items
          .map((item) => item.duration.inMilliseconds)
          .reduce((sum, item) => sum + item);
      _maxDuration = max(_maxDuration, trackDuration);
    });
  }

  void _computeTrackTweens(List<Track> tracks) {
    tracks.forEach((track) {
      final trackDuration = track.items
          .map((item) => item.duration.inMilliseconds)
          .reduce((sum, item) => sum + item);

      final sequenceItems = track.items
          .map((item) => TweenSequenceItem(
              tween: item.tween,
              weight: item.duration.inMilliseconds / _maxDuration))
          .toList();

      if (trackDuration < _maxDuration) {
        sequenceItems.add(TweenSequenceItem(
            tween: ConstantTween(null),
            weight: (_maxDuration - trackDuration) / _maxDuration));
      }

      final sequence = TweenSequence(sequenceItems);

      _tracksToTween[track.name] =
          _TweenData(tween: sequence, maxTime: trackDuration / _maxDuration);
    });
  }

  Duration get duration {
    return Duration(milliseconds: _maxDuration);
  }

  @override
  Map<String, dynamic> transform(double t) {
    final Map<String, dynamic> result = Map();
    _tracksToTween.forEach((name, tweenData) {
      final double tTween = max(0, min(t, tweenData.maxTime - 0.0001));
      result[name] = tweenData.tween.transform(tTween);
    });
    return result;
  }
}

/// Single property to tween. Used by [MultiTrackTween].
class Track<T> {
  final String name;
  final List<_TrackItem> items = [];

  Track(this.name) : assert(name != null, "Track name must not be null.");

  Track<T> add(Duration duration, Animatable<T> tween, {Curve curve}) {
    items.add(_TrackItem(duration, tween, curve: curve));
    return this;
  }
}

class _TrackItem<T> {
  final Duration duration;
  Animatable<T> tween;

  _TrackItem(this.duration, Animatable<T> _tween, {Curve curve})
      : assert(duration != null, "Please set a duration."),
        assert(_tween != null, "Please set a tween.") {
    if (curve != null) {
      tween = _tween.chain(CurveTween(curve: curve));
    } else {
      tween = _tween;
    }
  }
}

class _TweenData<T> {
  final Animatable<T> tween;
  final double maxTime;

  _TweenData({this.tween, this.maxTime});
}

enum Playback {
  /// Animation stands still.
  PAUSE,

  /// Animation plays forwards and stops at the end.
  PLAY_FORWARD,

  /// Animation plays backwards and stops at the beginning.
  PLAY_REVERSE,

  /// Animation will reset to the beginning and start playing forward.
  START_OVER_FORWARD,

  /// Animation will reset to the end and start play backward.
  START_OVER_REVERSE,

  /// Animation will play forwards and start over at the beginning when it
  /// reaches the end.
  LOOP,

  /// Animation will play forward until the end and will reverse playing until
  /// it reaches the beginning. Then it starts over playing forward. And so on.
  MIRROR
}

class ControlledAnimation<T> extends StatefulWidget {
  final Playback playback;
  final Animatable<T> tween;
  final Curve curve;
  final Duration duration;
  final Duration delay;
  final Widget Function(BuildContext buildContext, T animatedValue) builder;
  final Widget Function(BuildContext, Widget child, T animatedValue)
      builderWithChild;
  final Widget child;
  final AnimationStatusListener animationControllerStatusListener;
  final double startPosition;

  ControlledAnimation(
      {this.playback = Playback.PLAY_FORWARD,
      this.tween,
      this.curve = Curves.linear,
      this.duration,
      this.delay,
      this.builder,
      this.builderWithChild,
      this.child,
      this.animationControllerStatusListener,
      this.startPosition = 0.0,
      Key key})
      : assert(duration != null,
            "Please set property duration. Example: Duration(milliseconds: 500)"),
        assert(tween != null,
            "Please set property tween. Example: Tween(from: 0.0, to: 100.0)"),
        assert(
            (builderWithChild != null && child != null && builder == null) ||
                (builder != null && builderWithChild == null && child == null),
            "Either use just builder and keep buildWithChild and child null. "
            "Or keep builder null and set a builderWithChild and a child."),
        assert(
            startPosition >= 0 && startPosition <= 1,
            "The property startPosition "
            "must have a value between 0.0 and 1.0."),
        super(key: key);

  @override
  _ControlledAnimationState<T> createState() => _ControlledAnimationState<T>();
}

class _ControlledAnimationState<T> extends State<ControlledAnimation>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation<T> _animation;
  bool _isDisposed = false;
  bool _waitForDelay = true;
  bool _isCurrentlyMirroring = false;

  @override
  void initState() {
    _controller = AnimationController(vsync: this, duration: widget.duration)
      ..addListener(() {
        setState(() {});
      })
      ..value = widget.startPosition;

    _animation = widget.tween
        .chain(CurveTween(curve: widget.curve))
        .animate(_controller);

    if (widget.animationControllerStatusListener != null) {
      _controller.addStatusListener(widget.animationControllerStatusListener);
    }

    initialize();
    super.initState();
  }

  void initialize() async {
    if (widget.delay != null) {
      await Future.delayed(widget.delay);
    }
    _waitForDelay = false;
    executeInstruction();
  }

  @override
  void didUpdateWidget(ControlledAnimation oldWidget) {
    _controller.duration = widget.duration;
    executeInstruction();
    super.didUpdateWidget(oldWidget);
  }

  void executeInstruction() async {
    if (_isDisposed || _waitForDelay) {
      return;
    }

    if (widget.playback == Playback.PAUSE) {
      _controller.stop();
    }
    if (widget.playback == Playback.PLAY_FORWARD) {
      _controller.forward();
    }
    if (widget.playback == Playback.PLAY_REVERSE) {
      _controller.reverse();
    }
    if (widget.playback == Playback.START_OVER_FORWARD) {
      _controller.forward(from: 0.0);
    }
    if (widget.playback == Playback.START_OVER_REVERSE) {
      _controller.reverse(from: 1.0);
    }
    if (widget.playback == Playback.LOOP) {
      _controller.repeat();
    }
    if (widget.playback == Playback.MIRROR && !_isCurrentlyMirroring) {
      _isCurrentlyMirroring = true;
      _controller.repeat(reverse: true);
    }

    if (widget.playback != Playback.MIRROR) {
      _isCurrentlyMirroring = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.builder != null) {
      return widget.builder(context, _animation.value);
    } else if (widget.builderWithChild != null && widget.child != null) {
      return widget.builderWithChild(context, widget.child, _animation.value);
    }
    _controller.stop(canceled: true);
    throw FlutterError(
        "I don't know how to build the animation. Make sure to either specify "
        "a builder or a builderWithChild (along with a child).");
  }

  @override
  void dispose() {
    _isDisposed = true;
    _controller.dispose();
    super.dispose();
  }
}

class AnimationProgress {
  final Duration duration;
  final Duration startTime;

  AnimationProgress({this.duration, this.startTime})
      : assert(duration != null, "Please specify an animation duration."),
        assert(
            startTime != null, "Please specify a start time of the animation.");
  double progress(Duration time) => max(0.0,
      min((time - startTime).inMilliseconds / duration.inMilliseconds, 1.0));
}
