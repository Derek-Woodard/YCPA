winstyle = 'docked';
% winstyle = 'normal';

set(0,'DefaultFigureWindowStyle',winstyle)
set(0,'defaultaxesfontsize',18)
set(0,'defaultaxesfontname','Times New Roman')
% set(0,'defaultfigurecolor',[1 1 1])

% clear VARIABLES;
clear
global spatialFactor;
global c_eps_0 c_mu_0 c_c c_eta_0
global simulationStopTimes;
global AsymForcing
global dels
global SurfHxLeft SurfHyLeft SurfEzLeft SurfHxRight SurfHyRight SurfEzRight

close all

dels = 0.75;
spatialFactor = 1;

c_c = 299792458;                  % speed of light
c_eps_0 = 8.8542149e-12;          % vacuum permittivity
c_mu_0 = 1.2566370614e-6;         % vacuum permeability
c_eta_0 = sqrt(c_mu_0/c_eps_0);


tSim = 200e-15

% Lowering the frequency allows more waves to pass through the barriers.
% Raising the frequency prevents the waves from passing through as easily.
f = 230e12;
lambda = c_c/f;

xMax{1} = 20e-6;
nx{1} = 200;
ny{1} = 0.75*nx{1};


Reg.n = 1;

mu{1} = ones(nx{1},ny{1})*c_mu_0;

% The inclusion adds the barrier(s) that the wave interacts with
% commenting this out still lets the program run, but with no barrier,
% there is nothing for the planewave to interact with aside from the border
epi{1} = ones(nx{1},ny{1})*c_eps_0;
% epi{1}(75:85,50:100)= c_eps_0*11.3;    % This is the code that adds the inclusion

% The following add more blocks for the grating effect
epi{1}(145:155,70:80)= c_eps_0*11.3;
epi{1}(165:175,70:80)= c_eps_0*11.3;
epi{1}(185:195,70:80)= c_eps_0*11.3;
epi{1}(125:135,70:80)= c_eps_0*11.3;
epi{1}(105:115,70:80)= c_eps_0*11.3;

epi{1}(145:155,90:100)= c_eps_0*11.3;
epi{1}(165:175,90:100)= c_eps_0*11.3;
epi{1}(185:195,90:100)= c_eps_0*11.3;
epi{1}(125:135,90:100)= c_eps_0*11.3;
epi{1}(105:115,90:100)= c_eps_0*11.3;

epi{1}(145:155,50:60)= c_eps_0*11.3;
epi{1}(165:175,50:60)= c_eps_0*11.3;
epi{1}(185:195,50:60)= c_eps_0*11.3;
epi{1}(125:135,50:60)= c_eps_0*11.3;
epi{1}(105:115,50:60)= c_eps_0*11.3;

epi{1}(125:135,110:120)= c_eps_0*11.3;
epi{1}(145:155,110:120)= c_eps_0*11.3;
epi{1}(165:175,110:120)= c_eps_0*11.3;

epi{1}(125:135,30:40)= c_eps_0*11.3;
epi{1}(145:155,30:40)= c_eps_0*11.3;
epi{1}(165:175,30:40)= c_eps_0*11.3;


sigma{1} = zeros(nx{1},ny{1});
sigmaH{1} = zeros(nx{1},ny{1});

dx = xMax{1}/nx{1};
dt = 0.25*dx/c_c;
nSteps = round(tSim/dt*2);
yMax = ny{1}*dx;
nsteps_lamda = lambda/dx

movie = 1;
Plot.off = 0;
Plot.pl = 0;
Plot.ori = '13';
Plot.N = 100;
Plot.MaxEz = 1.1;
Plot.MaxH = Plot.MaxEz/c_eta_0;
Plot.pv = [0 0 90];
Plot.reglim = [0 xMax{1} 0 yMax];

% bc sets the boundary conditions
bc{1}.NumS = 2;

% bc.s provides the source of the plane wave
bc{1}.s(1).xpos = nx{1}/(4) + 1;
bc{1}.s(1).type = 'ss';
bc{1}.s(1).fct = @PlaneWaveBC;

% This is my attempt to add a second source in the middle of the area
bc{1}.s(2).xpos = nx{1}/(2) + 1;
bc{1}.s(2).type = 'ss';
bc{1}.s(2).fct = @PlaneWaveBC;

% mag = -1/c_eta_0;
mag = 1;
phi = 0;
omega = f*2*pi;
betap = 0;
t0 = 30e-15;
st = -0.05; %15e-15;
s = 0;
y0 = yMax/2;
sty = 1.5*lambda;
bc{1}.s(1).paras = {mag,phi,omega,betap,t0,st,s,y0,sty,'s'};

% This is part of my attempt to add a second source
bc{1}.s(2).paras = {mag,phi,omega,betap,t0,st,s,y0,sty,'s'};

Plot.y0 = round(y0/dx);

% The different types of boundary conditions are set here for the top,
% bottom, left, and right
bc{1}.xm.type = 'a';
% bc{1}.xp.type = 'a';
bc{1}.xp.type = 'e';
bc{1}.ym.type = 'a';
bc{1}.yp.type = 'a';

pml.width = 20 * spatialFactor;
pml.m = 3.5;

Reg.n  = 1;
Reg.xoff{1} = 0;
Reg.yoff{1} = 0;

RunYeeReg






