#! /snap/bin/octave

arg_list = argv()
dir_data = arg_list{1}
fileList = dir([dir_data filesep '*.mat']);

for file_num=1:1%length(fileList)
    datafile = [fileList(file_num).folder filesep fileList(file_num).name];
    loaded_vars = load(datafile);
    loaded_vars_names = fieldnames(loaded_vars); %could be more than one

    for var_idx = 1:length(loaded_vars_names)
        this_var_name = loaded_vars_names{var_idx};
        this_var = loaded_vars.(this_var_name);
        first_row = this_var(2,:);
        for j = 1:length(first_row) % Find which rows are strings
            if isa(first_row{j},'string')
                for i = 1:length(this_var)
                    this_var{i,j} = convertStringsToChars(this_var{i, j});
                end
            end
        end
        loaded_vars.(this_var_name) = this_var;
    end
    save(datafile,'-struct', 'loaded_vars', '-v7') 
end

end