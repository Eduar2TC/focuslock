package com.focuslock.app.bridge

import android.app.Activity
import io.flutter.plugin.common.MethodChannel
import com.focuslock.app.accessibility.FocusAccessibilityService
import com.focuslock.app.usage.AppUsageManager
import com.focuslock.app.blocking.AppBlockingManager
import com.focuslock.app.notifications.FocusNotificationManager

class FocusMethodChannel(
    private val activity: Activity,
    private val channel: MethodChannel
) {
    private val usageManager = AppUsageManager(activity)
    private val blockingManager = AppBlockingManager(activity)
    private val notificationManager = FocusNotificationManager(activity)

    fun configure() {
        channel.setMethodCallHandler { call, result ->
            when (call.method) {
                "getInstalledApps" -> {
                    val apps = usageManager.getInstalledApps()
                    result.success(apps.map { app ->
                        mapOf(
                            "packageName" to app.packageName,
                            "appName" to app.appName,
                            "icon" to app.icon
                        )
                    })
                }
                "hasRequiredPermissions" -> {
                    val hasUsage = usageManager.hasUsageStatsPermission()
                    val hasAccessibility = FocusAccessibilityService.isRunning()
                    result.success(mapOf(
                        "usageStats" to hasUsage,
                        "accessibility" to hasAccessibility
                    ))
                }
                "openUsageSettings" -> {
                    usageManager.openUsageStatsSettings()
                    result.success(null)
                }
                "openAccessibilitySettings" -> {
                    usageManager.openAccessibilitySettings()
                    result.success(null)
                }
                "startBlocking" -> {
                    val packages = call.arguments as List<String>
                    blockingManager.startBlocking(packages)
                    result.success(null)
                }
                "stopBlocking" -> {
                    blockingManager.stopBlocking()
                    result.success(null)
                }
                "getCurrentForegroundApp" -> {
                    val app = usageManager.getCurrentForegroundApp()
                    result.success(app?.let {
                        mapOf(
                            "packageName" to it.packageName,
                            "appName" to it.appName
                        )
                    })
                }
                "startForegroundService" -> {
                    val args = call.arguments as Map<String, Any>
                    val title = args["title"] as? String ?: ""
                    val body = args["body"] as? String ?: ""
                    notificationManager.startForegroundService(title, body)
                    result.success(null)
                }
                "updateNotification" -> {
                    val args = call.arguments as Map<String, Any>
                    val title = args["title"] as? String ?: ""
                    val body = args["body"] as? String ?: ""
                    notificationManager.updateNotification(title, body)
                    result.success(null)
                }
                "stopForegroundService" -> {
                    notificationManager.stopForegroundService()
                    result.success(null)
                }
                else -> result.notImplemented()
            }
        }
    }
}
