function plotFlankerArray(db)

%more in order
nID=[1 4 6 6  8 9 11 20 21];
aID=[3 2 5 12 2 5 1  2  1];

%featured
nID=[6 11 21 1 9 20];
aID=[12 1  1 3 5 2];
figure;
for i=1:length(aID)
    subplot(2,3,i);
    db.data{nID(i)}.analyses{aID(i)}.plot2axis('main')
    
    yl=ylim; yRng=diff(yl);
    vals=[0 0.25 0.5 0.75 1];
    yloc=0.5-fliplr(vals)*(yRng);
    set(gca,'yTick',yloc,'yTickLabel',vals);
    ylabel('contrast')
    
    iso=db.data{nID(i)}.analyses{aID(i)}.data.anesthesia;
    facts=['N' num2str(nID(i)) '- iso:' num2str(iso)  ];
    %title(facts)
end
settings.MarkerSize=3;
settings.fontSize=20
cleanUpFigure([],settings)
end
