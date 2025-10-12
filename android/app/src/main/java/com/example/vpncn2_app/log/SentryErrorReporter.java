// Copyright 2018 The Outline Authors
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

package com.example.vpncn2_app.log;

import android.content.Context;
import android.util.Log;

import java.util.LinkedList;
import java.util.Queue;
import java.util.logging.Handler;
import java.util.logging.LogRecord;

/**
 * Mock SentryErrorReporter - simplified version without Sentry dependency
 * Provides the same interface as the original but uses Android Log instead
 */
public class SentryErrorReporter {
    private static final String TAG = "SentryErrorReporter";
    private static final int MAX_BREADCRUMBS = 50;
    
    // Mock classes to maintain compatibility
    public enum SentryLevel {
        DEBUG, INFO, WARNING, ERROR, FATAL
    }
    
    public static class Breadcrumb {
        private String message;
        private SentryLevel level;
        
        public Breadcrumb(String message) {
            this.message = message;
            this.level = SentryLevel.INFO;
        }
        
        public String getMessage() { return message; }
        public SentryLevel getLevel() { return level; }
        public void setLevel(SentryLevel level) { this.level = level; }
    }
    
    private static Queue<Breadcrumb> breadcrumbsQueue = new LinkedList<>();
    private static boolean isInitialized = false;

    public static void init(Context context) {
        Log.d(TAG, "Mock SentryErrorReporter initialized (Sentry disabled)");
        isInitialized = true;
    }
    
    public static void init(Context context, String apiKey) {
        Log.d(TAG, "Mock SentryErrorReporter initialized with API key (Sentry disabled)");
        isInitialized = true;
    }
    
    public static void send(String uuid) {
        Log.d(TAG, "Mock Sentry send called with UUID: " + uuid);
    }
    
    // Mock log handler for compatibility
    public static final Handler BREADCRUMB_LOG_HANDLER = new Handler() {
        @Override
        public void publish(LogRecord record) {
            if (record != null) {
                Log.d(TAG, "Log handler: " + record.getMessage());
                recordBreadcrumb(record.getMessage(), SentryLevel.INFO);
            }
        }
        
        @Override
        public void flush() {
            // No-op
        }
        
        @Override
        public void close() throws SecurityException {
            // No-op
        }
    };

    public static void reportError(final String msg, final Throwable throwable) {
        Log.e(TAG, "Error reported: " + msg, throwable);
        
        // Record breadcrumb
        recordBreadcrumb(msg, SentryLevel.ERROR);
        if (throwable != null) {
            recordBreadcrumb("Exception: " + throwable.getMessage(), SentryLevel.ERROR);
        }
    }

    public static void reportError(final String msg) {
        Log.e(TAG, "Error reported: " + msg);
        recordBreadcrumb(msg, SentryLevel.ERROR);
    }

    public static void logInfo(final String msg) {
        Log.i(TAG, "Info: " + msg);
        recordBreadcrumb(msg, SentryLevel.INFO);
    }

    public static void logWarning(final String msg) {
        Log.w(TAG, "Warning: " + msg);
        recordBreadcrumb(msg, SentryLevel.WARNING);
    }

    public static void logError(final String msg) {
        Log.e(TAG, "Error: " + msg);
        recordBreadcrumb(msg, SentryLevel.ERROR);
    }

    public static void logDebug(final String msg) {
        Log.d(TAG, "Debug: " + msg);
        recordBreadcrumb(msg, SentryLevel.DEBUG);
    }

    public static void recordBreadcrumb(final String msg, SentryLevel level) {
        final Breadcrumb breadcrumb = new Breadcrumb(msg);
        breadcrumb.setLevel(level);
        addBreadcrumb(breadcrumb);
    }

    public static void recordBreadcrumb(final String msg) {
        final Breadcrumb breadcrumb = new Breadcrumb(msg);
        addBreadcrumb(breadcrumb);
    }

    private static void addBreadcrumb(Breadcrumb breadcrumb) {
        if (!isInitialized) {
            Log.d(TAG, "SentryErrorReporter not initialized, skipping breadcrumb");
            return;
        }
        
        breadcrumbsQueue.add(breadcrumb);
        if (breadcrumbsQueue.size() > MAX_BREADCRUMBS) {
            breadcrumbsQueue.remove();
        }
        
        Log.d(TAG, "Breadcrumb added: " + breadcrumb.getMessage());
    }

    public static boolean isInitialized() {
        return isInitialized;
    }
}