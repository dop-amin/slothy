#!/usr/bin/env python3
"""
Integrate Optimized Assembly Back to FFmpeg

This script takes SLOTHY-optimized assembly and integrates it back into
the original FFmpeg source files, preserving the original structure.
"""

import re
import json
import shutil
import argparse
from pathlib import Path
from typing import Dict, List, Optional


class FFmpegIntegrator:
    """Integrates optimized assembly back into FFmpeg source"""

    def __init__(self, ffmpeg_root: str, optimized_dir: str, output_dir: str):
        self.ffmpeg_root = Path(ffmpeg_root)
        self.optimized_dir = Path(optimized_dir)
        self.output_dir = Path(output_dir)
        self.output_dir.mkdir(parents=True, exist_ok=True)

    def create_optimized_ffmpeg(self, target: str) -> Dict:
        """
        Create a version of FFmpeg with optimized assembly

        Args:
            target: Target architecture (e.g., 'a55', 'a72')

        Returns:
            Summary of changes made
        """
        # Find all optimized functions for this target
        optimized_files = list(self.optimized_dir.glob(f'*_{target}.s'))

        if not optimized_files:
            print(f"No optimized files found for target '{target}'")
            return {'status': 'no_files', 'target': target}

        print(f"Found {len(optimized_files)} optimized functions for {target}")

        # Create output directory for this target
        target_output = self.output_dir / target
        target_output.mkdir(parents=True, exist_ok=True)

        # Copy FFmpeg source to output
        print(f"Copying FFmpeg source to {target_output}...")
        if (target_output / 'ffmpeg').exists():
            shutil.rmtree(target_output / 'ffmpeg')
        shutil.copytree(self.ffmpeg_root, target_output / 'ffmpeg',
                       ignore=shutil.ignore_patterns('*.o', '*.a', '.git'))

        changes = []

        # Process each optimized function
        for opt_file in optimized_files:
            # Load metadata from original extraction
            metadata_pattern = opt_file.stem.rsplit('_', 1)[0]  # Remove _a55 or _a72
            metadata_file = self.optimized_dir.parent / 'extracted' / f'{metadata_pattern}.json'

            if not metadata_file.exists():
                print(f"Warning: Metadata not found for {opt_file.name}")
                continue

            with open(metadata_file, 'r') as f:
                metadata = json.load(f)

            # Get source file location
            source_file = self.ffmpeg_root / metadata['source_file']
            output_file = target_output / 'ffmpeg' / metadata['source_file']

            # Read optimized assembly
            with open(opt_file, 'r') as f:
                optimized_asm = f.read()

            # Integrate into source file
            result = self.replace_function_in_file(
                output_file, metadata, optimized_asm
            )

            if result['success']:
                changes.append({
                    'file': metadata['source_file'],
                    'function': metadata['function_name'],
                    'status': 'replaced'
                })
                print(f"  ✓ Replaced {metadata['function_name']} in {metadata['source_file']}")
            else:
                changes.append({
                    'file': metadata['source_file'],
                    'function': metadata['function_name'],
                    'status': 'failed',
                    'error': result.get('error', 'Unknown error')
                })
                print(f"  ✗ Failed to replace {metadata['function_name']}: {result.get('error')}")

        # Save integration summary
        summary = {
            'target': target,
            'total_functions': len(optimized_files),
            'successful': sum(1 for c in changes if c['status'] == 'replaced'),
            'failed': sum(1 for c in changes if c['status'] == 'failed'),
            'changes': changes,
        }

        summary_file = target_output / 'integration_summary.json'
        with open(summary_file, 'w') as f:
            json.dump(summary, f, indent=2)

        print(f"\n{'='*60}")
        print(f"Integration summary for {target}:")
        print(f"  Total: {summary['total_functions']}")
        print(f"  Successful: {summary['successful']}")
        print(f"  Failed: {summary['failed']}")
        print(f"  Output: {target_output}")
        print(f"{'='*60}")

        return summary

    def replace_function_in_file(self, file_path: Path, metadata: Dict,
                                 optimized_asm: str) -> Dict:
        """
        Replace a function in an assembly file with optimized version

        Returns: dict with 'success' and optional 'error'
        """
        try:
            # Read original file
            with open(file_path, 'r', encoding='utf-8', errors='ignore') as f:
                lines = f.readlines()

            func_name = metadata['function_name']
            line_start = metadata['line_start']
            line_end = metadata['line_end']

            # Validate line numbers
            if line_start >= len(lines) or line_end >= len(lines):
                return {
                    'success': False,
                    'error': f'Line numbers out of range: {line_start}-{line_end} in {len(lines)} lines'
                }

            # Build new file content
            new_lines = []

            # Lines before function
            new_lines.extend(lines[:line_start])

            # Add optimized function with proper function/endfunc wrapper
            new_lines.append(f"function {func_name}, export=1\n")

            # Add optimized assembly (remove any function/endfunc from SLOTHY output)
            opt_lines = optimized_asm.split('\n')
            for line in opt_lines:
                stripped = line.strip()
                if stripped and not stripped.startswith('function') and not stripped.startswith('endfunc'):
                    new_lines.append(line + '\n')

            new_lines.append("endfunc\n")

            # Lines after function
            new_lines.extend(lines[line_end + 1:])

            # Write back
            with open(file_path, 'w') as f:
                f.writelines(new_lines)

            return {'success': True}

        except Exception as e:
            return {'success': False, 'error': str(e)}


def main():
    parser = argparse.ArgumentParser(
        description='Integrate SLOTHY-optimized assembly back into FFmpeg'
    )
    parser.add_argument(
        '--ffmpeg-root',
        type=str,
        default='/tmp/ffmpeg',
        help='Path to FFmpeg source root'
    )
    parser.add_argument(
        '--optimized-dir',
        type=str,
        default='ffmpeg-slothy-workflow/optimized',
        help='Directory with optimized functions'
    )
    parser.add_argument(
        '--output-dir',
        type=str,
        default='ffmpeg-slothy-workflow/integrated',
        help='Output directory for integrated FFmpeg'
    )
    parser.add_argument(
        '--target',
        type=str,
        required=True,
        help='Target architecture (e.g., a55, a72)'
    )

    args = parser.parse_args()

    integrator = FFmpegIntegrator(args.ffmpeg_root, args.optimized_dir, args.output_dir)
    summary = integrator.create_optimized_ffmpeg(args.target)

    # Exit with error if integration failed
    if summary.get('failed', 0) > 0:
        print("\nWarning: Some functions failed to integrate")


if __name__ == '__main__':
    main()
