# FFmpeg-SLOTHY Optimization Workflow

A modular workflow for optimizing FFmpeg's aarch64 assembly code using SLOTHY (Super Lazy Optimization of Tricky Handwritten assemblY).

## Overview

This workflow allows you to:
1. **Extract** suitable assembly functions from FFmpeg
2. **Optimize** them using SLOTHY for different microarchitectures (A55, A72)
3. **Evaluate** performance improvements using llvm-mca
4. **Integrate** optimized code back into FFmpeg

The workflow is designed to be modular and external to FFmpeg's build system, making it easy to experiment with optimizations without modifying the FFmpeg toolchain.

## Directory Structure

```
ffmpeg-slothy-workflow/
├── scripts/
│   ├── extract_functions.py         # Extract assembly from FFmpeg
│   ├── optimize_with_slothy.py      # Run SLOTHY optimization
│   ├── add_missing_instructions.py  # Helper for missing instructions
│   ├── integrate_back.py            # Integrate optimized code back
│   ├── evaluate_with_llvm_mca.py    # Performance evaluation
│   └── run_full_workflow.py         # Master orchestration script
├── extracted/                       # Extracted functions (generated)
├── optimized/                       # SLOTHY-optimized functions (generated)
├── results/                         # Performance evaluation results (generated)
└── integrated/                      # FFmpeg with optimized code (generated)
```

## Prerequisites

### Required
- Python 3.9+
- SLOTHY (this repository)
- FFmpeg source code

### Optional (for evaluation)
- LLVM tools (llvm-mca) for performance analysis

### Installation

1. Ensure SLOTHY dependencies are installed:
   ```bash
   pip install -r requirements.txt
   ```

2. Clone FFmpeg (if not already done):
   ```bash
   git clone https://github.com/FFmpeg/FFmpeg.git /tmp/ffmpeg
   ```

3. Make scripts executable:
   ```bash
   chmod +x ffmpeg-slothy-workflow/scripts/*.py
   ```

## Quick Start

### Run Full Workflow (Simple)

```bash
# Run full workflow for Cortex-A55 (limited to 3 files for testing)
python ffmpeg-slothy-workflow/scripts/run_full_workflow.py \
    --targets a55 \
    --max-files 3 \
    --skip-integration

# Run for both A55 and A72
python ffmpeg-slothy-workflow/scripts/run_full_workflow.py \
    --targets a55,a72 \
    --max-files 3
```

### Step-by-Step Workflow

#### Step 1: Extract Functions

```bash
python ffmpeg-slothy-workflow/scripts/extract_functions.py \
    --ffmpeg-root /tmp/ffmpeg \
    --output-dir ffmpeg-slothy-workflow/extracted \
    --max-files 5  # Process only first 5 files for testing
```

This will:
- Scan FFmpeg for aarch64 assembly files
- Extract functions suitable for optimization
- Save them to `extracted/` with metadata

#### Step 2: Optimize with SLOTHY

```bash
python ffmpeg-slothy-workflow/scripts/optimize_with_slothy.py \
    --extracted-dir ffmpeg-slothy-workflow/extracted \
    --output-dir ffmpeg-slothy-workflow/optimized \
    --targets a55,a72 \
    --max-functions 5  # Process only 5 functions for testing
```

This will:
- Load extracted functions
- Optimize for each target (A55, A72)
- Save optimized versions to `optimized/`
- Generate `optimization_summary.json` with results

**Note:** Some functions may fail due to missing instructions in SLOTHY's model. See "Handling Missing Instructions" below.

#### Step 3: Evaluate Performance (Optional)

```bash
# For Cortex-A55
python ffmpeg-slothy-workflow/scripts/evaluate_with_llvm_mca.py \
    --extracted-dir ffmpeg-slothy-workflow/extracted \
    --optimized-dir ffmpeg-slothy-workflow/optimized \
    --results-dir ffmpeg-slothy-workflow/results \
    --target cortex-a55

# For Cortex-A72
python ffmpeg-slothy-workflow/scripts/evaluate_with_llvm_mca.py \
    --target cortex-a72
```

This will:
- Run llvm-mca on original and optimized versions
- Compare performance metrics
- Generate detailed reports in `results/`

**Metrics evaluated:**
- IPC (Instructions Per Cycle)
- Block RThroughput (cycles per iteration)
- Total Cycles
- Speedup

**Note:** llvm-mca results are approximations and may not reflect real hardware performance accurately.

#### Step 4: Integrate Back to FFmpeg (Optional)

```bash
python ffmpeg-slothy-workflow/scripts/integrate_back.py \
    --ffmpeg-root /tmp/ffmpeg \
    --optimized-dir ffmpeg-slothy-workflow/optimized \
    --output-dir ffmpeg-slothy-workflow/integrated \
    --target a55
```

This will:
- Create a copy of FFmpeg in `integrated/a55/ffmpeg/`
- Replace original functions with optimized versions
- Preserve FFmpeg's structure and build system

You can then build and test this version:
```bash
cd ffmpeg-slothy-workflow/integrated/a55/ffmpeg
./configure --arch=aarch64
make
make check  # Run tests if available
```

## Handling Missing Instructions

If SLOTHY encounters unknown instructions, the workflow will:
1. Log them in `optimization_summary.json`
2. Print a list of missing instructions

### Add Missing Instructions to SLOTHY

Use the helper script to analyze and generate code for missing instructions:

```bash
python ffmpeg-slothy-workflow/scripts/add_missing_instructions.py \
    faddp fabd fmaxnm \
    --slothy-arch-file slothy/targets/aarch64/aarch64_neon.py \
    --output missing_instructions_analysis.txt
```

This will:
- Categorize each instruction (load, store, arithmetic, etc.)
- Estimate latency and throughput based on category
- Find similar instructions already in SLOTHY
- Generate Python code stubs
- Provide ARM Software Optimization Guide references

**Next steps:**
1. Review the generated analysis
2. Verify latency/throughput from ARM SWOG:
   - [Cortex-A55 SWOG](https://developer.arm.com/documentation/epm128372/latest/)
   - [Cortex-A72 SWOG](https://developer.arm.com/documentation/uan0016/latest/)
3. Add instruction definitions to `slothy/targets/aarch64/aarch64_neon.py`
4. Add latency/throughput to `slothy/targets/aarch64/cortex_a55.py` (and/or `cortex_a72_frontend.py`)
5. Re-run optimization

### Example: Adding a Floating-Point Instruction

For instruction `faddp` (floating-point add pairwise):

1. Analyze it:
   ```bash
   python scripts/add_missing_instructions.py faddp
   ```

2. Review ARM SWOG for actual latency/throughput

3. Add to `aarch64_neon.py`:
   ```python
   # Floating-point add pairwise
   faddp = AArch64Instruction(
       "faddp <Vd>.<T>, <Vn>.<T>, <Vm>.<T>",
       ...
   )
   ```

4. Add to `cortex_a55.py`:
   ```python
   execution_units = {
       ...
       faddp: [[ExecutionUnit.VEC0, ExecutionUnit.VEC1]],
   }

   inverse_throughput = {
       ...
       faddp: 1,
   }

   default_latencies = {
       ...
       faddp: 3,  # From ARM SWOG
   }
   ```

## Output Files

### extraction_summary.json
Lists all extracted functions with metadata:
```json
{
  "libavcodec_aarch64_aacpsdsp_neon_ff_ps_add_squares_neon": {
    "source_file": "libavcodec/aarch64/aacpsdsp_neon.S",
    "function_name": "ff_ps_add_squares_neon",
    "instruction_count": 10,
    "has_loop": true,
    "loop_start_label": "1"
  }
}
```

### optimization_summary.json
Results of SLOTHY optimization:
```json
{
  "successful": [
    {
      "status": "success",
      "function": "ff_ps_add_squares_neon",
      "target": "a55",
      "output_file": "optimized/..._a55.s"
    }
  ],
  "failed": [...],
  "missing_instructions": ["faddp", "fabd"],
  "stats": {
    "total_attempts": 20,
    "successful": 15,
    "failed": 5
  }
}
```

### evaluation_summary_cortex-a55.json
Performance evaluation results:
```json
{
  "target": "cortex-a55",
  "evaluations": [
    {
      "function": "ff_ps_add_squares_neon",
      "comparison": {
        "speedup": 1.15,
        "throughput_improvement_pct": 13.04,
        "ipc_improvement_pct": 15.2
      }
    }
  ],
  "aggregate": {
    "mean_speedup": 1.12,
    "min_speedup": 1.01,
    "max_speedup": 1.35
  }
}
```

## Workflow Parameters

### Common Parameters

| Parameter | Default | Description |
|-----------|---------|-------------|
| `--ffmpeg-root` | `/tmp/ffmpeg` | Path to FFmpeg source |
| `--max-files` | 0 (all) | Limit number of files to process |
| `--max-functions` | 0 (all) | Limit number of functions to optimize |
| `--targets` | `a55` | Comma-separated targets (a55, a72) |

### Optimization Parameters

| Parameter | Default | Description |
|-----------|---------|-------------|
| `--timeout` | 300 | Timeout per function (seconds) |

### Integration Parameters

| Parameter | Description |
|-----------|-------------|
| `--target` | Target architecture (required for integration) |

## Performance Notes

### SLOTHY Performance
- Functions < 50 instructions: seconds to minutes
- Functions 50-150 instructions: minutes to hours
- Functions > 150 instructions: may require heuristics

### Recommended Testing Strategy
1. Start with `--max-files 3` for quick testing
2. Increase gradually based on results
3. Use `--max-functions 10` to limit optimization time

## Troubleshooting

### Problem: SLOTHY Optimization Fails

**Check:**
1. `optimization_summary.json` for missing instructions
2. Use `add_missing_instructions.py` to analyze and add them
3. Check SLOTHY logs for other errors

### Problem: llvm-mca Not Found

**Solution:**
```bash
# Install LLVM tools
sudo apt-get install llvm  # Ubuntu/Debian
brew install llvm          # macOS
```

Or skip evaluation:
```bash
python scripts/run_full_workflow.py --skip-evaluation
```

### Problem: Integration Fails

**Check:**
1. `integration_summary.json` for specific errors
2. Verify original FFmpeg source is unmodified
3. Check file permissions

## Architecture Support

Currently supported targets:
- **cortex_a55** (Cortex-A55): Full support
- **cortex_a72** (Cortex-A72): Frontend model (experimental)

To add new architectures:
1. Create target module in `slothy/targets/aarch64/`
2. Define execution units, latencies, and throughput
3. Add to workflow scripts

## Testing

After integration, test FFmpeg:

```bash
cd ffmpeg-slothy-workflow/integrated/a55/ffmpeg

# Configure for aarch64
./configure --arch=aarch64 --enable-cross-compile \
    --cross-prefix=aarch64-linux-gnu- --target-os=linux

# Build
make -j$(nproc)

# Run tests (if available)
make check

# Or test specific functionality
./ffmpeg -i input.mp4 -c:v h264 output.mp4
```

## Best Practices

1. **Start Small**: Test with a few files first
2. **Verify Instructions**: Always verify latency/throughput from ARM SWOG
3. **Iterate**: Add missing instructions incrementally
4. **Test**: Build and test integrated FFmpeg before deployment
5. **Document**: Keep track of which functions were optimized and why

## References

- [SLOTHY Paper](https://eprint.iacr.org/2022/1303)
- [SLOTHY Repository](https://github.com/slothy-optimizer/slothy)
- [Cortex-A55 SWOG](https://developer.arm.com/documentation/epm128372/latest/)
- [Cortex-A72 SWOG](https://developer.arm.com/documentation/uan0016/latest/)
- [ARM Architecture Reference Manual](https://developer.arm.com/documentation/ddi0487/latest/)

## Contributing

Improvements to this workflow are welcome! Areas for contribution:
- Additional architecture models
- Better instruction detection
- Automated testing integration
- Build system integration

## License

This workflow inherits SLOTHY's MIT license. See LICENSE file for details.
