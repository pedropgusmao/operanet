function convert_and_save(data_dir)
fileList = dir([data_dir filesep '*.mat']);
for file_num =1:length(fileList)
    datafile = [fileList(file_num).folder filesep fileList(file_num).name];
    [pathstr, filename, ~] = fileparts(datafile);
    parquetfile = [pathstr filesep filename '.parquet'];
    loaded_vars = load(datafile);
    loaded_vars_names = fieldnames(loaded_vars);

    this_var_name = loaded_vars_names{1};
    this_var = loaded_vars.(this_var_name);

    % First convert table to cel if needed? 
        
    % Convert from cell to table if needed
    % and remove extra level of cell
    if isa(this_var, 'cell') 
        header = convertCharsToStrings(this_var(1,:));
        this_var = this_var(2:end,:);
        % Remove inner cell
        for j =1:length(header)
            if isa(this_var{1,j}, 'char')
                for i = 1:length(this_var)   
                 this_var{i,j} = convertCharsToStrings(this_var{i,j});
                end
            elseif isa(this_var{1,j},'cell')
                if isa(this_var{1,j}{1}, 'char')
                    for i = 1:length(this_var)   
                        this_var{i,j} = convertCharsToStrings(this_var{i,j}{1});
                    end
                end
            end
        end
        this_var = cell2table(this_var, "VariableNames", header);       
    end

    % Now that we have a table:
    header = this_var.Properties.VariableNames;

    % Remove 2-dimension cells and make it ROW-MAJOR
    for j = 1:length(header)
        if isa(this_var{1,j}, 'cell')
            if isa(this_var{1,j}{1}, 'numeric')
                [m, n] = size(this_var{1,j}{1});
                if (m ~=1) && (n~=1) % Need to transpose
                    for i = 1:height(this_var) 
                        tmp = cell2mat(this_var{i,j}).';
                        this_var{i,j} = {reshape(tmp,1,[])};
                    end
                elseif (m==1) && (n==1) && ~isreal(this_var{1,j}{1}) % Save complex
                    for i = 1:height(this_var) 
                        this_var{i,j} = {[real(this_var{i,j}) imag(this_var{i,j})] };
                    end
                end
            end  

        elseif isa(this_var{1,j}, 'numeric') && ~isreal(this_var{1,j}) % Hopefully first elements is not 0j
            this_column_name = header{j};
            temp = [ real(this_var{:,j}) imag(this_var{:,j}) ];
            temp = num2cell(temp,2);
            T = table(temp);
            T.Properties.VariableNames{'temp'} = this_column_name;
            this_var.(this_column_name) = T.(this_column_name);
        end
    end
    % Save to parquet
    parquetwrite(parquetfile, this_var)
    disp(['Done proccessing file: ' datafile])
end
end
