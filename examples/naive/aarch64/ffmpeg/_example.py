import os
import sys

from common.OptimizationRunner import OptimizationRunner
import slothy.targets.aarch64.aarch64_neon as AArch64_Neon
import slothy.targets.aarch64.cortex_a55 as Target_CortexA55

SUBFOLDER = os.path.basename(os.path.dirname(__file__)) + "/"


class ff_scalarproduct_float_neon(OptimizationRunner):
    def __init__(self, arch=AArch64_Neon, target=Target_CortexA55, timeout=None):
        name = "ff_scalarproduct_float_neon"
        super().__init__(
            name,
            name,
            arch=arch,
            target=target,
            timeout=timeout,
            subfolder=SUBFOLDER,
        )

    def core(self, slothy):
        slothy.config.sw_pipelining.enabled = True
        slothy.config.inputs_are_outputs = True
        slothy.config.variable_size = True
        slothy.config.reserved_regs = ["x0", "x1", "x2", "x30", "sp"]
        slothy.config.constraints.stalls_first_attempt = 32
        slothy.optimize_loop("1")


class ff_butterflies_float_neon(OptimizationRunner):
    def __init__(self, arch=AArch64_Neon, target=Target_CortexA55, timeout=None):
        name = "ff_butterflies_float_neon"
        super().__init__(
            name,
            name,
            arch=arch,
            target=target,
            timeout=timeout,
            subfolder=SUBFOLDER,
        )

    def core(self, slothy):
        slothy.config.sw_pipelining.enabled = False
        slothy.config.inputs_are_outputs = True
        slothy.config.variable_size = True
        slothy.config.reserved_regs = ["x0", "x1", "x2", "x30", "sp"]
        slothy.config.outputs = ["flags"]
        slothy.config.constraints.stalls_first_attempt = 32
        slothy.optimize_loop("1")


class ff_vector_fmul_neon(OptimizationRunner):
    def __init__(self, arch=AArch64_Neon, target=Target_CortexA55, timeout=None):
        name = "ff_vector_fmul_neon"
        super().__init__(
            name,
            name,
            arch=arch,
            target=target,
            timeout=timeout,
            subfolder=SUBFOLDER,
        )

    def core(self, slothy):
        slothy.config.sw_pipelining.enabled = True
        slothy.config.inputs_are_outputs = True
        slothy.config.variable_size = True
        slothy.config.reserved_regs = ["x0", "x1", "x2", "x3", "x30", "sp"]
        slothy.config.constraints.stalls_first_attempt = 32
        slothy.optimize_loop("1")


class ff_vector_dmul_scalar_neon(OptimizationRunner):
    def __init__(self, arch=AArch64_Neon, target=Target_CortexA55, timeout=None):
        name = "ff_vector_dmul_scalar_neon"
        super().__init__(
            name,
            name,
            arch=arch,
            target=target,
            timeout=timeout,
            subfolder=SUBFOLDER,
        )

    def core(self, slothy):
        slothy.config.sw_pipelining.enabled = True
        slothy.config.inputs_are_outputs = True
        slothy.config.variable_size = True
        slothy.config.reserved_regs = ["x0", "x1", "x2", "x30", "sp"]
        slothy.config.constraints.stalls_first_attempt = 32
        slothy.optimize_loop("1")


class ff_vector_fmac_scalar_neon(OptimizationRunner):
    def __init__(self, arch=AArch64_Neon, target=Target_CortexA55, timeout=None):
        name = "ff_vector_fmac_scalar_neon"
        super().__init__(
            name,
            name,
            arch=arch,
            target=target,
            timeout=timeout,
            subfolder=SUBFOLDER,
        )

    def core(self, slothy):
        slothy.config.sw_pipelining.enabled = True
        slothy.config.inputs_are_outputs = True
        slothy.config.variable_size = True
        slothy.config.reserved_regs = ["x0", "x1", "x2", "x3", "x30", "sp"]
        slothy.config.constraints.stalls_first_attempt = 32
        # x3 holds a stride value (-32), not an address; selftest randomizes it and crashes
        slothy.config.selftest = False
        slothy.optimize_loop("1")


class ff_vector_fmul_reverse_neon(OptimizationRunner):
    def __init__(self, arch=AArch64_Neon, target=Target_CortexA55, timeout=None):
        name = "ff_vector_fmul_reverse_neon"
        super().__init__(
            name,
            name,
            arch=arch,
            target=target,
            timeout=timeout,
            subfolder=SUBFOLDER,
        )

    def core(self, slothy):
        slothy.config.variable_size = True
        slothy.config.reserved_regs = ["x0", "x1", "x2", "x3", "x4", "x30", "sp"]
        slothy.config.outputs = ["v16", "v17", "v2", "v3", "v0", "v1", "x3", "flags"]
        slothy.config.constraints.stalls_first_attempt = 32
        slothy.optimize("loop_body", "loop_body_end")


example_instances = [
    ff_scalarproduct_float_neon(),
    ff_butterflies_float_neon(),
    ff_vector_fmul_neon(),
    ff_vector_dmul_scalar_neon(),
    ff_vector_fmac_scalar_neon(),
    ff_vector_fmul_reverse_neon(),
]

if __name__ == "__main__":
    ff_scalarproduct_float_neon().run()
    ff_butterflies_float_neon().run()
    ff_vector_fmul_neon().run()
    ff_vector_dmul_scalar_neon().run()
    ff_vector_fmac_scalar_neon().run()
    ff_vector_fmul_reverse_neon().run()
