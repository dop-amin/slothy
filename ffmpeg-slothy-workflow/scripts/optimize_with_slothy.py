#!/usr/bin/env python3
"""
SLOTHY Optimizer for FFmpeg Assembly

This script takes extracted FFmpeg assembly functions and optimizes them
using SLOTHY for different microarchitectures (A55, A72).
"""

import re
import os
import sys
import json
import argparse
import traceback
from pathlib import Path
from typing import Dict, List, Optional, Tuple

# Add SLOTHY to path
sys.path.insert(0, str(Path(__file__).parent.parent.parent))

import slothy
import slothy.targets.aarch64.aarch64_neon as AArch64_Neon
import slothy.targets.aarch64.cortex_a55 as Target_CortexA55
import slothy.targets.aarch64.cortex_a72_frontend as Target_CortexA72


class MissingInstructionError(Exception):
    """Raised when SLOTHY encounters an unknown instruction"""
    def __init__(self, instruction: str, message: str):
        self.instruction = instruction
        super().__init__(message)


class FFmpegSlothyOptimizer:
    """Optimizes FFmpeg assembly using SLOTHY"""

    def __init__(self, extracted_dir: str, optimized_dir: str):
        self.extracted_dir = Path(extracted_dir)
        self.optimized_dir = Path(optimized_dir)
        self.optimized_dir.mkdir(parents=True, exist_ok=True)

        # Track missing instructions
        self.missing_instructions = set()

    def get_target_module(self, target_name: str):
        """Get SLOTHY target module by name"""
        targets = {
            'cortex_a55': Target_CortexA55,
            'cortex_a72': Target_CortexA72,
            'a55': Target_CortexA55,
            'a72': Target_CortexA72,
        }
        return targets.get(target_name.lower(), Target_CortexA55)

    def prepare_assembly_for_slothy(self, asm_lines: List[str], metadata: Dict) -> Tuple[str, Dict]:
        """
        Prepare FFmpeg assembly for SLOTHY processing

        Returns: (prepared_assembly_text, optimization_config)
        """
        prepared_lines = []
        opt_config = {}

        # Extract function name and loop info
        func_name = metadata.get('function_name', 'unknown')
        has_loop = metadata.get('has_loop', False)
        loop_start = metadata.get('loop_start_label')

        # Process each line
        for line in asm_lines:
            stripped = line.strip()

            # Skip function/endfunc directives - SLOTHY doesn't need them
            if stripped.startswith('function') or stripped.startswith('endfunc'):
                continue

            # Keep everything else including labels, instructions, comments
            prepared_lines.append(line)

        # Build optimization config
        if has_loop and loop_start:
            opt_config['has_loop'] = True
            opt_config['loop_label'] = loop_start
        else:
            opt_config['has_loop'] = False

        return '\n'.join(prepared_lines), opt_config

    def detect_missing_instruction(self, error_msg: str) -> Optional[str]:
        """
        Detect missing instruction from SLOTHY error message

        Returns: instruction mnemonic if detected, None otherwise
        """
        # Common patterns in SLOTHY error messages
        patterns = [
            r"Unknown instruction[:\s]+['\"]?(\w+)",
            r"Could not parse instruction[:\s]+['\"]?(\w+)",
            r"Unsupported instruction[:\s]+['\"]?(\w+)",
            r"No match for instruction[:\s]+['\"]?(\w+)",
        ]

        for pattern in patterns:
            match = re.search(pattern, error_msg, re.IGNORECASE)
            if match:
                return match.group(1)

        return None

    def optimize_function(self, func_file: Path, target_name: str,
                         timeout: int = 300) -> Optional[Dict]:
        """
        Optimize a single function with SLOTHY

        Returns: optimization result dict or None if failed
        """
        # Load metadata
        metadata_file = func_file.with_suffix('.json')
        with open(metadata_file, 'r') as f:
            metadata = json.load(f)

        # Load assembly
        with open(func_file, 'r') as f:
            asm_lines = f.readlines()

        func_name = metadata['function_name']
        print(f"\n{'='*60}")
        print(f"Optimizing: {func_name} for {target_name}")
        print(f"{'='*60}")

        try:
            # Prepare assembly
            prepared_asm, opt_config = self.prepare_assembly_for_slothy(asm_lines, metadata)

            # Create temporary file for SLOTHY
            temp_input = self.optimized_dir / f"temp_{func_name}_input.s"
            with open(temp_input, 'w') as f:
                f.write(prepared_asm)

            # Get target module
            target_module = self.get_target_module(target_name)

            # Create SLOTHY instance
            slothy_instance = slothy.Slothy(AArch64_Neon, target_module)

            # Configure SLOTHY
            slothy_instance.config.sw_pipelining.enabled = opt_config.get('has_loop', False)
            slothy_instance.config.variable_size = True
            slothy_instance.config.reserved_regs = ["sp", "x30"]  # Minimal reservations

            # Load source
            slothy_instance.load_source_from_file(str(temp_input))

            # Optimize
            if opt_config.get('has_loop'):
                loop_label = opt_config['loop_label']
                print(f"Optimizing loop starting at label '{loop_label}'")
                slothy_instance.optimize_loop(loop_label)
            else:
                print("Optimizing whole function (no loop detected)")
                # Try to optimize the whole thing
                slothy_instance.optimize()

            # Save optimized version
            output_name = f"{func_file.stem}_{target_name}.s"
            output_file = self.optimized_dir / output_name
            slothy_instance.write_source_to_file(str(output_file))

            # Clean up temp file
            temp_input.unlink()

            result = {
                'status': 'success',
                'function': func_name,
                'target': target_name,
                'output_file': str(output_file),
                'original_instructions': metadata['instruction_count'],
            }

            print(f"✓ Optimization successful!")
            print(f"  Output: {output_file}")

            return result

        except Exception as e:
            error_msg = str(e)
            traceback_str = traceback.format_exc()

            print(f"✗ Optimization failed!")
            print(f"  Error: {error_msg}")

            # Check for missing instruction
            missing_instr = self.detect_missing_instruction(error_msg)
            if missing_instr:
                self.missing_instructions.add(missing_instr)
                print(f"  → Missing instruction: {missing_instr}")

            result = {
                'status': 'failed',
                'function': func_name,
                'target': target_name,
                'error': error_msg,
                'traceback': traceback_str,
            }

            if missing_instr:
                result['missing_instruction'] = missing_instr

            return result

    def optimize_all(self, target_names: List[str], max_functions: int = 0,
                     timeout: int = 300) -> Dict:
        """
        Optimize all extracted functions

        Args:
            target_names: List of target names (e.g., ['a55', 'a72'])
            max_functions: Maximum number of functions to process (0 = all)
            timeout: Timeout per function in seconds

        Returns:
            Summary of optimization results
        """
        # Find all extracted function files
        func_files = sorted(self.extracted_dir.glob('*.s'))
        if max_functions > 0:
            func_files = func_files[:max_functions]

        print(f"Found {len(func_files)} functions to optimize")
        print(f"Targets: {', '.join(target_names)}")

        results = {
            'successful': [],
            'failed': [],
            'missing_instructions': set(),
        }

        for func_file in func_files:
            for target_name in target_names:
                result = self.optimize_function(func_file, target_name, timeout)
                if result:
                    if result['status'] == 'success':
                        results['successful'].append(result)
                    else:
                        results['failed'].append(result)
                        if 'missing_instruction' in result:
                            results['missing_instructions'].add(result['missing_instruction'])

        # Convert set to list for JSON serialization
        results['missing_instructions'] = list(results['missing_instructions'])

        # Save results summary
        summary_file = self.optimized_dir / 'optimization_summary.json'
        with open(summary_file, 'w') as f:
            # Make a JSON-serializable copy
            json_results = {
                'successful': results['successful'],
                'failed': results['failed'],
                'missing_instructions': results['missing_instructions'],
                'stats': {
                    'total_attempts': len(results['successful']) + len(results['failed']),
                    'successful': len(results['successful']),
                    'failed': len(results['failed']),
                }
            }
            json.dump(json_results, f, indent=2)

        # Print summary
        print(f"\n{'='*60}")
        print(f"OPTIMIZATION SUMMARY")
        print(f"{'='*60}")
        print(f"Total functions processed: {len(func_files)}")
        print(f"Successful optimizations: {len(results['successful'])}")
        print(f"Failed optimizations: {len(results['failed'])}")

        if results['missing_instructions']:
            print(f"\nMissing instructions detected:")
            for instr in sorted(results['missing_instructions']):
                print(f"  - {instr}")
            print(f"\nThese instructions need to be added to SLOTHY's architecture model.")

        return results


def main():
    parser = argparse.ArgumentParser(
        description='Optimize FFmpeg assembly functions using SLOTHY'
    )
    parser.add_argument(
        '--extracted-dir',
        type=str,
        default='ffmpeg-slothy-workflow/extracted',
        help='Directory with extracted functions'
    )
    parser.add_argument(
        '--output-dir',
        type=str,
        default='ffmpeg-slothy-workflow/optimized',
        help='Output directory for optimized functions'
    )
    parser.add_argument(
        '--targets',
        type=str,
        default='a55,a72',
        help='Comma-separated list of targets (a55, a72)'
    )
    parser.add_argument(
        '--max-functions',
        type=int,
        default=0,
        help='Maximum number of functions to process (0 = all)'
    )
    parser.add_argument(
        '--timeout',
        type=int,
        default=300,
        help='Timeout per function in seconds'
    )

    args = parser.parse_args()

    target_names = [t.strip() for t in args.targets.split(',')]

    optimizer = FFmpegSlothyOptimizer(args.extracted_dir, args.output_dir)
    results = optimizer.optimize_all(target_names, args.max_functions, args.timeout)

    # Exit with error code if any optimizations failed
    if results['failed']:
        sys.exit(1)


if __name__ == '__main__':
    main()
