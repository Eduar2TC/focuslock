package com.focuslock.app.accessibility

import android.accessibilityservice.AccessibilityService
import android.accessibilityservice.AccessibilityServiceInfo
import android.content.Intent
import android.os.Build
import android.util.Log
import android.view.accessibility.AccessibilityEvent

class FocusAccessibilityService : AccessibilityService() {

    companion object {
        private const val TAG = "FocusAccessibility"
        private var instance: FocusAccessibilityService? = null
        private var blockedPackages: Set<String> = emptySet()
        private var interventionCallback: ((String) -> Unit)? = null

        fun isRunning(): Boolean = instance != null

        fun setBlockedPackages(packages: Set<String>) {
            blockedPackages = packages
        }

        fun setInterventionCallback(callback: (String) -> Unit) {
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
                interventionCallback?.invoke(packageName)
            }
        }
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
