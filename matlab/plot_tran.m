function plot_tran(fid,time,dp)  
%
%read in the U(U**2+V**2+W**2) structure functions
%
components=['u','v','w'];
var=['x','y','z'];
axmax=0;
clf
for j=1:3
  for i=1:3
    subplot(3,3,3*(i-1)+j)
    [n_del,delta,bin_size,n_bin,n_call,bins,pdf]=read1pdf(fid);
    
    p=1;
    % structure function to the p'th power
    str=sum(pdf(:,dp).*bins(:,dp).^p);

    mx=max(bins(:,dp) - bins(:,dp).*(pdf(:,dp)==0));
    mn=min(bins(:,dp) - bins(:,dp).*(pdf(:,dp)==0)); % min over non zero values
    bar(bins(:,dp),pdf(:,dp))
    ax=axis;
    axmax=max(axmax,ax(4));
    

    text=['\Delta',sprintf('_{%i%s}',delta(dp),var(i))]; 
    text=[text,sprintf('%s   ||',components(j)),text,'U||^2'];
    text=['[   ',text,'   ]^{.33}'];
    ylabel(text);
    xlabel(sprintf('[%.3f,%.3f]  nc=%i',mn,mx,n_call));
    set(gca,'YTickLabel','')    
  end
end
for j=1:3
  for i=1:3
    ax=axis;
    axmax=max(axmax,ax(4));
    subplot(3,3,3*(i-1)+j)
    axis([-5,5,0,axmax]);
    %axis([ax(1),ax(2),0,axmax]);
    
    if ((i==1) & (j==2))
      ax=axis;
      x=.5*( ax(1)+ax(2)) - .1*(ax(2)-ax(1));
      y=ax(4) + .2*(ax(4)-ax(3));
      title(sprintf('Time=%.2f   U=(u,v,w)',time))
      %text(x,y,sprintf('Time=%.2f',time));
    end
  end
end
