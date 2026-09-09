package com.focuslock.app.bridge

import android.app.Activity
import android.util.Log
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
            try {
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
                        val hasAccessibility = FocusAccessibilityService.isPermissionGranted(activity) ||
                                FocusAccessibilityService.isRunning()
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
                        val args = call.arguments as? Map<String, Any>
                        if (args == null) {
                            result.error("INVALID_ARGUMENTS", "Expected a map with packages and allowEmergencyExit", null)
                            return@setMethodCallHandler
                        }
                        val packages = args["packages"] as? List<String>
                        if (packages == null) {
                            result.error("INVALID_ARGUMENTS", "Expected a list of package names", null)
                            return@setMethodCallHandler
                        }
                        val allowEmergencyExit = args["allowEmergencyExit"] as? Boolean ?: false
                        blockingManager.startBlocking(packages)
                        FocusAccessibilityService.setBlockedPackages(packages.toSet())
                        FocusAccessibilityService.setBlockingActive(true)
                        FocusAccessibilityService.setAllowEmergencyExit(allowEmergencyExit)
                        result.success(null)
                    }
                    "stopBlocking" -> {
                        blockingManager.stopBlocking()
                        FocusAccessibilityService.setBlockedPackages(emptySet())
                        FocusAccessibilityService.setBlockingActive(false)
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
                    "getLastBlockedAppAttempt" -> {
                        val packageName = FocusAccessibilityService.getAndClearLastBlockedPackage()
                        if (packageName == null) {
                            result.success(null)
                        } else {
                            val appName = try {
                                val pm = activity.packageManager
                                val appInfo = pm.getApplicationInfo(packageName, 0)
                                pm.getApplicationLabel(appInfo).toString()
                            } catch (e: Exception) {
                                packageName
                            }
                            result.success(mapOf(
                                "packageName" to packageName,
                                "appName" to appName
                            ))
                        }
                    }
                    "startForegroundService" -> {
                        val args = call.arguments as? Map<String, Any>
                        if (args == null) {
                            result.error("INVALID_ARGUMENTS", "Expected a map with title and body", null)
                            return@setMethodCallHandler
                        }
                        val title = args["title"] as? String ?: ""
                        val body = args["body"] as? String ?: ""
                        notificationManager.startForegroundService(title, body)
                        result.success(null)
                    }
                    "updateNotification" -> {
                        val args = call.arguments as? Map<String, Any>
                        if (args == null) {
                            result.error("INVALID_ARGUMENTS", "Expected a map with title and body", null)
                            return@setMethodCallHandler
                        }
                        val title = args["title"] as? String ?: ""
                        val body = args["body"] as? String ?: ""
                        notificationManager.updateNotification(title, body)
                        result.success(null)
                    }
                    "stopForegroundService" -> {
                        notificationManager.stopForegroundService()
                        result.success(null)
                    }
                    "playAlert" -> {
                        val args = call.arguments as? Map<String, Any>
                        if (args == null) {
                            result.error("INVALID_ARGUMENTS", "Expected a map with title, body, soundEnabled, vibrationEnabled", null)
                            return@setMethodCallHandler
                        }
                        val title = args["title"] as? String ?: "FocusLock"
                        val body = args["body"] as? String ?: ""
                        val soundEnabled = args["soundEnabled"] as? Boolean ?: true
                        val vibrationEnabled = args["vibrationEnabled"] as? Boolean ?: true
                        notificationManager.playAlert(title, body, soundEnabled, vibrationEnabled)
                        result.success(null)
                    }
                    else -> result.notImplemented()
                }
            } catch (e: Exception) {
                Log.e("FocusMethodChannel", "Error handling method call: ${call.method}", e)
                result.error("NATIVE_ERROR", e.message, e.stackTraceToString())
            }
        }
    }
}
