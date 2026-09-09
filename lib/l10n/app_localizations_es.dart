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
  String get presessionTaskLabel => 'En que vas a trabajar?';

  @override
  String get presessionTaskHint => 'Construir mi app Flutter';

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
  String get focusResume => 'Reanudar';

  @override
  String get focusPause => 'Pausar';

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
  String get appsAppbarTitle => 'Apps Bloqueadas';

  @override
  String get appsPermissionsRequired => 'Permisos Requeridos';

  @override
  String get appsGrantUsageAccess => 'Conceder Acceso de Uso';

  @override
  String get appsGrantAccessibilityAccess => 'Conceder Acceso de Accesibilidad';

  @override
  String get appsEmptyTitle => 'No se encontraron apps';

  @override
  String appsErrorLoad(String error) {
    return 'Error al cargar apps: $error';
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
}
