
range=.0:1.0:75;
name='../src/sht/rung'


mkpr=0;            % make ps and jpeg files
mkcontour=1;       % use pcolor or contour


s=findstr(name,'/');
s=s(length(s));
shortname=name(s+1:length(name));

for i=range
  ts=i;
  ts = sprintf('%9.5f',10000+ts);
  ts=ts(2:10);

  tsf=[name,ts,'.vor']
  fidvor=fopen(tsf,'r');
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
  qmax=max(max(max(abs(q))));
  disp(sprintf('max vor=                %f ',qmax));
  vor = squeeze(q(:,:,1))';

  
  tsf=[name,ts,'.w']
  fid=fopen(tsf,'r');
  time=fread(fid,1,'float64')
  data=fread(fid,3,'float64');
  nx=data(1);
  ny=data(2);
  nz=data(3);
  
  x=fread(fid,nx,'float64');
  y=fread(fid,ny,'float64');
  z=fread(fid,nz,'float64');
  h = fread(fid,nx*ny*nz,'float64');
  h = reshape(h,nx,ny,nz);
  h = squeeze(h(:,:,1))';
  

  %
  %2D field.  options set above:
  %mkcontour=0,1    use pcolor, or contour plot
  %
  figure(1)

  subplot(2,1,1)
  ts=sprintf('vorticity  time=%.2f  max=%e',time,qmax)
  pcolor(x,y,vor)
  shading interp
  title(ts);
  axis square

  subplot(2,1,2)
  pcolor(x,y,h)
  shading interp
  axis square
  title('height')
  
  
  disp('pause...')
  pause
end


  
if (mkpr) 
  if (mplot>0)
    orient tall
  end
  pname=[name,'.vor.ps'];
  disp('creating ps...')
  print('-depsc',pname);
  pname=[name,'.vor.jpg'];
  disp('creating jpg...')
  print('-djpeg','-r 96',pname);
end
