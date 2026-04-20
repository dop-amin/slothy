import os
import sys

from common.OptimizationRunner import OptimizationRunner
import slothy.targets.aarch64.aarch64_neon as AArch64_Neon
import slothy.targets.aarch64.cortex_a55 as Target_CortexA55
import slothy.targets.aarch64.cortex_a72_frontend as Target_CortexA72

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


class ff_vector_fmul_add_neon(OptimizationRunner):
    def __init__(self, arch=AArch64_Neon, target=Target_CortexA55, timeout=None):
        name = "ff_vector_fmul_add_neon"
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
        slothy.config.reserved_regs = ["x0", "x1", "x2", "x3", "x4", "x30", "sp"]
        slothy.config.constraints.stalls_first_attempt = 64
        # Unicorn selftest crashes on 4-register ld1/st1 patterns
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


class ff_opus_postfilter_neon(OptimizationRunner):
    def __init__(self, arch=AArch64_Neon, target=Target_CortexA55, timeout=None):
        name = "ff_opus_postfilter_neon"
        super().__init__(
            name,
            name,
            arch=arch,
            target=target,
            timeout=timeout,
            subfolder=SUBFOLDER,
        )

    def core(self, slothy):
        # SW pipelining is disabled: ld1 has no pre-indexed offset form in AArch64,
        # so the address fixup SLOTHY would need to move ld1 {v}, [x0] before
        # st1 {v}, [x0], #16 cannot be expressed as a valid instruction.
        slothy.config.sw_pipelining.enabled = False
        slothy.config.inputs_are_outputs = True
        slothy.config.variable_size = True
        slothy.config.reserved_regs = [
            "x0",
            "x1",
            "x2",
            "x3",
            "x4",
            "x5",
            "x6",
            "x30",
            "sp",
        ]
        slothy.config.constraints.stalls_first_attempt = 32
        slothy.config.constraints.prefer_caller_save_registers = True
        slothy.config.sw_pipelining.minimize_overlapping = False
        slothy.config.selftest_address_registers = {
            "x0": 8192,
            "x1": 8192,
            "x2": 8192,
            "x4": 8192,
            "x5": 8192,
            "x6": 8192,
        }
        slothy.optimize_loop("1")


class ff_opus_deemphasis_neon(OptimizationRunner):
    def __init__(self, arch=AArch64_Neon, target=Target_CortexA55, timeout=None):
        name = "ff_opus_deemphasis_neon"
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
        slothy.config.reserved_regs = ["x0", "x1", "x2", "x3", "x4", "x30", "sp"]
        slothy.config.constraints.prefer_caller_save_registers = True
        slothy.config.sw_pipelining.minimize_overlapping = False
        slothy.config.constraints.stalls_first_attempt = 64
        slothy.optimize_loop("1")


class ff_ps_hybrid_analysis_neon(OptimizationRunner):
    def __init__(self, arch=AArch64_Neon, target=Target_CortexA55, timeout=None):
        name = "ff_ps_hybrid_analysis_neon"
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
        slothy.config.reserved_regs = ["x0", "x1", "x2", "x3", "x4", "x30", "sp"]
        slothy.config.constraints.stalls_first_attempt = 64
        slothy.config.constraints.prefer_caller_save_registers = True
        slothy.config.sw_pipelining.minimize_overlapping = False
        slothy.config.selftest_address_registers = {"x0": 8192, "x1": 8192, "x2": 8192}
        slothy.config.selftest_initial_register_values = {"x3": 2}

        slothy.optimize_loop("1")


class ff_mpadsp_apply_window_float_neon(OptimizationRunner):
    def __init__(self, arch=AArch64_Neon, target=Target_CortexA55, timeout=None):
        name = "ff_mpadsp_apply_window_float_neon"
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
        slothy.config.reserved_regs = [
            "x6",
            "x7",
            "x8",
            "x9",
            "x10",
            "x11",
            "x12",
            "x30",
            "sp",
        ]
        slothy.config.constraints.stalls_first_attempt = 64
        slothy.config.constraints.prefer_caller_save_registers = True
        slothy.config.sw_pipelining.minimize_overlapping = False
        slothy.config.selftest_initial_register_values = {"x9": 64 * 4}
        slothy.optimize_loop("2")


class put_h264_qpel8_v_lowpass_neon(OptimizationRunner):
    def __init__(self, arch=AArch64_Neon, target=Target_CortexA55, timeout=None):
        name = "put_h264_qpel8_v_lowpass_neon"
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
        slothy.config.reserved_regs = ["x0", "x1", "x2", "x3", "x30", "sp"]
        slothy.config.constraints.stalls_first_attempt = 64
        slothy.config.constraints.prefer_caller_save_registers = True
        slothy.config.sw_pipelining.minimize_overlapping = False
        # x3 = src stride, x2 = dst stride (small values, not pointers)
        # v6 holds constants (h[1]=20, h[0]=5), not a pointer
        slothy.config.selftest_initial_register_values = {"x3": 8, "x2": 8}
        slothy.config.selftest_address_registers = {"x0": 8192, "x1": 8192}
        slothy.config.outputs = [
            "v16",
            "v17",
            "v18",
            "v19",
            "v20",
            "v21",
            "v22",
            "v23",
            "x0",
            "x1",
        ]
        slothy.optimize("body_start", "body_end")


class avg_h264_qpel8_v_lowpass_neon(OptimizationRunner):
    def __init__(self, arch=AArch64_Neon, target=Target_CortexA55, timeout=None):
        name = "avg_h264_qpel8_v_lowpass_neon"
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
        slothy.config.reserved_regs = ["x0", "x1", "x2", "x3", "x30", "sp"]
        slothy.config.constraints.stalls_first_attempt = 64
        slothy.config.constraints.prefer_caller_save_registers = True
        slothy.config.sw_pipelining.minimize_overlapping = False
        slothy.config.selftest_initial_register_values = {"x3": 8, "x2": 8}
        slothy.config.selftest_address_registers = {"x0": 8192, "x1": 8192}
        slothy.config.outputs = [
            "v16",
            "v17",
            "v18",
            "v19",
            "v20",
            "v21",
            "v22",
            "v23",
            "x0",
            "x1",
        ]
        slothy.optimize("body_start", "body_end")


class put_h264_qpel8_hv_lowpass_neon_top(OptimizationRunner):
    def __init__(self, arch=AArch64_Neon, target=Target_CortexA55, timeout=None):
        name = "put_h264_qpel8_hv_lowpass_neon_top"
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
        slothy.config.reserved_regs = ["x0", "x1", "x2", "x3", "x30", "sp"]
        slothy.config.constraints.stalls_first_attempt = 64
        slothy.config.constraints.prefer_caller_save_registers = True
        slothy.config.sw_pipelining.minimize_overlapping = False
        # x3 = src stride (not a pointer), x1 is the only pointer
        # v6 used as constant during lowpass_8H, then overwritten as scratch in lowpass_8.16
        slothy.config.split_heuristic = True
        slothy.config.split_heuristic_factor = 4
        slothy.config.split_heuristic_preprocess_naive_interleaving = True
        slothy.config.split_heuristic_repeat = 2
        slothy.config.split_heuristic_optimize_seam = 6
        slothy.config.split_heuristic_stepsize = 0.05
        slothy.config.split_heuristic_estimate_performance = True

        slothy.config.selftest_initial_register_values = {"x3": 16}
        slothy.config.selftest_address_registers = {"x1": 8192}
        slothy.config.outputs = [
            "v16",
            "v17",
            "v18",
            "v19",
            "v20",
            "v21",
            "v22",
            "v23",
            "x1",
        ]
        slothy.optimize("body_start", "body_end")


class ff_h264_idct_add_neon(OptimizationRunner):
    def __init__(self, arch=AArch64_Neon, target=Target_CortexA55, timeout=None):
        name = "ff_h264_idct_add_neon"
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
        slothy.config.reserved_regs = ["x10", "x1", "x12", "x6", "x5", "x1", 
                                       "x9", "x7", "x13", "x14", "x4", "x3", 
                                       "x0", "x30", "sp"]
        slothy.config.constraints.stalls_first_attempt = 32
        slothy.config.constraints.prefer_caller_save_registers = True
        slothy.config.sw_pipelining.minimize_overlapping = False
        slothy.config.selftest_address_registers = {"x0": 8192, "x1": 8192}
        slothy.config.selftest_initial_register_values = {"x2": 16}
        slothy.config.outputs = ["x0", "x1"]
        slothy.optimize("body_start", "body_end")


class ff_h264_idct8_add_neon(OptimizationRunner):
    def __init__(self, arch=AArch64_Neon, target=Target_CortexA55, timeout=None):
        name = "ff_h264_idct8_add_neon"
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
        slothy.config.reserved_regs = ["x10", "x1", "x2", "x12", "x6", "x5", "x1", 
                                       "x9", "x7", "x13", "x14", "x4", "x3", 
                                       "x0", "x30", "sp"]
        slothy.config.constraints.prefer_caller_save_registers = True
        slothy.config.sw_pipelining.minimize_overlapping = False
        slothy.config.constraints.stalls_first_attempt = 64
        slothy.config.split_heuristic = True
        slothy.config.split_heuristic_factor = 2
        slothy.config.split_heuristic_preprocess_naive_interleaving = True
        slothy.config.split_heuristic_repeat = 2
        slothy.config.split_heuristic_optimize_seam = 6
        slothy.config.split_heuristic_stepsize = 0.1
        slothy.config.split_heuristic_estimate_performance = True
        slothy.config.selftest_address_registers = {"x0": 8192, "x1": 8192, "x3": 8192}
        slothy.config.selftest_initial_register_values = {"w2": 16, "x2": 16}
        slothy.config.outputs = ["x0", "x1", "x3"]
        slothy.config.unsafe_address_offset_fixup = False
        slothy.optimize("body_start", "body_end")


class ff_hevc_put_hevc_h8_8_neon(OptimizationRunner):
    def __init__(self, arch=AArch64_Neon, target=Target_CortexA55, timeout=None):
        name = "ff_hevc_put_hevc_h8_8_neon"
        super().__init__(
            name, name, arch=arch, target=target, timeout=timeout, subfolder=SUBFOLDER
        )

    def core(self, slothy):
        slothy.config.variable_size = True
        slothy.config.reserved_regs = ["x30", "sp"]
        slothy.config.constraints.stalls_first_attempt = 16
        slothy.config.constraints.prefer_caller_save_registers = True
        slothy.config.sw_pipelining.minimize_overlapping = False
        # v0 holds the 8-tap signed filter; v16-v19 hold source pixels (8b)
        # No address registers needed (all register-to-register)
        slothy.config.outputs = ["v23", "v24"]
        slothy.optimize("body_start", "body_end")


class ff_hevc_put_hevc_h16_8_neon(OptimizationRunner):
    def __init__(self, arch=AArch64_Neon, target=Target_CortexA55, timeout=None):
        name = "ff_hevc_put_hevc_h16_8_neon"
        super().__init__(
            name, name, arch=arch, target=target, timeout=timeout, subfolder=SUBFOLDER
        )

    def core(self, slothy):
        slothy.config.variable_size = True
        slothy.config.reserved_regs = ["x30", "sp"]
        slothy.config.constraints.stalls_first_attempt = 32
        slothy.config.constraints.prefer_caller_save_registers = True
        slothy.config.sw_pipelining.minimize_overlapping = False
        slothy.config.outputs = ["v26", "v27", "v28", "v29"]
        slothy.optimize("body_start", "body_end")


class put_h264_qpel8_v_lowpass_l2_neon(OptimizationRunner):
    def __init__(self, arch=AArch64_Neon, target=Target_CortexA55, timeout=None):
        name = "put_h264_qpel8_v_lowpass_l2_neon"
        super().__init__(
            name, name, arch=arch, target=target, timeout=timeout, subfolder=SUBFOLDER
        )

    def core(self, slothy):
        slothy.config.variable_size = True
        slothy.config.reserved_regs = ["x0", "x1", "x3", "x12", "x2", "x30", "sp", "v6"]
        slothy.config.constraints.stalls_first_attempt = 64
        slothy.config.constraints.prefer_caller_save_registers = True
        slothy.config.sw_pipelining.minimize_overlapping = False
        slothy.config.selftest_address_registers = {"x0": 8192, "x1": 8192, "x12": 8192}
        slothy.config.selftest_initial_register_values = {
            "x3": 8,  # src stride
            "x2": 8,  # src2 stride
            # v6.h[1]=20 v6.h[0]=5 (lowpass_const, set by caller)
        }
        slothy.config.inputs_are_outputs = False
        slothy.config.outputs = ["x0", "x12"]
        slothy.optimize("body_start", "body_end")


class put_h264_qpel8_h_lowpass_neon(OptimizationRunner):
    def __init__(self, arch=AArch64_Neon, target=Target_CortexA55, timeout=None):
        name = "put_h264_qpel8_h_lowpass_neon"
        super().__init__(
            name, name, arch=arch, target=target, timeout=timeout, subfolder=SUBFOLDER
        )

    def core(self, slothy):
        slothy.config.variable_size = True
        slothy.config.reserved_regs = ["x0", "x1", "x2", "x3", "x12", "x30", "sp"]
        slothy.config.constraints.prefer_caller_save_registers = True
        slothy.config.sw_pipelining.minimize_overlapping = False
        slothy.config.sw_pipelining.enabled = True
        slothy.config.inputs_are_outputs = True
        slothy.config.constraints.stalls_first_attempt = 16
        slothy.config.selftest_address_registers = {"x0": 8192, "x1": 8192}
        slothy.config.selftest_initial_register_values = {
            "x2": 8,  # src stride
            "x3": 8,  # dst stride
            "x12": 8,  # loop count (height), must be even
        }
        slothy.optimize_loop("loop_start")


class ff_h264_h_loop_filter_luma_neon(OptimizationRunner):
    def __init__(self, arch=AArch64_Neon, target=Target_CortexA55, timeout=None):
        name = "ff_h264_h_loop_filter_luma_neon"
        super().__init__(
            name, name, arch=arch, target=target, timeout=timeout, subfolder=SUBFOLDER
        )

    def core(self, slothy):
        # region1: loads + transpose_8x16B + h264_loop_filter_luma up to cbz
        # Outputs needed after this region: x0 (advanced by 16*x1), x7 (cbz test),
        # and all vector regs live into region2.
        slothy.config.variable_size = True
        slothy.config.reserved_regs = ["x0", "x1", "x7", "x30", "sp"]
        slothy.config.constraints.stalls_first_attempt = 32
        slothy.config.constraints.prefer_caller_save_registers = True
        slothy.config.selftest_address_registers = {"x0": 8192}
        slothy.config.selftest_initial_register_values = {
            "x1": 16,   # stride
            "w2": 64,   # alpha
            "w3": 4,    # beta
        }
        slothy.config.outputs = [
            "x0", "x7",
            "v0", "v2", "v4", "v16", "v17", "v18", "v19", "v20", "v21", "v24",
        ]
        slothy.optimize("region1_start", "region1_end")

        # region2: h264_loop_filter_luma after cbz + transpose_4x16B + stores
        slothy.config.reserved_regs = ["x0", "x1", "x30", "sp"]
        slothy.config.selftest_address_registers = {"x0": 8192}
        slothy.config.selftest_initial_register_values = {"x1": 16}
        slothy.config.outputs = []
        slothy.optimize("region2_start", "region2_end")


class ff_put_h264_chroma_mc8_neon(OptimizationRunner):
    def __init__(self, arch=AArch64_Neon, target=Target_CortexA55, timeout=None):
        name = "ff_put_h264_chroma_mc8_neon"
        super().__init__(
            name, name, arch=arch, target=target, timeout=timeout, subfolder=SUBFOLDER
        )

    def core(self, slothy):
        slothy.config.variable_size = True
        slothy.config.reserved_regs = ["x0", "x1", "x2", "x30", "sp"]
        slothy.config.constraints.prefer_caller_save_registers = True
        slothy.config.constraints.minimize_spills = False
        slothy.config.sw_pipelining.enabled = True
        slothy.config.sw_pipelining.minimize_overlapping = False
        slothy.config.inputs_are_outputs = True
        slothy.config.constraints.stalls_first_attempt = 16
        slothy.config.selftest_address_registers = {"x0": 8192, "x1": 8192}
        slothy.config.selftest_initial_register_values = {
            "x2": 8,  # stride
            "w3": 8,  # height (must be even, > 0)
        }
        slothy.optimize_loop("loop_start")


example_instances = [
    ff_scalarproduct_float_neon(),
    ff_butterflies_float_neon(),
    ff_vector_fmul_neon(),
    ff_vector_dmul_scalar_neon(),
    ff_vector_fmac_scalar_neon(),
    ff_vector_fmul_reverse_neon(),
    ff_vector_fmul_add_neon(),
    ff_opus_postfilter_neon(),
    ff_opus_deemphasis_neon(),
    ff_ps_hybrid_analysis_neon(),
    ff_mpadsp_apply_window_float_neon(),
    put_h264_qpel8_v_lowpass_neon(),
    avg_h264_qpel8_v_lowpass_neon(),
    put_h264_qpel8_hv_lowpass_neon_top(),
    ff_h264_idct_add_neon(),
    ff_h264_idct8_add_neon(),
    ff_hevc_put_hevc_h8_8_neon(),
    ff_hevc_put_hevc_h16_8_neon(),
    put_h264_qpel8_v_lowpass_l2_neon(),
    put_h264_qpel8_h_lowpass_neon(),
    ff_put_h264_chroma_mc8_neon(),
    ff_h264_h_loop_filter_luma_neon(),
    ff_scalarproduct_float_neon(target=Target_CortexA72),
    ff_butterflies_float_neon(target=Target_CortexA72),
    ff_vector_fmul_neon(target=Target_CortexA72),
    ff_vector_dmul_scalar_neon(target=Target_CortexA72),
    ff_vector_fmac_scalar_neon(target=Target_CortexA72),
    ff_vector_fmul_reverse_neon(target=Target_CortexA72),
    ff_vector_fmul_add_neon(target=Target_CortexA72),
    ff_opus_postfilter_neon(target=Target_CortexA72),
    ff_opus_deemphasis_neon(target=Target_CortexA72),
    ff_ps_hybrid_analysis_neon(target=Target_CortexA72),
    ff_mpadsp_apply_window_float_neon(target=Target_CortexA72),
    put_h264_qpel8_v_lowpass_neon(target=Target_CortexA72),
    avg_h264_qpel8_v_lowpass_neon(target=Target_CortexA72),
    put_h264_qpel8_hv_lowpass_neon_top(target=Target_CortexA72),
    ff_h264_idct_add_neon(target=Target_CortexA72),
    ff_h264_idct8_add_neon(target=Target_CortexA72),
    ff_hevc_put_hevc_h8_8_neon(target=Target_CortexA72),
    ff_hevc_put_hevc_h16_8_neon(target=Target_CortexA72),
    put_h264_qpel8_v_lowpass_l2_neon(target=Target_CortexA72),
    put_h264_qpel8_h_lowpass_neon(target=Target_CortexA72),
    ff_put_h264_chroma_mc8_neon(target=Target_CortexA72),
]

if __name__ == "__main__":
    ff_scalarproduct_float_neon().run()
    ff_butterflies_float_neon().run()
    ff_vector_fmul_neon().run()
    ff_vector_dmul_scalar_neon().run()
    ff_vector_fmac_scalar_neon().run()
    ff_vector_fmul_reverse_neon().run()
    ff_vector_fmul_add_neon().run()
    ff_opus_postfilter_neon().run()
    ff_opus_deemphasis_neon().run()
    ff_ps_hybrid_analysis_neon().run()
    ff_mpadsp_apply_window_float_neon().run()
    put_h264_qpel8_v_lowpass_neon().run()
    avg_h264_qpel8_v_lowpass_neon().run()
    put_h264_qpel8_hv_lowpass_neon_top().run()
    ff_h264_idct_add_neon().run()
    ff_h264_idct8_add_neon().run()
    ff_hevc_put_hevc_h8_8_neon().run()
    ff_hevc_put_hevc_h16_8_neon().run()
    ff_h264_h_loop_filter_luma_neon().run()
