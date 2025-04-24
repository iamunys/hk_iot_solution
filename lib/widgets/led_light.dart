import 'package:flutter/material.dart';
import 'package:smart_controller/constant/constant.dart';

class PulsingLEDLight extends StatefulWidget {
  final bool isOn;
  final Color onColor;
  final Color offColor;
  final double size;
  final bool pulse;

  const PulsingLEDLight({
    super.key,
    required this.isOn,
    this.onColor = Colors.green,
    this.offColor = Colors.grey,
    this.size = 50.0,
    required this.pulse,
  });

  @override
  _PulsingLEDLightState createState() => _PulsingLEDLightState();
}

class _PulsingLEDLightState extends State<PulsingLEDLight>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    )..repeat(reverse: true);
    _animation = Tween<double>(begin: 0.5, end: 1.0).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Constant.bgPrimary,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.1),
            offset: const Offset(-3, -3),
            blurRadius: 15,
          ),
          BoxShadow(
            color: Colors.black.withOpacity(.1),
            offset: const Offset(3, 3),
            blurRadius: 15,
          ),
        ],
      ),
      child: widget.pulse
          ? AnimatedBuilder(
              animation: _animation,
              builder: (context, child) {
                return Opacity(
                  opacity: widget.isOn ? _animation.value : 1.0,
                  child: LEDLight(
                    isOn: widget.isOn,
                    onColor: widget.onColor,
                    offColor: widget.offColor,
                    size: widget.size,
                  ),
                );
              },
            )
          : LEDLight(
              isOn: widget.isOn,
              onColor: widget.onColor,
              offColor: widget.offColor,
              size: widget.size,
            ),
    );
  }
}

class LEDLight extends StatelessWidget {
  final bool isOn;
  final Color onColor;
  final Color offColor;
  final double size;

  const LEDLight({
    super.key,
    required this.isOn,
    this.onColor = Colors.green,
    this.offColor = Colors.grey,
    this.size = 50.0,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isOn ? onColor : offColor,
        boxShadow: [
          if (isOn)
            BoxShadow(
              color: onColor.withOpacity(0.6),
              blurRadius: 10,
              spreadRadius: 5,
            ),
        ],
      ),
    );
  }
}
