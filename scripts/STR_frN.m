ssn = { 'YYY','DJF','MAM','JJA','SON'};
nssn = length(ssn);

yr1= 1979;
yr2 = 2015;
yrs = (yr1:yr2);
nyrs = length(yrs);

C = {'k','b','r','g','y',[.5 .6 .7],[0 0.75 0.75 ]} ;


figure
for issn = 1:nssn
    subplot(nssn,1,issn);
    for isec = 1:1
    if issn~=2
        x = squeeze(yrs(1,:));
        y1=squeeze(STRloc(isec,issn,:));
        y2 =  -squeeze(STRint(isec,issn,:));
        y3 = squeeze(frN(isec,issn,:))/1000;
    else
        x = squeeze(yrs(1,2:nyrs));
        y1=squeeze(STRloc(isec,issn,2:nyrs));
        y2 =  -squeeze(STRint(isec,issn,2:nyrs));
        y3 = squeeze(frN(isec,issn,2:nyrs))/1000;
    end
        [ax,p1,p2] = plotyy(x, y1,x,y2);
        xlim(ax(1),[yr1-1 yr2+1]);
        xlim(ax(2),[yr1-1 yr2+1]);
        ylim(ax(2),[1016;10120]);
        
        %reduce the width of the plot
        pos = get(ax(1),'position');
        offset = 0.07;
        ax(1).Position = [pos(1)+offset pos(2) pos(3)-offset pos(4)];
        
        %Determine the proper x-limits for the third axes
        limx1=get(ax(1),'xlim');
        limx3=[limx1(1)-offset*(limx1(2)-limx1(1))/pos(3)   limx1(2) ];
        
        pos3 = pos;
        ax(3)=axes('Position',pos3,'box','off',...
       'Color','none','XColor','k','YColor','g',...   
       'xtick',[],'xlim',limx3,'yaxislocation','left','NextPlot','add');
       limy3=get(ax(3),'YLim');

       %Hide unwanted portion of the x-axis line that lies
       %between the end of the second and third axes
%        cfig = get(gcf,'color');
%        line([limx3(1) limx1(1)],[-1 -1],...
%            'Color','g','Parent',ax(3),'Clipping','off');
%        axes(ax(2))
%        
       plot(ax(3),x,y3,'Color','g')

%         p.Color = C{isec};
%         if isec == 1
%             p.LineWidth = 2
%         end 
%         hold on;
        title(ssn(issn));
    end
    if issn == nssn
       lgd = legend({'STRloc','-STRint'})
       lgd.Location = 'southoutside'
    end
end

clear y1 y2 x
