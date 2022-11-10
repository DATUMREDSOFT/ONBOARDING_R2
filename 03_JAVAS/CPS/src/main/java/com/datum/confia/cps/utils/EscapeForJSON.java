package com.datum.confia.cps.utils;

public class EscapeForJSON {

	
    public static String escapeForJSON(String str) {

        StringBuilder ret = new StringBuilder();
        int idx = 0;

        if (str == null) {
            return null;
        }

        while (idx < str.length()) {
            switch (str.charAt(idx)) {
            case '"':
                ret.append("\\\"");
                break;

            case '\\':
                ret.append("\\\\");
                break;

            case '/':
                ret.append("\\/");
                break;

            case '\b':
                ret.append("\\b");
                break;

            case '\f':
                ret.append("\\f");
                break;

            case '\n':
                ret.append("\\n");
                break;

            case '\r':
                ret.append("\\r");
                break;

            case '\t':
                ret.append("\\t");
                break;

            default:
                ret.append(str.charAt(idx));
                break;

            }

            idx++;
        }

        return ret.toString();
    }
	
}
