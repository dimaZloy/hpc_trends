
using PyPlot;
using Dates;
using Printf;
using DelimitedFiles;
using Statistics; 
using HDF5;


## https://www.karlrupp.net/2018/02/42-years-of-microprocessor-trend-data/
## from https://github.com/karlrupp/microprocessor-trend-data/tree/master/48yrs
include("cores.jl")
include("freq.jl")
include("specint.jl")

include("top500.jl") ## from top500.org

## HPC tests of OF runs at Stallo HCP facility 
## OF-v1.7.1
## 3D Lid-driven cavity flow with grids  
## OF 150x150x150
## OF 200x200x200
## OF 250x250x250

## AF from <http://www.ansys.com/Support/Platform+Support/Benchmarks+Overview>.
## AF 150x150x150
## AF 200x200x200
## AF 250x250x250

fluent3=[
1	1
2	2
4	3.7
8	6
16	12
32	23.4
64	43.3
128	61.2
256	81.1
512	83.7
];

fluent2=[
1	1
8	7.9
16	15.5
32	31.4
64	59.4
128	115.4
256	192.9
512	324
];


fluent1=[
1	1
8	7.8
16	14.8
32	28.3
64	55
128	103.9
256	189.7
512	295.4

];


ideal=[
1 1 
256 256
512 512
1024 1024
];

idealW=[
1 1 
256 1
512 1
1024 1
];




of150=[

128	36.8
256	130.8
512	148.8
1024	97.7
];

of200=[

128	29.1
256	60.7
512	186.5
1024	204.9

];

of250=[

48	18.6
96	47.6
144	76.8
256	141.6
512	422.82
1024	638.93

];



ofW25=[
1	1
8	0.65
27	1.22
125	2.18
216	3.18
343	3.65
512	4.16
1000	7.06
];

ofW35=[
1	1
8	0.26
27	0.54
125	0.89
216	1.04
343	1.52
512	1.73
1000	1.97

];

ofW25[:,2] = 1.0./ofW25[:,2];
ofW35[:,2] = 1.0./ofW35[:,2];

#########################################################################


## HPC tests of ala HCcylinder runs at Vilje HCP facility 
## meshes: 
## 13M: cells: 12744448
## 25M: cells: 24570240
## 38M: cells: 38059341




M13data=[
## N	delta	Sp	Sp ideal	Ev
32	10950	1	1	1
64	5616	1.9497863248	2	0.9748931624
128	2970	3.6868686869	4	0.9217171717
256	1585	6.9085173502	8	0.8635646688
512	839	13.0512514899	16	0.8157032181
1024	477	22.9559748428	32	0.7173742138
];

M25data=[
##N	delta	Sp	Sp ideal	Ev
64	6345	1	1	1
128	3312	1.9157608696	2	0.9578804348
256	1776	3.5726351351	4	0.8931587838
512	1011	6.2759643917	8	0.784495549
1024	461	13.7635574837	16	0.6602223427

];

M38data=[
##N	delta	Sp	Sp ideal	Ev				
128	6702	1	1	1
256	3529	1.8991215642	2	0.9495607821
512	1852	3.6187904968	4	0.9046976242
1024	1077	6.2228412256	8	0.7778551532
2048	660	10.1545454545	16	0.6346590909
];


figure(141);
clf();

lw2 = 2;
fs = 12;
ms = 5.0;
xmin = 1
xmax = 2048*2
ymin = 1
ymax = 2048*2

Sp_ideal = [
1	1
32	32
64	64
128	128
256	256
512	512
1024	1024
2048	2048
4098	4098

];

Ep_ideal = [
1	1
32	1
64	1
128	1
256	1
512	1
1024	1
2048	1
4098	1
];


subplot(1,2,1)

loglog(fluent1[:,1], fluent1[:,2],"*k",markersize=ms,color = "navy", label="1-AF");
loglog(fluent2[:,1], fluent2[:,2],"*k",markersize=ms,color = "blue", label="2-AF");
loglog(fluent3[:,1], fluent3[:,2],"*k",markersize=ms,color = "indigo", label="3-AF");

# loglog(xx, ftAVE,'k','linewidth',1.5);

 loglog(of150[:,1], of150[:,2],"og",markersize=ms,color = "darkgreen", label="3ML-Stallo");
 loglog(of200[:,1], of200[:,2],"og",markersize=ms,color = "lime", label="8ML-Stallo");
 loglog(of250[:,1], of250[:,2],"og",markersize=ms,color = "turquoise", label="16ML-Stallo");

loglog(M13data[:,1],M13data[:,3].*32, "^r", markersize=ms, color = "darkred", label="13MT-Vilje", linewidth = lw2);
loglog(M25data[:,1],M25data[:,3].*64, "^r", markersize=ms, color = "lightcoral",  label="25MT-Vilje", linewidth = lw2);
loglog(M38data[:,1],M38data[:,3].*128,"^r", markersize=ms, color = "magenta", label="38MT-Vilje", linewidth = lw2);

loglog(Sp_ideal[:,1],Sp_ideal[:,2], "--", color = "midnightblue",label="Ideal", linewidth = lw2-1.0);

xlabel("Number of MPI procs");
ylabel("Sp");
xlim(xmin, xmax);
ylim(ymin, ymax);
legend(fontsize=fs);
grid(which="both", ls="-", color="lightgreen");


subplot(1,2,2)



semilogx(M13data[:,1],M13data[:,5], "^r", markersize=ms, color = "darkred", label="13MT-Vilje", linewidth = lw2);
semilogx(M25data[:,1],M25data[:,5], "^r", markersize=ms, color = "lightcoral", label="25MT-Vilje", linewidth = lw2);
semilogx(M38data[:,1],M38data[:,5], "^r", markersize=ms, color = "magenta", label="38MT-Vilje", linewidth = lw2);

semilogx(M13data[:,1],M13data[:,5], "-.", color = "darkred", linewidth = lw2);
semilogx(M25data[:,1],M25data[:,5], "--", color = "lightcoral", linewidth = lw2);
semilogx(M38data[:,1],M38data[:,5], "-", color = "magenta", linewidth = lw2);

semilogx(Ep_ideal[:,1],Ep_ideal[:,2], "--", color = "midnightblue",label="Ideal", linewidth = lw2-1.0);
xlabel("Number of MPI procs");
ylabel("Ep");
xlim(xmin, xmax);
ylim(0.0, 1.05);
legend(fontsize=fs);
grid(which="both", ls="-", color="lightgreen");



figure(200);
clf();
subplot(1,2,1)
semilogy(cpu_cores_dat[:,1],cpu_cores_dat[:,2], "^r", markersize=ms+1, color = "darkred", linewidth = lw2,label ="№ ядер");
semilogy(cpu_freq_dat[:,1],cpu_freq_dat[:,2], "og", markersize=ms, color = "darkorange", linewidth = lw2, label ="Частота MHz");
semilogy(cpu_specint_dat[:,1],cpu_specint_dat[:,2], "sb", markersize=ms, color = "darkblue", linewidth = lw2,label ="SPECInt x 1e+3");
ylabel("");
xlabel("");
xlim(1970, 2025);
ylim(1e-1, 1e+6);
legend(fontsize=fs);
grid(which="both", ls="-", color="lightgreen");


subplot(1,2,2)
semilogy(top500data2021[:,1],top500data2021[:,2], "*k", markersize=ms+2, color = "tomato", linewidth = lw2);
ylabel(L"\mathtt{R_{p} TFlops}");
xlabel("");
xlim(1990,2025);
ylim(1e-2, 2e+6);
#legend(fontsize=fs);
grid(which="both", ls="-", color="lightgreen");


