# FFmpeg-SLOTHY Workflow - Quick Start Guide

## Prerequisites

```bash
# Install dependencies
pip install -r requirements.txt

# FFmpeg should already be cloned at /tmp/ffmpeg
# If not:
git clone https://github.com/FFmpeg/FFmpeg.git /tmp/ffmpeg
```

## Quick Test (Recommended First Time)

Test the workflow on a small sample:

```bash
# Extract functions from 2 FFmpeg files
python ffmpeg-slothy-workflow/scripts/extract_functions.py \
    --ffmpeg-root /tmp/ffmpeg \
    --output-dir ffmpeg-slothy-workflow/extracted \
    --max-files 2

# View what was extracted
cat ffmpeg-slothy-workflow/extracted/extraction_summary.json | python -m json.tool
```

**Expected output:** List of extracted functions with metadata (7 functions from 2 files)

## Run Full Workflow

### Option 1: Using Master Script (Easiest)

```bash
# Run complete workflow for Cortex-A55 on 3 files
python ffmpeg-slothy-workflow/scripts/run_full_workflow.py \
    --targets a55 \
    --max-files 3 \
    --skip-evaluation

# Run for both A55 and A72
python ffmpeg-slothy-workflow/scripts/run_full_workflow.py \
    --targets a55,a72 \
    --max-files 5
```

### Option 2: Step by Step

```bash
# Step 1: Extract (from 5 files)
python ffmpeg-slothy-workflow/scripts/extract_functions.py \
    --max-files 5

# Step 2: Optimize for A55
python ffmpeg-slothy-workflow/scripts/optimize_with_slothy.py \
    --targets a55 \
    --max-functions 5

# Step 3: Check results
cat ffmpeg-slothy-workflow/optimized/optimization_summary.json | python -m json.tool
```

## Understanding the Results

### Extraction Results

Location: `ffmpeg-slothy-workflow/extracted/`

- `extraction_summary.json` - List of all extracted functions
- `*.s` files - Assembly code for each function
- `*.json` files - Metadata for each function

### Optimization Results

Location: `ffmpeg-slothy-workflow/optimized/`

- `optimization_summary.json` - Success/failure summary
- `*_a55.s` - Optimized for Cortex-A55
- `*_a72.s` - Optimized for Cortex-A72 (if requested)

**Key fields in optimization_summary.json:**
- `successful` - List of successfully optimized functions
- `failed` - List of failed optimizations with errors
- `missing_instructions` - Instructions that need to be added to SLOTHY

## Handling Missing Instructions

When optimization fails due to missing instructions:

```bash
# Check which instructions are missing
cat ffmpeg-slothy-workflow/optimized/optimization_summary.json | \
    python -c "import sys,json; print('\n'.join(json.load(sys.stdin)['missing_instructions']))"

# Analyze a missing instruction (e.g., scvtf)
python ffmpeg-slothy-workflow/scripts/add_missing_instructions.py scvtf

# This will generate:
# - Instruction category
# - Estimated latency/throughput
# - Similar instructions in SLOTHY
# - Code stub to add to SLOTHY
# - ARM SWOG reference URLs
```

### Example: Adding scvtf (Signed Convert to Float)

1. Run analysis:
   ```bash
   python ffmpeg-slothy-workflow/scripts/add_missing_instructions.py scvtf
   ```

2. Look up actual values in [ARM Cortex-A55 SWOG](https://developer.arm.com/documentation/epm128372/latest/)

3. Add to `slothy/targets/aarch64/aarch64_neon.py`:
   ```python
   # Signed convert to float (GPR to SIMD)
   scvtf = AArch64Instruction("scvtf <Sd>, <Wn>", ...)
   ```

4. Add performance data to `slothy/targets/aarch64/cortex_a55.py`

5. Re-run optimization:
   ```bash
   python ffmpeg-slothy-workflow/scripts/optimize_with_slothy.py --targets a55
   ```

## Evaluate Performance (Optional)

Requires llvm-mca to be installed:

```bash
# For Cortex-A55
python ffmpeg-slothy-workflow/scripts/evaluate_with_llvm_mca.py \
    --target cortex-a55

# View results
cat ffmpeg-slothy-workflow/results/evaluation_summary_cortex-a55.json | python -m json.tool
```

**Note:** llvm-mca results are approximations and may not match real hardware.

## Integrate Back to FFmpeg (Optional)

```bash
# Create optimized FFmpeg for A55
python ffmpeg-slothy-workflow/scripts/integrate_back.py \
    --target a55

# Output will be in:
# ffmpeg-slothy-workflow/integrated/a55/ffmpeg/
```

### Build and Test

```bash
cd ffmpeg-slothy-workflow/integrated/a55/ffmpeg

# Configure and build
./configure --arch=aarch64
make -j$(nproc)

# Test (if tests available)
make check
```

## Common Issues

### Issue: "ModuleNotFoundError: No module named 'sympy'"
**Solution:** `pip install -r requirements.txt`

### Issue: "llvm-mca not found"
**Solution:** Install LLVM or skip evaluation with `--skip-evaluation`

### Issue: Optimization timeout
**Solution:** Increase timeout with `--timeout 600` (seconds)

### Issue: Too many failed optimizations
**Solution:**
1. Check `missing_instructions` in optimization summary
2. Add missing instructions to SLOTHY
3. Re-run optimization

## Performance Tips

- **Start small:** Use `--max-files 2` for initial testing
- **Incremental:** Add missing instructions one at a time
- **Parallel targets:** Optimize for multiple targets in one run with `--targets a55,a72`
- **Timeout:** Small functions: 60s, Medium: 300s, Large: 600s+

## Next Steps

1. **Extract more functions:** Increase `--max-files`
2. **Add missing instructions:** Use the analysis tool
3. **Evaluate performance:** Run llvm-mca analysis
4. **Build and test:** Integrate and test with real FFmpeg workloads
5. **Iterate:** Re-optimize after adding instructions

## File Structure Summary

```
ffmpeg-slothy-workflow/
├── scripts/              # All workflow scripts
│   ├── extract_functions.py
│   ├── optimize_with_slothy.py
│   ├── add_missing_instructions.py
│   ├── integrate_back.py
│   ├── evaluate_with_llvm_mca.py
│   └── run_full_workflow.py
│
├── extracted/           # Extracted FFmpeg functions
│   ├── extraction_summary.json
│   ├── *.s             # Assembly files
│   └── *.json          # Metadata files
│
├── optimized/          # SLOTHY-optimized functions
│   ├── optimization_summary.json
│   ├── *_a55.s        # Optimized for A55
│   └── *_a72.s        # Optimized for A72
│
├── results/            # Performance evaluation
│   ├── evaluation_summary_*.json
│   └── *_detail.txt   # Detailed llvm-mca output
│
└── integrated/         # FFmpeg with optimized code
    ├── a55/
    └── a72/
```

## Getting Help

- Read the full README: `ffmpeg-slothy-workflow/README.md`
- Check SLOTHY docs: https://github.com/slothy-optimizer/slothy
- ARM documentation:
  - [Cortex-A55 SWOG](https://developer.arm.com/documentation/epm128372/latest/)
  - [Cortex-A72 SWOG](https://developer.arm.com/documentation/uan0016/latest/)

## Example Workflow Session

```bash
# 1. Extract from 3 files
python ffmpeg-slothy-workflow/scripts/extract_functions.py --max-files 3

# 2. Optimize for A55
python ffmpeg-slothy-workflow/scripts/optimize_with_slothy.py --targets a55

# 3. Check what failed
cat ffmpeg-slothy-workflow/optimized/optimization_summary.json | \
    python -m json.tool | grep -A 5 "missing_instructions"

# 4. Analyze missing instructions
python ffmpeg-slothy-workflow/scripts/add_missing_instructions.py scvtf fcvt

# 5. Add instructions to SLOTHY (manual step)
# Edit slothy/targets/aarch64/aarch64_neon.py
# Edit slothy/targets/aarch64/cortex_a55.py

# 6. Re-run optimization
python ffmpeg-slothy-workflow/scripts/optimize_with_slothy.py --targets a55

# 7. Evaluate performance
python ffmpeg-slothy-workflow/scripts/evaluate_with_llvm_mca.py

# 8. Check results
cat ffmpeg-slothy-workflow/results/evaluation_summary_cortex-a55.json
```
