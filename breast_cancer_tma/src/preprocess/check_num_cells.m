load('Images.mat')

num_cells = [];
for i = 1:3
    
   for j = 1:72
       
       for k = 1:numel(Images{i,j}.patches)
         num_cells(end+1) =  detectCells(Images{i, j}.patches{k}, 256) ;
       end
       
   end
end

max(num_cells)
min(num_cells)

mean(num_cells)
