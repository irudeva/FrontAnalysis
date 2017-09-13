
var = {'SH','LH','PE'};
yr1 = 1979;
yr2 = 2015;


for iv = 1:3
    
    disp(char(var(iv)));
    fnc = char(strcat('/Users/irudeva/work/Communication/GhyslaineBoschat/Fluxes/latitudes_when_zm_',var(iv),'_eq_0.nc'));
    vart = ncread(fnc,'time');
    varlat = ncread(fnc,'latitudes');
    
    vartime = (vart)/24 + datenum('1900-01-01 00:00:00');
    clear vart
    
    for i = 1:length(varlat)
       varyr(i,1)=str2double(datestr(vartime(i,1),'yyyy'));
       varmm(i,1)=str2double(datestr(vartime(i,1),'mm')) ;
    end
    
    %YYY
    for iyr = yr1:yr2
        varssn(iyr-yr1+1,1) = mean(varlat(varyr==iyr));
    end
    
    %DJF
    varssn(1,2) = NaN;
    for iyr = yr1+1:yr2
        varssn(iyr-yr1+1,2) = mean(varlat((varyr==iyr-1 & varmm==12) | (varyr==iyr & (varmm==1 | varmm==2))));
    end
    
    
    %MAM
    for iyr = yr1:yr2
        varssn(iyr-yr1+1,3) = mean(varlat(varyr==iyr &(varmm==3 | varmm==4 | varmm==5)));
    end
    
    %JJA
    for iyr = yr1:yr2
        varssn(iyr-yr1+1,4) = mean(varlat(varyr==iyr &(varmm==6 | varmm==7 | varmm==8)));
    end
    
    %SON
    for iyr = yr1:yr2
        varssn(iyr-yr1+1,5) = mean(varlat(varyr==iyr &(varmm==9 | varmm==10 | varmm==11)));
    end
    
    if strcmp(var(iv),'SH') 
        SHssn = varssn;
    else if strcmp(var(iv),'LH') 
        LHssn = varssn;
    else if strcmp(var(iv),'PE') 
        PEssn = varssn;
    end
    end
    end

end

clear fnc i iv iyr var varlat varmm varssn vartime varyr yr1 yr2


% Plotting
C = {'k','b','r','g','y','m','c',[.5 .6 .7],[0 0.75 0.75 ]} ;
yrclim = (1979:2000);

figure
isec = 1;
for issn = 1:nssn
    subplot(nssn,1,issn)
    
    %transform some vars to index form
    if issn~=2
        yr = squeeze(yrs(1,:));
        ifrN = (frN(isec,issn,:)-mean(frN(isec,issn,ismember(yrs,yrclim))))/std(frN(isec,issn,ismember(yrs,yrclim)));
        iSTRloc = (STRloc(isec,issn,:)-mean(STRloc(isec,issn,ismember(yrs,yrclim))))/std(STRloc(isec,issn,ismember(yrs,yrclim)));
        y1 = [ (squeeze(-SAMssn(isec,issn,:)))';(squeeze(ifrN))';(squeeze(iSTRloc))'];
        % for regular ts
        %y2 = [ squeeze(STRloc(isec,issn,:)),squeeze(SHssn(:,issn)),squeeze(LHssn(:,issn)),squeeze(PEssn(:,issn))];
        % for normalized ts
        iSH = (SHssn(:,issn)-mean(SHssn(ismember(yrs,yrclim),issn)))/std(SHssn(ismember(yrs,yrclim),issn));
        iLH = (LHssn(:,issn)-mean(LHssn(ismember(yrs,yrclim),issn)))/std(LHssn(ismember(yrs,yrclim),issn));
        iPE = (PEssn(:,issn)-mean(PEssn(ismember(yrs,yrclim),issn)))/std(PEssn(ismember(yrs,yrclim),issn));
        iSTRint = (STRint(isec,issn,:)-mean(STRint(isec,issn,ismember(yrs,yrclim))))/std(STRint(isec,issn,ismember(yrs,yrclim)));
        y2 = [ squeeze(iSTRloc),squeeze(iSH),squeeze(iLH),squeeze(iPE)];
   else
        clear ifrN iSTRloc yr
        yr = squeeze(yrs(1,2:nyrs));
        yrDJF = ismember(yrs(2:nyrs),yrclim);
        frN_DJF = frN(isec,issn,2:nyrs);
        STR_DJF = STRloc(isec,issn,2:nyrs);
        ifrN = (frN_DJF-mean(frN_DJF(yrDJF)))/std(frN_DJF(yrDJF));
        iSTRloc = (STR_DJF-mean(STR_DJF(yrDJF)))/std(STR_DJF(yrDJF));
        y1 = [ (squeeze(-SAMssn(isec,issn,2:nyrs)))';(squeeze(ifrN))';(squeeze(iSTRloc))'];
        % for regular ts
        %y2 = [squeeze(STRloc(isec,issn,2:nyrs)),squeeze(SHssn(2:nyrs,issn)),squeeze(LHssn(2:nyrs,issn)),squeeze(PEssn(2:nyrs,issn))];
        % for normalized ts
        SH_DJF =  SHssn(2:nyrs,issn);
        LH_DJF =  LHssn(2:nyrs,issn);
        PE_DJF =  PEssn(2:nyrs,issn);
        STR_DJF = STRint(isec,issn,2:nyrs);
        iSH = (SH_DJF-mean(SH_DJF(yrDJF)))/std(SH_DJF(yrDJF));
        iLH = (LH_DJF-mean(LH_DJF(yrDJF)))/std(LH_DJF(yrDJF));
        iPE = (PE_DJF-mean(PE_DJF(yrDJF)))/std(PE_DJF(yrDJF));
        iSTRint = (STR_DJF-mean(STR_DJF(yrDJF)))/std(STR_DJF(yrDJF));
        y2 = [ squeeze(iSTRloc),squeeze(iSH),squeeze(iLH),squeeze(iPE)];
    end
    
    x2 = [yr',yr',yr',yr'];
    [hAx,hLine1,hLine2] = plotyy(yr,y1,x2,y2);
    %[hAx,hLine1,hLine2] = plotyy(yr,y1,[yr',yr'],[squeeze(SHssn(:,issn)),squeeze(LHssn(:,issn))]);
    xlim(hAx(1),[yr1-1 yr2+1]);
    xlim(hAx(2),[yr1-1 yr2+1]);

    hold on
    %plot(hAx(1),yr,(squeeze(ifrN))')
    hLine1(1).Color = 'k';
    hLine1(2).Color = 'm';
    hLine1(1).LineWidth = 2;
    %[b1, b2] = hLine2.LineStyle
    hLine2(1).Color = 'r';
    %hLine2(1).LineStyle = '--';
    %hLine2(2).LineStyle = '--';
    %hLine2(3).LineStyle = '--';
    hLine2(2).LineWidth = 2;
    hLine2(3).LineWidth = 2;
    hLine2(4).LineWidth = 2;

%     s = plot(squeeze(yrs(1,:)), squeeze(SAMssn(isec,issn,:)),'-');
%     s.Color = C{1};
%     if isec == 1
%         p.LineWidth = 2
%     end 
%     hold on;
    
    
%     yyaxis left
%     sh = plot(squeeze(yrs(1,:)), squeeze(SHssn(:,issn)),'-');
%     sh.Color = C{2};
% 
%     lh = plot(squeeze(yrs(1,:)), squeeze(LHssn(:,issn)),'-');
%     lh.Color = C{3};
% 
%     pe = plot(squeeze(yrs(1,:)), squeeze(PEssn(:,issn)),'-');
%     pe.Color = C{4};
%     
%     f = plot(squeeze(yrs(1,:)), squeeze(frN(isec,issn,:)),'-');
%     f.Color = C{5};
% 
%    sl = plot(squeeze(yrs(1,:)), squeeze(STRloc(isec,issn,:)),'-');
%    sl.Color = C{6};

%     si = plot(squeeze(yrs(1,:)), squeeze(STRint(isec,issn,:)),'-');
%     si.Color = C{7};
    
    title(ssn(issn));
    
    if issn == nssn
       lgd = legend({'-SAM','ifrN','iSTRint','STRloc','SH','LH','PE'});
       lgd.Location = 'bestoutside';
    end
end

%clear x* y1 y2 yr yr1 yr2 yclim sl si s sh p pe ifrN iSTRlic b* C f lgd lh



for iv = 1:3
    
    disp(char(var(iv)));
    fnc = char(strcat('/Users/irudeva/work/Communication/GhyslaineBoschat/Fluxes/latitudes_when_zm_',var(iv),'_eq_0.nc'));
    vart = ncread(fnc,'time');
    varlat = ncread(fnc,'latitudes');
    
    vartime = (vart)/24 + datenum('1900-01-01 00:00:00');
    clear vart
    
    yr1 = 1979;
    yr2 = 2015;
    
    for i = 1:length(varlat)
       varyr(i,1)=str2double(datestr(vartime(i,1),'yyyy'));
       varmm(i,1)=str2double(datestr(vartime(i,1),'mm')) ;
    end
    
    %YYY
    for iyr = yr1:yr2
        varssn(iyr-yr1+1,1) = mean(varlat(varyr==iyr));
    end
    
    %DJF
    varssn(1,2) = NaN;
    for iyr = yr1+1:yr2
        varssn(iyr-yr1+1,2) = mean(varlat((varyr==iyr-1 & varmm==12) | (varyr==iyr & (varmm==1 | varmm==2))));
    end
    
    
    %MAM
    for iyr = yr1:yr2
        varssn(iyr-yr1+1,3) = mean(varlat(varyr==iyr &(varmm==3 | varmm==4 | varmm==5)));
    end
    
    %JJA
    for iyr = yr1:yr2
        varssn(iyr-yr1+1,4) = mean(varlat(varyr==iyr &(varmm==6 | varmm==7 | varmm==8)));
    end
    
    %SON
    for iyr = yr1:yr2
        varssn(iyr-yr1+1,5) = mean(varlat(varyr==iyr &(varmm==9 | varmm==10 | varmm==11)));
    end
    
    if strcmp(var(iv),'SH') 
        SHssn = varssn;
    else if strcmp(var(iv),'LH') 
        LHssn = varssn;
    else if strcmp(var(iv),'PE') 
        PEssn = varssn;
    end
    end
    end

end

clear fnc i iv iyr var varlat varmm varssn vartime varyr yr1 yr2

