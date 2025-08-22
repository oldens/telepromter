class PrompterSettings {
  final double speed;
  final double fontSize;
  final bool isMirrored;
  
  const PrompterSettings({
    this.speed = 1.0,
    this.fontSize = 18.0,
    this.isMirrored = false,
  });
  
  PrompterSettings copyWith({
    double? speed,
    double? fontSize,
    bool? isMirrored,
  }) {
    return PrompterSettings(
      speed: speed ?? this.speed,
      fontSize: fontSize ?? this.fontSize,
      isMirrored: isMirrored ?? this.isMirrored,
    );
  }
  
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is PrompterSettings &&
        other.speed == speed &&
        other.fontSize == fontSize &&
        other.isMirrored == isMirrored;
  }
  
  @override
  int get hashCode => Object.hash(speed, fontSize, isMirrored);
  
  @override
  String toString() => 'PrompterSettings(speed: $speed, fontSize: $fontSize, isMirrored: $isMirrored)';
}
