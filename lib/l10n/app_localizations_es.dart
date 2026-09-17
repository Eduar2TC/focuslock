// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get app_name => 'FocusLock';

  @override
  String get greetingMorning => 'Buenos dias';

  @override
  String get greetingAfternoon => 'Buenas tardes';

  @override
  String get greetingEvening => 'Buenas noches';

  @override
  String get timeAM => 'a. m.';

  @override
  String get timePM => 'p. m.';

  @override
  String get commonCancel => 'Cancelar';

  @override
  String get commonDelete => 'Eliminar';

  @override
  String get commonEdit => 'Editar';

  @override
  String get commonError => 'Error';

  @override
  String get commonDay => 'dia';

  @override
  String get commonDays => 'dias';

  @override
  String get commonCycles => 'ciclos';

  @override
  String get homeTitle => 'Enfoque de hoy';

  @override
  String get homeStartButton => 'Iniciar Enfoque';

  @override
  String get homeResumeSession => 'Reanudar Sesion';

  @override
  String get homeActiveSession => 'Sesion de enfoque en curso';

  @override
  String get homeStatsButton => 'Estadisticas';

  @override
  String get homeSettingsButton => 'Ajustes';

  @override
  String get homeStatFocusTimeLabel => 'Tiempo enfocado';

  @override
  String get homeStatStreakLabel => 'Racha';

  @override
  String get onboardingStep1Title => 'Bienvenido a FocusLock';

  @override
  String get onboardingStep1Subtitle =>
      'Una herramienta para trabajo profundo, no otra distraccion.';

  @override
  String get onboardingStep2Title => 'Define tu Intencion';

  @override
  String get onboardingStep2Subtitle =>
      'Dinos que quieres lograr. Esto crea compromiso.';

  @override
  String get onboardingStep3Title => 'Configura tu Temporizador';

  @override
  String get onboardingStep3Subtitle =>
      'Elige cuanto tiempo quieres enfocarte. Empieza con 25 minutos.';

  @override
  String get onboardingStep4Title => 'Elige tus Distracciones';

  @override
  String get onboardingStep4Subtitle =>
      'Selecciona las apps que te alejan de tu trabajo.';

  @override
  String get onboardingStep5Title => 'Concede Permisos';

  @override
  String get onboardingStep5Subtitle =>
      'FocusLock los necesita para proteger tu tiempo de enfoque.';

  @override
  String get onboardingStep6Title => 'Estas Listo';

  @override
  String get onboardingStep6Subtitle =>
      'Deja tu telefono y empieza a trabajar. Nosotros nos encargamos del resto.';

  @override
  String get onboardingButtonNext => 'Siguiente';

  @override
  String get onboardingButtonStart => 'Empezar';

  @override
  String get presessionAppbarTitle => 'Nueva Sesion';

  @override
  String get presessionTaskLabel => '¿En qué estás trabajando?';

  @override
  String get presessionTaskHint =>
      'p. ej., Escritura profunda, Sprint de código...';

  @override
  String get presessionDurationLabel => 'Duracion';

  @override
  String presessionDurationSummary(int duration) {
    return 'Se usaran $duration minutos a menos que elijas otra opcion';
  }

  @override
  String get presessionBlockedAppsLabel => 'Apps Bloqueadas';

  @override
  String get presessionNoBlockedApps =>
      'Sin apps bloqueadas. Toca Editar para seleccionar apps.';

  @override
  String get presessionErrorEmptyTask => 'Por favor ingresa una tarea';

  @override
  String get presessionStartButton => 'Iniciar Enfoque';

  @override
  String focusCycleIndicator(int current, int total) {
    return 'Ciclo $current de $total';
  }

  @override
  String get focusBreakTitle => 'Descanso';

  @override
  String get focusSkipBreak => 'Saltar descanso';

  @override
  String get focusResume => 'Reanudar Enfoque';

  @override
  String get focusPause => 'Pausar Sesión';

  @override
  String get focusCancelDialogTitle => 'Cancelar Sesion?';

  @override
  String get focusCancelDialogContent =>
      'Tu progreso se guardara pero la sesion se marcara como cancelada.';

  @override
  String get focusCancelDialogKeepGoing => 'Seguir Enfocado';

  @override
  String get focusCancelDialogConfirm => 'Cancelar Sesion';

  @override
  String get focusExitDialogTitle => 'Abandonar Sesion?';

  @override
  String get focusExitDialogContent =>
      'Tu sesion de enfoque sigue en segundo plano. Puedes reanudarla desde la pantalla principal o la notificacion.';

  @override
  String get focusExitDialogStay => 'Seguir Enfocado';

  @override
  String get focusExitDialogExit => 'Salir al Inicio';

  @override
  String get completionTitleCompleted => 'Sesion Completada';

  @override
  String get completionTitleCancelled => 'Sesion Terminada';

  @override
  String get completionInfoTask => 'Tarea';

  @override
  String get completionInfoScore => 'Puntuacion';

  @override
  String get completionInfoCurrentStreak => 'Racha actual';

  @override
  String get completionEncourage =>
      'Buen trabajo! Cada minuto de enfoque cuenta.';

  @override
  String get completionDoneButton => 'Listo';

  @override
  String get settingsAppbarTitle => 'Ajustes';

  @override
  String get settingsSectionFocus => 'Enfoque';

  @override
  String get settingsFocusDuration => 'Duracion de Enfoque';

  @override
  String get settingsShortBreak => 'Descanso Corto';

  @override
  String get settingsLongBreak => 'Descanso Largo';

  @override
  String get settingsCycles => 'Ciclos';

  @override
  String get settingsSectionBlocking => 'Bloqueo';

  @override
  String get settingsAllowBypassBlocking => 'Permitir saltar bloqueo';

  @override
  String get settingsAllowCancelSession => 'Permitir cancelar sesion';

  @override
  String get settingsSectionNotifications => 'Notificaciones';

  @override
  String get settingsSound => 'Sonido';

  @override
  String get settingsVibration => 'Vibracion';

  @override
  String get settingsSectionData => 'Datos';

  @override
  String get settingsExportData => 'Exportar Datos';

  @override
  String get settingsDeleteHistory => 'Eliminar Historial';

  @override
  String get settingsExportSuccess => 'Datos exportados correctamente';

  @override
  String settingsExportError(String error) {
    return 'Error al exportar: $error';
  }

  @override
  String get settingsDeleteDialogTitle => 'Eliminar Todo el Historial';

  @override
  String get settingsDeleteDialogContent =>
      'Esto eliminara permanentemente todas tus sesiones de enfoque. Esta accion no se puede deshacer.';

  @override
  String get settingsDeleteSuccess => 'Historial eliminado correctamente';

  @override
  String settingsDeleteError(String error) {
    return 'Error al eliminar: $error';
  }

  @override
  String get statsAppbarTitle => 'Estadisticas';

  @override
  String get statsOverviewSection => 'Resumen';

  @override
  String get statsSessionsLabel => 'Sesiones';

  @override
  String statsSessionsValue(int count) {
    return '$count completadas';
  }

  @override
  String get statsSessionsDone => 'Hecho';

  @override
  String get statsTotalFocusTimeLabel => 'Tiempo enfocado';

  @override
  String get statsCurrentStreakLabel => 'Racha actual';

  @override
  String statsCurrentStreakValue(int count) {
    return '$count dias';
  }

  @override
  String get statsTodayLabel => 'Hoy';

  @override
  String statsTodayWithCount(int count) {
    return 'Hoy ($count sesiones)';
  }

  @override
  String get statsEmptyTodayTitle => 'Sin sesiones hoy';

  @override
  String get statsEmptyTodayDescription =>
      'Inicia una sesion de enfoque para ver tu progreso aqui.';

  @override
  String get statsEmptyTodayCta => 'Iniciar Enfoque';

  @override
  String get statsSubtitle => 'Métricas de enfoque y bienestar digital';

  @override
  String get statsPeriodWeek => 'Semana';

  @override
  String get statsPeriodMonth => 'Mes';

  @override
  String statsDeltaToday(String delta) {
    return '$delta vs ayer';
  }

  @override
  String statsDeltaWeek(String delta) {
    return '$delta vs la semana pasada';
  }

  @override
  String statsDeltaMonth(String delta) {
    return '$delta vs el mes pasado';
  }

  @override
  String statsDailyAvg(String value) {
    return 'Promedio diario: $value';
  }

  @override
  String statsCompletionRate(int percent) {
    return '$percent% tasa de finalización';
  }

  @override
  String get statsSuccessRateLabel => 'Tasa de éxito';

  @override
  String get statsSuccessRateSubtitle => 'Modo estricto intacto';

  @override
  String statsPausesUsed(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count usos de pausa',
      one: '$count uso de pausa',
    );
    return '$_temp0';
  }

  @override
  String statsDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'días',
      one: 'día',
    );
    return '$_temp0';
  }

  @override
  String statsBestStreak(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Mejor: $count días',
      one: 'Mejor: $count día',
    );
    return '$_temp0';
  }

  @override
  String get statsFocusChartTitle => 'Tiempo enfocado (horas)';

  @override
  String statsDailyTarget(String target) {
    return 'Meta diaria: $target';
  }

  @override
  String statsTodayChip(String value) {
    return 'Hoy: $value';
  }

  @override
  String statsPeriodTotal(String value) {
    return 'Total: $value';
  }

  @override
  String statsWeeklyTotal(String value) {
    return 'Total semanal: $value';
  }

  @override
  String statsOnTrack(String goal) {
    return 'En camino a la meta de $goal';
  }

  @override
  String get statsInterventionsTitle => 'Intervenciones';

  @override
  String get statsInterventionsSubtitle =>
      'Distracciones evitadas por FocusLock durante las sesiones';

  @override
  String statsInterventionsTotal(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Total',
      one: '$count Total',
    );
    return '$_temp0';
  }

  @override
  String get statsAppBlocking => 'Bloqueando';

  @override
  String get statsBlockedAppsEmpty => 'Aún no se bloquean apps.';

  @override
  String get statsQualityTitle => 'Calidad y patrón de enfoque';

  @override
  String get statsInsightChip => 'Insight';

  @override
  String statsPeakWindow(String start, String end) {
    return 'Ventana de enfoque máxima: $start – $end';
  }

  @override
  String statsInsightBody(int percent) {
    return 'Completas el $percent% de las sesiones iniciadas antes del mediodía.';
  }

  @override
  String get statsConsistencyTitle => 'Puntuación de constancia';

  @override
  String statsConsistencyValue(int score) {
    return '$score / 100';
  }

  @override
  String get appsAppbarTitle => 'Apps Bloqueadas';

  @override
  String get appsPermissionsRequired => 'Permisos Requeridos';

  @override
  String get appsGrantUsageAccess => 'Conceder Acceso de Uso';

  @override
  String get appsGrantAccessibilityAccess => 'Conceder Acceso de Accesibilidad';

  @override
  String get permissionsPageTitle => 'Permisos Requeridos';

  @override
  String get permissionsPageSubtitle =>
      'Una sesión estricta bloquea otras apps. FocusLock necesita estos permisos para funcionar.';

  @override
  String get permissionsUsageStats => 'Acceso de Uso';

  @override
  String get permissionsAccessibility => 'Acceso de Accesibilidad';

  @override
  String get permissionsGranted => 'Concedido';

  @override
  String get permissionsMissing => 'Faltante';

  @override
  String get permissionsAllGranted => 'Todos los permisos concedidos';

  @override
  String get permissionsContinue => 'Continuar';

  @override
  String get presessionErrorRequiresApps =>
      'Añade al menos una app que bloquear antes de comenzar.';

  @override
  String get appsEmptyTitle => 'No se encontraron apps';

  @override
  String appsErrorLoad(String error) {
    return 'Error al cargar apps: $error';
  }

  @override
  String statsErrorLoad(String error) {
    return 'Error al cargar estadísticas: $error';
  }

  @override
  String get notificationSessionActiveTitle => 'Sesion de Enfoque Activa';

  @override
  String notificationSessionActiveBody(String task, int minutes) {
    return '$task - $minutes minutos';
  }

  @override
  String notificationSessionRecoveringBody(String task, int minutes) {
    return '$task - $minutes minutos restantes';
  }

  @override
  String get achievementFirstSessionTitle => 'Primer Paso';

  @override
  String get achievementFirstSessionDescription =>
      'Completa tu primera sesion de enfoque';

  @override
  String get achievementStreak3Title => 'Constante';

  @override
  String get achievementStreak3Description => 'Mantén una racha de 3 dias';

  @override
  String get achievementStreak7Title => 'Dedicado';

  @override
  String get achievementStreak7Description => 'Mantén una racha de 7 dias';

  @override
  String get achievementSessions10Title => 'Enfocado';

  @override
  String get achievementSessions10Description =>
      'Completa 10 sesiones de enfoque';

  @override
  String get achievementSessions50Title => 'Disciplinado';

  @override
  String get achievementSessions50Description =>
      'Completa 50 sesiones de enfoque';

  @override
  String get achievementFocus10hTitle => 'Trabajador Profundo';

  @override
  String get achievementFocus10hDescription =>
      'Acumula 10 horas de tiempo de enfoque';

  @override
  String get navHome => 'Inicio';

  @override
  String get commonClear => 'Limpiar';

  @override
  String get homeCalmMind => 'Mente en calma';

  @override
  String get homeScheduleReady => 'Tu sesión profunda programada está lista.';

  @override
  String homeSessionsCompleted(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count sesiones completadas',
      one: '$count sesión completada',
    );
    return '$_temp0';
  }

  @override
  String homeGoalPercent(int percent) {
    return '$percent% de la meta';
  }

  @override
  String homeStreakLabel(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count días de racha',
      one: '$count día de racha',
    );
    return '$_temp0';
  }

  @override
  String homeBestStreak(int count) {
    return 'Récord: $count días';
  }

  @override
  String get homeStreakActive => 'Activo';

  @override
  String get homeRecentActivity => 'Actividad reciente';

  @override
  String get homeViewAll => 'Ver todo';

  @override
  String get homeRecentEmpty =>
      'Aún no hay sesiones. Inicia tu primera sesión de enfoque.';

  @override
  String get homeRecentCompleted => 'Completada';

  @override
  String get homeRecentCancelled => 'Cancelada';

  @override
  String get presessionSetupChip => 'Configuración de Sesión';

  @override
  String get presessionReadyTitle => '¿Listo para enfocar?';

  @override
  String get presessionReadySubtitle =>
      'Define tu intención y bloquea las distracciones.';

  @override
  String get presessionRequired => 'Obligatorio';

  @override
  String get presessionTaskDefault => 'Construir mi aplicación Flutter';

  @override
  String get presessionCustom => 'Personalizado';

  @override
  String get presessionCustomDuration => 'Duración personalizada';

  @override
  String get presessionCustomSet => 'Establecer duración';

  @override
  String presessionCustomMin(int min) {
    return '$min min';
  }

  @override
  String get presessionMin => 'min';

  @override
  String get presessionAppsToBlock => 'Apps a bloquear';

  @override
  String presessionActiveCount(int count) {
    return '$count activas';
  }

  @override
  String get presessionManage => 'Gestionar';

  @override
  String presessionMoreCount(int count) {
    return '+$count más';
  }

  @override
  String get presessionEnforcementMode => 'Modo de Cumplimiento';

  @override
  String get modeStandard => 'Estándar';

  @override
  String get modeStandardDescription =>
      'Sal cuando lo necesites sin penalización. Registra las salidas intencionales.';

  @override
  String get modeStrict => 'Estricto';

  @override
  String get modeStrictDescription =>
      'Salir cuenta como interrupción. El desbloqueo de emergencia requiere esperar 60 segundos.';

  @override
  String get modeRecommended => 'Recomendado';

  @override
  String presessionStartWithDuration(int min) {
    return 'Iniciar Enfoque ($min min)';
  }

  @override
  String get presessionFaceDownTip =>
      'Poner tu teléfono boca abajo atenuará automáticamente la pantalla.';

  @override
  String get focusModeStrict => 'ENFOQUE ESTRICTO';

  @override
  String get focusModeStandard => 'ENFOQUE ESTÁNDAR';

  @override
  String get focusBreakTime => 'TIEMPO DE DESCANSO';

  @override
  String get focusRestrictedMode => 'MODO RESTRINGIDO';

  @override
  String get focusPausedLabel => 'PAUSADO';

  @override
  String get focusNoAppsBlocked => 'Sin apps bloqueadas';

  @override
  String focusLockedDownCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Teléfono bloqueado • $count apps bloqueadas',
      one: 'Teléfono bloqueado • $count app bloqueada',
    );
    return '$_temp0';
  }

  @override
  String get focusZenPill => 'Deja el teléfono y sumérgete.';

  @override
  String get focusEndSessionEarly => 'Terminar sesión antes de tiempo';

  @override
  String get focusSheetTitle => '¿Romper sesión de enfoque?';

  @override
  String get focusSheetBody => 'Tu racha actual se reiniciará por hoy.';

  @override
  String get focusUnlockPhone => 'Desbloquear Teléfono';

  @override
  String get focusSheetConfirm => 'Terminar sesión';

  @override
  String get blockedDefaultTask => 'Tu sesión de enfoque';

  @override
  String get blockedFallbackApp => 'Esta app';

  @override
  String get blockedInterventionGate => 'Puerta de Intervención';

  @override
  String get blockedStayFocused => 'Mantente enfocado.';

  @override
  String get blockedBreathe =>
      'Respira. Tu yo del futuro te agradecerá terminar esta sesión.';

  @override
  String get blockedYouChose => 'Elegiste enfocarte en';

  @override
  String get blockedDeepWork => 'Trabajo Profundo';

  @override
  String blockedTimeRemaining(String time) {
    return '$time restantes';
  }

  @override
  String blockedSessionTarget(int minutes) {
    return 'Objetivo de sesión: ${minutes}m';
  }

  @override
  String blockedAppIsLocked(String app) {
    return '$app está bloqueada';
  }

  @override
  String get blockedFocusShield => 'Dentro de tu escudo de enfoque';

  @override
  String get blockedStrictActive => 'El Modo Estricto está activo';

  @override
  String get blockedStrictWarning =>
      'Salir de esta sesión antes de tiempo se registrará permanentemente como una interrupción en tu racha semanal.';

  @override
  String get blockedReturnToFocus => 'Volver al enfoque';

  @override
  String get blockedEndSessionAnyway => 'Terminar sesión de todos modos';

  @override
  String get blockedUrges =>
      'Los impulsos alcanzan su punto máximo y desaparecen en 3 minutos';

  @override
  String get blockedBreakStreak => '¿Romper tu racha?';

  @override
  String get blockedBreath =>
      'Estás a solo minutos de asegurar la mejor sesión de enfoque de hoy. Respira lenta y profundamente tres veces en su lugar.';

  @override
  String get blockedKeepGoing => 'Voy a continuar';

  @override
  String get blockedQuitSession => 'Abandonar sesión';
}
