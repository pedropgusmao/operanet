function convert_and_save(data_dir)
fileList = dir([data_dir filesep '*.mat']);
for file_num =1:length(fileList)
    datafile = [fileList(file_num).folder filesep fileList(file_num).name];
    loaded_vars = load(datafile);
    loaded_vars_names = fieldnames(loaded_vars); %could be more than one

    for var_idx = 1:length(loaded_vars_names)
        this_var_name = loaded_vars_names{var_idx};
        this_var = loaded_vars.(this_var_name);
        if isa(this_var, 'table') % header is not the first line
            header = this_var.Properties.VariableNames;
            for j = 1:length(header)
                if isa(this_var{1,j}, 'string')
                    this_var.(header{j}) = char(this_var.(header{j}));
                end
            end

        elseif isa(this_var, 'cell') % header is not the first line
            first_row = this_var(2,:);
            for j = 1:length(first_row) % Find which rows are strings
                if isa(first_row{j},'string')
                    for i = 1:length(this_var)
                        this_var{i,j} = convertStringsToChars(this_var{i,j});
                    end
                end
            end
        end
        loaded_vars.(this_var_name) = this_var;
    end
    save(datafile,'-struct', 'loaded_vars', '-v7.3') 
    disp(['Done proccessing file: ' datafile])
end
end