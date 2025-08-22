class PrompterSettings {
  final double speed;
  final double fontSize;
  final bool isMirrored;
  final double startDelay; // в секундах
  
  const PrompterSettings({
    this.speed = 1.0,
    this.fontSize = 18.0,
    this.isMirrored = false,
    this.startDelay = 2.0,
  });
  
  PrompterSettings copyWith({
    double? speed,
    double? fontSize,
    bool? isMirrored,
    double? startDelay,
  }) {
    return PrompterSettings(
      speed: speed ?? this.speed,
      fontSize: fontSize ?? this.fontSize,
      isMirrored: isMirrored ?? this.isMirrored,
      startDelay: startDelay ?? this.startDelay,
    );
  }
  
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is PrompterSettings &&
        other.speed == speed &&
        other.fontSize == fontSize &&
        other.isMirrored == isMirrored &&
        other.startDelay == startDelay;
  }
  
  @override
  int get hashCode => Object.hash(speed, fontSize, isMirrored, startDelay);
  
  @override
  String toString() => 'PrompterSettings(speed: $speed, fontSize: $fontSize, isMirrored: $isMirrored, startDelay: $startDelay)';
}
