#!/usr/bin/env node
/**
 * SessionStart hook — load project memory.
 * Reads .claude/memory/MEMORY.md and prints key context to stdout
 * so Claude has project awareness from the start.
 */
import { readFileSync, existsSync } from 'fs';
import { join } from 'path';

const memoryPath = join(process.cwd(), '.claude', 'memory', 'MEMORY.md');

if (existsSync(memoryPath)) {
  const content = readFileSync(memoryPath, 'utf-8');
  const lines = content.split('\n').slice(0, 200); // Limit to 200 lines
  console.log(lines.join('\n'));
} else {
  console.log('No project memory found.');
}
