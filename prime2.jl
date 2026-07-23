

using Downloads
using PyPlot
using Printf
using Statistics
using HDF5
using DSP
using FFTW
using CSV
using DataFrames
using LaTeXStrings

include("top500_data.jl")
include("cpu_gpu_data.jl")


# setup colors 

cc01 = "#1D5B79"
cc03 = "#468B97"
cc02 = "#EF6262"
cc04 = "#F3AA60"

# cc02 = "#003049"
# cc01 = "#D62828"
# cc03 = "#F77F00"
# cc04 = "#FCBF49"


fig, ax = plt.subplots(figsize=(13, 8.5))

min_year = 1970 
max_year = 2040

# Plot performance trace line with markers
ax.plot(top500_years, top500_perf_tflops, marker="o", color=cc02, linewidth=0,  markersize=10, label="Top500 Linpack FP64")
ax.plot(forecast_years, trend_line_gflops.*1000.0, "--", label="TOP500 - Экспоненциальный тренд", linewidth=1.5, color=cc02)

ax.plot(xeon_df.Year, xeon_df.Linpack_GFLOPS.*1000.0, label="Intel Xeon Linpack FP32", linewidth=0, "^",color = cc01,  markersize= 10)
ax.plot(epyc_df.Year, epyc_df.Linpack_GFLOPS.*1000.0, label="AMD Epic Linpack FP32", linewidth=0, "v", color=cc03, markersize=10)

ax.plot(year_ai_tensor, perf_ai_tensor_tflops,  label = "NVIDEA GPU FP16", "s", color=cc04, markersize = 10, alpha = 0.7,linewidth=0)




# Главный целевой барьер: 1 Зеттафлопс
ax.plot([min_year; max_year],[1e+15; 1e+15], "-", linewidth=1.5, color = "lightgreen")

annotate("1 ZFLOPS (Цель -  Зеттафлопс барьер)", xy=(2036, 1e+15), xytext=(2010, 1e+15*3),
             arrowprops=Dict("facecolor" => "black", "shrink" => 0.08, "width" => 0.5, "headwidth" => 4), fontsize=11)

annotate("Xeon 6980P FP32 (7.1 TFlops)", xy=(2026, xeon_df.Linpack_GFLOPS[end] *1000.0*0.5 ), xytext=(2026, xeon_df.Linpack_GFLOPS[end] *1000.0*0.5   ), color = cc01, fontsize=11)
annotate("EPYC 9965 FP32 (9.9 TFlops)", xy=(2026, xeon_df.Linpack_GFLOPS[end] *1000.0*1.5  ), xytext=(2026, xeon_df.Linpack_GFLOPS[end]  *1000.0*1.5  ), color = cc03, fontsize=11)

annotate("Cray-2 (1st Gigaflop)", xy=(1985,  2.6 *1e+3 ), xytext=(1970,  2.6 *1e+3*1.5), color = cc02, 
             arrowprops=Dict("facecolor" => cc02, "shrink" => 0.08, "width" => 0.5, "headwidth" => 4), fontsize=11)

annotate("ASCI Red (1st Teraflop)", xy=(1997,  1e+6 ), xytext=(1980,  1.0 *1e+6*1.5), color = cc02, 
             arrowprops=Dict("facecolor" => cc02, "shrink" => 0.08, "width" => 0.5, "headwidth" => 4), fontsize=11)

annotate("Roadrunner (1st Petaflop)", xy=(2008,  1e+9 ), xytext=(1990,  1.0 *1e+9*1.5), color = cc02, 
             arrowprops=Dict("facecolor" => cc02, "shrink" => 0.08, "width" => 0.5, "headwidth" => 4), fontsize=11)

annotate("Frontier (1st Exascale)", xy=(2022,  1e+12 ), xytext=(2005,  1.0 *1e+12*1.5), color = cc02, 
             arrowprops=Dict("facecolor" => cc02, "shrink" => 0.08, "width" => 0.5, "headwidth" => 4), fontsize=11)

annotate("LineShine (2.19 EFlops)", xy=(2026,  2.19*1e+12 ), xytext=(2030,  2.19 *1e+12*1.5), color = cc02, 
             arrowprops=Dict("facecolor" => cc02, "shrink" => 0.08, "width" => 0.5, "headwidth" => 4), fontsize=11)

annotate("NVIDEA B200 FP16 (4.5 PFlops)", xy=(2024,  perf_ai_tensor_tflops[end] ), xytext=(2027,  perf_ai_tensor_tflops[end] * 1.2), color = cc04, 
             arrowprops=Dict("facecolor" => cc04, "shrink" => 0.08, "width" => 0.5, "headwidth" => 4), fontsize=11)

ax.plot(2012, 460.0e+6,  "*", color=cc02, markersize = 15, alpha = 0.7,linewidth=0)
annotate("Vilje Linpack FP64", xy=(2012,  460e+6 ), xytext=(2015,  460e+6* 0.1), color = cc02, 
             arrowprops=Dict("facecolor" => cc02, "shrink" => 0.08, "width" => 0.5, "headwidth" => 4), fontsize=12)


# Показать интерактивное окно Matplotlib
ax.legend(fontsize=12)
ax.grid()
ax.minorticks_on()
ax.set_yscale("log")
ytick_values = [1.0, 1e+3, 1e+6, 1e+9, 1e+12, 1e+15 ]
ytick_labels = ["1 MFLOPS", "1 GFLOPS", "1 TFLOPS", "1 PFLOPS", "1 EFLOPS", "1 ZFLOPS"]
ax.set_yticks(ytick_values)
ax.set_yticklabels(ytick_labels)
ax.tick_params(axis="both", labelsize=12) 

ylim(1e-1, 1e+16)
xlim(1970, 2040)
xlabel("Календарный год", fontsize=14)
ylabel("Производительность вычислительных систем",fontsize=14)

# Сохранить график в файл высокого качества (векторный PDF или PNG)

PyPlot.tight_layout()
PyPlot.show()

PyPlot.savefig("fig_xx_top500_hpc_performance.pdf", dpi=300)
PyPlot.savefig("fig_xx_top500_hpc_performance.png", dpi=300)