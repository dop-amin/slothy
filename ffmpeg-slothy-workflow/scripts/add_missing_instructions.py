#!/usr/bin/env python3
"""
Add Missing Instructions to SLOTHY

This script helps add missing instructions to SLOTHY's architecture model
by analyzing the instruction and generating template code based on ARM
documentation and similar existing instructions.
"""

import re
import sys
import json
import argparse
from pathlib import Path
from typing import Dict, List, Optional, Tuple


class InstructionAnalyzer:
    """Analyzes instructions and generates SLOTHY model code"""

    # Common instruction categories and their typical characteristics
    INSTRUCTION_CATEGORIES = {
        'load': {
            'patterns': [r'^ld\d?r?[bhwd]?$', r'^ld\d+$', r'^ldr$', r'^ldp$'],
            'latency_range': (3, 5),
            'throughput': 1,
            'units': 'LOAD',
            'is_vector': False,
        },
        'store': {
            'patterns': [r'^st\d?r?[bhwd]?$', r'^st\d+$', r'^str$', r'^stp$'],
            'latency_range': (1, 4),
            'throughput': 1,
            'units': 'STORE',
            'is_vector': False,
        },
        'vector_load': {
            'patterns': [r'^ld\d+.*\.'],
            'latency_range': (4, 6),
            'throughput': 2,
            'units': 'VEC',
            'is_vector': True,
        },
        'vector_store': {
            'patterns': [r'^st\d+.*\.'],
            'latency_range': (1, 3),
            'throughput': 1,
            'units': 'VEC',
            'is_vector': True,
        },
        'float_arith': {
            'patterns': [r'^f(add|sub|mul|div|neg|abs|max|min|sqrt)'],
            'latency_range': (3, 5),
            'throughput': 1,
            'units': 'VEC',
            'is_vector': True,
        },
        'float_fma': {
            'patterns': [r'^f(mla|mls|madd|msub|nmadd|nmsub)'],
            'latency_range': (4, 6),
            'throughput': 1,
            'units': 'VEC',
            'is_vector': True,
        },
        'vector_arith': {
            'patterns': [r'^(add|sub|mul|div|neg|abs|max|min).*\.[248]?[sdh]$'],
            'latency_range': (2, 4),
            'throughput': 1,
            'units': 'VEC',
            'is_vector': True,
        },
        'vector_shift': {
            'patterns': [r'^(shl|shr|sshr|ushr|sli|sri).*\.[248]?[sdh]$'],
            'latency_range': (2, 3),
            'throughput': 1,
            'units': 'VEC',
            'is_vector': True,
        },
        'scalar_arith': {
            'patterns': [r'^(add|sub|and|orr|eor|mul|div)$', r'^(add|sub).*[xw]\d+'],
            'latency_range': (1, 2),
            'throughput': 1,
            'units': 'SCALAR',
            'is_vector': False,
        },
        'scalar_shift': {
            'patterns': [r'^(lsl|lsr|asr|ror)$'],
            'latency_range': (1, 1),
            'throughput': 1,
            'units': 'SCALAR',
            'is_vector': False,
        },
        'compare': {
            'patterns': [r'^cmp$', r'^ccmp$', r'^fcmp$'],
            'latency_range': (1, 2),
            'throughput': 1,
            'units': 'SCALAR',
            'is_vector': False,
        },
        'branch': {
            'patterns': [r'^b\.', r'^cbz$', r'^cbnz$', r'^tbz$', r'^tbnz$'],
            'latency_range': (1, 1),
            'throughput': 1,
            'units': 'BRANCH',
            'is_vector': False,
        },
    }

    # ARM Software Optimization Guide references
    ARM_SWOG_URLS = {
        'cortex_a55': 'https://developer.arm.com/documentation/epm128372/latest/',
        'cortex_a72': 'https://developer.arm.com/documentation/uan0016/latest/',
    }

    def __init__(self):
        self.analyzed_instructions = {}

    def categorize_instruction(self, mnemonic: str) -> Optional[Dict]:
        """
        Categorize an instruction based on its mnemonic

        Returns: category info dict or None
        """
        mnemonic_lower = mnemonic.lower()

        for category, info in self.INSTRUCTION_CATEGORIES.items():
            for pattern in info['patterns']:
                if re.match(pattern, mnemonic_lower):
                    return {
                        'category': category,
                        **info
                    }

        return None

    def find_similar_instructions(self, mnemonic: str, arch_file: Path) -> List[str]:
        """
        Find similar instructions already defined in SLOTHY

        Returns: list of similar instruction class names
        """
        similar = []

        # Read the architecture file
        if not arch_file.exists():
            return similar

        with open(arch_file, 'r') as f:
            content = f.read()

        # Look for instruction class definitions
        # Pattern: class InstrName(...): or InstrName = AArch64Instruction(...)
        class_pattern = r'class\s+(\w+)\s*\([^)]*\):|(\w+)\s*=\s*AArch64Instruction\('

        for match in re.finditer(class_pattern, content):
            class_name = match.group(1) or match.group(2)
            if class_name:
                # Check if similar (same prefix, etc.)
                if self._is_similar_mnemonic(mnemonic, class_name):
                    similar.append(class_name)

        return similar[:5]  # Return top 5

    def _is_similar_mnemonic(self, mnemonic1: str, mnemonic2: str) -> bool:
        """Check if two mnemonics are similar"""
        m1 = mnemonic1.lower()
        m2 = mnemonic2.lower()

        # Same prefix (first 2-3 chars)
        if m1[:3] == m2[:3]:
            return True

        # Similar patterns (e.g., fadd/faddp, ld1/ld2)
        if m1[:2] == m2[:2]:
            return True

        return False

    def generate_instruction_stub(self, mnemonic: str, category_info: Dict,
                                 similar_instructions: List[str]) -> str:
        """
        Generate Python code stub for adding the instruction to SLOTHY

        Returns: Python code as string
        """
        category = category_info['category']
        latency_low, latency_high = category_info['latency_range']
        throughput = category_info['throughput']
        units = category_info['units']
        is_vector = category_info['is_vector']

        stub = f"""# TODO: Add {mnemonic} instruction to SLOTHY architecture model
# Category: {category}
# Estimated latency: {latency_low}-{latency_high} cycles
# Estimated throughput: {throughput} instruction(s) per cycle
# Execution units: {units}
# Vector instruction: {is_vector}

# Similar instructions in SLOTHY:
{chr(10).join(f'#   - {sim}' for sim in similar_instructions) if similar_instructions else '#   (none found)'}

# Example instruction definition (adjust as needed):
# This is a placeholder - you need to verify the exact instruction format
# from the ARM Architecture Reference Manual

class {mnemonic.replace('.', '_').replace('-', '_')}(Instruction):
    \"\"\"
    {mnemonic.upper()} instruction

    TODO: Add proper instruction template and description
    \"\"\"

    # Placeholder - replace with actual instruction pattern
    pattern = "{mnemonic} <args>"

    def __init__(self):
        super().__init__()
        # TODO: Define inputs, outputs, and other properties

# Add to execution_units dict:
# {mnemonic.replace('.', '_').replace('-', '_')}: {units}()

# Add to inverse_throughput dict:
# {mnemonic.replace('.', '_').replace('-', '_')}: {throughput}

# Add to default_latencies dict:
# {mnemonic.replace('.', '_').replace('-', '_')}: {latency_low}  # TODO: verify with ARM SWOG

# ARM Software Optimization Guide reference:
# {self.ARM_SWOG_URLS.get('cortex_a55', 'https://developer.arm.com/documentation')}
"""
        return stub

    def analyze_instruction(self, mnemonic: str, slothy_arch_file: Path) -> Dict:
        """
        Analyze a missing instruction and generate recommendations

        Returns: analysis dict with recommendations
        """
        # Categorize
        category_info = self.categorize_instruction(mnemonic)
        if not category_info:
            category_info = {
                'category': 'unknown',
                'latency_range': (2, 4),
                'throughput': 1,
                'units': 'SCALAR',
                'is_vector': False,
            }

        # Find similar instructions
        similar = self.find_similar_instructions(mnemonic, slothy_arch_file)

        # Generate stub
        stub_code = self.generate_instruction_stub(mnemonic, category_info, similar)

        analysis = {
            'mnemonic': mnemonic,
            'category': category_info['category'],
            'estimated_latency': category_info['latency_range'],
            'estimated_throughput': category_info['throughput'],
            'execution_units': category_info['units'],
            'is_vector': category_info['is_vector'],
            'similar_instructions': similar,
            'stub_code': stub_code,
            'arm_swog_url': self.ARM_SWOG_URLS.get('cortex_a55', ''),
            'notes': [
                'These are ESTIMATES based on instruction category.',
                'You MUST verify actual values from ARM Software Optimization Guides.',
                'Different microarchitectures may have different characteristics.',
            ]
        }

        return analysis


def main():
    parser = argparse.ArgumentParser(
        description='Analyze missing instructions and generate SLOTHY model code'
    )
    parser.add_argument(
        'instructions',
        nargs='+',
        help='Instruction mnemonics to analyze (e.g., faddp fabd)'
    )
    parser.add_argument(
        '--slothy-arch-file',
        type=str,
        default='slothy/targets/aarch64/aarch64_neon.py',
        help='Path to SLOTHY architecture file'
    )
    parser.add_argument(
        '--output',
        type=str,
        help='Output file for analysis (default: print to stdout)'
    )
    parser.add_argument(
        '--format',
        choices=['text', 'json'],
        default='text',
        help='Output format'
    )

    args = parser.parse_args()

    analyzer = InstructionAnalyzer()
    arch_file = Path(args.slothy_arch_file)

    results = []
    for mnemonic in args.instructions:
        analysis = analyzer.analyze_instruction(mnemonic, arch_file)
        results.append(analysis)

    # Output results
    if args.format == 'json':
        output = json.dumps(results, indent=2)
    else:
        output_parts = []
        for analysis in results:
            output_parts.append('='*70)
            output_parts.append(f"Instruction: {analysis['mnemonic']}")
            output_parts.append('='*70)
            output_parts.append(f"Category: {analysis['category']}")
            output_parts.append(f"Estimated Latency: {analysis['estimated_latency'][0]}-{analysis['estimated_latency'][1]} cycles")
            output_parts.append(f"Estimated Throughput: {analysis['estimated_throughput']} per cycle")
            output_parts.append(f"Execution Units: {analysis['execution_units']}")
            output_parts.append(f"Vector Instruction: {analysis['is_vector']}")
            output_parts.append(f"\nSimilar Instructions:")
            if analysis['similar_instructions']:
                for sim in analysis['similar_instructions']:
                    output_parts.append(f"  - {sim}")
            else:
                output_parts.append("  (none found)")
            output_parts.append(f"\nNotes:")
            for note in analysis['notes']:
                output_parts.append(f"  - {note}")
            output_parts.append(f"\nARM SWOG Reference:")
            output_parts.append(f"  {analysis['arm_swog_url']}")
            output_parts.append(f"\nGenerated Code Stub:")
            output_parts.append(analysis['stub_code'])
            output_parts.append('')

        output = '\n'.join(output_parts)

    if args.output:
        with open(args.output, 'w') as f:
            f.write(output)
        print(f"Analysis written to {args.output}")
    else:
        print(output)


if __name__ == '__main__':
    main()
