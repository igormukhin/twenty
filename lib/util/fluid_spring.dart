import 'package:flutter/physics.dart';

/// Spring presets used by onboarding entrance animations.
abstract final class FluidSpring {
  const FluidSpring._();

  /// A balanced spring for standard entrance animations.
  static const SpringDescription defaultSpring = SpringDescription(
    mass: 1,
    stiffness: 400,
    damping: 28,
  );

  /// A lighter damping preset for a playful bounce.
  static const SpringDescription bouncy = SpringDescription(
    mass: 1,
    stiffness: 400,
    damping: 14,
  );
}
