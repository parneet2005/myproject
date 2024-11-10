    %----------------------------------------------------------------------
    %--------------------2D FDTD CODE STARTS HERE--------------------------
    %----------------------------------------------------------------------
function [receiver_times] = FDTD_NLOS(B, A_receivers_x, A_receivers_y)
    clear all
    close all
    clc
    
    %set environment constants
    disp('Setting up Environment Constants...')
    c0 = 299792500;
    fmax = 5.9e9;            % freq. used in V2V to calculate gaussian pulse width
    lambda = c0/fmax;        %Wavelength
    mu_0 = 4*pi*1e-7;       %Change these values to change from empty space to other (Density)
    eps_0 = 8.854187e-12;
    n = 1;                  %refractive index - THIS MAY CHANGE
    Z_fs = sqrt(mu_0/eps_0);
    
    %GRID RESOLUTION
    disp('Calculating Grid Resolution...')
    grid_size_in_wavelengths_x = 20;
    grid_size_in_wavelengths_y = grid_size_in_wavelengths_x;
    steps_per_wavelength = 0.1694; %Changed from 30
    dx = lambda/steps_per_wavelength;
    dy = dx; %step size in meters - which is a fraction of the min wavelength %originally multiplied with steps_per_wavelength
    numX = grid_size_in_wavelengths_x^2; 
    numY = numX;%number of steps in a grid
    
    %TIME RESOLUTION
    disp('Calculating Time Resolution...')
    nbc = n;    %Refractive Index
    dt = nbc*dx/(2*c0); %the factor of 2 required for perfect boundary conditions
    
    %Simulation Time
    disp('Calculating Simulation Time...')
    tau = 1/(pi*fmax); %as a function of the pulse bandwidth
    nmax = n;
    max_grid_dimension = sqrt(numX^2+numY^2);
    grid_prop_time = nmax*max_grid_dimension*dx/c0;
    sim_time = 12*tau+5*grid_prop_time;
    T_STEPS = ceil(sim_time/dt);
    
    %SOURCE CONSTRUCTION
    disp('Calculating Source Injection...')
    source_idx_x = 300;%B(1);     %Position of transmission source
    source_idx_y = 300;%B(2);     %Position of transmission source
    t_points = [0:T_STEPS-1]*dt;
    t_delay = 6*tau; %delay for excitation
    mag_E = 1;  %assume unit amplitude
    D_src = mag_E*exp(-((t_points-t_delay)/tau).^2);
    figure(1)
    plot(t_points,D_src) %see the gaussian pulse
    title('Excitation Profile')
        %Magnetic Source Excitation
    Mu_r_source  = 1;
    Eps_r_source  = 1;
    n_src = 1;
    Mag_H = -1*sqrt(Eps_r_source/Mu_r_source);
    del_t_Hx = n_src*dx/(2*c0) + dt/2;
    H_src = Mag_H*exp(-(  (t_points-t_delay + del_t_Hx)/tau  ).^2);
    figure(2)
    plot(t_points,D_src,'b',t_points,H_src,'r')
    title('Staggered E and H Excitation Profile')
     
    %GRID MATERIAL ELECTROMAGNETICS
    disp('Setting Grid Material Electromagnetics...')
    EPS = ones(numX,numY);
    MU = ones(numX,numY);
    
    %Construct Problem Space Device
    %disp('SKIPPED: Contruction of 2D Device...')
    %2D device building code here
    
    %Computing Update Coefficients for 2D FDTD 
    disp('Computing Update Coefficients for Ez Mode...')
            % M_Ez = (c0*dt/dx)./EPS;
            % M_Hx = (c0*dt/dx)./MU; 
    M_Hx = (-c0*dt)./MU;
    M_Hy = (-c0*dt)./MU; %note that dy=dx
    M_Dz = (c0*dt); %note that these are scalar quantities
    M_Ez = 1./EPS;
            
    %Initialise fields to Zero
    disp('Initializing Problem Space Fields to Zero...')
    Hx = zeros(numX,numY);
    Hy = zeros(numX,numY);
    Cy_Ez = zeros(numX,numY);
    Cx_Ez = zeros(numX,numY);
    Cz_H = zeros(numX,numY);
    Dz = zeros(numX,numY);
    Ez = zeros(numX,numY);
    
    %START MAIN TIME LOOP
    disp('Starting Main Time Loop...')
    
    % surf(Ez,'LineStyle','none')
    % view(2) %for 2D surface plots
    % axis image % fit axis tightly and use same length for the data units
    % colorbar;
    % grid off
    
    for t = 1:T_STEPS
        disp(['time step: ',num2str(t)])
        %update
        for nx = 1:numX
            for ny = 1:(numY-1)
                Cx_Ez(nx,ny) = (Ez(nx,ny+1) - Ez(nx, ny))/dy;
            end
            Cx_Ez(nx,numY) = (0 - Ez(nx,numY))/dy;
        end
        
        for ny = 1:numY
            for nx = 1:(numX-1)
                Cy_Ez(nx,ny) = (-1)*(Ez(nx+1,ny) - Ez(nx,ny))/dx;
            end
            Cy_Ez(numX,ny) = (-1)*(0 - Ez(numX,ny))/dx;
        end
        
        
        %update
        for nx = 1:numX
            for ny = 1:numY
                Hx(nx,ny) = Hx(nx,ny) + M_Hx(nx,ny)*Cx_Ez(nx,ny);
                Hy(nx,ny) = Hy(nx,ny) + M_Hy(nx,ny)*Cy_Ez(nx,ny);
            end
        end
        
       
        %update
        Cz_H(1,1) = (Hy(1,1) - 0)/dx - (Hx(1,1) - 0)/dy;
        for nx = 2 : numX
            Cz_H(nx,1) = (Hy(nx,1) - Hy(nx-1,1))/dx - (Hx(nx,1) - 0)/dy;
        end
        for ny = 2 : numY
            Cz_H(1,ny) = (Hy(1,ny) - 0)/dx - (Hx(1,ny) - Hx(1,ny-1))/dy;
            for nx = 2 : numX
                Cz_H(nx,ny) = (Hy(nx,ny) - Hy(nx-1,ny))/dx - (Hx(nx,ny) - Hx(nx,ny-1))/dy;
            end
        end
    
        %update D
        for nx = 1:numX
            for ny = 1:numY
                Dz(nx,ny) = Dz(nx,ny)+M_Dz*Cz_H(nx,ny);
            end
        end
        %ADD SOURCE HERE
        Dz(source_idx_x,source_idx_y) = Dz(source_idx_x,source_idx_y) + D_src(t);
        %update Ez field
        for nx = 1:numX
            for ny = 1:numY
                Ez(nx,ny) = M_Ez(nx,ny)*Dz(nx,ny);
            end
        end

%         if (Dz(x1,y1)==0)
%             recet1 = t;
%             a = 0;
%         elseif (Dz(x1,y1)~=0)
%             a = 1;
%         else
%             a = 1;
%         end
% 
%         if (Dz(x2,y2)==0)
%             recet2 = t;
%             b = 0;
%         elseif (Dz(x2,y2)~=0)
%             b = 1;
%         else
%             b = 1;
%         end
% 
%         if (Dz(x3,y3)==0)
%             recet3 = t;
%             c = 0;
%         elseif (Dz(x3,y3)~=0)
%             c = 1;
%         else
%             c = 1;
%         end
% 
%         if (Dz(x4,y4)==0)
%             recet4 = t;
%             d = 0;
%         elseif (Dz(x4,y4)~=0)
%             d = 1;
%         else
%             d = 1;
%         end
% 
%         if a+b+c+d == 0
%         
%         %e= 1;
%         elseif a+b+c+d == 4
%             break
%         else
%         %e = 1;
%         end
    
        if (mod(t,20) == 0)
            surf(Ez,'LineStyle','none') %transpose just rotates it by 90 deg
            view(2) %for 2D surface plots
            axis image % fit axis tightly and use same length for the data units
            caxis([-max(abs(Ez(:))) max(abs(Ez(:)))]);
            colorbar;
            shading interp;
            drawnow;
        end
        
        
    
    
    %     if (t==100)
    %         break
    %     end
    %     if (mod(t,2) == 0)
    %         plot(grid_array,Ey,'b',grid_array,Hx,'r',vertical_x, vertical_y,'k--')
    %         hold off
    %         drawnow;
    %     end
        %pause(0.002)
        %source injection
        %Ey(source_idx) = Ey(source_idx) + E_src(t);
    
    end
    
    times = [recet1 recet2 recet3 recet4];

    receiver_times = times;
    
    close all %for debugging perposes
    
    
    disp('[[  End of Program  ]]')
end
    
    
    
    
    

