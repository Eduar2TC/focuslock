import 'package:flutter_test/flutter_test.dart';
import 'package:focuslock/features/focus/domain/entities/state_machine.dart';
import 'package:focuslock/features/focus/domain/entities/focus_session.dart';

void main() {
  group('FocusSessionStateMachine', () {
    late FocusSessionStateMachine stateMachine;

    setUp(() {
      stateMachine = FocusSessionStateMachine();
    });

    test('valid transition from idle to preparing', () {
      expect(
        stateMachine.transition(SessionStatus.idle, SessionStatus.preparing),
        SessionStatus.preparing,
      );
    });

    test('valid transition from preparing to running', () {
      expect(
        stateMachine.transition(SessionStatus.preparing, SessionStatus.running),
        SessionStatus.running,
      );
    });

    test('valid transition from preparing to cancelled', () {
      expect(
        stateMachine.transition(SessionStatus.preparing, SessionStatus.cancelled),
        SessionStatus.cancelled,
      );
    });

    test('valid transition from running to paused', () {
      expect(
        stateMachine.transition(SessionStatus.running, SessionStatus.paused),
        SessionStatus.paused,
      );
    });

    test('valid transition from running to completed', () {
      expect(
        stateMachine.transition(SessionStatus.running, SessionStatus.completed),
        SessionStatus.completed,
      );
    });

    test('valid transition from running to cancelled', () {
      expect(
        stateMachine.transition(SessionStatus.running, SessionStatus.cancelled),
        SessionStatus.cancelled,
      );
    });

    test('valid transition from running to interrupted', () {
      expect(
        stateMachine.transition(SessionStatus.running, SessionStatus.interrupted),
        SessionStatus.interrupted,
      );
    });

    test('valid transition from paused to running', () {
      expect(
        stateMachine.transition(SessionStatus.paused, SessionStatus.running),
        SessionStatus.running,
      );
    });

    test('valid transition from paused to cancelled', () {
      expect(
        stateMachine.transition(SessionStatus.paused, SessionStatus.cancelled),
        SessionStatus.cancelled,
      );
    });

    test('valid transition from completed to idle', () {
      expect(
        stateMachine.transition(SessionStatus.completed, SessionStatus.idle),
        SessionStatus.idle,
      );
    });

    test('valid transition from cancelled to idle', () {
      expect(
        stateMachine.transition(SessionStatus.cancelled, SessionStatus.idle),
        SessionStatus.idle,
      );
    });

    test('valid transition from interrupted to idle', () {
      expect(
        stateMachine.transition(SessionStatus.interrupted, SessionStatus.idle),
        SessionStatus.idle,
      );
    });

    test('invalid transition from idle to running throws', () {
      expect(
        () => stateMachine.transition(SessionStatus.idle, SessionStatus.running),
        throwsA(isA<InvalidStateTransition>()),
      );
    });

    test('invalid transition from idle to completed throws', () {
      expect(
        () => stateMachine.transition(SessionStatus.idle, SessionStatus.completed),
        throwsA(isA<InvalidStateTransition>()),
      );
    });

    test('invalid transition from completed to running throws', () {
      expect(
        () => stateMachine.transition(SessionStatus.completed, SessionStatus.running),
        throwsA(isA<InvalidStateTransition>()),
      );
    });

    test('canTransition returns true for valid transitions', () {
      expect(stateMachine.canTransition(SessionStatus.idle, SessionStatus.preparing), true);
      expect(stateMachine.canTransition(SessionStatus.running, SessionStatus.paused), true);
    });

    test('canTransition returns false for invalid transitions', () {
      expect(stateMachine.canTransition(SessionStatus.idle, SessionStatus.running), false);
      expect(stateMachine.canTransition(SessionStatus.completed, SessionStatus.running), false);
    });
  });
}
