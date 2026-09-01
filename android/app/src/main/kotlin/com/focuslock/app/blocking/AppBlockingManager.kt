package com.focuslock.app.blocking

import android.content.Context
import android.content.Intent
import android.util.Log

class AppBlockingManager(private val context: Context) {

    companion object {
        private const val TAG = "AppBlockingManager"
        private var isBlocking = false
        private var blockedPackages = emptyList<String>()
    }

    fun startBlocking(packages: List<String>) {
        blockedPackages = packages
        isBlocking = true
        Log.d(TAG, "Started blocking ${packages.size} apps")
    }

    fun stopBlocking() {
        isBlocking = false
        blockedPackages = emptyList()
        Log.d(TAG, "Stopped blocking")
    }

    fun isAppBlocked(packageName: String): Boolean {
        return isBlocking && blockedPackages.contains(packageName)
    }

    fun navigateToFocusApp() {
        val intent = context.packageManager.getLaunchIntentForPackage(context.packageName)
        if (intent != null) {
            intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_CLEAR_TOP)
            context.startActivity(intent)
        }
    }
}
