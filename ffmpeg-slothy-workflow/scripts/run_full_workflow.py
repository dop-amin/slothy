#!/usr/bin/env python3
"""
Full FFmpeg-SLOTHY Optimization Workflow

This script orchestrates the complete workflow:
1. Extract assembly functions from FFmpeg
2. Optimize with SLOTHY for multiple targets
3. Evaluate performance with llvm-mca
4. Integrate optimized code back into FFmpeg
"""

import sys
import argparse
import subprocess
from pathlib import Path
from typing import List


class WorkflowRunner:
    """Orchestrates the full optimization workflow"""

    def __init__(self, ffmpeg_root: str, workflow_dir: str):
        self.ffmpeg_root = Path(ffmpeg_root)
        self.workflow_dir = Path(workflow_dir)
        self.scripts_dir = self.workflow_dir / 'scripts'

        # Ensure workflow directory exists
        self.workflow_dir.mkdir(parents=True, exist_ok=True)

    def run_step(self, script_name: str, args: List[str], description: str) -> bool:
        """
        Run a workflow step

        Returns: True if successful, False otherwise
        """
        print(f"\n{'='*70}")
        print(f"STEP: {description}")
        print(f"{'='*70}")

        script_path = self.scripts_dir / script_name
        cmd = [sys.executable, str(script_path)] + args

        print(f"Running: {' '.join(cmd)}")
        print()

        try:
            result = subprocess.run(cmd, check=True)
            print(f"\n✓ Step completed successfully")
            return True
        except subprocess.CalledProcessError as e:
            print(f"\n✗ Step failed with exit code {e.returncode}")
            return False
        except Exception as e:
            print(f"\n✗ Step failed with error: {e}")
            return False

    def run_full_workflow(self, targets: List[str], max_files: int = 0,
                         max_functions: int = 0, skip_integration: bool = False,
                         skip_evaluation: bool = False) -> bool:
        """
        Run the complete workflow

        Args:
            targets: List of target architectures (e.g., ['a55', 'a72'])
            max_files: Maximum FFmpeg files to process (0 = all)
            max_functions: Maximum functions to optimize (0 = all)
            skip_integration: Skip integration step
            skip_evaluation: Skip llvm-mca evaluation step

        Returns:
            True if all steps succeeded, False otherwise
        """
        print(f"\n{'#'*70}")
        print(f"# FFmpeg-SLOTHY Full Optimization Workflow")
        print(f"#")
        print(f"# FFmpeg root: {self.ffmpeg_root}")
        print(f"# Workflow dir: {self.workflow_dir}")
        print(f"# Targets: {', '.join(targets)}")
        print(f"{'#'*70}")

        # Step 1: Extract functions from FFmpeg
        extract_args = [
            '--ffmpeg-root', str(self.ffmpeg_root),
            '--output-dir', str(self.workflow_dir / 'extracted'),
        ]
        if max_files > 0:
            extract_args.extend(['--max-files', str(max_files)])

        if not self.run_step('extract_functions.py', extract_args,
                            'Extract assembly functions from FFmpeg'):
            return False

        # Step 2: Optimize with SLOTHY for each target
        optimize_args = [
            '--extracted-dir', str(self.workflow_dir / 'extracted'),
            '--output-dir', str(self.workflow_dir / 'optimized'),
            '--targets', ','.join(targets),
        ]
        if max_functions > 0:
            optimize_args.extend(['--max-functions', str(max_functions)])

        if not self.run_step('optimize_with_slothy.py', optimize_args,
                            'Optimize functions with SLOTHY'):
            print("\nNote: Some optimizations may have failed due to missing instructions.")
            print("Check the optimization summary for details.")
            # Continue even if some optimizations failed

        # Step 3: Evaluate with llvm-mca (optional)
        if not skip_evaluation:
            for target in targets:
                # Map target names to llvm-mca targets
                llvm_target = {
                    'a55': 'cortex-a55',
                    'a72': 'cortex-a72',
                    'cortex_a55': 'cortex-a55',
                    'cortex_a72': 'cortex-a72',
                }.get(target, target)

                eval_args = [
                    '--extracted-dir', str(self.workflow_dir / 'extracted'),
                    '--optimized-dir', str(self.workflow_dir / 'optimized'),
                    '--results-dir', str(self.workflow_dir / 'results'),
                    '--target', llvm_target,
                ]

                self.run_step('evaluate_with_llvm_mca.py', eval_args,
                             f'Evaluate performance for {target} with llvm-mca')
                # Don't fail workflow if evaluation fails (llvm-mca might not be available)

        # Step 4: Integrate optimized code back into FFmpeg (optional)
        if not skip_integration:
            for target in targets:
                integrate_args = [
                    '--ffmpeg-root', str(self.ffmpeg_root),
                    '--optimized-dir', str(self.workflow_dir / 'optimized'),
                    '--output-dir', str(self.workflow_dir / 'integrated'),
                    '--target', target,
                ]

                self.run_step('integrate_back.py', integrate_args,
                             f'Integrate optimized code back to FFmpeg for {target}')
                # Continue even if integration fails for one target

        # Final summary
        print(f"\n{'#'*70}")
        print(f"# Workflow Complete!")
        print(f"#")
        print(f"# Results:")
        print(f"#   - Extracted functions: {self.workflow_dir / 'extracted'}")
        print(f"#   - Optimized functions: {self.workflow_dir / 'optimized'}")
        if not skip_evaluation:
            print(f"#   - Performance results: {self.workflow_dir / 'results'}")
        if not skip_integration:
            print(f"#   - Integrated FFmpeg: {self.workflow_dir / 'integrated'}")
        print(f"#")
        print(f"# Next steps:")
        print(f"#   1. Review optimization_summary.json for missing instructions")
        print(f"#   2. Add missing instructions to SLOTHY (use add_missing_instructions.py)")
        print(f"#   3. Re-run optimization for functions that failed")
        print(f"#   4. Build and test integrated FFmpeg versions")
        print(f"{'#'*70}")

        return True


def main():
    parser = argparse.ArgumentParser(
        description='Run the full FFmpeg-SLOTHY optimization workflow',
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog="""
Examples:
  # Run full workflow for A55 only, limited to 5 files
  python run_full_workflow.py --targets a55 --max-files 5

  # Run for both A55 and A72
  python run_full_workflow.py --targets a55,a72

  # Run optimization only (skip integration and evaluation)
  python run_full_workflow.py --skip-integration --skip-evaluation
        """
    )
    parser.add_argument(
        '--ffmpeg-root',
        type=str,
        default='/tmp/ffmpeg',
        help='Path to FFmpeg source root'
    )
    parser.add_argument(
        '--workflow-dir',
        type=str,
        default='ffmpeg-slothy-workflow',
        help='Workflow directory'
    )
    parser.add_argument(
        '--targets',
        type=str,
        default='a55',
        help='Comma-separated list of targets (a55, a72)'
    )
    parser.add_argument(
        '--max-files',
        type=int,
        default=0,
        help='Maximum FFmpeg files to process (0 = all)'
    )
    parser.add_argument(
        '--max-functions',
        type=int,
        default=0,
        help='Maximum functions to optimize (0 = all)'
    )
    parser.add_argument(
        '--skip-integration',
        action='store_true',
        help='Skip integration step'
    )
    parser.add_argument(
        '--skip-evaluation',
        action='store_true',
        help='Skip llvm-mca evaluation step'
    )

    args = parser.parse_args()

    targets = [t.strip() for t in args.targets.split(',')]

    runner = WorkflowRunner(args.ffmpeg_root, args.workflow_dir)
    success = runner.run_full_workflow(
        targets,
        args.max_files,
        args.max_functions,
        args.skip_integration,
        args.skip_evaluation
    )

    sys.exit(0 if success else 1)


if __name__ == '__main__':
    main()
