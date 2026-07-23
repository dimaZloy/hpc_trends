
# 2. Define Historical Supercomputer Datasets using string parsing
top500_years_str = "1971 1974 1975 1976 1981 1982 1985 1988 1989 1991 " *
            "1993 1994 1995 1996 1997 1998 1999 2000 2001 2002 2003 2004 " *
            "2005 2006 2007 2008 2009 2010 2011 2012 2013 2014 2015 2016 " *
            "2017 2018 2019 2020 2021 2022 2023 2024 2025 2026"
top500_years = parse.(Int, split(top500_years_str))

top500_models = [
    "CDC 7600", "CDC STAR-100", "ILLIAC IV", "Cray-1", "CDC Cyber-205",
    "Cray X-MP", "Cray-2", "Cray Y-MP", "NEC SX-3", "Cray C90",
    "TMC CM-5", "Fujitsu NWT", "Intel Paragon", "Hitachi SR2201", "ASCI Red",
    "ASCI Red (Upgraded)", "ASCI Red (Upgraded)", "ASCI White", "ASCI White", "Earth Simulator",
    "Earth Simulator", "BlueGene/L", "BlueGene/L", "BlueGene/L", "BlueGene/L",
    "IBM Roadrunner", "Cray XT5 Jaguar", "Cray XT5 Jaguar", "Fujitsu K Computer", "IBM Sequoia",
    "MilkyWay-2", "MilkyWay-2", "MilkyWay-2", "Sunway TaihuLight", "Sunway TaihuLight",
    "IBM Summit", "IBM Summit", "Fujitsu Fugaku", "Fujitsu Fugaku", "HPE Frontier",
    "HPE Frontier", "HPE Frontier", "HPE El Capitan", "NSCS LineShine"
]

top500_perf_str = "0.036 0.100 0.150 0.160 0.400 0.800 1.90 2.60 22.0 16.0 " *
           "59.7 124.0 170.0 220.4 1060.0 1338.0 2121.0 4930.0 7226.0 35860.0 " *
           "35860.0 70720.0 136800.0 280600.0 478200.0 1026000.0 1759000.0 1759000.0 " *
           "10510000.0 16320000.0 33860000.0 33860000.0 33860000.0 93010000.0 " *
           "93010000.0 143500000.0 148600000.0 442010000.0 442010000.0 " *
           "1102000000.0 1194000000.0 1206000000.0 1742000000.0 2198400000.0"
top500_perf_gflops = parse.(Float64, split(top500_perf_str))
top500_perf_tflops = top500_perf_gflops.*1e+3
top500_perf_pflops = top500_perf_gflops.*1e+6
top500_perf_eflops = top500_perf_gflops.*1e+9

# Create DataFrame table presentation
top500_data = DataFrame(Deployment_Year = top500_years, System_Model = top500_models, Peak_Perf_GFLOPS = top500_perf_gflops)
println(top500_data)


# 2. Математический расчет экспоненциальной регрессии
# log10(Rmax) = slope * Year + intercept
log_y = log10.(top500_data.Peak_Perf_GFLOPS)
X = [ones(length(top500_data.Deployment_Year)) top500_data.Deployment_Year]
beta = X \ log_y # Метод наименьших квадратов
intercept, slope = beta[1], beta[2]

# Определение года достижения цели (log10(10^12) = 12)
target_log = 12.0
predicted_target_year = (target_log - intercept) / slope

# 3. Вектор годов для построения плавной линии тренда (с экстраполяцией до 2035)
forecast_years = collect(1971:2040)
trend_line_gflops = 10 .^ (slope .* forecast_years .+ intercept)
