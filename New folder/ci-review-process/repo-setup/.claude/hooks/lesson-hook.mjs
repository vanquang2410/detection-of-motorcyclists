#!/usr/bin/env node
/**
 * PostToolUse hook for Edit|Write|MultiEdit — captures lessons from changes.
 * Lightweight: logs file paths changed for session review.
 */
import { readFileSync, appendFileSync, existsSync, mkdirSync } from 'fs';
import { join } from 'path';

const input = readFileSync('/dev/stdin', 'utf-8');

try {
  const data = JSON.parse(input);
  const filePath = data.tool_input?.file_path || data.tool_input?.path || 'unknown';

  const logDir = join(process.cwd(), '.omc', 'logs');
  if (!existsSync(logDir)) {
    mkdirSync(logDir, { recursive: true });
  }

  const logEntry = `[${new Date().toISOString()}] ${data.tool_name}: ${filePath}\n`;
  appendFileSync(join(logDir, 'changes.log'), logEntry);

  // Pass through
  console.log(input);
} catch {
  console.log(input);
}
