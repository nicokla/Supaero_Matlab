function [ answer ] = askInteger( questionToAsk )
    answer=[];
    while isempty(answer)
        disp(questionToAsk);

        answer_asText = input('','s');
        answer=round(str2num(answer_asText));

        % error of input : we ask again
        if isempty(answer)
            %n_untilPause=0;
            disp('You made an error of input, answer again please :');
        end
    end
    
end

