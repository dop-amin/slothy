#!/usr/bin/env python3
"""
FFmpeg Assembly Function Extractor

This script extracts suitable assembly functions from FFmpeg for SLOTHY optimization.
It identifies function boundaries, extracts loops, and creates metadata for tracking.
"""

import re
import os
import json
import argparse
from pathlib import Path
from typing import List, Dict, Tuple, Optional


class FFmpegFunctionExtractor:
    """Extracts assembly functions from FFmpeg source files"""

    def __init__(self, ffmpeg_root: str, output_dir: str):
        self.ffmpeg_root = Path(ffmpeg_root)
        self.output_dir = Path(output_dir)
        self.output_dir.mkdir(parents=True, exist_ok=True)

    def find_aarch64_files(self) -> List[Path]:
        """Find all aarch64 assembly files in FFmpeg"""
        asm_files = []
        for root, dirs, files in os.walk(self.ffmpeg_root):
            for file in files:
                if file.endswith('.S') and 'aarch64' in root:
                    asm_files.append(Path(root) / file)
        return sorted(asm_files)

    def extract_function(self, lines: List[str], start_idx: int) -> Optional[Tuple[str, List[str], int]]:
        """
        Extract a single function from assembly code

        Returns: (function_name, function_lines, end_idx) or None
        """
        # Look for function declaration
        func_match = re.match(r'\s*function\s+(\w+)\s*,?\s*(.*)', lines[start_idx])
        if not func_match:
            return None

        func_name = func_match.group(1)
        func_lines = [lines[start_idx]]

        # Extract until endfunc
        idx = start_idx + 1
        while idx < len(lines):
            line = lines[idx]
            func_lines.append(line)
            if re.match(r'\s*endfunc\s*', line):
                return (func_name, func_lines, idx)
            idx += 1

        return None

    def has_loop(self, lines: List[str]) -> bool:
        """Check if function contains a loop"""
        for line in lines:
            # Look for branch instructions that go back (b.gt, b.ne, etc.)
            if re.search(r'\b(b\.(gt|ge|lt|le|ne|eq|hi|lo|cs|cc|mi|pl|vs|vc|ls|al))\s+\d+b', line):
                return True
            # Look for backward branches to labels
            if re.search(r'\b(b|cbz|cbnz|tbz|tbnz)\s+\d+b', line):
                return True
        return False

    def count_instructions(self, lines: List[str]) -> int:
        """Count actual instructions (excluding labels, directives, comments)"""
        count = 0
        for line in lines:
            stripped = line.strip()
            # Skip empty lines, comments, labels, directives
            if not stripped or stripped.startswith('//') or stripped.startswith('#'):
                continue
            if stripped.endswith(':'):
                continue
            if stripped.startswith('.') or stripped.startswith('function') or stripped.startswith('endfunc'):
                continue
            count += 1
        return count

    def is_suitable_for_optimization(self, func_name: str, func_lines: List[str]) -> bool:
        """
        Determine if a function is suitable for SLOTHY optimization

        Criteria:
        - Contains a loop (more interesting for optimization)
        - Has reasonable size (10-300 instructions)
        - Contains NEON instructions
        """
        instr_count = self.count_instructions(func_lines)

        # Check for minimum size
        if instr_count < 5:
            return False

        # Check for NEON/vector instructions
        has_neon = False
        for line in func_lines:
            if re.search(r'\b(ld\d|st\d|f(add|sub|mul|div|neg|abs|cmp|max|min)|v\d+\.|q\d+)', line):
                has_neon = True
                break

        # Prefer functions with loops and NEON
        has_loop_flag = self.has_loop(func_lines)

        return has_neon or has_loop_flag or instr_count >= 10

    def extract_loop_body(self, func_lines: List[str]) -> Optional[Tuple[str, str, List[str]]]:
        """
        Extract the main loop body from a function

        Returns: (start_label, end_label, loop_lines) or None
        """
        # Find loop start (label followed by instructions, ending with backward branch)
        loop_start_idx = None
        start_label = None

        for idx, line in enumerate(func_lines):
            # Look for numeric label at the start
            label_match = re.match(r'\s*(\d+):\s*$', line)
            if label_match:
                loop_start_idx = idx
                start_label = label_match.group(1)
                # Check if there's a backward branch to this label later
                target = f"{start_label}b"
                for later_line in func_lines[idx:]:
                    if target in later_line:
                        # Found a loop!
                        break
                else:
                    loop_start_idx = None
                    start_label = None

        if loop_start_idx is None:
            return None

        # Extract loop body
        loop_lines = []
        for idx in range(loop_start_idx, len(func_lines)):
            line = func_lines[idx]
            loop_lines.append(line)
            # Stop at backward branch
            if re.search(rf'\bb\.\w+\s+{start_label}b\b', line):
                break

        return (start_label, f"{start_label}_end", loop_lines)

    def save_function(self, source_file: Path, func_name: str, func_lines: List[str],
                     metadata: Dict) -> str:
        """Save extracted function and its metadata"""
        # Create output filename
        rel_path = source_file.relative_to(self.ffmpeg_root)
        safe_name = str(rel_path).replace('/', '_').replace('.S', '')
        output_name = f"{safe_name}_{func_name}"

        # Save assembly
        asm_file = self.output_dir / f"{output_name}.s"
        with open(asm_file, 'w') as f:
            f.write('\n'.join(func_lines))

        # Save metadata
        metadata_file = self.output_dir / f"{output_name}.json"
        with open(metadata_file, 'w') as f:
            json.dump(metadata, f, indent=2)

        return output_name

    def extract_all(self, min_instructions: int = 5, max_files: int = 0) -> Dict[str, Dict]:
        """
        Extract all suitable functions from FFmpeg

        Args:
            min_instructions: Minimum instruction count to consider
            max_files: Maximum number of files to process (0 = all)

        Returns:
            Dictionary of extracted functions with metadata
        """
        asm_files = self.find_aarch64_files()
        if max_files > 0:
            asm_files = asm_files[:max_files]

        extracted_functions = {}

        print(f"Found {len(asm_files)} aarch64 assembly files")

        for asm_file in asm_files:
            print(f"\nProcessing {asm_file.relative_to(self.ffmpeg_root)}...")

            with open(asm_file, 'r', encoding='utf-8', errors='ignore') as f:
                lines = f.readlines()

            idx = 0
            while idx < len(lines):
                result = self.extract_function(lines, idx)
                if result:
                    func_name, func_lines, end_idx = result

                    # Check if suitable for optimization
                    if self.is_suitable_for_optimization(func_name, func_lines):
                        instr_count = self.count_instructions(func_lines)
                        has_loop = self.has_loop(func_lines)

                        print(f"  Found: {func_name} ({instr_count} instructions, loop={has_loop})")

                        # Try to extract loop body
                        loop_info = self.extract_loop_body(func_lines)

                        # Create metadata
                        metadata = {
                            'source_file': str(asm_file.relative_to(self.ffmpeg_root)),
                            'function_name': func_name,
                            'instruction_count': instr_count,
                            'has_loop': has_loop,
                            'line_start': idx,
                            'line_end': end_idx,
                        }

                        if loop_info:
                            metadata['loop_start_label'] = loop_info[0]
                            metadata['loop_end_label'] = loop_info[1]

                        # Save function
                        output_name = self.save_function(asm_file, func_name, func_lines, metadata)
                        extracted_functions[output_name] = metadata

                    idx = end_idx + 1
                else:
                    idx += 1

        # Save summary
        summary_file = self.output_dir / "extraction_summary.json"
        with open(summary_file, 'w') as f:
            json.dump(extracted_functions, f, indent=2)

        print(f"\n{'='*60}")
        print(f"Extraction complete!")
        print(f"Total functions extracted: {len(extracted_functions)}")
        print(f"Output directory: {self.output_dir}")
        print(f"{'='*60}")

        return extracted_functions


def main():
    parser = argparse.ArgumentParser(
        description='Extract assembly functions from FFmpeg for SLOTHY optimization'
    )
    parser.add_argument(
        '--ffmpeg-root',
        type=str,
        default='/tmp/ffmpeg',
        help='Path to FFmpeg source root'
    )
    parser.add_argument(
        '--output-dir',
        type=str,
        default='ffmpeg-slothy-workflow/extracted',
        help='Output directory for extracted functions'
    )
    parser.add_argument(
        '--max-files',
        type=int,
        default=0,
        help='Maximum number of files to process (0 = all)'
    )

    args = parser.parse_args()

    extractor = FFmpegFunctionExtractor(args.ffmpeg_root, args.output_dir)
    extractor.extract_all(max_files=args.max_files)


if __name__ == '__main__':
    main()
