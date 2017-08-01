
%%Import frN, SAMssn, STRloc/int


%sec = { '0_90S','300_340E.0_90S','30_90E.0_90S','90_150E.0_90S','150_210E.0_90S','210_285E.0_90S'};
%charsec = {'SH','Atl','Ind','Au','WPac','EPac'}
ssn = { 'YYY','DJF','MAM','JJA','SON'};

yr1= 1979;
yr2 = 2015;
yrs = (yr1:yr2);
nyrs = length(yrs);


cc_STRloc_frN = zeros(6,5);
cc_STRint_frN = zeros(6,5);
for isec = 1:nsec
for issn = 1:5
    
    if issn ~=2 
        pc_STRloc_frN_mslp65(isec,issn) = partialcorri(squeeze(STRloc(isec,issn,:)),squeeze(frN(isec,issn,:)),squeeze(mslp65(isec,issn,:)));
        cc = corrcoef(STRloc(isec,issn,:),frN(isec,issn,:));
        cc_STRloc_frN(isec,issn) = cc(1,2);
        pc_STRint_frN_mslp65(isec,issn) = partialcorri(squeeze(STRint(isec,issn,:)),squeeze(frN(isec,issn,:)),squeeze(mslp65(isec,issn,:)));
        cc = corrcoef(STRint(isec,issn,:),frN(isec,issn,:));
        cc_STRint_frN(isec,issn) = cc(1,2);
        cc = corrcoef(STRloc(isec,issn,:),SAMssn(isec,issn,:));
        cc_STRloc_SAM(isec,issn) = cc(1,2);
        cc = corrcoef(STRint(isec,issn,:),SAMssn(isec,issn,:));
        cc_STRint_SAM(isec,issn) = cc(1,2);
        cc = corrcoef(frN(isec,issn,:),SAMssn(isec,issn,:));
        cc_frN_SAM(isec,issn) = cc(1,2);
   else
        %nyrs = size(yrs(:,1));
        pc_STRloc_frN_mslp65(isec,issn) = partialcorri(squeeze(STRloc(isec,issn,2:nyrs)),squeeze(frN(isec,issn,2:nyrs)),squeeze(mslp65(isec,issn,2:nyrs)));
        cc = corrcoef(STRloc(isec,issn,2:nyrs),frN(isec,issn,2:nyrs));
        cc_STRloc_frN(isec,issn) = cc(1,2);
        pc_STRint_frN_mslp65(isec,issn) = partialcorri(squeeze(STRint(isec,issn,2:nyrs)),squeeze(frN(isec,issn,2:nyrs)),squeeze(mslp65(isec,issn,2:nyrs)));
        cc = corrcoef(STRint(isec,issn,2:nyrs),frN(isec,issn,2:nyrs));
        cc_STRint_frN(isec,issn) = cc(1,2);
        cc = corrcoef(STRloc(isec,issn,2:nyrs),SAMssn(isec,issn,2:nyrs));
        cc_STRloc_SAM(isec,issn) = cc(1,2);
        cc = corrcoef(STRint(isec,issn,2:nyrs),SAMssn(isec,issn,2:nyrs));
        cc_STRint_SAM(isec,issn) = cc(1,2);
        cc = corrcoef(frN(isec,issn,2:nyrs),SAMssn(isec,issn,2:nyrs));
        cc_frN_SAM(isec,issn) = cc(1,2);
   end
    
end
end

figure
for isec = 1:nsec
    isec
    subplot(3,2,isec)
    xleft = .8:4.8;
    xcent = 1:5;
    xright = 1.2:5.2;
    c1 = plot(xleft,cc_STRloc_frN(isec,:),'ko');
    title(charsec(isec));
    ylim([0 1]);
    xlim([0.5 5.5]);
    %set(gca,'XTick',[1.5:4.5])
    set(gca,'xgrid','off')
    
    set(gca,'XTick',[1:5])
    set(gca,'XTickLabel',ssn)
    set(gca,'ticklength',[0 0])
    for iline = 1.5:4.5
        line([iline iline], get(gca, 'ylim'),'Color','black','LineWidth',0.0005);
    end

    
    hold on;
    p1 = plot(xleft,pc_STRloc_frN_mslp65(isec,:),'kx');
    hold on;
    c2 = plot(xright,-cc_STRint_frN(isec,:),'mo');
    hold on;
    p2 = plot(xright,-pc_STRint_frN_mslp65(isec,:),'mx')
    c3 = plot(xleft,-cc_STRloc_SAM(isec,:),'kd');
    c4 = plot(xright,cc_STRint_SAM(isec,:),'md');
    c5 = plot(xcent,-cc_frN_SAM(isec,:),'b*');
    if isec == 5
        lgd = legend([c1 p1 c3],{' STRloc / frN',' STRloc / frN / mslp65','-STRint / SAM'}) ;
        lgd.Location = 'southwest';
        %legend('boxoff')
    end
    if isec == 6
        lgd = legend([c2 p2 c4 c5],{'-STRint / frN','-STRint / frN / mslp65',' STRint / SAM', '-frN / SAM'}) ;
        lgd.Location = 'southeast';
        %legend('boxoff')
    end
end
