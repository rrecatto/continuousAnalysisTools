function plot2axis(s,requested,handle)
[requested{ismember('binarySpatial',requested)}]=deal('SpatialModulation');
[requested{ismember('gaussianFullField',requested)}]=deal('Temporal');
plot2ax(s,handle,requested);
end
