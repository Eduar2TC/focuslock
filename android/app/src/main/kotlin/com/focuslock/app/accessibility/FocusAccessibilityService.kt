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
        private var interventionCallback: ((String) -> Unit)? = null

        fun isRunning(): Boolean = instance != null

        fun isPermissionGranted(context: Context): Boolean {
            val service = ComponentName(context, FocusAccessibilityService::class.java).flattenToShortString()
            val enabledServices = Settings.Secure.getString(
                context.contentResolver,
                Settings.Secure.ENABLED_ACCESSIBILITY_SERVICES
            ) ?: return false
            val colonSplitter = TextUtils.SimpleStringSplitter(':')
            colonSplitter.setString(enabledServices)
            while (colonSplitter.hasNext()) {
                val componentName = colonSplitter.next()
                if (componentName.equals(service, ignoreCase = true)) {
                    return true
                }
            }
            return false
        }

        fun setBlockedPackages(packages: Set<String>) {
            blockedPackages = packages
        }

        fun setInterventionCallback(callback: ((String) -> Unit)?) {
            interventionCallback = callback
        }
    }

    override fun onAccessibilityEvent(event: AccessibilityEvent?) {
        if (event == null) return

        if (event.eventType == AccessibilityEvent.TYPE_WINDOW_STATE_CHANGED ||
            event.eventType == AccessibilityEvent.TYPE_WINDOW_CONTENT_CHANGED) {

            val packageName = event.packageName?.toString() ?: return

            if (packageName == this.packageName) return

            if (blockedPackages.contains(packageName)) {
                Log.d(TAG, "Blocked app detected: $packageName")
                // Cerrar la app bloqueada y volver a FocusLock
                interventionCallback?.invoke(packageName)
                navigateToFocusApp()
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
            notificationTimeout = 100
        }

        Log.d(TAG, "Accessibility service connected")
    }

    override fun onDestroy() {
        instance = null
        super.onDestroy()
        Log.d(TAG, "Accessibility service destroyed")
    }
}