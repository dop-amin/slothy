#!/usr/bin/env python3
"""
Evaluate Assembly Performance with llvm-mca

This script uses llvm-mca (LLVM Machine Code Analyzer) to evaluate
the performance of original and optimized assembly code.
"""

import re
import json
import subprocess
import argparse
from pathlib import Path
from typing import Dict, Optional, Tuple


class LLVMMCAEvaluator:
    """Evaluates assembly performance using llvm-mca"""

    def __init__(self, extracted_dir: str, optimized_dir: str, results_dir: str):
        self.extracted_dir = Path(extracted_dir)
        self.optimized_dir = Path(optimized_dir)
        self.results_dir = Path(results_dir)
        self.results_dir.mkdir(parents=True, exist_ok=True)

        # Check if llvm-mca is available
        self.llvm_mca_available = self._check_llvm_mca()

    def _check_llvm_mca(self) -> bool:
        """Check if llvm-mca is available"""
        try:
            subprocess.run(['llvm-mca', '--version'],
                          capture_output=True, check=True)
            return True
        except (subprocess.CalledProcessError, FileNotFoundError):
            print("Warning: llvm-mca not found in PATH")
            print("Please install LLVM tools to use performance evaluation")
            return False

    def prepare_asm_for_mca(self, asm_content: str) -> str:
        """
        Prepare assembly for llvm-mca analysis

        Remove function directives and other FFmpeg-specific syntax
        """
        lines = []
        for line in asm_content.split('\n'):
            stripped = line.strip()

            # Skip function/endfunc directives
            if stripped.startswith('function') or stripped.startswith('endfunc'):
                continue

            # Skip export directives
            if 'export=' in stripped:
                continue

            # Keep everything else
            lines.append(line)

        return '\n'.join(lines)

    def run_llvm_mca(self, asm_file: Path, target: str = 'cortex-a55',
                    march: str = 'aarch64') -> Optional[Dict]:
        """
        Run llvm-mca on assembly file

        Returns: dict with performance metrics or None if failed
        """
        if not self.llvm_mca_available:
            return None

        # Read and prepare assembly
        with open(asm_file, 'r') as f:
            asm_content = f.read()

        prepared_asm = self.prepare_asm_for_mca(asm_content)

        # Create temporary file
        temp_file = self.results_dir / f'temp_{asm_file.stem}.s'
        with open(temp_file, 'w') as f:
            f.write(prepared_asm)

        try:
            # Run llvm-mca
            cmd = [
                'llvm-mca',
                '-march=' + march,
                '-mcpu=' + target,
                '-timeline',
                '-timeline-max-iterations=1',
                '-iterations=100',
                str(temp_file)
            ]

            result = subprocess.run(cmd, capture_output=True, text=True, timeout=30)

            # Clean up temp file
            temp_file.unlink()

            if result.returncode != 0:
                return {
                    'status': 'error',
                    'error': result.stderr,
                }

            # Parse output
            metrics = self.parse_llvm_mca_output(result.stdout)
            metrics['status'] = 'success'
            metrics['raw_output'] = result.stdout

            return metrics

        except subprocess.TimeoutExpired:
            if temp_file.exists():
                temp_file.unlink()
            return {'status': 'timeout'}
        except Exception as e:
            if temp_file.exists():
                temp_file.unlink()
            return {'status': 'error', 'error': str(e)}

    def parse_llvm_mca_output(self, output: str) -> Dict:
        """
        Parse llvm-mca output to extract performance metrics

        Returns: dict with metrics
        """
        metrics = {}

        # Parse IPC (Instructions Per Cycle)
        ipc_match = re.search(r'IPC:\s+([\d.]+)', output)
        if ipc_match:
            metrics['ipc'] = float(ipc_match.group(1))

        # Parse Block RThroughput
        throughput_match = re.search(r'Block RThroughput:\s+([\d.]+)', output)
        if throughput_match:
            metrics['block_rthroughput'] = float(throughput_match.group(1))

        # Parse total cycles
        cycles_match = re.search(r'Total Cycles:\s+(\d+)', output)
        if cycles_match:
            metrics['total_cycles'] = int(cycles_match.group(1))

        # Parse total instructions
        instr_match = re.search(r'Total Instructions:\s+(\d+)', output)
        if instr_match:
            metrics['total_instructions'] = int(instr_match.group(1))

        # Parse dispatch width
        dispatch_match = re.search(r'Dispatch Width:\s+(\d+)', output)
        if dispatch_match:
            metrics['dispatch_width'] = int(dispatch_match.group(1))

        # Parse uOps per iteration
        uops_match = re.search(r'uOps Per Cycle:\s+([\d.]+)', output)
        if uops_match:
            metrics['uops_per_cycle'] = float(uops_match.group(1))

        return metrics

    def compare_performance(self, original_metrics: Dict, optimized_metrics: Dict) -> Dict:
        """
        Compare performance between original and optimized versions

        Returns: comparison dict with speedup, etc.
        """
        comparison = {}

        # Calculate speedup based on block throughput (lower is better)
        if 'block_rthroughput' in original_metrics and 'block_rthroughput' in optimized_metrics:
            orig_tput = original_metrics['block_rthroughput']
            opt_tput = optimized_metrics['block_rthroughput']
            if opt_tput > 0:
                comparison['speedup'] = orig_tput / opt_tput
                comparison['throughput_improvement_pct'] = ((orig_tput - opt_tput) / orig_tput) * 100

        # Compare IPC (higher is better)
        if 'ipc' in original_metrics and 'ipc' in optimized_metrics:
            orig_ipc = original_metrics['ipc']
            opt_ipc = optimized_metrics['ipc']
            if orig_ipc > 0:
                comparison['ipc_improvement_pct'] = ((opt_ipc - orig_ipc) / orig_ipc) * 100

        # Compare cycles (lower is better)
        if 'total_cycles' in original_metrics and 'total_cycles' in optimized_metrics:
            orig_cycles = original_metrics['total_cycles']
            opt_cycles = optimized_metrics['total_cycles']
            if orig_cycles > 0:
                comparison['cycle_reduction_pct'] = ((orig_cycles - opt_cycles) / orig_cycles) * 100

        return comparison

    def evaluate_all(self, target: str = 'cortex-a55') -> Dict:
        """
        Evaluate all extracted and optimized functions

        Args:
            target: llvm-mca target (e.g., 'cortex-a55', 'cortex-a72')

        Returns:
            Summary of evaluations
        """
        if not self.llvm_mca_available:
            return {'status': 'llvm_mca_not_available'}

        print(f"Evaluating performance for target: {target}")

        # Find all original extracted functions
        original_files = sorted(self.extracted_dir.glob('*.s'))

        evaluations = []

        for orig_file in original_files:
            # Find corresponding optimized version
            opt_pattern = f"{orig_file.stem}_{target}.s"
            opt_file = self.optimized_dir / opt_pattern

            if not opt_file.exists():
                continue

            func_name = orig_file.stem
            print(f"\nEvaluating: {func_name}")

            # Run llvm-mca on original
            print(f"  Running llvm-mca on original...")
            orig_metrics = self.run_llvm_mca(orig_file, target)

            # Run llvm-mca on optimized
            print(f"  Running llvm-mca on optimized...")
            opt_metrics = self.run_llvm_mca(opt_file, target)

            if orig_metrics and opt_metrics and \
               orig_metrics.get('status') == 'success' and \
               opt_metrics.get('status') == 'success':

                # Compare
                comparison = self.compare_performance(orig_metrics, opt_metrics)

                evaluation = {
                    'function': func_name,
                    'target': target,
                    'original': {k: v for k, v in orig_metrics.items() if k != 'raw_output'},
                    'optimized': {k: v for k, v in opt_metrics.items() if k != 'raw_output'},
                    'comparison': comparison,
                }

                evaluations.append(evaluation)

                # Print summary
                print(f"  Original throughput: {orig_metrics.get('block_rthroughput', 'N/A')}")
                print(f"  Optimized throughput: {opt_metrics.get('block_rthroughput', 'N/A')}")
                if 'speedup' in comparison:
                    print(f"  Speedup: {comparison['speedup']:.2f}x")

                # Save detailed output
                detail_file = self.results_dir / f"{func_name}_{target}_detail.txt"
                with open(detail_file, 'w') as f:
                    f.write("="*70 + "\n")
                    f.write(f"Function: {func_name}\n")
                    f.write(f"Target: {target}\n")
                    f.write("="*70 + "\n\n")
                    f.write("ORIGINAL:\n")
                    f.write("-"*70 + "\n")
                    f.write(orig_metrics.get('raw_output', 'No output'))
                    f.write("\n\n")
                    f.write("OPTIMIZED:\n")
                    f.write("-"*70 + "\n")
                    f.write(opt_metrics.get('raw_output', 'No output'))
                    f.write("\n\n")
                    f.write("COMPARISON:\n")
                    f.write("-"*70 + "\n")
                    f.write(json.dumps(comparison, indent=2))

            else:
                print(f"  Failed to evaluate (orig={orig_metrics.get('status')}, opt={opt_metrics.get('status')})")

        # Save summary
        summary = {
            'target': target,
            'total_evaluated': len(evaluations),
            'evaluations': evaluations,
        }

        # Calculate aggregate statistics
        if evaluations:
            speedups = [e['comparison'].get('speedup', 1.0) for e in evaluations if 'speedup' in e['comparison']]
            if speedups:
                summary['aggregate'] = {
                    'mean_speedup': sum(speedups) / len(speedups),
                    'min_speedup': min(speedups),
                    'max_speedup': max(speedups),
                }

        summary_file = self.results_dir / f'evaluation_summary_{target}.json'
        with open(summary_file, 'w') as f:
            json.dump(summary, f, indent=2)

        print(f"\n{'='*60}")
        print(f"Evaluation complete!")
        print(f"Total evaluated: {len(evaluations)}")
        if 'aggregate' in summary:
            print(f"Mean speedup: {summary['aggregate']['mean_speedup']:.2f}x")
            print(f"Range: {summary['aggregate']['min_speedup']:.2f}x - {summary['aggregate']['max_speedup']:.2f}x")
        print(f"Results saved to: {self.results_dir}")
        print(f"{'='*60}")

        return summary


def main():
    parser = argparse.ArgumentParser(
        description='Evaluate assembly performance using llvm-mca'
    )
    parser.add_argument(
        '--extracted-dir',
        type=str,
        default='ffmpeg-slothy-workflow/extracted',
        help='Directory with extracted functions'
    )
    parser.add_argument(
        '--optimized-dir',
        type=str,
        default='ffmpeg-slothy-workflow/optimized',
        help='Directory with optimized functions'
    )
    parser.add_argument(
        '--results-dir',
        type=str,
        default='ffmpeg-slothy-workflow/results',
        help='Output directory for evaluation results'
    )
    parser.add_argument(
        '--target',
        type=str,
        default='cortex-a55',
        help='llvm-mca target (cortex-a55, cortex-a72)'
    )

    args = parser.parse_args()

    evaluator = LLVMMCAEvaluator(args.extracted_dir, args.optimized_dir, args.results_dir)
    evaluator.evaluate_all(args.target)


if __name__ == '__main__':
    main()
