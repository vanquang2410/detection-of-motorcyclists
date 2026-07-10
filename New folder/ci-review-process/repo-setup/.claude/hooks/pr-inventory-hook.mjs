#!/usr/bin/env node
/**
 * PreToolUse hook for Bash — tracks PR-related commands.
 * Reads tool input from stdin, logs PR operations for audit trail.
 */
import { readFileSync, appendFileSync, existsSync, mkdirSync } from 'fs';
import { join } from 'path';

const input = readFileSync('/dev/stdin', 'utf-8');

try {
  const data = JSON.parse(input);
  const command = data.tool_input?.command || '';

  // Only track PR-related commands
  if (command.match(/gh\s+(pr|issue)/)) {
    const logDir = join(process.cwd(), '.omc', 'logs');
    if (!existsSync(logDir)) {
      mkdirSync(logDir, { recursive: true });
    }

    const logEntry = `[${new Date().toISOString()}] ${command}\n`;
    appendFileSync(join(logDir, 'pr-inventory.log'), logEntry);
  }

  // Pass through — do not block
  console.log(input);
} catch {
  // On parse error, pass through unchanged
  console.log(input);
}
