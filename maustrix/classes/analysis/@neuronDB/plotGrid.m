function plotGrid(db,type)
figure
xx=floor(sqrt(db.numNeurons));
yy=ceil(db.numNeurons/xx);
N=db.numNeurons;

fprintf('plotting %d, doing: ',N)
for i=1:N
    fprintf('.%d',i)
    subplot(xx,yy,i)
    try
        switch type
            case 'isi'
                db.data{i}.plotISI;
                if i~=1
                    set(gca,'ytick',[],'xtick',[])
                end
            otherwise
                error('bad type')
        end
    catch
        text(.5,.5,'fail');
        set(gca,'ytick',[],'xtick',[])
    end
    
end
end
