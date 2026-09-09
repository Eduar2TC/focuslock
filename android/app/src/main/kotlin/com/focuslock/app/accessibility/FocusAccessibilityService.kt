package com.focuslock.app.accessibility

import android.accessibilityservice.AccessibilityService
import android.accessibilityservice.AccessibilityServiceInfo
import android.content.ComponentName
import android.content.Context
import android.content.Intent
import android.os.Build
import android.provider.Settings
import android.text.TextUtils
import android.util.Log
import android.view.accessibility.AccessibilityEvent

class FocusAccessibilityService : AccessibilityService() {

    companion object {
        private const val TAG = "FocusAccessibility"
        private var instance: FocusAccessibilityService? = null
        private var blockedPackages: Set<String> = emptySet()
        private var isBlockingActive = false
        private var allowEmergencyExit = false
        private var lastBlockedPackage: String? = null

        fun isRunning(): Boolean = instance != null

        fun getAndClearLastBlockedPackage(): String? {
            val blocked = lastBlockedPackage
            lastBlockedPackage = null
            return blocked
        }

        fun isPermissionGranted(context: Context): Boolean {
            val componentName = ComponentName(context, FocusAccessibilityService::class.java)
            val service = componentName.flattenToShortString()
            val enabledServices = Settings.Secure.getString(
                context.contentResolver,
                Settings.Secure.ENABLED_ACCESSIBILITY_SERVICES
            ) ?: return false
            Log.d(TAG, "Checking permission - expected: $service")
            Log.d(TAG, "Enabled services: $enabledServices")
            val colonSplitter = TextUtils.SimpleStringSplitter(':')
            colonSplitter.setString(enabledServices)
            while (colonSplitter.hasNext()) {
                val componentName = colonSplitter.next()
                Log.d(TAG, "Found service: $componentName")
                if (componentName.equals(service, ignoreCase = true)) {
                    Log.d(TAG, "Permission GRANTED")
                    return true
                }
            }
            Log.d(TAG, "Permission NOT granted")
            return false
        }

        fun setBlockedPackages(packages: Set<String>) {
            blockedPackages = packages
        }

        fun setBlockingActive(active: Boolean) {
            isBlockingActive = active
        }

        fun setAllowEmergencyExit(allowed: Boolean) {
            allowEmergencyExit = allowed
        }
    }

    override fun onAccessibilityEvent(event: AccessibilityEvent?) {
        if (event == null) return
        if (!isBlockingActive) return

        if (event.eventType == AccessibilityEvent.TYPE_WINDOW_STATE_CHANGED ||
            event.eventType == AccessibilityEvent.TYPE_WINDOW_CONTENT_CHANGED) {

            val packageName = event.packageName?.toString() ?: return

            if (packageName == this.packageName) return

            if (blockedPackages.contains(packageName)) {
                Log.d(TAG, "Blocked app detected: $packageName")
                lastBlockedPackage = packageName
                if (!allowEmergencyExit) {
                    navigateToFocusApp()
                }
            }
        }
    }

    private fun navigateToFocusApp() {
        val intent = Intent(this, com.focuslock.app.MainActivity::class.java).apply {
            flags = Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_CLEAR_TOP
        }
        startActivity(intent)
    }

    override fun onInterrupt() {
        Log.d(TAG, "Accessibility service interrupted")
    }

    override fun onServiceConnected() {
        super.onServiceConnected()
        instance = this

        serviceInfo = serviceInfo.apply {
            eventTypes = AccessibilityEvent.TYPE_WINDOW_STATE_CHANGED or
                    AccessibilityEvent.TYPE_WINDOW_CONTENT_CHANGED
            feedbackType = AccessibilityServiceInfo.FEEDBACK_GENERIC
            flags = AccessibilityServiceInfo.FLAG_INCLUDE_NOT_IMPORTANT_VIEWS
            notificationTimeout = 500
        }

        Log.d(TAG, "Accessibility service connected")
    }

    override fun onDestroy() {
        instance = null
        super.onDestroy()
        Log.d(TAG, "Accessibility service destroyed")
    }
}