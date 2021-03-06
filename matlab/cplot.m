fidu=fopen('test-0-0-0-0000.0000.data');

%
%########################################################################
%#  plotting output file
%########################################################################

%ts=input('time=? ');

%range=0:.1:100.00;
%range=50:5.0:100.0;
range=[.1];
%name='../src/kh1024'; 
name='../temp'

mkpr=0;            % make ps and jpeg files
mkcontour=0;       % use pcolor or contour
mplot=1;           % set to nonzero to put 'mplot' plots per figure

mplot=min(mplot,length(range));

s=findstr(name,'/');
s=s(length(s));
shortname=name(s+1:length(name));

kplot=1;
for i=range
  ts=i;
  ts = sprintf('%9.5f',10000+ts);
  ts=ts(2:10);

  ts=[name,ts,'.vor']
  fidvor=fopen(ts,'r');
  time=fread(fidvor,1,'float64')
  data=fread(fidvor,3,'float64');
  nx=data(1);
  ny=data(2);
  nz=data(3);
  
  x=fread(fidvor,nx,'float64');
  y=fread(fidvor,ny,'float64');
  z=fread(fidvor,nz,'float64');
  
  q = fread(fidvor,nx*ny*nz,'float64');
  tmp = fread(fidvor,1,'float64');
  tmp=size(tmp);
  if (tmp(1)~=0) 
    disp('Error reading input file...')
  end
  fclose(fidvor);
  
  q = reshape(q,nx,ny,nz);
  qmax=max(max(max(q)));
  disp(sprintf('max vor=                %f ',qmax));

  %ts=sprintf('%s    time=%.2f  %ix%ix%i',shortname,time,nx,ny,nz);
  ts=sprintf('%s    time=%.2f  max=%f',shortname,time,qmax)

  
  if (nz>=4 ) 
    %
    %  3D field, plot 4 sections in a 2x2 subplot window
    %
    figure(4)
    for i=1:4
       subplot(2,2,i)
       nzi=1 + (i-1)*nz/4;
       nzi=floor(nzi);
       vor = squeeze(q(:,:,nzi));
       pcolor(x,y,vor')
       if (i==1)
         title(ts);
       else
         title(sprintf('nz=%i',nzi));
       end
       shading interp
       axis square
     end
     figure(3)
     clf;
     %q=shiftdim(q,2);
     %isosurface(z,x,y,q,3.0);
     isosurface(x,y,z,q,2.0);
     axis([0 1 0 1 0 1]);
     view([30,30]);
 
  else
    %
    %  2D field.  options set above:
    %  mkcontour=0,1    use pcolor, or contour plot
    %  mplot=N        plot in a subplot(n,1) window
    %
    figure(1)
    if (kplot==1) clf; end;
    vor = squeeze(q(:,:,1));
    if (mplot>1) 
      subplot(mplot,1,kplot)
      kplot=mod(kplot,mplot)+1;
    end
    if (mkcontour==0)
      pcolor(x,y,vor')
     caxis([-300,300])
      shading interp
    else
      if (qmax>15) 
        v=-60:5:60;
      else
        v=10;  % use 10 contours
      end  
      contour(x,y,vor',v)
      hold on
      %contour(x,y,vor',[0 0],'k')
      hold off
    end
    
    title(ts);
    axis equal
  end
  
  if (kplot==1)
    if (mkpr) 
      if (mplot>0)
        orient tall
      end
      pname=[name,'.vor.ps'];
      disp('creating ps...')
      print('-depsc','-r 600',pname);
      pname=[name,'.vor.jpg'];
      disp('creating jpg...')
      print('-djpeg','-r 96',pname);
    end

    'pause'; pause
  end
end
return




%
%########################################################################
%#  restart file
%########################################################################
time=fread(fidu,1,'float64');


data=fread(fidu,4,'float64');
nx=data(1);
ny=data(2);
nz=data(3);
n_var=data(4);

q = fread(fidu,nx*ny*nz*n_var,'float64');
fclose(fidu);

disp(sprintf('restart dump:\ntime=%f  dims=%i %i %i %i',time,nx,ny,nz,n_var))
q = reshape(q,nx,ny,nz,n_var);

u = squeeze(q(:,:,1,1));
figure(1)
subplot(2,2,1)
pcolor(u')
shading interp

v = squeeze(q(:,:,1,2));
subplot(2,2,2)
pcolor(v')
shading interp


