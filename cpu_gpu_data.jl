
# B200 2024 :   
# 		FP16 (half) 1,191.2 TFLOPS
# 		FP32 (float)   74.45 TFLOPS
# 		FP64 (double)  37.22 TFLOPS (1:2) 

# H200 2023 GH100/hopper
# 		FP16 (half)   267.6 TFLOPS
# 		FP32 (float)   66.91 TFLOPS 
# 		FP64 (double)  33.45 TFLOPS (1:2) 
		
# H100 2022 
# 		FP16 (half)  204.9 TFLOPS (4:1) 
# 		FP32 (float) 51.22 TFLOPS 
# 		FP64 (double) 25.61 TFLOPS (1:2) 
		
# A100 2020
# 		FP16 (half) 77.97 TFLOPS (4:1) 
# 		FP32 (float) 19.49 TFLOPS 
# 		FP64 (double) 9.746 TFLOPS (1:2) 


# A100 -> H100 -> H200 -> B200

perf_ai_tensor_tflops = [624,  1513, 1979, 4500].*1e+06
lab_ai_tensor = ["A100", "H100", "H200","B200"]
year_ai_tensor = [2020, 2022, 2023, 2024] 


# 1. Задание исходных данных
years = [2007, 2009, 2010, 2012, 2014, 2016, 2017, 2019, 2021, 2023, 2024, 2025]

models = ["Xeon X3230", "Xeon X5570", "Xeon X5680", "Xeon E5-2690", 
          "Xeon E5-2699 v3", "Xeon E5-2699 v4", "Xeon Platinum 8180", 
          "Xeon Platinum 8280", "Xeon Platinum 8380", "Xeon Platinum 8480+", 
          "Xeon Platinum 8592+", "Xeon 6980P"]

cores = [4, 4, 6, 8, 18, 22, 28, 28, 40, 56, 64, 128]
base_clock_ghz = [2.66, 2.93, 3.33, 2.90, 2.30, 2.20, 2.50, 2.70, 2.30, 2.00, 1.90, 2.00]
flops_per_cycle = [4, 4, 4, 8, 16, 16, 32, 32, 32, 32, 32, 32]

linpack_fp32_gflops = [25.5, 34.7, 62.3, 155.2, 542.1, 650.5, 1881.6, 2056.3, 2443.5, 3010.5, 3346.4, 7127.0]

# 2. Векторизованные расчеты в Julia (используется точка перед оператором)
peak_gflops = cores .* base_clock_ghz .* flops_per_cycle
efficiency_pct = (linpack_fp32_gflops ./ peak_gflops) .* 100

# 3. Создание DataFrame
xeon_df = DataFrame(
    Year = years,
    Model = models,
    Cores = cores,
    BaseClock_GHz = base_clock_ghz,
    Peak_GFLOPS = peak_gflops,
    Linpack_GFLOPS = linpack_fp32_gflops,
    Efficiency_Pct = efficiency_pct
)

println("--- INTEL XEON HPC LINPACK DATA ---")
println(xeon_df)


# 1. Задание исходных данных
years = [2017, 2019, 2021, 2022, 2023, 2024, 2025]

models = ["EPYC 7601", "EPYC 7742", "EPYC 7763", "EPYC 9654", "EPYC 9754", "EPYC 9655", "EPYC 9965"]

cores = [32, 64, 64, 96, 128, 96, 192]
base_clock_ghz = [2.20, 2.25, 2.45, 2.40, 2.25, 2.60, 2.00]
flops_per_cycle = [8, 16, 16, 16, 16, 32, 32]

linpack_fp32_gflops = [411.1, 1820.2, 2057.2, 3096.5, 3732.4, 6789.1, 9953.2]

# 2. Вычисления
peak_gflops = cores .* base_clock_ghz .* flops_per_cycle
efficiency_pct = (linpack_fp32_gflops ./ peak_gflops) .* 100

# 3. Создание DataFrame
epyc_df = DataFrame(
    Year = years,
    Model = models,
    Cores = cores,
    BaseClock_GHz = base_clock_ghz,
    Peak_GFLOPS = peak_gflops,
    Linpack_GFLOPS = linpack_fp32_gflops,
    Efficiency_Pct = efficiency_pct
)

println("\n--- AMD EPYC HPC LINPACK DATA ---")
println(epyc_df)
