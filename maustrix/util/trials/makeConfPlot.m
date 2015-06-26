function makeConfPlot(x,d,c)
chance=.5;
plot([1 max(x)],chance*ones(1,2),'k');
hold on

transparency=.2;

fill([x x(length(x):-1:1)],[d.pci(:,2)' d.pci(length(x):-1:1,1)'],c,'FaceAlpha',transparency,'LineStyle','none');
plot(x,d.phat,c);
errorbar(x,d.phat,d.phat-d.pci(:,1)',d.pci(:,2)'-d.phat,c);

ylim([0 1]);
xlim([1 max(x)]);
end