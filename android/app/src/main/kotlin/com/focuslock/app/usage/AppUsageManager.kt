package com.focuslock.app.usage

import android.app.AppOpsManager
import android.app.usage.UsageStatsManager
import android.content.Context
import android.content.Intent
import android.content.pm.ApplicationInfo
import android.content.pm.PackageManager
import android.os.Build
import android.provider.Settings

data class InstalledApp(
    val packageName: String,
    val appName: String,
    val icon: String?
)

class AppUsageManager(private val context: Context) {

    fun getInstalledApps(): List<InstalledApp> {
        val pm = context.packageManager
        val packages = pm.getInstalledApplications(PackageManager.GET_META_DATA)

        return packages
            .filter { appInfo ->
                (appInfo.flags and ApplicationInfo.FLAG_SYSTEM) == 0 ||
                        isUserInstalledSystemApp(appInfo)
            }
            .map { appInfo ->
                InstalledApp(
                    packageName = appInfo.packageName,
                    appName = pm.getApplicationLabel(appInfo).toString(),
                    icon = null
                )
            }
            .sortedBy { it.appName }
    }

    private fun isUserInstalledSystemApp(appInfo: ApplicationInfo): Boolean {
        return (appInfo.flags and ApplicationInfo.FLAG_SYSTEM) != 0 &&
                (appInfo.flags and ApplicationInfo.FLAG_UPDATED_SYSTEM_APP) != 0
    }

    fun hasUsageStatsPermission(): Boolean {
        val appOps = context.getSystemService(Context.APP_OPS_SERVICE) as AppOpsManager
        val mode = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
            appOps.unsafeCheckOpNoThrow(
                AppOpsManager.OPSTR_GET_USAGE_STATS,
                android.os.Process.myUid(),
                context.packageName
            )
        } else {
            @Suppress("DEPRECATION")
            appOps.checkOpNoThrow(
                AppOpsManager.OPSTR_GET_USAGE_STATS,
                android.os.Process.myUid(),
                context.packageName
            )
        }
        return mode == AppOpsManager.MODE_ALLOWED
    }

    fun openUsageStatsSettings() {
        val intent = Intent(Settings.ACTION_USAGE_ACCESS_SETTINGS)
        intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
        context.startActivity(intent)
    }

    fun openAccessibilitySettings() {
        val intent = Intent(Settings.ACTION_ACCESSIBILITY_SETTINGS)
        intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
        context.startActivity(intent)
    }

    fun getCurrentForegroundApp(): InstalledApp? {
        if (!hasUsageStatsPermission()) return null

        val usageStatsManager = context.getSystemService(Context.USAGE_STATS_SERVICE) as UsageStatsManager
        val endTime = System.currentTimeMillis()
        val beginTime = endTime - 1000 * 60

        val stats = usageStatsManager.queryUsageStats(
            UsageStatsManager.INTERVAL_DAILY,
            beginTime,
            endTime
        )

        if (stats.isNullOrEmpty()) return null

        var currentApp: InstalledApp? = null
        var maxTime = 0L

        for (usageStats in stats) {
            if (usageStats.lastTimeUsed > maxTime) {
                maxTime = usageStats.lastTimeUsed
                try {
                    val pm = context.packageManager
                    val appInfo = pm.getApplicationInfo(usageStats.packageName, 0)
                    currentApp = InstalledApp(
                        packageName = usageStats.packageName,
                        appName = pm.getApplicationLabel(appInfo).toString(),
                        icon = null
                    )
                } catch (e: PackageManager.NameNotFoundException) {
                    // App not found
                }
            }
        }

        return currentApp
    }
}
