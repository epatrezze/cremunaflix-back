/**
 * @file DateTimeUtil
 * @description ISO-8601 formatting helpers for API v1 payloads.
 * @layer Service
 * @patterns Utility
 * @author epatrezze
 * @date 2026-01-27
 */
public without sharing class DateTimeUtil {
    /**
     * @description Formats a Datetime into an ISO-8601 UTC string.
     * @param value Datetime to format.
     * @return ISO-8601 UTC string or null if value is null.
     */
    public static String formatIso(Datetime value) {
        if (value == null) {
            return null;
        }
        return value.formatGMT('yyyy-MM-dd\'T\'HH:mm:ss\'Z\'');
    }
}
